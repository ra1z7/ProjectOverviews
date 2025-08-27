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
            
            PulsatingButton(withText: "Click Me")
        }
        .font(.subheadline.monospaced())
    }
}

struct CustomizingAnimations: View {
    @State private var scaleAmount = 1.0
    @State private var colorIndex = -1
    @State private var colors: [Color] = [.red, .orange, .yellow, .green, .blue, .indigo, .purple, .pink, .mint, .teal].shuffled()
    
    var body: some View {
        NavigationStack {
            ScrollView() {
                VStack(spacing: 25) {
                    Animations()
                    
                    HStack(spacing: 30) {
                        animationDemo(for: .linear, caption: "linear", color: colors[0])
                        animationDemo(for: .default, caption: "default", color: colors[1])
                    }
                    HStack(spacing: 30) {
                        animationDemo(for: .bouncy, caption: "bouncy", color: colors[2])
                        animationDemo(for: .easeIn, caption: "easeIn", color: colors[3])
                    }
                    HStack(spacing: 30) {
                        animationDemo(for: .easeOut, caption: "easeOut", color: colors[4])
                        animationDemo(for: .easeInOut, caption: "easeInOut", color: colors[5])
                    }
                    HStack(spacing: 30) {
                        animationDemo(for: .interactiveSpring, caption: "interactiveSpring", color: colors[6])
                        animationDemo(for: .interpolatingSpring, caption: "interpolatingSpring", color: colors[7])
                    }
                    HStack(spacing: 30) {
                        animationDemo(for: .smooth, caption: "smooth", color: colors[8])
                        animationDemo(for: .snappy, caption: "snappy", color: colors[9])
                    }
                }
            }
            .navigationTitle("Animations Demo")
            .padding()
            .onAppear {
                scaleAmount = 2.0
                
                Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                    withAnimation(.easeOut(duration: 3)) {
                        colors.shuffle()
                    }
                }
            }
        }
    }
    
    func animationDemo(for animation: Animation, caption: String, color: Color) -> some View {
        VStack(spacing: 35) {
            Circle()
                .fill(color.gradient)
                .frame(width: 50)
                .scaleEffect(scaleAmount)
                .animation(animation.delay(1).repeatForever(autoreverses: true), value: scaleAmount)
            // When we say .easeInOut(duration: 2) we’re actually creating an instance of an Animation struct that has its own set of modifiers. So, we can attach modifiers directly to the animation to add a delay like above
        
            Text(caption)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(width: 150, height: 150)
    }
}

struct PulsatingButton: View {
    let title: String
    
    @State private var scaleAmount = 1.0
    
    var body: some View {
        Button(title) { }
        .foregroundStyle(.white)
        .padding(50)
        .background(.orange.gradient)
        .clipShape(.circle)
        .overlay {
            Circle()
                .stroke(.orange)
                .scaleEffect(scaleAmount)
                .opacity(2 - scaleAmount)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: false), value: scaleAmount)
        }
        .onAppear {
            scaleAmount = 2.0
        }
    }
    
    init(withText title: String) {
        self.title = title
    }
}

// The animation() modifier can be applied to any SwiftUI binding, which causes the value to animate between its current and new value.
struct AnimatingBindings: View {
    @State private var scaleAmount = 1.0
    @State private var scaleUp = false
    
    var body: some View {
        VStack {
            Stepper("Scale Amount", value: $scaleAmount.animation(
                .easeOut(duration: 2)
                    .repeatCount(3, autoreverses: true)
            ), in: 1...10)
            // What’s actually happening here is that SwiftUI is examining the state of our view before the binding changes, examining the target state of our views after the binding changes, then applying an animation to get from point A to point B.
            
            // This is why we can animate a Boolean changing: Swift isn’t somehow inventing new values between false and true, but just animating the view changes that occur as a result of the change.
            Toggle("Scale Up to 2x", isOn: $scaleUp.animation())
            
            // With this variant of the animation() modifier, we don’t need to specify which value we’re watching for changes – it’s literally attached to the value it should watch!
            
            Spacer()
            
            Button("Scale Up") {
                scaleAmount += 1.0
            }
            .foregroundStyle(.white)
            .padding(40)
            .background(.red.gradient)
            .clipShape(.circle)
            .scaleEffect(scaleUp ? 2.0 : scaleAmount)
        }
    }
    
    // These binding animations effectively turn the tables on implicit animations: rather than setting the animation on a view and implicitly animating it with a state change, we now set nothing on the view and explicitly animate it with a state change. In the former, the state change has no idea it will trigger an animation, and in the latter the view has no idea it will be animated
}

struct ExplicitAnimation: View {
    // it’s not attached to a binding, and it’s not attached to a view, it’s just us explicitly asking for a particular animation to occur because of a state change.
    @State private var rotationAmount = 0.0
    
    var body: some View {
        Button("Rotate") {
            withAnimation(.spring(duration: 10, bounce: 0.5)) { // without this, change will happen immediately, because there is no animation modifier attached to the button
                rotationAmount += 360
            }
        }
        .foregroundStyle(.white)
        .padding(50)
        .background(.orange.gradient)
        .clipShape(.rect(cornerRadius: 15))
        .rotation3DEffect(.degrees(rotationAmount), axis: (x: 0, y: 1, z: 0))
    }
}

struct RotationEffectDemo: View {
    @State private var rotationAngle = 0.0
    @State private var rotationAxis = "x"
    
    var axisValue: (Double, Double, Double) {
        switch rotationAxis {
        case "x":
            (1, 0, 0)
        case "y":
            (0, 1, 0)
        case "z":
            (0, 0, 1)
        default:
            (0, 0, 0)
        }
    }
    
    var body: some View {
        VStack(spacing: 40) {
            Text("Rotate Me in 3D")
                .font(.largeTitle.bold())

            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue.gradient)
                .frame(width: 200, height: 200)
                .rotation3DEffect(
                    .degrees(rotationAngle),
                    axis: (x: axisValue.0, y: axisValue.1, z: axisValue.2),
                    perspective: 0.5 // adds realistic depth to the rotation
                )
            
            Picker("Select Rotation Axis", selection: $rotationAxis) {
                Text("Horizontal").tag("x")
                Text("Vertical").tag("y")
                Text("Depth").tag("z")
            }
            .pickerStyle(.segmented)

            Slider(value: $rotationAngle, in: 0...360, step: 1) {
                // this closure acts as a label for the slider, helpful for accessibility and VoiceOver, even if it's not always visible on screen.
                Text("Rotation Angle")
            }
        }
        .padding(40)
    }
}

// Day 33
struct AnimationStack: View {
    // You can attach the animation() modifier several times, and the order in which you use it matters.
    // When we apply multiple animation() modifiers, each one controls everything before it up to the next animation, which lets us split one state change into as many segments as we need
    // It’s also possible to disable animations entirely by passing 'nil' to the modifier, For example, you might want the color change to happen immediately but the clip shape to retain its animation
    
    @State private var isRed = false
    
    var body: some View {
        Button("Change") {
            isRed.toggle()
        }
        .frame(width: 200, height: 200)
        .background(isRed ? .red : .blue)
        .foregroundStyle(.white)
        .animation(.default, value: isRed)
        .clipShape(.rect(cornerRadius: isRed ? 60 : 0))
        .animation(.spring(duration: 1, bounce: 0.5), value: isRed)
    }
}

struct DragGestureCard: View {
    // we have two options: add an implicit animation that will animate the drag and the release, or add an explicit animation to animate just the release.
    
    @State private var dragAmount = CGSize.zero
    
    var body: some View {
        LinearGradient(colors: [.blue, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(width: 300, height: 200)
            .clipShape(.rect(cornerRadius: 10))
            .offset(dragAmount) // lets us adjust the X and Y coordinate of a view without moving other views around it. You can pass in discrete X and Y coordinates if you want to, but it can also take a CGSize directly.
            .gesture(
                DragGesture()
                    // lets us run a closure whenever the user moves their finger
                    .onChanged { dragValue in
                        withAnimation(.interactiveSpring) {
                            dragAmount = dragValue.translation
                            // .translation tells us how far it has moved from the start point
                        }
                    }
                    // lets us run a closure when the user lifts their finger off the screen, ending the drag
                    .onEnded { _ in
                        withAnimation(.bouncy(extraBounce: 0.2)) {
                            dragAmount = CGSize.zero
                        }
                    }
                
                // Both of those closures are given a single parameter, which describes the drag operation like where it started, where it is currently, how far it moved, and so on.
            )
    }
}

struct SnakeTextEffect: View {
    @State private var dragAmount = CGSize.zero
    @State private var isBGRed = false
    
    let letters = Array("SwiftUI")
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0 ..< letters.count, id: \.self) { index in
                Text(String(letters[index]))
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding(5)
                    .background(isBGRed ? Color.red.gradient : Color.blue.gradient)
                    .offset(dragAmount)
                    .animation(.linear.delay(Double(index) / 15), value: dragAmount)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { dragAmount = $0.translation }
                .onEnded { _ in
                    dragAmount = .zero
                    isBGRed.toggle()
                }
        )
    }
}

#Preview {
    SnakeTextEffect()
}
