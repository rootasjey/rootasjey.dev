# TipTap Editor - New Code Features

## Overview

The TipTap editor has been enhanced with new code-related functionality, including inline code, code blocks, and block quotes. These features are accessible through a new dropdown menu in the bubble menu.

## New Features Added

### 1. Inline Code
- **Extension**: `@tiptap/extension-code`
- **Usage**: Select text and use the Code dropdown to apply inline code formatting
- **Keyboard Shortcut**: Available through bubble menu
- **Styling**: Purple background with rounded corners

### 2. Code Block
- **Extension**: `@tiptap/extension-code-block`
- **Usage**: Create multi-line code blocks for syntax highlighting
- **Features**:
  - Dark background with syntax highlighting
  - Monospace font (JetBrains Mono)
  - Horizontal scrolling for long lines
  - Purple gradient top border for visual distinction
- **Styling**: Custom `.code-block` class with enhanced visual design

### 3. Block Quote
- **Extension**: `@tiptap/extension-blockquote`
- **Usage**: Create highlighted quote blocks
- **Features**:
  - Left border for visual distinction
  - Indented content
  - Supports nested content
- **Styling**: Gray left border with proper spacing

## Implementation Details

### New Dependencies Installed
```bash
npm install @tiptap/extension-code @tiptap/extension-code-block @tiptap/extension-blockquote
```

### New Component: CodeDropdown.vue
- Located at: `components/CodeDropdown.vue`
- Follows the same pattern as existing dropdown components
- Provides three options:
  - Inline Code (icon: `i-lucide-code`)
  - Code Block (icon: `i-lucide-code-2`)
  - Block Quote (icon: `i-lucide-quote`)

### Editor Configuration Updates
- Disabled built-in code extensions from StarterKit to use custom configurations
- Added custom configurations for better styling and functionality
- Enhanced CSS styling for both light and dark modes

### Styling Enhancements
- **Light Mode**: Purple background for inline code, dark background for code blocks
- **Dark Mode**: Darker purple background for inline code, gray background for code blocks
- **Code Blocks**: Added gradient top border and improved typography
- **Block Quotes**: Enhanced border styling and spacing

## Usage Instructions

### For Users
1. **Inline Code**: Select text and click the Code dropdown, then choose "Inline Code"
2. **Code Block**: Place cursor where you want the code block and select "Code Block" from the dropdown
3. **Block Quote**: Select text or place cursor and choose "Block Quote" from the dropdown

### For Developers
The new features are automatically available in all instances of the TipTap editor throughout the application, including:
- Post editing pages (`/posts/[slug]`)
- Project editing pages (`/projects/[slug]`)
- Test editor page (`/test-editor`)

## Testing

Visit `/test-editor` to test all the new features. The test page includes:
- Sample content demonstrating all three new features
- Updated instructions for testing
- Live preview of the editor functionality

## Browser Compatibility

The new features work in all modern browsers and are fully responsive. The bubble menu adapts to mobile screens by hiding separators and adjusting layout.

## Future Enhancements

Potential future improvements could include:
- Syntax highlighting for specific programming languages in code blocks
- Copy-to-clipboard functionality for code blocks
- Language selection dropdown for code blocks
- Custom themes for code blocks
