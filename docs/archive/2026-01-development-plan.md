# TabsUp iOS App Development Plan

## Overview

Build a SwiftUI-based iOS bill splitting application compatible with iOS 17+. The app allows users to split bills evenly or by weighted shares/percentages, with persistent currency selection.

## Xcode project

- **Project file:** `TabsUp.xcodeproj` (project name: **TabsUp**)
- **Targets:** `TabsUp` (iOS app), `TabsUpTests` (unit tests), `TabsUpUITests` (UI tests)
- **Source folders (on disk):** `TabsUp/`, `TabsUpTests/`, `TabsUpUITests/` — each target uses a synchronized root group pointing at the matching folder

## Architecture

### File Structure

```
TabsUp/
├── TabsUpApp.swift (entry point)
├── LaunchScreen.storyboard
├── Assets.xcassets/
├── Models/
│   ├── Currency.swift
│   ├── Person.swift
│   └── SplitType.swift
├── Views/
│   ├── SplitDashboardView.swift (main screen)
│   ├── EnterAmountView.swift (modal for bill input)
│   ├── SplitBreakdownView.swift (detailed breakdown)
│   ├── CurrencySettingsView.swift (currency selection)
│   └── ShareSheetView.swift
├── ViewModels/
│   └── SplitViewModel.swift (observable state, calculations, people array)
├── Utilities/
│   ├── AppColors.swift (color palette)
│   └── UserDefaultsManager.swift (persistence)
TabsUpTests/
└── TabsUpTests.swift
TabsUpUITests/
├── TabsUpUITests.swift
└── TabsUpUITestsLaunchTests.swift
```

## Implementation Steps

### 1. Color Palette & Theme

Create `AppColors.swift` with color constants matching the mockups:

- Teal/Green accent: `#00D4AA` (approximate from screenshots)
- Purple accent: `#9B59B6` (approximate from screenshots)
- Dark background: `#1A1A2E` or similar dark purple-grey
- Card background: Dark purple-grey variant
- Text colors: White for primary, light grey for secondary

### 2. Data Models

- **Currency.swift**: Enum or struct with currency code, name, symbol (USD, EUR, GBP, JPY, CAD, AUD, CHF, CNY, INR, MXN, BRL, ZAR)
- **SplitType.swift**: Enum for `.even` and `.weighted`
- **Person.swift**: Struct with name, shares, percentage, calculated amount
- **SplitViewModel.swift**: Holds bill total, tip, headcount, split type, currency, and people array (the main “split” state lives here rather than a separate `BillSplit` type)

### 3. Persistence Layer

- **UserDefaultsManager.swift**: Singleton to persist selected currency using `@AppStorage` or `UserDefaults`
- Store currency code as string (e.g., "USD", "GBP")

### 4. Business Logic

- **SplitViewModel.swift**: ObservableObject managing:
  - Bill total amount
  - Tip percentage (0%, 10%, 15%, 20%, 25%)
  - Number of people (minimum 2)
  - Split type (even/weighted)
  - Selected currency
  - People array with shares/percentages
  - Calculation methods for even split and weighted split
  - Total with tip calculation

### 5. Main Dashboard View (`SplitDashboardView`)

Components:

- Header: "Split" title, "Let's divide that bill fairly" subtitle, settings gear icon (top right)
- Total Bill Card: Green dollar icon, bill amount display, "Scan" button (UI only)
- Tip Selection: Horizontal buttons for tip percentages
- Number of People Card: Purple people icon, +/- controls, count display
- Split Type Toggle: "Even Split" vs "% Weighted" segmented control
- Result Display:
  - For even split: "Per person (even)" card with calculated amount
  - For weighted: "Range (weighted)" card with min-max range, "Customize Split" button
- Navigation to EnterAmountView when tapping bill amount
- Navigation to CurrencySettingsView when tapping settings icon

### 6. Enter Amount View (`EnterAmountView`)

- Modal/sheet presentation
- Header: "X" close button, "Enter Amount" title
- "Bill Total" label
- Amount display with currency symbol
- Custom numeric keypad (0-9, decimal point, backspace)
- "Confirm Amount" button (teal/green)
- Updates parent view's bill total on confirm

### 7. Split Breakdown View (`SplitBreakdownView`)

- Navigation bar: Back arrow, "Split Breakdown" title, share icon
- Total Bill display card
- Split Method Toggle: "Shares" (default) vs "Percentages"
- Person cards list:
  - Avatar icon (green for "You", purple for others)
  - Name ("You", "Friend 1", "Friend 2", etc.)
  - Amount owed
  - Shares/Percentage with +/- adjustment buttons
- "Start New Split" button
- "Done" button (teal/green with checkmark)
- Real-time recalculation when shares/percentages change

### 8. Currency Settings View (`CurrencySettingsView`)

- Navigation bar: Back arrow, "Settings" title
- "CURRENCY" section header
- List of currencies with:
  - Currency name
  - ISO code
  - Symbol (green)
  - Toggle switch (green when selected)
- Persist selection using UserDefaultsManager
- Update app-wide currency on selection

### 9. App Entry Point

- Update `TabsUpApp.swift` to initialize with SplitDashboardView
- Set dark mode appearance
- Initialize default currency (USD) if none selected

## Key Features

### Split Calculations

- **Even Split**: `(billTotal + tip) / numberOfPeople`
- **Weighted Split (Shares)**: Each person's amount = `(personShares / totalShares) * (billTotal + tip)`
- **Weighted Split (Percentages)**: Each person's amount = `(personPercentage / 100) * (billTotal + tip)`
- Ensure percentages always sum to 100%
- Ensure shares are positive integers

### UI/UX Details

- Dark theme throughout
- Rounded corners on cards (cornerRadius ~16)
- Smooth animations for state changes
- Proper spacing and padding matching mockups
- Currency symbol formatting based on selected currency
- Number formatting with 2 decimal places

## Testing Considerations

- Test with iOS 17, 18, and latest iOS versions
- Verify currency persistence across app launches
- Test split calculations with various scenarios
- Test edge cases (0 people, negative amounts, etc.)
- Verify UI matches mockup designs

## Dependencies

- SwiftUI (iOS 17+)
- Foundation framework
- UserDefaults for persistence
