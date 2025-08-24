//
//  Animations.swift
//  ProjectOverviews
//
//  Created by Purnaman Rai (College) on 24/08/2025.
//

import SwiftUI

struct Animations: View {
    @State private var scaleAmount = 1.0 // a value of 1.0 is equivalent to 100% (button’s normal size)
    @State private var blurAmount = 0.0
    
    var implicitAnimationDemo: some View {
        // In SwiftUI, the simplest type of animation is an implicit one: we tell our views ahead of time “if someone wants to animate you, here’s how you should respond”, and nothing more. SwiftUI will then take care of making sure any changes that do occur follow the animation you requested.
        
        Button("Scale Up") {
            scaleAmount += 0.5
        }
        .padding(50)
        .foregroundStyle(.white)
        .background(.blue.gradient)
        .clipShape(.circle)
        .scaleEffect(scaleAmount)
        .animation(.bouncy, value: scaleAmount) // this asks SwiftUI to apply a bouncy animation whenever the value of scaleAmount changes
        
        // implicit animation takes effect on all properties of the view that change, meaning that if we attach more animating modifiers to the view then they will all change together. For example, we could add a second new modifier to the button, .blur()
        
        // The point is that nowhere have we said what each frame of the animation should look like, and we haven’t even said when SwiftUI should start and finish the animation. Instead, our animation becomes a function of our state just like the views themselves.
    }
        
    var blurMeButton: some View {
        HStack(spacing: 20) {
            Text(blurAmount.formatted())
                .contentTransition(.numericText())
            
            Button("Blur Me") {
                withAnimation {
                    blurAmount += 1.0
                }
            }
            .blur(radius: blurAmount)
            
            Button {
                blurAmount = 0.0
            } label: {
                Image(systemName: "arrow.trianglehead.clockwise.rotate.90")
                    .imageScale(.small)
            }
        }
        .foregroundStyle(.secondary)
    }
    
    var body: some View {
        VStack(spacing: 50) {
            implicitAnimationDemo
            
            blurMeButton
        }
        .font(.subheadline.monospaced())
    }
}

#Preview {
    Animations()
}
