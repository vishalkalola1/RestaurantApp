//
//  TappeableNavigation.swift
//  RestaurantReview
//
//  Created by vishal on 4/24/22.
//

import SwiftUI

struct TappableNavigation<Destination>: View where Destination: View {
    
    var destination: Destination
    var title: String
    @State var isActive = false
    
    var body: some View {
        Text(title)
            .bold()
            .font(.system(size: 15.0))
            .foregroundColor(.blue)
            .onTapGesture {
                self.isActive = true
            }
            .onTapNavigation($isActive, destination: destination)
    }
}
