---
name: video-hero
description: Build full-screen video background hero landing pages as single HTML files or React/Next.js components with liquid glass effects, responsive typography, and multiple layout archetypes. Triggers on "build a landing page", "create a hero section", "website with video background", "hero page", "glass effect site", "video landing page", "video hero", "cinematic landing page", "dark theme website", "product landing page with video".
user_invocable: true
---

# Video Hero — Video Background Landing Page Builder

Build stunning full-screen video background hero landing pages as **single self-contained HTML files** or **React/Next.js components**. No build step needed for HTML variant — just one `.html` file with inline CSS and JS.

## Non-Negotiables

1. **Single file** (HTML variant): One self-contained HTML file — inline CSS + JS, no external stylesheets or scripts
2. **Full-viewport hero**: `height: 100vh; height: 100dvh` on the hero section
3. **Video rules**: `autoplay loop muted playsinline` — always, no exceptions
4. **Distinctive design**: No generic Bootstrap/template look. Strong visual identity via typography, color, and glass effects
5. **Accessible**: `prefers-reduced-motion` hides video and shows solid background fallback
6. **Responsive**: Must work at 1920, 1280, 768, 375 widths
7. **CDN only** (HTML variant): Google Fonts + Lucide icons via CDN are the only external requests allowed
8. **Contrast**: All text over video must have sufficient contrast via overlay gradient (minimum rgba(0,0,0,0.3))
9. **Keyboard accessible**: All interactive elements reachable via Tab, Enter, Escape

## Workflow

### 1. Gather Inputs

Ask only what's needed (defaults in parens):

| Input | Default |
|-------|---------|
| Brand name | Required |
| Primary color | `#00E5A0` (electric green) |
| Background color | `#000000` (black) |
| Tagline / headline | Generate from brand |
| Subheadline | Generate from brand |
| CTA text + URL | "Get Started" / `#` |
| Font preference | bold/industrial |
| Layout archetype | full-width-left |
| Video source | Ask user or use `/higgsfield video` |

### 2. Choose Layout Archetype

See [Layout Archetypes](#layout-archetypes) below. Recommend based on brand personality:
- **full-width-left**: Bold, industrial, logistics/tech — content upper-third left
- **two-panel-split**: Modern SaaS, feature-rich — left hero + right feature cards
- **centered-hero**: Classic elegance, consumer/lifestyle — centered headline + dual CTAs

### 3. Obtain Video + Still Frame

Three paths for video:
1. **User provides URL**: Use directly as `<source src="URL">`
2. **User provides local file**: Use relative path
3. **Generate via HiggsField**: Use `/higgsfield video` skill with a prompt matching the brand mood

**Still Frame Selection** (when extracting a freeze frame for poster/fallback):

1. **Sample 5-6 frames** across the video duration (e.g., 0s, 3s, 5s, 7s, 9s, 12s)
2. **Evaluate each frame** for:
   - **Subject composition**: Is the main subject well-framed? 3/4 angle > head-on
   - **Negative space**: Is there room for text overlay without competing?
   - **Visual energy**: Motion blur, sparks, light trails add dynamism to a still
   - **Brand alignment**: Does the color temperature match the brand palette?
3. **Show options to the user** — never pick a single frame without evaluation. Present 2-3 best candidates with brief notes on why each works.
4. **Extract with ffmpeg**: `ffmpeg -ss {time} -i video.mp4 -vframes 1 -update 1 -q:v 2 output.jpg`

Never grab the first available frame. A poorly chosen freeze frame undermines the entire hero.

### 4. Assemble the Page

1. Set CSS custom properties from design system template
2. Add video background boilerplate (with poster from step 3 if available)
3. Build layout from chosen archetype
4. Apply liquid glass effects to cards/panels
5. Add button styles matching archetype
6. Add responsive breakpoints + reduced-motion rules
7. Add SEO meta tags

### 5. Deliver

1. Save to current working directory as `{brand-name}-landing.html`
2. Open with `start "" {filename}` (Windows)
3. Report file path and customization points

---

## Performance Budgets

| Metric | Target | Hard Limit |
|--------|--------|------------|
| Video file size | < 10MB | < 15MB |
| LCP | < 2.5s | < 3.5s |
| Total page weight (excl. video) | < 100KB | < 200KB |
| Time to hero visible | < 1.5s | < 2.5s |

**Video optimization:**
- Target 720p for background videos (1080p only if hero is the ONLY content)
- Use H.264 for max compatibility, H.265 for Safari with H.264 fallback
- Aim for 2-4 Mbps bitrate for backgrounds (detail is hidden by overlay)
- Keep duration 10-20s for clean loops

---

## Design System Template

Every page starts with these CSS custom properties. Replace values per brand:

```css
:root {
  /* Brand */
  --color-primary: #00E5A0;
  --color-bg: #000000;
  --color-text: #FFFFFF;
  --color-muted: rgba(255,255,255,0.6);
  --color-accent: #00E5A0;

  /* Typography */
  --font-display: 'Bebas Neue', Impact, sans-serif;
  --font-body: 'Inter', system-ui, sans-serif;
  --font-accent: 'Space Mono', monospace;

  /* Fluid sizing */
  --size-headline: clamp(3rem, 8vw, 7rem);
  --size-subhead: clamp(1rem, 2vw, 1.5rem);
  --size-body: clamp(0.875rem, 1.2vw, 1.125rem);

  /* Letter spacing */
  --ls-tight: -0.04em;
  --ls-wide: 0.08em;
  --ls-ultra: 0.2em;

  /* Glass */
  --glass-blur-light: 4px;
  --glass-blur-strong: 50px;
  --glass-bg-light: rgba(255,255,255,0.04);
  --glass-bg-strong: rgba(255,255,255,0.08);
  --glass-border-light: rgba(255,255,255,0.08);
  --glass-border-strong: rgba(255,255,255,0.15);

  /* Layout */
  --max-width: 1400px;
  --section-padding: clamp(2rem, 5vw, 6rem);
}
```

### Recommended Font Pairings

| Style | Display | Body | Accent |
|-------|---------|------|--------|
| Bold / Industrial | Bebas Neue | Inter | Space Mono |
| Elegant / Editorial | Playfair Display | Lora | — |
| Clean / Modern | Sora | DM Sans | JetBrains Mono |
| Luxury / Minimal | Cormorant Garamond | Nunito Sans | — |

Google Fonts link template:
```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=FONT1&family=FONT2&display=swap" rel="stylesheet">
```

Lucide icons CDN:
```html
<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.min.js"></script>
<!-- After DOM: --> <script>lucide.createIcons();</script>
```

---

## Video Background Boilerplate

```html
<div class="video-bg">
  <video autoplay loop muted playsinline poster="poster.jpg">
    <source src="VIDEO_URL" type="video/mp4">
  </video>
  <div class="video-overlay"></div>
</div>
```

```css
.video-bg {
  position: fixed;
  inset: 0;
  z-index: 0;
  overflow: hidden;
}
.video-bg video {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.video-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(
    180deg,
    rgba(0,0,0,0.3) 0%,
    rgba(0,0,0,0.1) 40%,
    rgba(0,0,0,0.6) 100%
  );
}
```

Notes:
- `poster` attribute prevents white flash before video loads — use a still frame from the video (see step 3)
- Mobile Safari requires `playsinline` for autoplay
- The overlay gradient ensures text readability over any video content

---

## Layout Archetypes

### Full-Width Left-Aligned (Targo-style)

Content positioned upper-third left. Glass card anchored bottom-left. Best for bold industrial brands.

```html
<section class="hero">
  <div class="hero-content">
    <p class="hero-kicker">KICKER TEXT</p>
    <h1 class="hero-headline">HEADLINE</h1>
    <p class="hero-sub">Subheadline text here.</p>
    <div class="hero-ctas">
      <a href="#" class="btn-clipped">GET STARTED</a>
      <a href="#" class="btn-ghost">LEARN MORE</a>
    </div>
  </div>
  <div class="hero-glass-card">
    <div class="glass-stat">
      <span class="stat-value">99.8%</span>
      <span class="stat-label">Uptime</span>
    </div>
    <div class="glass-stat">
      <span class="stat-value">24/7</span>
      <span class="stat-label">Support</span>
    </div>
  </div>
</section>
```

```css
.hero {
  position: relative;
  z-index: 1;
  height: 100vh;
  height: 100dvh;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  padding: var(--section-padding);
}
.hero-content {
  max-width: 640px;
  padding-top: 15vh;
}
.hero-kicker {
  font-family: var(--font-accent);
  font-size: var(--size-body);
  letter-spacing: var(--ls-ultra);
  color: var(--color-primary);
  text-transform: uppercase;
  margin-bottom: 1rem;
}
.hero-headline {
  font-family: var(--font-display);
  font-size: var(--size-headline);
  letter-spacing: var(--ls-tight);
  line-height: 0.95;
  color: var(--color-text);
  margin: 0 0 1.5rem;
}
.hero-sub {
  font-family: var(--font-body);
  font-size: var(--size-subhead);
  color: var(--color-muted);
  max-width: 480px;
  line-height: 1.6;
  margin-bottom: 2rem;
}
.hero-glass-card {
  display: flex;
  gap: 2rem;
  padding: 1.5rem 2rem;
  max-width: 400px;
}
```

### Two-Panel Split (Bloom-style)

Left 52% for hero + CTA, right 48% for feature cards in a glass panel. Stacks vertically on mobile.

```html
<section class="hero hero-split">
  <div class="hero-left">
    <h1 class="hero-headline">HEADLINE</h1>
    <p class="hero-sub">Subheadline here.</p>
    <div class="hero-ctas">
      <a href="#" class="btn-pill">Get Started Free</a>
      <a href="#" class="btn-pill btn-pill-outline">Watch Demo</a>
    </div>
  </div>
  <div class="hero-right">
    <div class="feature-card liquid-glass-strong">
      <i data-lucide="zap"></i>
      <h3>Feature One</h3>
      <p>Description text.</p>
    </div>
    <div class="feature-card liquid-glass-strong">
      <i data-lucide="shield"></i>
      <h3>Feature Two</h3>
      <p>Description text.</p>
    </div>
    <div class="feature-card liquid-glass-strong">
      <i data-lucide="trending-up"></i>
      <h3>Feature Three</h3>
      <p>Description text.</p>
    </div>
  </div>
</section>
```

```css
.hero-split {
  display: grid;
  grid-template-columns: 52% 48%;
  align-items: center;
  gap: 2rem;
}
.hero-left { padding-right: 2rem; }
.hero-right {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}
.feature-card {
  padding: 1.5rem;
  border-radius: 16px;
}
.feature-card i {
  width: 24px;
  height: 24px;
  color: var(--color-primary);
  margin-bottom: 0.75rem;
}
.feature-card h3 {
  font-family: var(--font-body);
  font-size: 1.1rem;
  font-weight: 600;
  color: var(--color-text);
  margin: 0 0 0.5rem;
}
.feature-card p {
  font-size: var(--size-body);
  color: var(--color-muted);
  margin: 0;
  line-height: 1.5;
}

@media (max-width: 1024px) {
  .hero-split {
    grid-template-columns: 1fr;
    text-align: center;
  }
  .hero-left { padding-right: 0; }
  .hero-right {
    flex-direction: row;
    flex-wrap: wrap;
    justify-content: center;
  }
  .feature-card { flex: 1 1 280px; max-width: 320px; }
}
```

### Centered Hero (Classic)

Centered headline with dual CTAs. Best for consumer/lifestyle brands.

```html
<section class="hero hero-centered">
  <div class="hero-content-center">
    <p class="hero-kicker">KICKER</p>
    <h1 class="hero-headline">HEADLINE</h1>
    <p class="hero-sub">Subheadline centered.</p>
    <div class="hero-ctas">
      <a href="#" class="btn-pill">Primary CTA</a>
      <a href="#" class="btn-pill btn-pill-outline">Secondary CTA</a>
    </div>
  </div>
</section>
```

```css
.hero-centered {
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
}
.hero-content-center {
  max-width: 800px;
}
.hero-content-center .hero-sub {
  max-width: 600px;
  margin-left: auto;
  margin-right: auto;
}
.hero-ctas {
  display: flex;
  gap: 1rem;
  flex-wrap: wrap;
}
.hero-centered .hero-ctas {
  justify-content: center;
}
```

---

## Liquid Glass CSS

### Light Glass (`.liquid-glass`)

Subtle, transparent. Use for stat cards, nav bars, secondary panels.

```css
.liquid-glass {
  background: var(--glass-bg-light);
  backdrop-filter: blur(var(--glass-blur-light)) saturate(120%);
  -webkit-backdrop-filter: blur(var(--glass-blur-light)) saturate(120%);
  border: 1px solid var(--glass-border-light);
  border-radius: 16px;
  position: relative;
}
.liquid-glass::before {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: inherit;
  padding: 1px;
  background: linear-gradient(
    135deg,
    rgba(255,255,255,0.12) 0%,
    rgba(255,255,255,0) 50%,
    rgba(255,255,255,0.06) 100%
  );
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: xor;
  mask-composite: exclude;
  pointer-events: none;
}
```

### Strong Glass (`.liquid-glass-strong`)

Deep blur, prominent borders. Use for hero cards, CTAs, feature panels.

```css
.liquid-glass-strong {
  background: var(--glass-bg-strong);
  backdrop-filter: blur(var(--glass-blur-strong)) saturate(180%);
  -webkit-backdrop-filter: blur(var(--glass-blur-strong)) saturate(180%);
  border: 1px solid var(--glass-border-strong);
  border-radius: 20px;
  box-shadow:
    0 8px 32px rgba(0,0,0,0.3),
    inset 0 1px 0 rgba(255,255,255,0.05);
  position: relative;
  overflow: hidden;
}
.liquid-glass-strong::after {
  content: '';
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: linear-gradient(
    45deg,
    transparent 40%,
    rgba(255,255,255,0.03) 50%,
    transparent 60%
  );
  pointer-events: none;
}
```

---

## Button Styles

### Clipped Corner (Industrial)

```css
.btn-clipped {
  display: inline-block;
  padding: 1rem 2.5rem;
  background: var(--color-primary);
  color: var(--color-bg);
  font-family: var(--font-display);
  font-size: 1rem;
  letter-spacing: var(--ls-wide);
  text-transform: uppercase;
  text-decoration: none;
  clip-path: polygon(12px 0, 100% 0, 100% calc(100% - 12px), calc(100% - 12px) 100%, 0 100%, 0 12px);
  transition: transform 0.2s, opacity 0.2s;
}
.btn-clipped:hover { transform: translateY(-2px); opacity: 0.9; }
.btn-clipped:focus-visible {
  outline: 2px solid var(--color-primary);
  outline-offset: 4px;
}
```

### Ghost Button

```css
.btn-ghost {
  display: inline-block;
  padding: 1rem 2.5rem;
  background: transparent;
  color: var(--color-text);
  font-family: var(--font-display);
  font-size: 1rem;
  letter-spacing: var(--ls-wide);
  text-transform: uppercase;
  text-decoration: none;
  border: 1px solid rgba(255,255,255,0.2);
  clip-path: polygon(12px 0, 100% 0, 100% calc(100% - 12px), calc(100% - 12px) 100%, 0 100%, 0 12px);
  transition: border-color 0.2s;
}
.btn-ghost:hover { border-color: var(--color-primary); }
.btn-ghost:focus-visible {
  outline: 2px solid var(--color-primary);
  outline-offset: 4px;
}
```

### Glass Pill (Modern/SaaS)

```css
.btn-pill {
  display: inline-block;
  padding: 0.875rem 2rem;
  background: var(--color-primary);
  color: var(--color-bg);
  font-family: var(--font-body);
  font-weight: 600;
  font-size: 1rem;
  text-decoration: none;
  border-radius: 100px;
  border: none;
  transition: transform 0.2s, box-shadow 0.2s;
}
.btn-pill:hover {
  transform: scale(1.05);
  box-shadow: 0 4px 20px rgba(0,0,0,0.3);
}
.btn-pill:focus-visible {
  outline: 2px solid var(--color-primary);
  outline-offset: 4px;
}
.btn-pill-outline {
  background: var(--glass-bg-light);
  color: var(--color-text);
  border: 1px solid var(--glass-border-strong);
  backdrop-filter: blur(var(--glass-blur-light));
  -webkit-backdrop-filter: blur(var(--glass-blur-light));
}
```

---

## Responsive Breakpoints

Always include at the end of the `<style>` block:

```css
@media (max-width: 1024px) {
  .hero-split { grid-template-columns: 1fr; }
  .hero-content { padding-top: 10vh; }
  :root { --size-headline: clamp(2.5rem, 6vw, 4.5rem); }
}

@media (max-width: 640px) {
  .hero { padding: 1.5rem; }
  .hero-ctas { flex-direction: column; }
  .btn-clipped, .btn-ghost, .btn-pill { width: 100%; text-align: center; }
  .hero-glass-card { flex-direction: column; gap: 1rem; }
}

@media (prefers-reduced-motion: reduce) {
  .video-bg video { display: none; }
  .video-bg { background: var(--color-bg); }
  .video-overlay { background: var(--color-bg); }
  *, *::before, *::after {
    animation-duration: 0s !important;
    transition-duration: 0s !important;
  }
}
```

---

## HiggsField Video Integration

Use `/higgsfield video` to generate a background video. Map the brand feel to the best model:

| Brand Feel | Model | Prompt Tips |
|------------|-------|-------------|
| Cinematic / dramatic | Kling 3.0 | "Slow cinematic pan across...", "dramatic lighting" |
| Abstract / artistic | WAN 2.6 | "Abstract flowing particles", "liquid motion" |
| Realistic / product | Veo 3.1 | "Photorealistic aerial shot", "product showcase" |
| Fast / energetic | MiniMax Hailuo | "Dynamic motion", "fast-paced transitions" |
| Dreamy / atmospheric | Sora 2 | "Ethereal atmosphere", "soft focus bokeh" |

Good background video prompts:
- Keep motion slow and looping — avoid sudden cuts
- Dark/moody works best (text readability)
- Abstract > literal for hero backgrounds
- "Seamless loop" in prompt helps some models

---

## Complete HTML Skeleton

Use this as the starting template. Fill in design system vars, chosen archetype, and glass styles:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>BRAND_NAME</title>
  <meta name="description" content="BRAND_DESCRIPTION">
  <meta property="og:title" content="BRAND_NAME">
  <meta property="og:description" content="BRAND_DESCRIPTION">
  <meta property="og:type" content="website">
  <meta name="theme-color" content="#000000">

  <!-- Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=FONT1&family=FONT2&display=swap" rel="stylesheet">

  <style>
    /* === Reset === */
    *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
    html { scroll-behavior: smooth; }
    body {
      font-family: var(--font-body);
      background: var(--color-bg);
      color: var(--color-text);
      overflow-x: hidden;
    }

    /* === Design System (replace per brand) === */
    :root {
      /* PASTE design system vars HERE */
    }

    /* === Video Background === */
    .video-bg { position: fixed; inset: 0; z-index: 0; overflow: hidden; }
    .video-bg video { width: 100%; height: 100%; object-fit: cover; }
    .video-overlay {
      position: absolute; inset: 0;
      background: linear-gradient(180deg, rgba(0,0,0,0.3) 0%, rgba(0,0,0,0.1) 40%, rgba(0,0,0,0.6) 100%);
    }

    /* === Glass Effects === */
    /* PASTE liquid-glass and liquid-glass-strong HERE */

    /* === Hero === */
    .hero {
      position: relative;
      z-index: 1;
      height: 100vh;
      height: 100dvh;
      padding: var(--section-padding);
    }

    /* === ARCHETYPE CSS HERE === */

    /* === Buttons === */
    /* PASTE chosen button style HERE */

    /* === Accessibility === */
    .sr-only {
      position: absolute; width: 1px; height: 1px;
      padding: 0; margin: -1px; overflow: hidden;
      clip: rect(0,0,0,0); white-space: nowrap; border: 0;
    }
    a:focus-visible, button:focus-visible {
      outline: 2px solid var(--color-primary);
      outline-offset: 4px;
    }

    /* === Responsive === */
    /* PASTE responsive breakpoints HERE */
  </style>
</head>
<body>

  <!-- Skip to content -->
  <a href="#hero" class="sr-only" style="position:fixed;top:0;left:0;z-index:10000;padding:1rem;background:var(--color-primary);color:var(--color-bg);">Skip to content</a>

  <!-- Video Background -->
  <div class="video-bg" aria-hidden="true">
    <video autoplay loop muted playsinline poster="poster.jpg">
      <source src="VIDEO_URL" type="video/mp4">
    </video>
    <div class="video-overlay"></div>
  </div>

  <!-- ARCHETYPE HTML HERE (add id="hero") -->

  <!-- Icons (optional) -->
  <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.min.js"></script>
  <script>lucide.createIcons();</script>
</body>
</html>
```

---

## React / Next.js Variant

For projects using React/Next.js instead of a single HTML file:

```tsx
// components/VideoHero.tsx
"use client";
import { useRef, useEffect, useState } from "react";

interface VideoHeroProps {
  videoSrc: string;
  posterSrc?: string;
  headline: string;
  subheadline?: string;
  kicker?: string;
  ctaPrimary?: { text: string; href: string };
  ctaSecondary?: { text: string; href: string };
  /** "left" | "center" | "split" */
  layout?: "left" | "center" | "split";
  brandColor?: string;
  children?: React.ReactNode;
}

export function VideoHero({
  videoSrc,
  posterSrc,
  headline,
  subheadline,
  kicker,
  ctaPrimary,
  ctaSecondary,
  layout = "left",
  brandColor = "#00E5A0",
  children,
}: VideoHeroProps) {
  const videoRef = useRef<HTMLVideoElement>(null);
  const [isReduced, setIsReduced] = useState(false);

  useEffect(() => {
    const mq = window.matchMedia("(prefers-reduced-motion: reduce)");
    setIsReduced(mq.matches);
    const handler = (e: MediaQueryListEvent) => setIsReduced(e.matches);
    mq.addEventListener("change", handler);
    return () => mq.removeEventListener("change", handler);
  }, []);

  return (
    <section
      id="hero"
      className="relative z-10 flex min-h-dvh"
      style={
        layout === "center"
          ? { alignItems: "center", justifyContent: "center", textAlign: "center" }
          : { flexDirection: "column", justifyContent: "space-between" }
      }
    >
      {/* Video Background */}
      <div className="fixed inset-0 z-0 overflow-hidden" aria-hidden="true">
        {!isReduced && (
          <video
            ref={videoRef}
            autoPlay
            loop
            muted
            playsInline
            poster={posterSrc}
            className="w-full h-full object-cover"
          >
            <source src={videoSrc} type="video/mp4" />
          </video>
        )}
        <div
          className="absolute inset-0"
          style={{
            background: isReduced
              ? "var(--color-bg, #000)"
              : "linear-gradient(180deg, rgba(0,0,0,0.3) 0%, rgba(0,0,0,0.1) 40%, rgba(0,0,0,0.6) 100%)",
          }}
        />
      </div>

      {/* Content */}
      <div className="relative z-10 p-[clamp(2rem,5vw,6rem)]">
        <div className={layout === "center" ? "max-w-[800px] mx-auto" : "max-w-[640px] pt-[15vh]"}>
          {kicker && (
            <p
              className="text-sm uppercase tracking-[0.2em] mb-4"
              style={{ color: brandColor }}
            >
              {kicker}
            </p>
          )}

          <h1 className="text-[clamp(3rem,8vw,7rem)] font-bold leading-[0.95] tracking-tight mb-6 text-white">
            {headline}
          </h1>

          {subheadline && (
            <p className="text-[clamp(1rem,2vw,1.5rem)] text-white/60 max-w-[480px] leading-relaxed mb-8">
              {subheadline}
            </p>
          )}

          {(ctaPrimary || ctaSecondary) && (
            <div className={`flex gap-4 flex-wrap ${layout === "center" ? "justify-center" : ""}`}>
              {ctaPrimary && (
                <a
                  href={ctaPrimary.href}
                  className="inline-block px-8 py-3.5 rounded-xl font-semibold text-black transition-transform hover:scale-105"
                  style={{ background: brandColor }}
                >
                  {ctaPrimary.text}
                </a>
              )}
              {ctaSecondary && (
                <a
                  href={ctaSecondary.href}
                  className="inline-block px-8 py-3.5 rounded-xl font-semibold text-white border border-white/20 backdrop-blur-sm transition-colors hover:border-white/40"
                >
                  {ctaSecondary.text}
                </a>
              )}
            </div>
          )}
        </div>
      </div>

      {/* Optional children (glass cards, stats, etc.) */}
      {children && (
        <div className="relative z-10 p-[clamp(2rem,5vw,6rem)]">
          {children}
        </div>
      )}
    </section>
  );
}
```

**Usage:**
```tsx
<VideoHero
  videoSrc="/videos/hero.mp4"
  posterSrc="/images/hero-poster.jpg"
  headline="MOVE FASTER"
  subheadline="Enterprise logistics platform built for speed."
  kicker="TARGO LOGISTICS"
  ctaPrimary={{ text: "Get Started", href: "/signup" }}
  ctaSecondary={{ text: "Watch Demo", href: "/demo" }}
  layout="left"
  brandColor="#C62828"
>
  {/* Glass stat cards */}
  <div className="flex gap-8 max-w-[400px]">
    <div className="backdrop-blur-sm bg-white/5 border border-white/10 rounded-2xl p-4">
      <span className="text-2xl font-bold text-white">99.8%</span>
      <span className="text-sm text-white/50 block">Uptime</span>
    </div>
  </div>
</VideoHero>
```

---

## Delivery Checklist

Before handing off, verify:

- [ ] Video has `autoplay loop muted playsinline`
- [ ] Video has poster fallback (still frame, not first frame)
- [ ] Hero is `100dvh`
- [ ] Responsive at 1920, 1280, 768, 375
- [ ] `prefers-reduced-motion` hides video, disables animations
- [ ] Glass effects have `-webkit-` prefixes for Safari
- [ ] All text passes WCAG AA contrast over video overlay
- [ ] All buttons/links have `:focus-visible` styles
- [ ] Skip-to-content link present
- [ ] `aria-hidden="true"` on decorative video background
- [ ] SEO meta tags (title, description, og:title, og:description, theme-color)
- [ ] Video file < 15MB (target < 10MB)
- [ ] LCP < 3.5s
- [ ] File opened in browser via `start "" filename.html` (HTML variant)
- [ ] File path and easy customization points reported to user

## Related Skills

- `higgsfield` — generate video backgrounds via HiggsField AI
- `overkill-web-design` — design philosophy for taking it to the next level
- `3d-immersive` — code templates for 3D effects, animations, and interactions
