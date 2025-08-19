//
//  Stepper.swift
//  ProjectOverviews
//
//  Created by Purnaman Rai (College) on 19/08/2025.
//

import SwiftUI

struct BetterRest: View {
    @State private var sleepAmount = 8.0
    
    @State private var wakeUp = Date.now
    @State private var tomorrow = Date.now.addingTimeInterval(86400)
    
    var body: some View {
        VStack {
            Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
            
            DatePicker("Please select a date", selection: $wakeUp, in: Date.now..., displayedComponents: .date)
            DatePicker("Please select a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                .labelsHidden()
        }
        .padding()
    }
}

#Preview {
    BetterRest()
}
