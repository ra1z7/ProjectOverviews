//
//  Stepper.swift
//  ProjectOverviews
//
//  Created by Purnaman Rai (College) on 19/08/2025.
//

import SwiftUI

struct BetterRest: View {
    @State private var sleepAmount = 8.0
    
    var body: some View {
        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
    }
}

#Preview {
    BetterRest()
}
