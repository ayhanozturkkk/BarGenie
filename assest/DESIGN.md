# Design System: The Cinematic Alchemist

## 1. Overview & Creative North Star
**The Creative North Star: "The Digital Sommelier"**

This design system is built to evoke the atmosphere of a private, high-end speakeasy at midnight. It rejects the "app-like" feel of standard mobile interfaces in favor of a **High-End Editorial** experience. We achieve this by treating the screen not as a flat grid, but as a dimly lit bar top where light and shadow define the space.

To break the "template" look, we utilize **Intentional Asymmetry**. Large, elegant serif displays are often offset, and imagery is allowed to bleed off-edge or overlap containers. This creates a sense of movement and "cinematic" pacing—where the user isn't just navigating a menu, but exploring a curated collection.

## 2. Colors & Tonal Depth

The palette is rooted in deep charcoal and illuminated by the glow of aged spirits (Gold).

### The "No-Line" Rule
**Explicit Instruction:** Solid 1px borders are strictly prohibited for sectioning. We define boundaries through tonal shifts. A `surface-container-low` section sitting on a `surface` background provides enough contrast to guide the eye without the "cheap" look of outlines.

### Surface Hierarchy & Nesting
Treat the UI as physical layers of smoked glass and dark wood.
*   **Base:** `surface` (#131313) for the overall canvas.
*   **Submerged Elements:** `surface-container-lowest` (#0E0E0E) for recessed areas like search bars or inset toggles.
*   **Elevated Elements:** `surface-container` (#201F1F) for primary content cards.
*   **Highlight Layers:** `surface-container-highest` (#353534) for floating elements or active states.

### The "Glass & Glow" Rule
To capture the "glowing bottles" atmosphere, use **Glassmorphism**. Floating elements should utilize `surface_variant` at 60-80% opacity with a `backdrop-blur` of 20px. This allows the rich photography of cocktails to bleed through the UI, softening the interface.

### Signature Textures
Main CTAs must use a linear gradient: `primary` (#EBC165) to `primary_container` (#C9A24A). This mimics the way light hits liquid in a crystal glass, providing a "visual soul" that flat gold cannot achieve.

## 3. Typography: The Editorial Voice

We pair a high-contrast serif for "flavor" with a high-readability sans-serif for "function."

*   **Display & Headlines (Newsreader):** Used for cocktail names, category headers, and storytelling. It should feel authoritative and artisanal. Use `display-lg` (3.5rem) for hero screens to create a bold, editorial impact.
*   **Titles & Body (Manrope):** Used for ingredients, instructions, and navigation. This sans-serif provides the "Modern" balance to the serif's "Heritage."
*   **Labeling:** `label-md` should always be in `on-surface-variant` (#D1C5B2) to maintain a soft hierarchy that doesn't distract from the primary content.

## 4. Elevation & Depth: Tonal Layering

We convey hierarchy through light, not lines.

*   **The Layering Principle:** Instead of shadows, stack your tokens. Place a `surface-container-low` card on a `surface` background. If the card needs to feel "active," transition it to `surface-container-high`.
*   **Ambient Shadows:** When a floating action is required (e.g., a "Mix" button), use an extra-diffused shadow: `offset-y: 12px`, `blur: 24px`, `color: rgba(0, 0, 0, 0.4)`. The shadow should feel like a natural light obstruction, never a harsh drop-shadow.
*   **The "Ghost Border" Fallback:** If a divider is mandatory for accessibility, use the `outline-variant` token at 15% opacity. This creates a "suggestion" of a line that disappears into the background.

## 5. Components

### Buttons
*   **Primary:** Gradient filled (`primary` to `primary_container`). Use `rounded-md` (0.375rem) for a sharp, sophisticated look.
*   **Secondary:** No fill. `Ghost Border` (outline-variant at 20%) with `on-surface` text.
*   **Tertiary:** Text only in `primary_fixed_dim`. Use for low-emphasis actions like "View More."

### Input Fields
*   **Styling:** Use `surface-container-high` as the background. No border. The placeholder text (`placeholder-text`: #6B6B6B) should be lowercase to feel more "minimalist/boutique."
*   **Active State:** A subtle bottom-border glow using the `primary` token (1px height).

### Cards & Lists
*   **The No-Divider Rule:** Forbid the use of line dividers between list items. Use `spacing-6` (2rem) of vertical white space to separate ingredients.
*   **Mixology Cards:** Use `surface-container` with a high-quality cocktail image that overlaps the top-left edge of the card, breaking the rectangular container.

### Signature Component: The "Spirit Gauge"
A custom horizontal slider for alcohol intensity. Use `surface-container-highest` for the track and a glowing `primary` (Gold) thumb with a subtle outer glow (blur: 8px) to mimic a backlit bottle.

## 6. Do's and Don'ts

### Do:
*   **DO** use whitespace as a luxury. High-end brands aren't afraid of "empty" space.
*   **DO** use `newsreader` for numbers in recipes (e.g., "2 oz"). It adds a bespoke, handwritten feel.
*   **DO** utilize the `roundedness-sm` (0.125rem) for small chips to keep them looking "precise" and architectural.

### Don't:
*   **DON'T** use pure white (#FFFFFF). It breaks the cinematic immersion. Always use `primary-text` (#EAEAEA).
*   **DON'T** use standard system icons. Use thin-stroke (1px or 1.5px) custom iconography to match the `manrope` weight.
*   **DON'T** use 100% opaque cards. Use 90% opacity to let the dark wood/bar background textures provide "warmth" to the UI.