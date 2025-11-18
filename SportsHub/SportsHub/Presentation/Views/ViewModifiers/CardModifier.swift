//
//  CardModifier.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import SwiftUI

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, .spacingMedium)
            .padding(.bottom, .spacingMedium)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardModifier())
    }
}
