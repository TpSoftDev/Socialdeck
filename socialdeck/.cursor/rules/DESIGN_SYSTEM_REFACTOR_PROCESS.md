# Design System Refactor Process
## Reusable Process for Future Refactoring Sessions

**Purpose:** This document captures the successful process we used to refactor the design system tokens. Use this as a guide for future refactoring sessions with new AI assistants.

---

## 🎯 Core Principles

### What Works Well (DO THIS)
1. **Visual Diagrams & Architecture**
   - Create visual diagrams showing file organization
   - Show design system architecture (hierarchical relationships)
   - Use visual summaries to help understand the structure
   - These help visualize what we're doing and make notes

2. **Step-by-Step Approach**
   - One file at a time
   - One change at a time
   - Complete → Review → Approve → Next
   - Never rush past review points

3. **Brainstorm Before Planning**
   - FIRST: Brainstorm and explore ideas together
   - Ask open-ended questions to understand the problem space
   - Explore concepts, goals, and constraints
   - THEN: Present multiple approaches with pros/cons
   - Let me choose which approach to follow

4. **Clear Communication**
   - Explain what we're about to do and why
   - Stop after each step and wait for review
   - Use plain language, not jargon
   - Show progress clearly

5. **Figma-First Approach**
   - Always match Figma exactly (names AND values)
   - Use full Figma variable names (e.g., `borderRadiusZero`, not `zero`)
   - Scan codebase for duplication BEFORE starting
   - Verify values against Figma

6. **Context-Aware Migration**
   - Analyze context for each usage (margin vs padding vs gap)
   - Use semantic tokens appropriately
   - Handle non-Figma values with comments
   - Map to closest equivalent when needed

### What Doesn't Work (AVOID THIS)
1. **Rushing**
   - ❌ Don't fly past everything
   - ❌ Don't do multiple files without review
   - ❌ Don't assume approval - wait for explicit confirmation

2. **Creating .md Files for Plans**
   - ❌ Don't create markdown files for plans
   - ✅ Discuss plans in chat
   - ✅ Use Cursor's plan mode for execution (after approval)

3. **Incomplete Names**
   - ❌ Don't use short names (e.g., `zero` instead of `borderRadiusZero`)
   - ✅ Always use full Figma variable names

4. **Skipping Steps**
   - ❌ Don't skip scanning for duplication
   - ❌ Don't skip brainstorming phase
   - ❌ Don't start implementation without approval

5. **Not Following Project Rules**
   - ❌ Don't execute automatically
   - ❌ Don't write full solutions without permission
   - ✅ Always follow the project rules in Cursor settings

---

## 📋 Standard Process Flow

### Phase 1: Discovery & Analysis
1. **Read the codebase thoroughly**
   - Understand current structure
   - Identify all files involved
   - Understand how things are linked
   - Note nuances and patterns

2. **Review Figma design**
   - Get design context from Figma (use MCP tool)
   - Understand Figma's structure and hierarchy
   - Identify variable names and values
   - Note relationships between tokens

3. **Compare Code vs Figma**
   - Identify mismatches (names, values, structure)
   - Find duplications in codebase
   - List what needs to change

4. **Create visual diagrams**
   - Show current architecture
   - Show target architecture
   - Show file organization
   - Help visualize the changes

### Phase 2: Brainstorming & Planning
1. **Brainstorm approaches**
   - Ask open-ended questions
   - Explore different strategies
   - Discuss pros and cons
   - Think through the problem space

2. **Present options**
   - Offer 2-3 different approaches
   - Explain why each might work
   - Be critical and point out issues
   - Let me choose

3. **Create detailed plan**
   - Break into small, clear steps
   - One file at a time
   - List what will change
   - Discuss in chat (not .md file)

4. **Get explicit approval**
   - Wait for "yes" or "alright let's do that"
   - Confirm approach before starting
   - Make sure we're aligned

### Phase 3: Implementation (One Step at a Time)
1. **Do ONE thing**
   - One file
   - One change
   - Complete it fully

2. **Show what was done**
   - Explain what changed
   - Show the changes clearly
   - Wait for review

3. **Wait for approval**
   - Don't continue until I say "ready" or "next"
   - I need to review each step
   - Respect the review process

4. **Apply feedback**
   - If I make refinements, note the patterns
   - Follow those patterns going forward
   - Learn from my styling preferences

5. **Repeat**
   - Only after approval, move to next step
   - One at a time, always

### Phase 4: Migration (If Applicable)
1. **Scan for all usages**
   - Find all files using old tokens
   - Count how many need updating
   - Group by file type

2. **Create migration strategy**
   - Context detection (margin vs padding vs gap)
   - Handle non-Figma values
   - Map old → new tokens
   - Order of migration

3. **Migrate file by file**
   - One file at a time
   - Show progress
   - Test compilation after each batch
   - Wait for review between batches

4. **Verify completion**
   - Check for remaining old usages
   - Verify compilation
   - Test visually if needed

---

## 🎨 Visual Documentation Standards

### When to Create Diagrams
- **File Organization**: Show directory structure before/after
- **Architecture**: Show hierarchical relationships (Size → Control/Space/Radius)
- **Mapping Tables**: Show how old tokens map to new tokens
- **Process Flow**: Show the step-by-step process visually

### Diagram Types That Work Well
1. **Hierarchical Architecture Diagrams**
   - Show foundation layer (Size)
   - Show dependent layers (Control, Space, Radius)
   - Show relationships (1:1 mapping, offset mapping)
   - Use visual hierarchy (boxes, arrows, labels)

2. **File Structure Diagrams**
   - Show directory tree
   - Label files (NEW, UPDATED, REPLACED, UNCHANGED)
   - Show relationships between files

3. **Migration Mapping Tables**
   - Old token → New token
   - Context-dependent mappings
   - Value changes (if any)

---

## 📝 Communication Patterns

### Good Communication Examples
- "I've completed File X. Here's what changed: [summary]. Ready for review."
- "Before we continue, let me show you the architecture diagram so you can visualize what we're doing."
- "I found 3 different approaches. Here are the pros/cons of each. Which do you prefer?"
- "I've migrated 5 files. Should I continue with the next batch, or do you want to review first?"

### Bad Communication Examples
- "Done!" (too vague, no context)
- "I've updated everything." (didn't wait for review)
- "Here's the plan in a .md file." (should discuss in chat)
- "I'll do all 29 files now." (too much at once)

---

## ✅ Success Checklist

Before considering a refactor complete:
- [ ] All variable names match Figma exactly
- [ ] All values match Figma exactly
- [ ] Architecture matches Figma structure
- [ ] All files migrated (if applicable)
- [ ] No compilation errors
- [ ] Code follows my styling patterns
- [ ] Visual diagrams created (if helpful)
- [ ] Process documented for future reference

---

## 🔄 How to Use This Process in a New Chat

1. **Share this document** with the new AI assistant at the start
2. **Reference it** when the assistant starts to rush or skip steps
3. **Remind them** of the core principles if they drift
4. **Point to specific sections** when they need guidance
5. **Update this document** with new learnings after each session

---

## 💡 Key Takeaways

1. **Visualization is powerful** - Diagrams help understand and document
2. **One step at a time** - Never rush, always review
3. **Figma is the source of truth** - Match it exactly
4. **Communication is key** - Discuss, don't assume
5. **Process matters** - Following the process leads to better results

---

**Last Updated:** After Size/Space/Radius/Control refactor completion
**Next Refactor:** Colors, Shadows, Themes (separate process)

