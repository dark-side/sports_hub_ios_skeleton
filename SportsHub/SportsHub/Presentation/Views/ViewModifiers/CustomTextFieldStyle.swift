//
//  CustomTextFieldStyle.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.backgroundField)
            .cornerRadius(.cornerRadiusMedium)
            .overlay(
                RoundedRectangle(cornerRadius: .cornerRadiusMedium)
                    .stroke(Color.borderField, lineWidth: .borderWidthThin)
            )
    }
}
