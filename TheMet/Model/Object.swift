// Object
// Created by Raymond Shelton on 9/26/24.
// This file defines the Object structure used to represent art pieces from The Met's collection.

import Foundation

// Structure representing an art object from The Met's collection.
struct Object: Codable, Hashable {
    let objectID: Int // Unique identifier for the object
    let title: String // Title of the art piece
    let creditLine: String // Credit line for the artwork
    let objectURL: String // URL to the object's page on The Met's website
    let isPublicDomain: Bool // Indicates if the object is in the public domain
    let primaryImageSmall: String // URL for a small version of the object's primary image
}

extension Object {
    // Provides sample Object data for testing purposes
    static func sample(isPublicDomain: Bool) -> Object {
        if isPublicDomain {
            return Object(
                objectID: 452174,
                title: "\"Bahram Gur Slays the Rhino-Wolf\", Folio 586r from the Shahnama (Book of Kings) of Shah Tahmasp",
                creditLine: "Gift of Arthur A. Houghton Jr., 1970",
                objectURL: "https://www.metmuseum.org/art/collection/search/452174",
                isPublicDomain: true,
                primaryImageSmall: "https://images.metmuseum.org/CRDImages/is/original/DP107178.jpg"
            )
        } else {
            return Object(
                objectID: 828444,
                title: "Hexagonal flower vase",
                creditLine: "Gift of Samuel and Gabrielle Lurie, 2019",
                objectURL: "https://www.metmuseum.org/art/collection/search/828444",
                isPublicDomain: false,
                primaryImageSmall: ""
            )
        }
    }
}

// Structure for handling a collection of Object IDs
struct ObjectIDs: Codable {
    let total: Int // Total number of objects found
    let objectIDs: [Int] // Array of object IDs
}
