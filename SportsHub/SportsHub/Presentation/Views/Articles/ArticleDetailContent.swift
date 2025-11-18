//
//  ArticleDetailContent.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import SwiftUI

struct ArticleDetailContent: View {
    let article: Article

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .spacingMedium) {
                if let imageUrl = article.imageUrl {
                    headerImage(imageUrl)
                }

                VStack(alignment: .leading, spacing: .spacingSmall) {
                    Group{
                        Text(article.title)
                            .font(.title)
                            .fontWeight(.bold)

                        Text("Published: \(formatDate(article.createdAt))")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Divider()

                        Text(article.description)
                            .font(.body)
                            .padding(.vertical, .spacingXSmall)

                        actionBar

                        if !article.comments.isEmpty {
                            commentSection
                        }
                    }
                    .padding(.horizontal, 17)
                }
                .padding(.bottom, .spacingLarge)
            }
        }
    }

    private var actionBar: some View {
        HStack(spacing: 20) {
            HStack {
                Image(systemName: "hand.thumbsup")
                Text("\(article.likes)")
            }

            HStack {
                Image(systemName: "hand.thumbsdown")
                Text("\(article.dislikes)")
            }

            HStack {
                Image(systemName: "text.bubble")
                Text("\(article.commentsCount)")
            }
        }
        .foregroundColor(.secondary)
        .padding(.vertical, .spacingXSmall)
    }

    private var commentSection: some View {
        VStack(alignment: .leading, spacing: 17, content: {
            Text("Comments")
                .font(.cardTitle)
                .padding(.top, .spacingXSmall)

            VStack(alignment: .leading, spacing: 0, content: {
                ForEach(article.comments, id: \.self) { comment in
                    CommentView(comment: comment)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .padding(.horizontal, 17)
                }
            })
            .frame(maxWidth: .infinity)
            .border(Color.borderComment, width: .borderWidthThin)
            .background(Color.backgroundComment)

        })
        .padding(.horizontal, 17)
        .padding(.vertical, 15)
        .background(Color.backgroundCommentSection)
    }

    private func headerImage(_ imageUrl: URL) -> some View {
        AsyncImage(url: imageUrl){ result in
            result.image?
                .resizable()
                .scaledToFill()
        }
        .aspectRatio(.articleImageAspectRatio, contentMode: .fill)
        .frame(height: .headerImageHeight)
        .clipped()
        .background(Color.backgroundPlaceholder)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
