//
//  TappeableNavigation.swift
//  RestaurantReview
//
//  Created by vishal on 4/24/22.
//

import SwiftUI

struct NonTappableNavigation<Destination>: View where Destination: View {
    
    var destination: Destination
    @Binding var isActive: Bool
    
    var body: some View {
        EmptyView()
            .onTapNavigation($isActive, destination: destination)
    }
}
