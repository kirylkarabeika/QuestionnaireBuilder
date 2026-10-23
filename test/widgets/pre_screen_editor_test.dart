import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:labs_questionnaire_creator/main.dart';
import 'package:labs_questionnaire_creator/models/questionnaire.dart';
import 'package:labs_questionnaire_creator/widgets/pre_screen_item_editor.dart';

void main() {
  testWidgets('creates, edits, switches styles, and deletes a list item', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const App());

    Future<void> reveal(Finder finder) async {
      await tester.scrollUntilVisible(
        finder,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();
    }

    Future<void> selectStyle(String label) async {
      final dropdown = find.byType(DropdownButtonFormField<PreScreenStyle>);
      await reveal(dropdown);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text(label).last);
      await tester.pumpAndSettle();
    }

    await reveal(find.text('Has pre-screen'));
    await tester.tap(find.text('Has pre-screen'));
    await tester.pumpAndSettle();
    await selectStyle('List');
    await reveal(find.text('Add item'));
    await tester.tap(find.text('Add item'));
    await tester.pumpAndSettle();

    final itemEditor = find.byType(PreScreenItemEditor);
    final fields = find.descendant(
      of: itemEditor,
      matching: find.byType(TextField),
    );
    await reveal(fields.first);
    await tester.enterText(fields.first, 'Bring your keys');
    await tester.pump();
    await reveal(fields.last);
    await tester.enterText(fields.last, 'https://example.com/key.png');
    await tester.pumpAndSettle();
    expect(
      tester.widget<PreScreenItemEditor>(itemEditor).item,
      const PreScreenItem(
        title: 'Bring your keys',
        iconUrl: 'https://example.com/key.png',
      ),
    );
    final image = find.descendant(of: itemEditor, matching: find.byType(Image));
    expect(tester.getSize(image), const Size(32, 32));

    await selectStyle('Cards');
    await reveal(find.text('Add card'));
    expect(find.byType(PreScreenItemEditor), findsNothing);
    await selectStyle('List');
    await reveal(itemEditor);
    expect(
      tester.widget<PreScreenItemEditor>(itemEditor).item.title,
      'Bring your keys',
    );
    expect(
      tester.widget<PreScreenItemEditor>(itemEditor).item.iconUrl,
      'https://example.com/key.png',
    );

    final delete = find.byTooltip('Delete item');
    await reveal(delete);
    await tester.tap(delete);
    await tester.pumpAndSettle();
    expect(itemEditor, findsNothing);
  });
}
