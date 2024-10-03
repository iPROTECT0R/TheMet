// TheMetWidget
// Created by Raymond Shelton on 9/26/24.
// This file defines the timeline provider for the widget, managing the entries displayed.

import WidgetKit
import SwiftUI
struct Provider: TimelineProvider {
    // Provides a placeholder for when the widget is loading
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), object: Object.sample(isPublicDomain: true))
    }

    // Provides a snapshot for the widget, used for quick previews
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), object: Object.sample(isPublicDomain: false))
        completion(entry)
    }

    // Generates a timeline of entries for the widget, updating them regularly
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = []

        // Create entries an hour apart, starting from the current date
        let currentDate = Date()
        let interval = 3  // Update every 3 seconds for demonstration

        let objects = readObjects()  // Fetch previously saved objects
        for index in 0 ..< objects.count {
            let entryDate = Calendar.current.date(
                byAdding: .second,
                value: index * interval,
                to: currentDate)!
            let entry = SimpleEntry(
                date: entryDate,
                object: objects[index])
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .never)  // No automatic updates
        completion(timeline)
    }

    // Reads the objects from a JSON file in shared storage
    func readObjects() -> [Object] {
        var objects: [Object] = []
        let archiveURL =
            FileManager.sharedContainerURL()
            .appendingPathComponent("objects.json")
        print(">>> \(archiveURL)")

        if let codeData = try? Data(contentsOf: archiveURL) {
            do {
                objects = try JSONDecoder()
                    .decode([Object].self, from: codeData)
            } catch {
                print("Error: Can’t decode contents")
            }
        }
        return objects
    }
}

// Represents a single entry in the timeline
struct SimpleEntry: TimelineEntry {
    let date: Date
    let object: Object
}

// View for displaying a single widget entry
struct TheMetWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        WidgetView(entry: entry)  // Render the widget view with the entry data
    }
}

// Main widget structure
struct TheMetWidget: Widget {
    let kind: String = "TheMetWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TheMetWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("The Met")  // Name displayed in the widget configuration
        .description("View objects from the Metropolitan Museum.")  // Description for the widget
        .supportedFamilies([.systemMedium, .systemLarge])  // Supported widget sizes
    }
}

// Preview for the widget in Xcode
struct TheMetWidget_Previews: PreviewProvider {
    static var previews: some View {
        TheMetWidgetEntryView(
            entry: SimpleEntry(
                date: Date(),
                object: Object.sample(isPublicDomain: true)))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
