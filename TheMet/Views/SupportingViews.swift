// SupportingViews
// Created by Raymond Shelton on 9/26/24.
// This file defines views for displaying a web indicator and a placeholder.

import SwiftUI

struct WebIndicatorView: View {
    // Title to display in the web indicator
    let title: String

    var body: some View {
        HStack {
            Text(title) // Show the title
            Spacer() // Push the image to the right
            Image(systemName: "rectangle.portrait.and.arrow.right.fill") // Indicator image
                .font(.footnote) // Smaller font size for the icon
        }
    }
}

struct PlaceholderView: View {
    // Note to display in the placeholder
    let note: String
    
    var body: some View {
        ZStack {
            Rectangle() // Background rectangle for the placeholder
                .inset(by: 7) // Inset for padding
                .fill(Color.metForeground) // Fill with the foreground color
                .border(Color.metBackground, width: 7) // Border with the background color
                .padding() // Additional padding around the rectangle
            Text(note) // Display the note text
                .foregroundColor(.metBackground) // Set text color to background color
        }
    }
}
