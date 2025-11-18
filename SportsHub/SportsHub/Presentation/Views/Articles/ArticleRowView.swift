//
//  ArticleRowView.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import SwiftUI

struct ArticleRowView: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading, spacing: .spacingXSmall) {
            AsyncImage(url: article.imageUrl){ result in
                result.image?
                    .resizable()
                    .scaledToFill()
            }
            .aspectRatio(.articleImageAspectRatio, contentMode: .fill)
            .frame(height: .headerImageHeight)
            .clipped()
            .background(Color.backgroundPlaceholder)
            Text(article.title)
                .font(.openSansBold16)
                .foregroundColor(.textPrimary)
            Text(article.shortDescription)
                .multilineTextAlignment(.leading)
                .font(.openSansRegular14)
                .foregroundColor(.textSecondary)
        }
        .cardStyle()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
