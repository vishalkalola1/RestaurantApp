//
//  View+Extentions.swift
//  RestaurantReview
//
//  Created by vishal on 4/24/22.
//

import SwiftUI

public extension View {
    func alert(isPresented: Binding<Bool>,
               title: String,
               message: String? = nil,
               dismissButton: Alert.Button? = nil) -> some View {
        
        alert(isPresented: isPresented) {
            Alert(title: Text(title),
                  message: {
                    if let message = message { return Text(message) }
                    else { return nil } }(),
                  dismissButton: dismissButton)
        }
    }
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    func onTapNavigation<Destination: View>(_ isActive: Binding<Bool>, destination: Destination) -> some View {
        return NavigationLink(destination: destination, isActive: isActive) {
            self
        }
    }
    
    func textFieldStyle(with placeholder: String, text: String) -> some View {
        modifier(CustomTextFieldStyle(placeholder: placeholder, text: text))
    }
}
