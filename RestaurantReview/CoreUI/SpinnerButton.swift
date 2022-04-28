//
//  SpinnerButton.swift
//  RestaurantReview
//
//  Created by vishal on 4/28/22.
//

import SwiftUI

struct SpinnerButton: View {
    
    @Binding var loading: Bool
    var action: () -> Void
    
    var body: some View {
        if loading {
            Spinner()
                .frame(width: 45, height: 45, alignment: .center)
        } else {
            Button {
                action()
            } label: {
                Text("LOG IN")
                    .bold()
                    .foregroundColor(.white)
                    .frame(width: 150, height: 45, alignment: .center)
                    .background(Color.blue)
                    .font(.system(size: 13.0))
                    .cornerRadius(45, antialiased: false)
            }
            .background(Color.blue)
            .cornerRadius(45, antialiased: true)
        }
    }
}
