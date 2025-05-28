
# 📘 Documentation Formatting Rules for Notion

Follow these rules **every time** you generate documentation inside Notion. Match the formatting quality and clarity of Cursor output.

---

## 1. 🧱 Heading Structure

Use these heading levels to structure the page clearly:
- `#` for top-level sections (`# 🎯 Overview`)
- `##` for sub-sections (`## 📁 File Location`)
- `###` for nested content or examples (`### 💻 Usage Examples`)

---

## 2. 💻 Code Formatting

- Always wrap code in triple backticks with a language tag:

````dart
SDeckIcon(context.icons.home)

	•	Use bash, json, yaml, plaintext, or dart where appropriate
	•	Do not use single backticks for multi-line code blocks

⸻

3. ✨ Text Styling and Emphasis
	•	Use bold for:
	•	Key concepts
	•	Filenames
	•	Important terminology
	•	Use italics sparingly for emphasis
	•	Use inline backticks for:
	•	Variable names
	•	File paths (lib/Design_System/Utils/widgets/sdeck_icon.dart)
	•	Constants and one-liner code expressions

⸻

4. 📋 Lists and Structure
	•	Use bullet lists for all multi-point breakdowns
	•	Add one empty line between:
	•	Paragraphs
	•	Lists
	•	Code blocks
	•	Do not compress multiple sections into a single block of text

✅ Good:
	•	Clean structure
	•	Visually scannable
	•	Cursor-style clarity

❌ Bad:
A huge block of dense, unformatted markdown

⸻

5. 🆚 Before vs After Examples

Use this format when showing improvements:

Before

SvgPicture.asset(
  context.icons.home,
  colorFilter: ColorFilter.mode(
    Theme.of(context).colorScheme.onSurface,
    BlendMode.srcIn,
  ),
)

After

SDeckIcon(context.icons.home)


⸻

6. 📂 Directory and File Trees

Use plaintext for file and folder trees:

lib/
├── main.dart
├── simple_example.dart
└── Design_System/
    └── Utils/
        ├── constants/
        ├── Themes/
        │   └── custom_themes/
        └── widgets/


⸻

7. 🧠 Final Output Principles
	•	Match Cursor formatting in Notion exactly
	•	Output should look like a well-written technical document, not raw logs
	•	Every documented page should be easy to scan, beautifully structured, and cleanly styled

⸻

8. 🔁 Reusability
	•	Use these formatting rules every time, regardless of the subject
	•	Whether documenting architecture, APIs, tests, configs, or styles — always apply this structure
