# Coding Style & Documentation Guide

This document outlines the preferred coding style, formatting conventions, and documentation patterns for this codebase. Use this as a reference when writing or modifying code.

## File Structure & Formatting

### File Header
Every file should start with a header comment block. The file header is NOT just a description—it's a synthesis of multiple sources that tells a complete story.

#### File Header Writing Process

When writing a file header, follow this step-by-step process:

**Step 1: Gather Information**
Answer these questions in order:

1. **What is this class/token?**
   - Read the code to understand its structure
   - Check what values/properties it contains
   - Understand its data type and purpose
   - Example: "It's a class with static const doubles representing spacing values"

2. **What does Figma say about it?** (if applicable)
   - Read Figma descriptions/notes for design intent
   - Capture the purpose and terminology
   - Note any specific concepts or relationships
   - Example: "Figma says: 'Size variables define consistent spacing, dimensions...'"

3. **How does it relate to other tokens/components?**
   - Check imports and dependencies
   - Understand the hierarchy (e.g., Space references Size)
   - Note if it's foundational or built on top of others
   - Example: "Space tokens reference Size tokens as semantic aliases"

4. **What does it actually do in the codebase?**
   - Check how it's used in components
   - Understand its role in the design system
   - Note if it's used directly or indirectly
   - Example: "Used directly for component dimensions (width, height, icon sizes)"

5. **How should developers use it?**
   - Provide concrete usage examples
   - Show all relevant use cases (e.g., margin, padding, gap)
   - Use real examples from the codebase
   - Example: "Usage: SDeckSize.size24"

**Step 2: Synthesize the Information**

Don't just copy Figma or describe code. Create a narrative that flows:

1. **First sentence: What it is**
   - Start with the class/token name and its primary purpose
   - Use Figma terminology naturally, but don't copy word-for-word
   - Example: "Size tokens define consistent spacing, dimensions, and scaling across the design system."
   - **Reasoning**: Gives immediate clarity on purpose

2. **Second sentence: Its role/relationship**
   - Explain where it fits in the hierarchy
   - Describe relationships with other tokens/components
   - Example: "They serve as the foundation layer—the base numeric values that all other token classes (Space, Radius) reference."
   - **Reasoning**: Explains hierarchy and helps developers understand dependencies

3. **Third sentence: The benefit/value** (if applicable)
   - Explain why it matters or what problem it solves
   - Describe the value it provides
   - Example: "These tokens ensure visual harmony and maintain proportional relationships between components and layouts."
   - **Reasoning**: Explains the "why" behind its existence

4. **Usage section: How to use it**
   - Show actual code examples
   - Include all relevant use cases
   - Use real examples from the codebase
   - Example:
     ```dart
     // Usage:
     //   SDeckSpace.margin16
     //   SDeckSpace.padding16
     //   SDeckSpace.gap16
     ```
   - **Reasoning**: Provides practical, actionable guidance

**Step 3: Structure the Header**

Format the synthesized information:

```dart
/*----------------------------- filename.dart ---------------------------------*/
// [First sentence: What it is]
// [Second sentence: Role/relationship]
// [Third sentence: Benefit/value - if applicable]
//
// Usage:
//   ClassName.example1
//   ClassName.example2
/*--------------------------------------------------------------------------*/
```

**Step 4: Balance and Refinement**

- **Not too verbose**: Don't write paragraphs—2-4 sentences max
- **Not too sparse**: Don't just say "Size tokens for spacing"
- **Professional**: Write for developers who need to understand and use it
- **Clear**: Each sentence should add value and build understanding

#### Examples of Good File Headers

**Example 1: Foundation Token (Size)**
```dart
/*----------------------------- size.dart ---------------------------------*/
// Size tokens define consistent spacing, dimensions, and scaling across the
// design system. They serve as the foundation layer—the base numeric values
// that all other token classes (Space, Radius) reference.
//
// These tokens ensure visual harmony and maintain proportional relationships
// between components and layouts.
//
// Usage: SDeckSize.size24
/*--------------------------------------------------------------------------*/
```

**Example 2: Semantic Token (Space)**
```dart
/*----------------------------- space.dart ---------------------------------*/
// Space tokens define the system's spacing scale, used for padding, margins,
// and gaps. They create consistent rhythm, alignment, and visual balance
// across components and layouts.
//
// These tokens reference Size tokens as semantic aliases, providing
// context-specific naming for spacing values.
//
// Usage:
//   SDeckSpace.margin16
//   SDeckSpace.padding16
//   SDeckSpace.gap16
/*--------------------------------------------------------------------------*/
```

**Example 3: Component File**
```dart
/*----------------------------- button_enums.dart -------------------------*/
// Shared enums for button components in the SocialDeck design system.
// These enums define size variations, shapes, icon locations, and interaction
// states that control button appearance and behavior across all button types.
//
// Usage:
//   SDeckButtonSize.large
//   SDeckButtonShape.round
//   SDeckButtonIconLocation.left
/*--------------------------------------------------------------------------*/
```

#### Key Principles for File Headers

1. **Synthesize, don't copy**: Combine Figma intent with code reality
2. **Tell a story**: Flow from "what" → "why" → "how"
3. **Show relationships**: Explain how it connects to other parts
4. **Be practical**: Include usage examples developers can copy
5. **Balance detail**: Enough to understand, not so much it overwhelms

### Import Section
Always include a formatted import section comment:

```dart
//-------------------------------- Imports --------------------------------//
import 'package:example/example.dart';
import 'other_file.dart';
```

### Class Declaration
Always include a formatted class name comment before the class:

```dart
//------------------------------- ClassName ------------------------------//
class ClassName {
  ClassName._();
  // ...
}
```

### Section Headers
Use asterisk-based section headers for organizing code:

```dart
//*************************** Section Name **********************************//
```

For longer section names, adjust the asterisks to maintain visual balance:

```dart
//*************************** Margin **************************************//
//*************************** Padding *************************************//
//*************************** Gap *****************************************//
```

## Documentation Style

### Documentation Philosophy
- **Balance is key**: Not too verbose, not too sparse
- **Professional**: Focus on what developers need to know
- **Clear**: Explain what the class/token is and how to use it
- **Inspired by Figma**: Use Figma descriptions as inspiration, but adapt them naturally (don't copy word-for-word)

### What to Include in Documentation

1. **What it is**: Brief explanation of the class/token's purpose
2. **Why it exists**: Its role in the design system (if applicable)
3. **How to use it**: Simple usage examples
   - If there are multiple use cases (e.g., margin, padding, gap), show examples for each:
   ```dart
   // Usage:
   //   SDeckSpace.margin16
   //   SDeckSpace.padding16
   //   SDeckSpace.gap16
   ```

### What to Remove

**Never include:**
- "Matches Figma exactly" comments (assumed)
- "Private constructor - prevents instantiation" comments (standard Dart pattern)
- Redundant inline value comments like `// 0 px` when the value is clear
- Comments that just repeat what the code already shows
- "Matches Figma: [token list]" in documentation (redundant)

**Keep only:**
- Comments that add value or clarify relationships
- Usage examples that help developers understand how to use the code
- Explanations of purpose and role in the design system

## Code Organization

### Token Files Structure

1. **File Header** - Description and usage
2. **Imports Section** - With formatted comment
3. **Class Comment** - Formatted class name comment
4. **Class Declaration** - With private constructor
5. **Section Headers** - For organizing token groups
6. **Token Declarations** - Clean, without redundant comments

### Example: Complete Token File

```dart
/*----------------------------- space.dart ---------------------------------*/
// Space tokens define the system's spacing scale, used for padding, margins,
// and gaps. They create consistent rhythm, alignment, and visual balance
// across components and layouts.
//
// These tokens reference Size tokens as semantic aliases, providing
// context-specific naming for spacing values.
//
// Usage:
//   SDeckSpace.margin16
//   SDeckSpace.padding16
//   SDeckSpace.gap16
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'size.dart';

//------------------------------- SDeckSpace ------------------------------//
class SDeckSpace {
  SDeckSpace._();

  //*************************** Margin **************************************//
  static const double marginZero = SDeckSize.sizeZero;
  static const double margin4 = SDeckSize.size4;
  static const double margin8 = SDeckSize.size8;
  // ... more tokens

  //*************************** Padding *************************************//
  static const double paddingZero = SDeckSize.sizeZero;
  static const double padding4 = SDeckSize.size4;
  // ... more tokens
}
```

## Key Principles

1. **Consistency**: Always use the same formatting patterns across all files
2. **Clarity**: Code should be self-documenting where possible
3. **Organization**: Use section headers to group related code
4. **Professional**: Documentation should be helpful, not redundant
5. **Balance**: Find the middle ground between too much and too little documentation

## Formatting Details

- Use consistent spacing around section headers
- Maintain alignment in section header asterisks
- Keep class name comments aligned consistently
- Import comments should be formatted with dashes
- File header should match the pattern exactly

## Applying the Style Guide

### When Asked to "Apply Coding Style Guide"

When applying this style guide to a file, follow this checklist:

1. **File Header**
   - [ ] Follow the File Header Writing Process (Step 1-4 above)
   - [ ] Answer all 5 questions before writing
   - [ ] Synthesize information from code, Figma (if applicable), and relationships
   - [ ] Structure: What → Why → How (Usage)
   - [ ] Balance: 2-4 sentences, not too verbose, not too sparse

2. **Import Section**
   - [ ] Add formatted import comment: `//-------------------------------- Imports --------------------------------//`
   - [ ] Ensure all imports are present and necessary

3. **Class/Comment Declaration**
   - [ ] Add formatted class name comment: `//------------------------------- ClassName ------------------------------//`
   - [ ] Ensure proper alignment and formatting

4. **Section Headers**
   - [ ] Use asterisk-based headers: `//*************************** Section Name **********************************//`
   - [ ] Adjust asterisks for visual balance with section name length
   - [ ] Remove inconsistent formatting (like `//========================` or `//-----------------------------`)

5. **Code Cleanup**
   - [ ] Remove "Matches Figma" comments
   - [ ] Remove "Private constructor" comments
   - [ ] Remove redundant inline comments
   - [ ] Remove comments that just repeat what code shows
   - [ ] Keep only comments that add value

6. **Documentation**
   - [ ] Ensure usage examples are present and accurate
   - [ ] Show all relevant use cases if multiple exist
   - [ ] Verify examples match actual codebase usage

### Remember

When working on token files or any design system code:
- Always include the formatted import section comment
- Always include the formatted class name comment
- Use section headers for organization
- Keep documentation balanced and professional
- Show usage examples for different use cases when applicable
- Remove redundant comments that don't add value
- **Follow the File Header Writing Process** - don't just write a generic description

