import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:labs_questionnaire_creator/editor/draft_store.dart';
import 'package:labs_questionnaire_creator/editor/editor_controller.dart';
import 'package:labs_questionnaire_creator/main.dart';
import 'package:labs_questionnaire_creator/models/questionnaire.dart';

void main() {
  testWidgets(
    'review opens the exact nested field and keeps incomplete exports disabled',
    (tester) async {
      tester.view.physicalSize = const Size(1450, 1100);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = EditorController()
        ..setTitle('Routes survey')
        ..addQuestion(QuestionType.carouselSingleSelect);
      final question = controller.questionnaire.value.questions.single;
      controller.updateQuestion(
        question.id,
        question.copyWith(
          title: 'Choose routes',
          options: const [Option(id: 'item', text: '')],
        ),
      );
      await tester.pumpWidget(
        App(controller: controller, draftStore: MemoryDraftStore()),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('3 · Review'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Export questionnaire'),
            )
            .onPressed,
        isNull,
      );
      await tester.tap(find.text('Add text for answer 1 in question 1.'));
      await tester.pumpAndSettle();
      expect(find.text('Edit answer choice'), findsOneWidget);
      final field = find.widgetWithText(TextField, 'Answer text');
      expect(field, findsOneWidget);
      expect(tester.widget<TextField>(field).focusNode!.hasFocus, isTrue);
      await tester.enterText(field, 'Mountains');
      await tester.pump();
      await tester.tap(find.text('3 · Review'));
      await tester.pumpAndSettle();
      expect(find.text('Ready to export'), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Export questionnaire'),
            )
            .onPressed,
        isNotNull,
      );
    },
  );
  testWidgets(
    'restores and autosaves the local draft across workspace sessions',
    (tester) async {
      const initial = Questionnaire(
        id: 'saved',
        title: 'Recovered draft',
        description: '',
        questions: [
          Question(id: 'q', title: 'A question', type: QuestionType.textInput),
        ],
      );
      final store = MemoryDraftStore(jsonEncode(initial));
      final first = EditorController();
      await tester.pumpWidget(App(controller: first, draftStore: store));
      await tester.pumpAndSettle();
      expect(first.questionnaire.value.title, 'Recovered draft');
      expect(first.canUndo, isFalse);
      await tester.enterText(
        find.widgetWithText(TextField, 'Question title'),
        'Edited and recovered',
      );
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump();
      expect(
        jsonDecode(store.content!)['questions'][0]['title'],
        'Edited and recovered',
      );
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      final second = EditorController();
      await tester.pumpWidget(App(controller: second, draftStore: store));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextField>(find.widgetWithText(TextField, 'Question title'))
            .controller!
            .text,
        'Edited and recovered',
      );
      expect(second.canUndo, isFalse);
    },
  );
  testWidgets(
    'desktop and mobile workspace can preview and review sample content',
    (tester) async {
      tester.view.physicalSize = const Size(1500, 1100);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      if (const bool.fromEnvironment('captureWorkspace')) {
        await tester.runAsync(() async {
          final bytes = await File(
            const String.fromEnvironment('qaFont'),
          ).readAsBytes();
          await (FontLoader(
            'Roboto',
          )..addFont(Future.value(ByteData.sublistView(bytes)))).load();
          final icons = await File(
            '${File(const String.fromEnvironment('qaFont')).parent.path}/MaterialIcons-Regular.otf',
          ).readAsBytes();
          await (FontLoader(
            'MaterialIcons',
          )..addFont(Future.value(ByteData.sublistView(icons)))).load();
        });
      }
      final controller = EditorController();
      controller.importJson(
        jsonEncode(
          const Questionnaire(
            id: 'trip-feedback',
            title: 'Trip feedback',
            description: 'Help us improve your next drive.',
            questions: [
              Question(
                id: 'routes',
                title: 'Where do you like to drive?',
                description: 'Choose all the places you enjoy.',
                type: QuestionType.carouselMultiSelect,
                options: [
                  Option(
                    id: 'mountains',
                    text: 'Mountains',
                    description: 'Scenic routes and winding roads.',
                    imageUrl: 'https://example.com/mountains.png',
                  ),
                  Option(
                    id: 'coast',
                    text: 'Coast',
                    description: 'Sea views and open horizons.',
                    imageUrl: 'https://example.com/coast.png',
                  ),
                ],
              ),
              Question(
                id: 'comfort',
                order: 1,
                title: 'How was your last drive?',
                description: 'Think about comfort throughout your journey.',
                type: QuestionType.starRating,
                options: [
                  Option(
                    id: 'comfort-rating',
                    text: 'Overall comfort',
                    description: 'More stars means more comfortable.',
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      final boundary = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: boundary,
          child: App(controller: controller, draftStore: MemoryDraftStore()),
        ),
      );
      await tester.pumpAndSettle();
      Future<void> capture(String name) async {
        if (!const bool.fromEnvironment('captureWorkspace')) return;
        await tester.runAsync(() async {
          final image =
              await (boundary.currentContext!.findRenderObject()!
                      as RenderRepaintBoundary)
                  .toImage();
          final data = await image.toByteData(format: ui.ImageByteFormat.png);
          final file = File('/tmp/questionnaire-workspace-qa/$name.png');
          await file.parent.create(recursive: true);
          await file.writeAsBytes(data!.buffer.asUint8List());
          image.dispose();
        });
      }

      await capture('setup');
      await tester.tap(find.text('2 · Questions'));
      await tester.pumpAndSettle();
      await capture('workspace');
      await tester.tap(find.text('Mountains').first);
      await tester.pumpAndSettle();
      await capture('carousel-item');
      expect(find.widgetWithText(TextField, 'Question title'), findsNothing);
      await tester.tap(find.text('3 · Review'));
      await tester.pumpAndSettle();
      await capture('review');
      await tester.tap(find.text('Try questionnaire'));
      await tester.pumpAndSettle();
      expect(find.text('Try questionnaire'), findsNWidgets(2));
      tester.view.physicalSize = const Size(390, 900);
      await tester.pumpAndSettle();
      await tester.tap(find.text('2 · Questions'));
      await tester.pumpAndSettle();
      await capture('mobile');
      await tester.tap(find.byTooltip('Preview'));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('phone-preview')), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
