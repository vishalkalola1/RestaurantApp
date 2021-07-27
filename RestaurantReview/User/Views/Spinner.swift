//
//  Spinner.swift
//  Spinner
//
//  Created by Vishal on 7/22/21.
//

import SwiftUI

struct Spinner: View {
    
    @State private var anticlockRotation = false
    @State private var animateStart = false
    @State private var animateEnd = true
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Circle()
                    .stroke(lineWidth: 5)
                    .fill(Color.init(red: 0.96, green: 0.96, blue: 0.96))
                    .frame(width: geo.size.height, height: geo.size.height)
                
                Circle()
                    .trim(from: animateStart ? 1/3 : 1/9, to: animateEnd ? 2/5 : 1)
                    .stroke(lineWidth: 5)
                    .rotationEffect(.degrees(anticlockRotation ? 360 : 0))
                    .frame(width: geo.size.height, height: geo.size.height)
                    .foregroundColor(Color.blue)
                    .onAppear() {
                        withAnimation(Animation
                                        .linear(duration: 1)
                                        .repeatForever(autoreverses: false)) {
                            self.anticlockRotation.toggle()
                        }
                        withAnimation(Animation
                                        .linear(duration: 1)
                                        .delay(0.5)
                                        .repeatForever(autoreverses: true)) {
                            self.animateStart.toggle()
                        }
                        withAnimation(Animation
                                        .linear(duration: 1)
                                        .delay(1)
                                        .repeatForever(autoreverses: true)) {
                            self.animateEnd.toggle()
                        }
                    }
            }
        }
    }
}

struct Spinner_Previews: PreviewProvider {
    static var previews: some View {
        Spinner().frame(width: 100, height: 100, alignment: .center)
    }
}
