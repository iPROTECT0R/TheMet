// TheMetWidgetBundle
// Created by Raymond Shelton on 9/26/24.
// This file sets up the widget bundle for The Met app, allowing widgets to be displayed on the home screen.

import WidgetKit
import SwiftUI
@main
struct TheMetWidgetBundle: WidgetBundle {
    // The main body of the widget bundle
    var body: some Widget {
        // Include TheMetWidget in this bundle
        TheMetWidget()
    }
}
