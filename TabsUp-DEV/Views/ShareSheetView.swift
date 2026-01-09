//
//  ShareSheetView.swift
//  TabsUp
//
//  Created by Thomas Weschke on 09/01/2026.
//

import SwiftUI
import UIKit
import LinkPresentation

class ShareActivityItemSource: NSObject, UIActivityItemSource {
    let shareText: String
    
    init(shareText: String) {
        self.shareText = shareText
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return shareText
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return shareText
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return "Breakdown from TabsUp"
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = "Breakdown from TabsUp"
        
        // Try to get app icon
        if let appIcon = getAppIcon() {
            metadata.iconProvider = NSItemProvider(object: appIcon)
        }
        
        return metadata
    }
    
    private func getAppIcon() -> UIImage? {
        // Try multiple approaches to get the app icon
        if let icon = UIImage(named: "AppIcon") {
            return icon
        }
        
        // Try getting from bundle icons
        if let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
           let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? [String: Any],
           let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? [String] {
            for iconName in iconFiles.reversed() {
                if let icon = UIImage(named: iconName) {
                    return icon
                }
            }
        }
        
        // Fallback: try common app icon names
        let commonNames = ["AppIcon-60@2x", "AppIcon-60@3x", "AppIcon-76", "AppIcon-76@2x"]
        for name in commonNames {
            if let icon = UIImage(named: name) {
                return icon
            }
        }
        
        return nil
    }
}

struct ShareSheetView: UIViewControllerRepresentable {
    let activityItemSource: ShareActivityItemSource
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: [activityItemSource],
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No update needed
    }
}
