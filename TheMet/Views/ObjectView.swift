// ObjectView
// Created by Raymond Shelton on 9/26/24.
// This file defines the view that displays details about an art object from The Met.

import SwiftUI

struct ObjectView: View {
    // The art object being displayed
    let object: Object

    var body: some View {
        VStack {
            // Display a link to the object's URL, if available
            if let url = URL(string: object.objectURL) {
                Link(destination: url) {
                    WebIndicatorView(title: object.title)
                        .multilineTextAlignment(.leading) // Align text to the leading edge
                        .font(.callout) // Set the font style
                        .frame(minHeight: 44) // Minimum height for touch targets
                        // Additional styling for the link
                        .padding()
                        .background(Color.metBackground) // Background color
                        .foregroundColor(.white) // Text color
                        .cornerRadius(10) // Rounded corners
                }
            } else {
                // If the URL is not valid, just display the title
                Text(object.title)
                    .multilineTextAlignment(.leading)
                    .font(.callout)
                    .frame(minHeight: 44)
            }

            // Display the primary image if it's in the public domain
            if object.isPublicDomain {
                AsyncImage(url: URL(string: object.primaryImageSmall)) { image in
                    image
                        .resizable() // Make the image resizable
                        .aspectRatio(contentMode: .fit) // Maintain aspect ratio
                } placeholder: {
                    // Show a placeholder while the image is loading
                    PlaceholderView(note: "Display image here")
                }
            } else {
                // Show a placeholder if the object is not in the public domain
                PlaceholderView(note: "Not in public domain. URL not valid.")
            }

            // Display the credit line for the artwork
            Text(object.creditLine)
                .font(.caption) // Smaller font for credit line
                .padding()
                .background(Color.metForeground) // Background color
                .cornerRadius(10) // Rounded corners
        }
        .padding(.vertical) // Vertical padding for the overall view
    }
}

// Preview for the ObjectView
struct ObjectView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectView(
            object: Object(
                objectID: 452174,
                title: "Bahram Gur Slays the Rhino-Wolf",
                creditLine: "Gift of Arthur A. Houghton Jr., 1970",
                objectURL: "https://www.metmuseum.org/art/collection/search/452174",
                isPublicDomain: true,
                primaryImageSmall: "https://images.metmuseum.org/CRDImages/is/original/DP107178.jpg"
            )
        )
    }
}
