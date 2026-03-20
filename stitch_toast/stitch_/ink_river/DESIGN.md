# Design System: Ink River

### 1. Overview & Creative North Star
**Creative North Star: "The Modern Calligrapher"**
Ink River is a design system that marries the soul of traditional editorial publishing with the precision of modern digital interfaces. It rejects the generic "SaaS-blue" aesthetic in favor of high-contrast, serif-led layouts that treat whitespace as a functional element rather than a void. The system is defined by its use of "The Newsreader" font family—a typeface that breathes life into digital text with its varying optical sizes—and a "Cyan-Ink" primary accent that slices through a neutral, parchment-inspired background.

### 2. Colors
The color palette is anchored by a high-clarity Cyan (#11B4D4) representing the "Ink," set against a refined "Paper" background (#F6F8F8).

- **The "No-Line" Rule:** Visual structure is never achieved through 1px solid borders. Instead, sections are defined by subtle shifts from `surface_container_lowest` (pure white) to `surface` (pale grey). Boundary lines, if used, must be at 10% opacity of the primary color (`primary/10`), acting as a ghost-hint rather than a hard separator.
- **Surface Hierarchy & Nesting:** Content cards use `surface_container_lowest` to pop against the `background`. Hover states and secondary interactions utilize `primary/10` overlays to create a sense of glowing activation.
- **The "Glass & Gradient" Rule:** Navigation bars and sticky headers must use a `backdrop-blur` of at least 12px with a 80% opacity fill to maintain context of the content scrolling beneath them.

### 3. Typography
Ink River uses a single, sophisticated typeface: **Newsreader**. This creates a cohesive, book-like rhythm.

- **Display (1.875rem / 30px):** Bold and tight-tracked for the main title, evoking the masthead of a classic journal.
- **Headline (1.5rem / 24px):** Used for article titles and major section headers.
- **Title (1.25rem / 20px):** Medium-weight for sub-sections.
- **Body (1.125rem / 18px):** Optimized for long-form reading with a generous line-height for maximum legibility.
- **Labels (0.875rem / 14px):** Used for metadata, dates, and categories, often paired with increased letter spacing for a refined "Technical" feel.
- **Micro (10px):** Reserved exclusively for bottom navigation labels to maximize screen real estate.

### 4. Elevation & Depth
Depth in Ink River is achieved through "Tonal Stacking" rather than aggressive drop shadows.

- **The Layering Principle:** The background is the lowest point. Content cards "float" exactly one tier above using a subtle white background and a minimal `shadow-sm`.
- **Ambient Shadows:** Shadows are rare. When used, they follow the `shadow-sm` profile: a very tight, low-spread shadow that simulates a thin card resting on a table.
- **Glassmorphism:** Bottom navigation and top headers use `bg-white/90` with `backdrop-blur-lg` to create a "Floating Pane" effect.

### 5. Components
- **Articles & Cards:** Horizontal layouts for desktop, vertical for mobile. Images use `rounded-xl` (0.75rem) and feature a `scale-105` transition on hover to simulate tactile engagement.
- **Search Bar:** A "pill-lite" design using `rounded-xl`. It utilizes a `ring-1` of slate-200, which transforms into a `ring-2` of `primary` upon focus, creating a "pulsing" intent.
- **Buttons:** Icons are wrapped in `rounded-lg` containers with `hover:bg-primary/10` backgrounds. This creates a soft, non-intrusive interaction.
- **Tags/Chips:** Small, uppercase, and bold. They use a `bg-primary/10` background with `text-primary` for high-contrast categorisation without the weight of a solid button.

### 6. Do's and Don'ts
**Do:**
- Use "Newsreader" for every text element to reinforce the editorial brand.
- Utilize the `italic` variant of the body font for secondary descriptions and taglines.
- Ensure all images have a `duration-500` transition for a smooth, premium feel.

**Don't:**
- Never use pure black (#000000); use `slate-900` for text to maintain a soft, "ink-on-paper" contrast.
- Avoid sharp corners; even small elements should have at least `rounded` (0.25rem).
- Do not use heavy drop shadows; let the whitespace and tonal shifts provide the hierarchy.