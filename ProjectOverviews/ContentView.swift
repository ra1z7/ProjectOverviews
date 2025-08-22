//
//  ContentView.swift
//  ProjectOverviews
//
//  Created by Purnaman Rai (College) on 19/08/2025.
//

import SwiftUI

public func removeUnusedVarError(for value: Any) -> some View{
    Button("Print") {
        print(value)
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
