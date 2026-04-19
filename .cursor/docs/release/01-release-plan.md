# Release plan — TabsUp

## Versions

| | Version |
|---|--------|
| **Current (shipping baseline)** | **1.0** |
| **Next** | **1.1** |

## Goal for 1.1

Introduce **Tip mode** alongside the existing **Split** flow so users can work in either mode from a coherent navigation pattern.

## Phases

### Phase 0: Swipe container

Foundation for switching between primary experiences (e.g. horizontal swipe or equivalent container). No full Tip UI yet—focus on structure and safe integration with existing Split screens.

### Phase 1: Tip UI

Screens, controls, and layout for Tip mode consistent with current app style (dark theme, existing typography and spacing patterns). Wire navigation only as far as Phase 0 allows.

### Phase 2: Logic + polish

Tip calculations, validation, edge cases, persistence if required, accessibility passes, and final UI polish. Align versioning and release assets with **02-release-checklist.md**.

## In scope (1.1)

- Tip mode as a first-class companion to Split, per phases above
- Reuse existing design language (colors, components, patterns)
- iOS deployment target and project constraints unchanged unless explicitly decided elsewhere

## Out of scope (1.1)

- New unrelated features (subscriptions, accounts, cloud sync, etc.)
- Full redesign of Split or global navigation unrelated to Tip introduction
- Android or other platforms
- Marketing copy or App Store listing beyond what release checklist requires
