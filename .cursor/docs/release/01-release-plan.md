# TabsUp v1.1 — Release plan

## 1. Version overview

| | |
|---|---|
| **Current (live)** | **1.0** |
| **Next** | **1.1** |

## 2. Goal

- Introduce a **dedicated Tip experience** alongside the existing **Split** flow.
- **Maintain** current UI design and behaviour.

## 3. UX direction

- **Swipeable dashboard container** hosting two modes: **Split** and **Tip**.
- **Split** screen: **unchanged** in layout and behaviour.
- **Tip** is a **separate screen** within that container.
- **Same visual design system** must be used.

### Tip Mode behaviour

- Single-user calculation only
- No "number of people"
- No split type (even / weighted)
- Shows:
  - bill amount
  - tip percentage selection
  - calculated tip amount
  - total including tip

## 4. Phases

| Phase | Focus |
|--------|--------|
| **Phase 0** | Dashboard container (**swipe navigation**). |
| **Phase 1** | **Tip UI** (layout only). |
| **Phase 2** | **Tip logic integration** — reuse existing logic. |
| **Phase 3** | **Polish and validation**. |

## 5. In scope

- Swipe navigation
- Tip calculation screen
- Reuse of existing tip logic
- Design consistency

## 6. Out of scope

- UI redesign
- New features beyond tip mode
- Persistence changes
- Sharing improvements
- Animations overhaul
- Widgets or external integrations

## 7. Constraints

- **`SplitViewModel`** remains the **primary logic source**.
- **Existing Split screen** must **not change visually**.
- **Minimal code changes** only.
- Tip screen must reuse existing components and styling patterns where possible (cards, spacing, typography, colours).
- No new design language may be introduced.

## 8. Implementation guardrails

- Do not modify `.xcodeproj` structure
- Do not rename files or folders
- Do not introduce new dependencies
- Do not perform Git operations
- Work strictly phase-by-phase
- Stop after each phase and report changes
- Always list touched files

## 9. Success criteria

**Phase 0**

- App launches normally
- Split screen behaves exactly as before
- User can swipe to a second placeholder page

**Phase 1**

- Tip screen displays correctly
- UI matches Split design language

**Phase 2**

- Tip values calculate correctly
- No regression in Split functionality

**Phase 3**

- UI spacing, formatting, and consistency verified
- App ready for release testing
