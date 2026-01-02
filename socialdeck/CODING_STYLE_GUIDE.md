# Coding Style & Documentation Guide

This document outlines the preferred coding style, formatting conventions, and documentation patterns for this codebase. Use this as a reference when writing or modifying code.

## File Structure & Formatting

### File Header
Every file should start with a header comment block:

```dart
/*----------------------------- filename.dart ---------------------------------*/
// Description of what this file/class does
// Additional context or explanation
//
// Usage: ClassName.example
/*--------------------------------------------------------------------------*/
```

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

## Remember

When working on token files or any design system code:
- Always include the formatted import section comment
- Always include the formatted class name comment
- Use section headers for organization
- Keep documentation balanced and professional
- Show usage examples for different use cases when applicable
- Remove redundant comments that don't add value

