# labs_questionnaire_creator

A Flutter editor for questionnaire JSON files.

## Authoring workspace

Move freely between **Setup**, **Questions**, and **Review**:

- **Setup** contains the title, introduction, optional background image, and welcome
  screen. Availability, scheduling, IDs, and compatibility settings are collapsed
  into separate sections.
- **Questions** shows a reorderable outline and one focused editor. Answer choices,
  carousel items, rating details, and welcome content open in their own editors,
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
first. Exporting still produces the same questionnaire JSON schema.

## Question descriptions and images

Every question type supports an optional `description` string. Set it using
**Add description** below the question title. Descriptions
support multiple lines. Clearing the field saves `null`; older JSON files
without `description` continue to load.

Every question type supports an optional `imageUrl` string. Set it using
**Add image (optional)**, then paste an image URL. Existing images appear as
thumbnails with change and remove actions. Clearing the field
saves `null`; older JSON files without `imageUrl` continue to load.

Answer-level images are available only for **Image choice** answers and **Carousel**
items. Single choice and Multiple choice answers have no image controls.
Question-level images remain available for every question type.

Optional answer-level descriptions are available for **Image choice**
(`prominent_single_select`) answers and **Carousel** items. Single choice and
Multiple choice answers show their answer text without a description.
Question-level descriptions and star rating descriptions remain available.

## Carousel and star rating questions

Use **Add question**, then choose **Carousel** or **Star rating**. Both types have the
same question title, optional description and image URL, and skippable setting
as the existing question types.

Carousels use `type: "carousel"`, a `selectionMode` of `single_select` (default)
or `multi_select`, and an `items` array. Each item has a stable `id`, zero-based
`order`, `title`, `description`, and `imageUrl`. Item descriptions support multiple
lines and default to an empty string when omitted in older JSON. Use **Add carousel
item** to add items; deleting one renumbers the remaining items without changing
their IDs.

Star rating questions use `type: "star_rating"` and a `starRating` object with
its own `title`, `description`, and positive integer `starCount` (default `5`).
The rating description is separate from the optional question description.

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
      "type": "carousel",
      "isSkippable": true,
      "selectionMode": "multi_select",
      "items": [
        {
          "id": "mountains",
          "order": 0,
          "title": "Mountains",
          "description": "Scenic routes through the mountains",
          "imageUrl": "https://example.com/mountains.png"
        },
        {
          "id": "coast",
          "order": 1,
          "title": "Coast",
          "description": "Relaxing drives along the coast",
          "imageUrl": "https://example.com/coast.png"
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
      "starRating": {
        "title": "Comfort",
        "starCount": 5,
        "description": "More stars means more comfortable"
      }
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
choose **Cards** or **List with icons** under **Welcome layout**. List items have a title and an icon URL, with a small
leading icon preview in the editor.

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
      }
    ]
  }
}
```

The `style` values are `cards` and `list`. Files without `style` use `cards`.
Icon URLs are JSON strings, using the exact key `iconURL`. Both content arrays
are saved so switching styles preserves edits; consumers display the array
selected by `style`.
