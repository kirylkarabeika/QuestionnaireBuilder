# labs_questionnaire_creator

A Flutter editor for questionnaire JSON files.

## Authoring workspace

Move freely between **Setup**, **Questions**, and **Review**:

- **Setup** contains the title, introduction, optional background image, and welcome
  screen. Availability, scheduling, IDs, and compatibility settings are collapsed
  into separate sections.
- **Questions** shows a reorderable outline and one focused editor. Answer choices
  and welcome content open in their own editors,
  with a breadcrumb, back button, and live preview. Questions can be duplicated
  or deleted; undo and redo restore edits and structural changes.
- **Review** lists incomplete content. Selecting an issue opens the exact question
  or nested field. **Try questionnaire** lets you answer, skip, browse carousel
  cards, and complete the participant flow without changing the questionnaire.

On wide screens, the phone preview stays beside the editor. Smaller screens use
a question picker and a **Preview** dialog. The preview is illustrative; the
consuming app controls its final presentation. Links are not opened in preview.

Edits automatically save one local draft, restored on the next launch. Web drafts
use this browser's local storage. Desktop drafts use the user's application data
directory. Drafts are local to the device and are not published or synchronized.
The header reports saving or recovery errors. **File menu → Download draft JSON**
can export incomplete work; the normal **Export** action checks required content
first. Exporting produces questionnaire JSON with answer content in `options`.

## Question descriptions and images

Every question type supports an optional `description` string. Set it using
**Add description** below the question title. Descriptions
support multiple lines. Clearing the field saves `null`; older JSON files
without `description` continue to load.

Every question type supports an optional `imageUrl` string. Set it using
**Add image (optional)**, then paste an image URL. Existing images appear as
thumbnails with change and remove actions. Clearing the field
saves `null`; older JSON files without `imageUrl` continue to load.

Optional answer-level images are available for **Image choice** and **Carousel** answers.
Question-level images remain available for every question type.

Optional answer-level descriptions are available for **Image choice**
(`prominent_single_select`), **Carousel**, and **Star rating** options. Single choice
and Multiple choice answers show their answer text without a description.

## Carousel and star rating questions

Use **Add question**, then choose **Carousel (single choice)**,
**Carousel (multiple choice)**, or **Star rating**. These types have the
same question title, optional description and image URL, and skippable setting
as the existing question types.

Carousels use `type: "carousel_single_select"` or `type: "carousel_multi_select"`.
The type determines whether participants choose one or multiple answers.
Star rating questions use `type: "star_rating"`.

All three types store their content in the same `options` array used by other
answer choices. Each option has an automatically generated `id` and zero-based
`order`, mandatory `text`, and an optional `description`. Use **Add answer choice**
to add an option; deleting one renumbers the remaining options without changing
their IDs. Carousel options also support an optional `imageUrl`, with an
**Add image (optional)** control and image preview. Images can be changed or removed.
Star rating options contain only text and description controls.
Descriptions support multiple lines and save as `null` when cleared or omitted.
Star ratings have no configurable star count. The preview shows five stars for
each rating option and requires each option to be rated.

```json
{
  "id": "extended-survey",
  "title": "Your preferences",
  "description": "Tell us what you think",
  "showByCondition": "extended_questionnaire",
  "questions": [
    {
      "id": "favourites",
      "order": 0,
      "title": "Choose your favourites",
      "description": "Select all that apply",
      "imageUrl": null,
      "type": "carousel_multi_select",
      "isSkippable": true,
      "options": [
        {
          "id": "mountains",
          "order": 0,
          "text": "Mountains",
          "description": "Scenic routes through the mountains",
          "imageUrl": "https://example.com/mountains.png"
        },
        {
          "id": "coast",
          "order": 1,
          "text": "Coast",
          "description": null,
          "imageUrl": null
        }
      ]
    },
    {
      "id": "experience",
      "order": 1,
      "title": "How was your trip?",
      "description": null,
      "imageUrl": null,
      "type": "star_rating",
      "isSkippable": false,
      "options": [
        {
          "id": "comfort",
          "order": 0,
          "text": "Comfort",
          "description": "More stars means more comfortable",
          "imageUrl": null
        }
      ]
    }
  ]
}
```

The **Extended questionnaire** condition uses the value
`extended_questionnaire`. The editor applies and locks this condition while
either new question type is present, including when importing JSON. After
removing all extended questions, the condition can be changed again. It can
also be selected manually for other questionnaires. Consuming apps must support
this condition and the new question types; older apps must treat an unknown
condition as hidden before decoding the questions.

## Pre-screen styles

Enable **Include a welcome screen** in Setup, open **Edit welcome screen**, and
choose **Cards** or **List with icons** under **Welcome layout**. List items have a
required title and an optional icon URL. Use **Add icon (optional)** to add an image;
items without an icon show only their text in the editor and participant preview.

```json
{
  "preScreen": {
    "title": "Before you start",
    "description": "Please read the following",
    "style": "list",
    "cards": [],
    "items": [
      {
        "title": "Have your keys ready",
        "iconURL": "https://example.com/key.png"
      },
      {
        "title": "Allow a few minutes",
        "iconURL": null
      }
    ]
  }
}
```

The `style` values are `cards` and `list`. Files without `style` use `cards`.
Icon URLs use the exact key `iconURL` and can be omitted or `null`. Clearing an
icon saves `null`; provided URLs must be full http or https links. Both content arrays
are saved so switching styles preserves edits; consumers display the array
selected by `style`.
