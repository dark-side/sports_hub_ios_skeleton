//
//  DesignSystem.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import SwiftUI

// MARK: - Color Extensions
extension Color {
    // Primary Colors
    static let appPrimary = Color(red: 215.0/255.0, green: 33.0/255.0, blue: 48.0/255.0)
    static let appError = Color.red
    static let appDisabled = Color.gray
    
    // Text Colors
    static let textPrimary = Color(red: 0.17, green: 0.18, blue: 0.26)
    static let textSecondary = Color(red: 0.50, green: 0.48, blue: 0.48)
    
    // Background Colors
    static let backgroundPlaceholder = Color(red: 0.50, green: 0.23, blue: 0.27).opacity(0.50)
    static let backgroundError = Color.red.opacity(0.1)
    static let backgroundComment = Color(red: 1.0, green: 1.0, blue: 1.0)
    static let backgroundCommentSection = Color(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0)
    static let backgroundField = Color(.systemBackground)
    static let backgroundPage = Color(.systemGroupedBackground)
    
    // Border Colors
    static let borderField = Color.gray.opacity(0.3)
    static let borderComment = Color(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0)
}

// MARK: - Font Extensions
extension Font {
    // System Fonts
    static let largeTitle = Font.title
    static let sectionTitle = Font.title2
    static let cardTitle = Font.headline
    static let body = Font.body
    static let subtitle = Font.subheadline
    static let caption = Font.caption
    
    // Custom Fonts
    static let openSansBold16 = Font.custom("Open Sans", size: 16).weight(.bold)
    static let openSansRegular14 = Font.custom("Open Sans", size: 14)
    
    // Icon Sizes
    static let iconLarge = Font.system(size: 50)
}

// MARK: - Spacing Extensions
extension CGFloat {
    // Standard Spacing
    static let spacingXSmall: CGFloat = 8
    static let spacingSmall: CGFloat = 12
    static let spacingMedium: CGFloat = 16
    static let spacingLarge: CGFloat = 24
    static let spacingXLarge: CGFloat = 40
    static let spacingXXLarge: CGFloat = 60
    
    // Component Specific
    static let buttonHeight: CGFloat = 50
    static let cornerRadiusSmall: CGFloat = 8
    static let cornerRadiusMedium: CGFloat = 10
    static let cornerRadiusLarge: CGFloat = 12
    static let borderWidthThin: CGFloat = 1
    static let popoverWidth: CGFloat = 250
    static let articleImageAspectRatio: CGFloat = 343/190
    static let headerImageHeight: CGFloat = 200
}

