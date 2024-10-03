import Foundation
import WidgetKit

// TheMetStore.swift
// Created by [Your Name] on 9/26/24.
// This class manages fetching and storing objects from The Met API.

extension FileManager {
    // Accesses the shared container URL for app group.
    static func sharedContainerURL() -> URL {
        return FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.com.yourcompany.TheMet.objects")!
        // Force unwrapping is used here as we expect the URL to always exist.
    }
}

class TheMetStore: ObservableObject {
    @Published var objects: [Object] = []  // Array to hold fetched objects.
    let service = TheMetService()  // Service instance to handle API requests.
    let maxIndex: Int  // Maximum number of objects to fetch.

    init(_ maxIndex: Int = 30) {
        self.maxIndex = maxIndex  // Initialize maxIndex with a default value.
    }

    // Fetches objects based on the provided search term asynchronously.
    func fetchObjects(for queryTerm: String) async throws {
        if let objectIDs = try await service.getObjectIDs(from: queryTerm) {
            // Loop through the object IDs and fetch details.
            for (index, objectID) in objectIDs.objectIDs.enumerated() where index < maxIndex {
                if let object = try await service.getObject(from: objectID) {
                    await MainActor.run {
                        objects.append(object)  // Update objects array on the main thread.
                    }
                }
            }
            writeObjects()  // Save fetched objects to disk.
            WidgetCenter.shared.reloadTimelines(ofKind: "TheMetWidget")  // Refresh the widget.
        }
    }

    // Writes the current objects array to a JSON file.
    func writeObjects() {
        let archiveURL = FileManager.sharedContainerURL()
            .appendingPathComponent("objects.json")
        print(">>> \(archiveURL)")

        if let dataToSave = try? JSONEncoder().encode(objects) {
            do {
                try dataToSave.write(to: archiveURL)  // Write the encoded data.
            } catch {
                print("Error: Can’t write objects")  // Print error if writing fails.
            }
        }
    }
}
