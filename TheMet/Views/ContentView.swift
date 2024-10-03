// ContentView
// Created by Raymond Shelton on 9/26/24.
// This file defines the main content view for The Met app, allowing users to search and view art objects.

import SwiftUI

struct ContentView: View {
    // StateObject to manage the art collection data
    @StateObject private var store = TheMetStore()
    // Query string for searching art objects
    @State private var query = "peony"
    // Boolean to control the visibility of the search field
    @State private var showQueryField = false
    // Task for managing the fetching of art objects
    @State private var fetchObjectsTask: Task<Void, Error>?
    // Navigation path for navigating between views
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                // Display the current search query
                Text("You searched for '\(query)'")
                    .padding(5)
                    .background(Color.metForeground)
                    .cornerRadius(10)

                // List of art objects fetched from The Met
                List(store.objects, id: \.objectID) { object in
                    // Handle public domain objects differently
                    if !object.isPublicDomain, let url = URL(string: object.objectURL) {
                        NavigationLink(value: url) {
                            WebIndicatorView(title: object.title)
                        }
                        .listRowBackground(Color.metBackground)
                        .foregroundColor(.white)
                    } else {
                        NavigationLink(value: object) {
                            Text(object.title)
                        }
                        .listRowBackground(Color.metForeground)
                    }
                }
                .navigationTitle("The Met")
                .toolbar {
                    // Button to initiate a new search
                    Button("Search the Met") {
                        query = "" // Clear the current query
                        showQueryField = true // Show the search field
                    }
                    .foregroundColor(Color.metBackground)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.metBackground, lineWidth: 2))
                }
                .alert("Search the Met", isPresented: $showQueryField) {
                    // Alert containing the search field
                    TextField("Search the Met", text: $query)
                    Button("Search") {
                        // Cancel any ongoing fetch task
                        fetchObjectsTask?.cancel()
                        // Start a new task to fetch objects based on the query
                        fetchObjectsTask = Task {
                            do {
                                store.objects = [] // Clear previous results
                                try await store.fetchObjects(for: query) // Fetch new results
                            } catch {}
                        }
                    }
                }
                .navigationDestination(for: URL.self) { url in
                    // Destination view for navigating to a URL
                    SafariView(url: url)
                        .navigationBarTitleDisplayMode(.inline)
                        .ignoresSafeArea()
                }
                .navigationDestination(for: Object.self) { object in
                    // Destination view for navigating to an Object
                    ObjectView(object: object)
                }
            }
            .overlay {
                // Show a progress view while objects are loading
                if store.objects.isEmpty { ProgressView() }
            }
        }
        .onOpenURL { url in
            // Handle incoming URLs to navigate to the appropriate object or URL
            if let id = url.host,
               let object = store.objects.first(where: { String($0.objectID) == id }) {
                if object.isPublicDomain {
                    path.append(object)
                } else {
                    if let url = URL(string: object.objectURL) {
                        path.append(url)
                    }
                }
            }
        }
        .task {
            // Fetch initial objects based on the default query when the view appears
            do {
                try await store.fetchObjects(for: query)
            } catch {}
        }
    }
}

// Preview for the ContentView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
