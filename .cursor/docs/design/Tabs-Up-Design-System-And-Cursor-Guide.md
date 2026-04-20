# Tabs Up — Design System & Cursor Guide

**Single source of truth** for visual language, tokens, reusable patterns, and how AI-assisted work should extend the app without drifting from the established look and feel.

**Audience:** Designers, developers, and Cursor agents working in this repository.

**Canonical implementation:** SwiftUI. Tokens live in code — **`AppColors`**, **`DesignSpacing`**, **`DesignLayout`**, **`DesignTypography`**, **`DesignRadius`**, **`DesignStroke`** / **`DesignOpacity`**, **`DesignElevation`**, **`DesignMotion`**, and view modifiers in **`DashboardChrome.swift`**. This document describes *what* to use and *where* it lives.

---

## 1. Brand & experience principles

| Principle | What it means in practice |
|-----------|---------------------------|
| **Soft, confident UI** | Rounded rectangles with `.continuous` corner style, light elevation (shadows) on light mode, restrained borders. |
| **Teal + purple brand** | Primary accent is teal (`#00D4AA`); secondary accent is purple (`#9B59B6`). Full-strength gradient is reserved for **primary CTAs** and strong brand moments; chips and selection use **softer** teal–purple washes. |
| **Readable hierarchy** | Large bold numbers for money; `secondaryText` for captions; section titles use `.headline` + semibold. |
| **System typography** | Prefer **SF Pro** via SwiftUI semantic fonts (`.title`, `.headline`, `.subheadline`, `.caption`). For fixed point sizes (dashboard titles, hero amounts, keypad), use **`DesignTypography`** — do not scatter raw `.system(size:)` values in views. |
| **Light-first, dark-aware** | Semantic colours use `AppColors` adaptive pairs. Test new UI in **both** schemes. |
| **One interaction model** | Tappable controls that look like pills or cards use `DashboardSubtlePressButtonStyle` unless a system control (e.g. `List`) dictates otherwise. |

---

## 2. Colour system

### 2.1 Brand (fixed hex — use via `AppColors`)

| Token | Hex | Usage |
|-------|-----|--------|
| `tealAccent` | `#00D4AA` | Selection accents, borders, pager active segment, teal text on chips |
| `purpleAccent` | `#9B59B6` | Secondary accent, stepper tint family, gradient end stops |
| `greenIcon` | `#00D4AA` | Alias for icon emphasis where “green check” semantics apply |

### 2.2 Semantic surfaces & text (`AppColors`)

| Token | Role |
|-------|------|
| `primaryBackground` | Screen canvas (light: **`#F7F8FC`**; dark: deep blue-grey) |
| `cardBackground` | Cards, circular icon buttons, sheet surfaces |
| `primaryText` | Main labels and values (`.label` / white in dark) |
| `secondaryText` | Hints, captions, “Total Bill”, “people” |
| `borderSubtle` | 1 pt hairlines on cards and chrome |
| `buttonText` | White on primary CTA |

### 2.3 Gradients (always via helpers — do not hard-code stops in views)

| API | Role |
|-----|------|
| `AppColors.gradient(colorScheme:)` | **Primary CTA** — light: mint `#2EC4B6` → sky `#38BDF8` → violet `#5B73F0` (leading → trailing); dark: teal → purple (diagonal) |
| `AppColors.chipSelectedBackground(colorScheme:)` | Legacy teal → purple horizontal wash; **`splitTypeSelectedGradient`** aliases this (prefer **`tipChipSelectedGradient`** / **`splitTypePillSelectedGradient`** for UI) |
| `AppColors.tipChipSelectedGradient(colorScheme:)` | **Selected Add Tip** squircles: mint/turquoise (leading) → very pale white-cyan (trailing) |
| `AppColors.brandTintGradient(colorScheme:)` | **Small accents** — icons in selected Split Type, decorative glyphs (teal → purple, diagonal, softer) |

### 2.4 Component-specific fills (`AppColors`)

| Token / function | Role |
|------------------|------|
| `tipChipInactiveFill(colorScheme:)` | Unselected Add Tip chips — **same as** `splitTypeUnselectedFill` (inactive Split Type / Weighted) |
| `splitTypeUnselectedFill(colorScheme:)` | Unselected Split Type segment (light: **white**; dark: card-like) |
| `splitTypePillBorderTeal` | Selected Split Type capsule border (mockup `#26C4A6`) |
| `splitTypePillSelectedGradient(colorScheme:)` | Selected fill: soft white-cyan → mint (light); dark teal pair |
| `splitTypeEvenIconRear` | Navy (`#2C3E50`) for rear figure in layered Even icon fallback |
| `splitTypeInactiveBorderColor` | Hairline on unselected Split Type |
| `stepperPurpleTintLight` | `#EDE7F5` — ± button background (light) |
| `stepperIconTint` | Purple (`purpleAccent`) on ± icons in light mode |

### 2.5 Currency pill (Total Bill card)

Aligned with **selected Add Tip** chips:

- **Fill:** `tipChipSelectedGradient(colorScheme:)`
- **Border:** `splitTypePillBorderTeal` (`#26C4A6`), **`DesignStroke.chipBorder`** (1.25 pt)
- **Radius:** `DesignRadius.tipChip`
- **Label / chevron:** `primaryText` (and slightly muted chevron)

---

## 3. Typography

| Element | Pattern |
|---------|---------|
| Dashboard screen title (“Split”, “Tip”) | **`DesignTypography.dashboardScreenTitle`** + `AppColors.primaryText` |
| Subtitle under title | `.subheadline`, muted (light: `primaryText` @ **`DesignOpacity.subtitleOnLight`** or `secondaryText`) |
| Section labels (“Add Tip”, “Split Type”) | `.headline` + `.semibold` + `primaryText` |
| Card captions (“Total Bill”, “Per person (even)”) | `.footnote` / `.caption` + `secondaryText` |
| Money — Total Bill hero | **`DesignTypography.totalBillHero`** |
| Money — large metrics (per person, weighted range, tip totals) | **`DesignTypography.largeMetric`** / **`tipSummaryPrimary`** as appropriate |
| Keypad / large entry | **`DesignTypography.keypadDisplay`** |
| Sheet bar (close, title, balance) & keypad digit keys | **`DesignTypography.sheetNavigationBar`**, **`keypadKeyTitle`** (Dynamic Type `.title2` scale) |
| Dashboard menu icon | **`DesignTypography.dashboardBarButton`** |
| Card inline icons / emphasized amounts (`.title3` scale) | **`DesignTypography.cardInlineIcon`** |
| Primary CTA label | `.headline` on button content + `.dashboardPrimaryCTA()` |

---

## 4. Spacing & layout

Use **`DesignSpacing`** for insets and stack spacing; use **`DesignLayout`** for hit targets (e.g. **`touchTarget` 44**), pager dot geometry, keypad row height, etc.

| Convention | Token / value |
|------------|---------------|
| Screen horizontal padding | **`DesignSpacing.screenHorizontal`** (20 pt) |
| Vertical spacing between major blocks | **`DesignSpacing.section`** (24 pt) — but **not** between subtitle and pager (see §7.1) |
| Pager dots → first card (Total Bill) | **`DesignSpacing.pagerToFirstCard`** (12 pt) |
| Header cluster top inset | **`DesignSpacing.headerTop`** (4 pt) |
| Subtitle → pager dots | **`DesignSpacing.compact`** (8 pt) inside the header+pager inner `VStack` |
| Pager indicator | Below subtitle; **centered**; horizontal padding **`screenHorizontal`** |
| Chip / control spacing | **`DesignSpacing.related`** (12 pt) |
| Sheet horizontal / bottom | **`DesignSpacing.sheetHorizontal`**, **`screenBottom`** |
| Card interior (replaces bare `.padding()`) | **`DesignSpacing.insetDefault`** (16 pt) |
| Flush stacks (no inter-row gap) | **`DesignSpacing.stackFlush`** (0) — prefer over raw `spacing: 0` |
| Collapsed `Spacer` | **`DesignSpacing.spacerMinCollapsed`** (0) |

Canvas wash opacities on **`DashboardCanvasBackground`**: **`DesignOpacity.canvasTealWashLight`** / **`canvasPurpleWashLight`**. Gradient endpoint locations: **`DesignLayout.gradientStopStart`** / **`gradientStopEnd`**.

Currency chevron mute: **`DesignOpacity.currencyChevronMuted`**.

Elevation shadows use **`DesignElevation.shadowBase`** (not raw `Color.black` in views). Invisible stroke width: **`DesignStroke.hidden`**.

---

## 5. Corner radii & shapes

**Do not hard-code radii in views.** Use **`DesignRadius`** (`TabsUp/Utilities/DesignRadius.swift`) — single source of truth aligned with mockups (~24–32pt large cards, ~10–14pt compact controls, ~16–18pt split type).

| Token | pt | Use |
|-------|-----|-----|
| `DesignRadius.card` | **28** | Main white cards: Total Bill, People, Per person, Tip totals, breakdown cards, `dashboardCardSurface` / `splitDashboardPrimaryCardSurface` defaults |
| `DesignRadius.tipChip` | **12** | Add Tip squircles (height **44**) and **currency** pill on Total Bill (same radius + active chip styling) |
| `DesignRadius.stepper` | **12** | ± controls ( **44×44** ) |
| `DesignRadius.iconTile` | **10** | Purple people icon square |
| `DesignRadius.sheetControl` | **12** | Custom Tip toggles, keypad keys, `EnterAmountView` keypad cells |
| `DesignRadius.breakdownCompact` | **10** | Split breakdown: Shares/Percentages toggle, person row ± buttons |
| `DesignRadius.splitTypeSegment` | **17** | Even / % Weighted segments (`RoundedRectangle`, continuous, height **48**) |
| `DesignRadius.primaryButtonHeight` | **56** | Primary CTA & solid Done-style buttons |
| Primary CTA shape | — | **`Capsule(style: .continuous)`** via `.dashboardPrimaryCTA()` — full pill, not a numeric radius |
| Pager active segment | — | **`Capsule`** (intrinsic) |
| Settings / menu (header) | — | **Circle** + `dashboardCircularIconSurface()` |

To change curvature app-wide, adjust **`DesignRadius`** and rebuild.

---

## 6. Elevation & shadows

Numeric shadow parameters live in **`DesignElevation`**; View extensions (**`designSplitPrimaryCardShadow()`**, **`designDashboardCardLiftShadow`**, **`designPrimaryCTAShadow`**, **`designCircularIconShadow`**, **`designCurrencyPillShadow()`**) apply them consistently.

| Surface | Treatment |
|---------|-----------|
| `dashboardCardSurface` | **`DesignElevation.DashboardCard`** — light lift only |
| `splitDashboardPrimaryCardSurface` / Total Bill surface | **`DesignElevation.SplitPrimaryCard`** paired layers |
| Tip chips (inactive, light) | **`DesignElevation.TipChip`** — selected vs unselected radii in `TipButton` |
| Primary CTA (light) | **`DesignElevation.PrimaryCTA`** + capsule stroke via **`DesignOpacity.ctaCapsuleBorderLight` / `Dark`** |

Hairline strokes use **`DesignStroke.hairline`**; chip / split borders use **`chipBorder`** / **`splitTypeSelected`**.

Do **not** mix ad-hoc shadow values on new screens — extend **`DesignElevation`** and the `View` helpers in **`DesignElevation.swift`**.

---

## 7. Components (reference patterns)

### 7.1 Screen chrome

- **Background:** `DashboardCanvasBackground()` — base `primaryBackground` + light-only subtle teal/purple wash.
- **Header:** Title + subtitle in a leading `VStack`; trailing **hamburger** `line.3.horizontal` in circular surface → opens `CurrencySettingsView` (Appearance + Currency). Use **`HStack(alignment: .top)`** so the menu aligns with the title row (not vertically centered across title + subtitle).
- **Header + pager block:** Wrap title row and **`PagerIndicatorView`** in an inner **`VStack(spacing: DesignSpacing.compact)`** with shared horizontal padding — do **not** place the pager as a separate sibling of a loose `VStack(spacing: section)` or you get **24 pt** between subtitle and dots. Use an outer **`VStack(spacing: 0)`**; put **`DesignSpacing.pagerToFirstCard`** on the Total Bill card so dots → card stays tight; use **`DesignSpacing.section`** for the block *below* Total Bill (Add Tip, etc.).

### 7.2 Pager indicator

- `PagerIndicatorView` — capsule active segment (teal), inactive dots; **center** alignment; spring animation on change. Dot buttons use modest vertical padding (compact row).

### 7.3 Total Bill card

- **Two tap targets:** currency pill (`onCurrencyTap`) opens settings; amount area (`onTap`) opens amount entry.
- **Currency pill:** same visual system as **Add Tip (selected)** — `tipChipSelectedGradient`, `splitTypePillBorderTeal`, `DesignRadius.tipChip`; light-mode shadow matches tip chips.
- Pill shows **code + chevron.down**; no trailing chevron on the card row.

### 7.4 Add Tip chips

- **Shape:** Squircle **`DesignRadius.tipChip`**, height **44**.
- **Selected:** `tipChipSelectedGradient` (mint left → pale white-cyan right) + border **`splitTypePillBorderTeal`** (`#26C4A6`); label **`primaryText`** (black in light).
- **Unselected:** `tipChipInactiveFill` (same as **`splitTypeUnselectedFill`** — inactive Split Type / Weighted) + **`primaryText`**; **no** border.

### 7.5 Number of people

- Purple **rounded square** icon container (`purpleIcon`) + `person.2.fill` white.
- **Steppers:** light purple fill + purple icon tint (see `stepperPurpleTintLight` / `stepperIconTint`).

### 7.6 Split Type

- **Shape:** `RoundedRectangle(cornerRadius: DesignRadius.splitTypeSegment, style: .continuous)`, height **48** (mockup ~16–18pt corners).
- **Selected:** `splitTypePillSelectedGradient` + **`splitTypePillBorderTeal`** (`#26C4A6`); labels **`primaryText`** (black in light).
- **Unselected (light):** **White** fill, **no** stroke; soft **drop shadow** only. **Unselected (dark):** hairline border.
- **Even icon — selected:** Use asset **`SplitTypeEvenPeople`** in `Assets.xcassets` if present; otherwise layered `person.fill` fallback (teal `#26C4A6` + navy rear). **Even — unselected:** `person.2.fill` monochrome.
- **Weighted icon:** `chart.pie.fill`; selected uses `brandTintGradient`, unselected `primaryText`.

### 7.7 Primary CTA

- `.dashboardPrimaryCTA()` — full width, height **`DesignRadius.primaryButtonHeight`**, **`Capsule`** clip, white text, brand gradient, light stroke, light shadow.

### 7.8 Interaction

- **`DashboardSubtlePressButtonStyle`** — scale to `0.96` with spring; use for pills, cards acting as buttons, CTA.

---

## 8. Icons (SF Symbols)

| Context | Symbol |
|---------|--------|
| Settings entry (header) | `line.3.horizontal` |
| Currency dropdown | `chevron.down` (with currency code) |
| Split / Even | `person.2.fill` |
| Weighted split | `chart.pie.fill` |
| CTA trailing | `chevron.right` |
| Result decorative (even split card) | Asset `PerPersonBillIcon` (`Assets.xcassets`) — receipt + check on soft circle; decorative only |

Prefer **filled** vs **outline** consistently per component family; do not mix weights arbitrarily.

---

## 9. File map (where to change what)

| Concern | File(s) |
|---------|---------|
| **Corner radii & CTA height (tokens)** | `TabsUp/Utilities/DesignRadius.swift` |
| Colour tokens, gradients, hex helpers | `TabsUp/Utilities/AppColors.swift` |
| Shared backgrounds, card modifiers, CTA, press style | `TabsUp/Utilities/DashboardChrome.swift` |
| Appearance mode storage | `TabsUp/Utilities/AppAppearance.swift` |
| Split + Tip dashboards, compound components | `TabsUp/Views/SplitDashboardView.swift`, `TipDashboardView.swift` |
| Pager | `TabsUp/Views/PagerIndicatorView.swift` |
| Settings sheet | `TabsUp/Views/CurrencySettingsView.swift` |

---

## 10. Cursor / AI workflow (keep the app consistent)

When implementing or refactoring UI:

1. **Read this guide first** when the task touches layout, colour, typography, or new screens.
2. **Reuse tokens** from `AppColors`, **`DesignRadius`**, and modifiers from `DashboardChrome` — do not introduce magic radii or new hex colours in views unless you add a named token and document it here.
3. **Match existing components** — new features should look like siblings of `TotalBillCard`, tip chips, and Split Type (radii, shadows, padding 20).
4. **Respect product rules** in `.cursor/docs/ai/cursor-rules.md** (no silent redesigns; minimal diffs).
5. **Dual-scheme check** — verify light and dark for any new surface or gradient.
6. **Update this document** when you add a new reusable token, modifier, or component pattern — the guide and code should stay in sync.

### Checklist — new screen or major section

- [ ] Uses `DashboardCanvasBackground` (or justified exception)
- [ ] Horizontal padding 20 for main content
- [ ] Text uses `primaryText` / `secondaryText` (no raw `.gray` unless semantic)
- [ ] Primary actions use `.dashboardPrimaryCTA()` or documented variant
- [ ] Tappable custom controls use `DashboardSubtlePressButtonStyle` where appropriate
- [ ] Colours come from `AppColors` (or shared modifiers); corners from **`DesignRadius`**
- [ ] Light + dark verified

---

## 11. Revision history (manual)

| Date | Notes |
|------|--------|
| 2026-04-19 | Initial design system + Cursor guide (aligned with Split/Tip dashboard implementation). |
| 2026-04-19 | **`DesignRadius`** tokens; large cards **28pt**, compact controls **10–12pt**, split type **17pt**, primary CTA **`Capsule`**; style guide §5 updated. |

---

*End of document.*
