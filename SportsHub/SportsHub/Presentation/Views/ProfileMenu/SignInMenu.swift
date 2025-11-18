//
//  SignInMenu.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import SwiftUI

struct SignInMenu: View {
    let onSignIn: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Guest info section
            VStack(spacing: .spacingXSmall) {
                Image(systemName: "person.crop.circle")
                    .font(.iconLarge)
                    .foregroundColor(.gray)
                
                Text("Not signed in")
                    .font(.cardTitle)
                    .foregroundColor(.secondary)
            }
            .padding()
            
            Divider()
            
            // Sign in button
            Button(action: onSignIn) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.forward")
                    Text("Sign In")
                    Spacer()
                }
                .padding()
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .foregroundColor(.textPrimary)
        }
        .frame(width: .popoverWidth)
    }
}

#Preview("Sign In Menu") {
    SignInMenu(onSignIn: {})
}
