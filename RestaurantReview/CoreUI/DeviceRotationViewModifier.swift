//
//  Orientation.swift
//  RestaurantReview
//
//  Created by vishal on 4/30/22.
//

import SwiftUI

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIInterfaceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                guard let scene = UIApplication.shared.keyWindow?.windowScene else { return }
                action(scene.interfaceOrientation)
            }
    }
}
