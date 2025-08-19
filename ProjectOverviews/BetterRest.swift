//
//  Stepper.swift
//  ProjectOverviews
//
//  Created by Purnaman Rai (College) on 19/08/2025.
//

import SwiftUI

struct BetterRest: View {
    @State private var sleepAmount = 8.0
    
    @State private var wakeUp = Date.now // encapsulates the year, month, date, hour, minute, second, timezone, and more
    // whereas DateComponents lets us read or write specific parts of a date rather than the whole thing
    @State private var tomorrow = Date.now.addingTimeInterval(86400) // but do all days have 86,400 seconds?
    
    var body: some View {
        VStack {
            Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
            
            DatePicker("Please select a date", selection: $wakeUp, in: Date.now..., displayedComponents: .date)
            DatePicker("Please select a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                .labelsHidden()
            
            // formatting dates and times
            // Option 1
            Text(Date.now, format: .dateTime.hour().minute())
            Text(Date.now, format: .dateTime.day().month().year())
            
            // Option 2
            Text(Date.now.formatted(date: .long, time: .shortened))
            Text(Date.now.formatted(date: .omitted, time: .complete))
        }
        .padding()
    }
    
    func workingWithDate() {
        // any usage of dates that actually matters in our code, we should rely on Apple’s frameworks for calculations and formatting instead of doing it by hand e.g. addingTimeInterval(86400)
        
        // writing date/time
        var components1 = DateComponents()
        components1.hour = 8
        components1.minute = 0
        let date = Calendar.current.date(from: components1) ?? .now
        // Calendar.current means “Use the user’s current calendar system”
        // .date(from:) tries to turn the DateComponents into a real Date object.
        
        // reading date/time
        let components2 = Calendar.current.dateComponents([.hour, .minute], from: date) // extracting DateComponents from 'date' constant
        let hour = components2.hour ?? 0
        let minute = components2.minute ?? 0
    }
}

#Preview {
    BetterRest()
}
