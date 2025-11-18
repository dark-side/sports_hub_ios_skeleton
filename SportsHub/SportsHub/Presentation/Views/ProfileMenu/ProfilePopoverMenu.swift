//
//  ProfilePopoverMenu.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import SwiftUI

struct ProfileMenu: View {
    let user: User?
    let onSignOut: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // User info section
            VStack(spacing: .spacingXSmall) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.iconLarge)
                    .foregroundColor(.appPrimary)
                
                if let user = user {
                    Text(user.name)
                        .font(.cardTitle)
                    
                    Text(user.email)
                        .font(.subtitle)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            
            Divider()
            
            // Sign out button
            Button(action: onSignOut) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    Text("Sign Out")
                    Spacer()
                }
                .padding()
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .foregroundColor(.appError)
        }
        .frame(width: .popoverWidth)
    }
}

#Preview("Profile Menu") {
    ProfileMenu(
        user: User(id: 1, email: "user@example.com", name: "John Doe", token: "token123"),
        onSignOut: {}
    )
}
