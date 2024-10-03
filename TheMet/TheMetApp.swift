// TheMetApp
// Created by Raymond Shelton on 9/26/24.
// This file is the main entry point for TheMetApp, setting up the app's initial user interface.

import SwiftUI

@main
struct TheMetApp: App {
    // This is where we define the app's main scene.
    var body: some Scene {
        // WindowGroup manages a group of windows for our app.
        WindowGroup {
            // ContentView is the first view the user will see when the app launches.
            ContentView()
        }
    }
}
