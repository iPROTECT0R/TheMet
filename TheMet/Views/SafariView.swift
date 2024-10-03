// SafariView
// Created by Raymond Shelton on 9/26/24.
// This file provides a view that displays a URL in a Safari view controller.

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    // The URL to be displayed in the Safari view
    let url: URL

    // Create the Safari view controller
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url) // Initialize with the provided URL
    }

    // Update the Safari view controller when needed
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        // No updates needed for this simple implementation
    }
}

// Preview for the SafariView
struct SafariView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a Safari view with a sample URL
        // swiftlint:disable:next force_unwrapping
        SafariView(url: URL(string: "https://www.metmuseum.org/art/collection/search/437092")!)
    }
}
