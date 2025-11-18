//
//  CommentView.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import SwiftUI

struct CommentView: View {
    let comment: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            Text(comment)
                .font(.openSansRegular14)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
