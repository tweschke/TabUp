//
//  DesignSpacing.swift
//  TabsUp
//
//  Horizontal insets, vertical rhythm, and stack spacing — avoids magic numbers in views.
//

import CoreGraphics

enum DesignSpacing {
    // MARK: - Structural (no extra gap)

    /// Use for `VStack` / `HStack` when siblings must sit flush (replaces raw `spacing: 0`).
    static let stackFlush: CGFloat = 0

    /// `Spacer(minLength:)` when the flexible space should collapse to zero.
    static let spacerMinCollapsed: CGFloat = 0

    // MARK: - Major vertical rhythm

    /// Space between major dashboard sections (cards, section blocks).
    static let section: CGFloat = 24

    /// Space from pager dots row down to the Total Bill card — tighter than `section`.
    static let pagerToFirstCard: CGFloat = 12

    // MARK: - Screen & sheet insets

    /// Main scroll content horizontal inset (dashboard cards, breakdown).
    static let screenHorizontal: CGFloat = 20

    /// Slightly wider inset (e.g. tip chip horizontal padding).
    static let screenHorizontalWide: CGFloat = 22

    /// Sheets and full-screen panels (Custom Tip, Enter Amount).
    static let sheetHorizontal: CGFloat = 24

    /// Bottom padding for scroll content and sheet footers.
    static let screenBottom: CGFloat = 32

    /// First section below sheet header / mode toggle block.
    static let sheetSectionTop: CGFloat = 24

    /// Space above large keypad display block in sheets.
    static let sheetDisplayTop: CGFloat = 32

    /// SwiftUI default-style uniform padding for card interiors (replaces bare `.padding()`).
    static let insetDefault: CGFloat = 16

    // MARK: - Tight stacks

    /// Micro gap (pager padding, baseline pairs, keypad glyph stack) — same value as `headerTop`.
    static let tight: CGFloat = 4

    /// Header top padding; pager dot touch padding; small row nudge.
    static let headerTop: CGFloat = 4

    /// Title + subtitle column; keypad title/subtitle.
    static let compact: CGFloat = 8

    /// Title block: “Split” over subtitle.
    static let titleGroup: CGFloat = 5

    /// Chip rows, split-type pair, dashboard header icon row.
    static let related: CGFloat = 12

    /// Card subsections (e.g. weighted result block).
    static let subsection: CGFloat = 16

    /// Inline label + value (currency row, baseline pairs).
    static let inlineTight: CGFloat = 6

    /// Total Bill: currency pill ↔ amount block.
    static let totalBillCore: CGFloat = 18

    /// Even / weighted result: label block ↔ icon.
    static let resultRow: CGFloat = 14

    /// Number of People: count vs “people” caption.
    static let stepperCaption: CGFloat = 2

    /// Preview & tight vertical stacks.
    static let preview: CGFloat = 16

    /// List row / settings compact vertical padding.
    static let listRowCompact: CGFloat = 8
}
