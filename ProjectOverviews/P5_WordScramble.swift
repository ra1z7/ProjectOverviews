//
//  WordScramble.swift
//  ProjectOverviews
//
//  Created by Purnaman Rai (College) on 22/08/2025.
//

import SwiftUI

struct WordScramble: View {
    let fruits = ["Apple", "Banana", "Cherry"]
    
    var body: some View {
        // List is identical to Form, except it’s used for presentation of data rather than requesting user input.
        List(fruits, id: \.self) {
            Text($0)
        }
        .listStyle(.grouped)
        
        
        
        
        // When Xcode builds your iOS app, it creates something called a “bundle”. This happens on all of Apple’s platforms, including macOS, and it allows the system to store all the files for a single app in one place – the binary code (the actual compiled Swift stuff we wrote), all the artwork, plus any extra files we need all in one place.
        if let fileURL = Bundle.main.url(forResource: "someFile", withExtension: "txt") {
            // we found the file in our bundle!
            // What’s inside the URL doesn’t really matter, because iOS uses paths that are impossible to guess – our app lives in its own sandbox, and we shouldn’t try to read outside of it.
            
            if let contents = try? String(contentsOf: fileURL, encoding: .utf16) {
                // we loaded the file into a string!
                removeUnusedVarError(for: contents)
            }
        }
        
        
        
        
        // Working with String
        let myString = "a b c"
        let letters = myString.components(separatedBy: " ")
        let letter = letters.randomElement()
        let trimmedLetter = letter?.trimmingCharacters(in: .whitespacesAndNewlines)
        removeUnusedVarError(for: trimmedLetter ?? "Nothing")

        
                
        
        // Working with UITextChecker() class which comes from UIKit and is written in Obj-C
        let spellingChecker = UITextChecker()
        let wordToCheck = "Swift❤️" // .count = 6 | .utf16.count = 7
        // Swift uses a very clever, very advanced way of working with strings, which allows it to use complex characters such as emoji in exactly the same way that it uses the English alphabet. However, Objective-C does not use this method of storing letters, which means we need to ask Swift to create an Objective-C string range using the entire length of all our characters:
        let characterRange = NSRange(location: 0, length: wordToCheck.utf16.count) // how much of our string we want to check, here, we want to check the whole string
        
        // UTF-16 is what’s called a character encoding – a way of storing letters in a string. We use it here so that Objective-C can understand how Swift’s strings are stored; it’s a nice bridging format for us to connect the two.
        
        // Finally, we can ask our text checker to report where it found any misspellings in our word, passing in the range to check, a position to start within the range (so we can do things like “Find Next”), whether it should wrap around once it reaches the end, and what language to use for the dictionary:
        let misspelledRange = spellingChecker.rangeOfMisspelledWord(in: wordToCheck, range: characterRange, startingAt: 0, wrap: false, language: "en")
        // That sends back another Objective-C string range (NSRange), telling us where the misspelling was found. Even then, there’s still one complexity here: Objective-C didn’t have any concept of optionals, so instead it relied on special values to represent missing data. If there was no spelling mistake, then we get back the special value 'NSNotFound'.
        let spellingIsCorrect = (misspelledRange.location == NSNotFound)
        removeUnusedVarError(for: spellingIsCorrect)
    }
}

#Preview {
    WordScramble()
}
