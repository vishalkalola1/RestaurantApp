//
//  CustomTextField.swift
//  RestaurantReview
//
//  Created by vishal on 4/24/22.
//

import SwiftUI

struct CustomTextFieldStyle: ViewModifier {
    var placeholder: String
    var text: String

    func body(content: Content) -> some View {
        return content
            .placeholder(when: text.isEmpty) {
                Text(placeholder).foregroundColor(.blue)
            }
            .frame(height: 50, alignment: .center)
            .font(.system(size: 15.0))
            .foregroundColor(.blue)
            .textInputAutocapitalization(.never)
    }
}


struct TextFieldView: View {
    
    var placeHolder: String
    var imageName: String
    @Binding var text: String
    var isSecure = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            Image(systemName: imageName)
                .foregroundColor(.blue)
            
            if isSecure {
                SecureField("", text: $text)
                    .textFieldStyle(with: placeHolder, text: text)
                    
            } else {
                TextField("", text: $text)
                    .textFieldStyle(with: placeHolder, text: text)
            }
        }
        .padding([.leading, .trailing], 20)
        .overlay(
            RoundedRectangle(cornerRadius: 35)
                .stroke(Color.blue, lineWidth: 2)
        )
        .background(Color.white)
        .cornerRadius(35)
    }
}
