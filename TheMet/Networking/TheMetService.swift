// TheMetService
// Created by Raymond Shelton on 9/26/24.
// This file defines a service for fetching data from The Met's public collection API.

import Foundation
struct TheMetService {
    // Base URL for The Met's public collection API
    let baseURLString = "https://collectionapi.metmuseum.org/public/collection/v1/"
    let session = URLSession.shared  // Shared URL session for making requests
    let decoder = JSONDecoder()       // JSON decoder for parsing response data

    // Fetches object IDs based on a search query
    func getObjectIDs(from queryTerm: String) async throws -> ObjectIDs? {
        let objectIDs: ObjectIDs?  // To hold the decoded object IDs

        // Create URL components for the search endpoint
        guard var urlComponents = URLComponents(string: baseURLString + "search") else {
            return nil  // Return nil if URL components can't be created
        }
        
        // Setting up base parameters for the request
        let baseParams = ["hasImages": "true"]  // We only want objects that have images
        urlComponents.setQueryItems(with: baseParams)
        // Add the query term to the URL
        urlComponents.queryItems! += [URLQueryItem(name: "q", value: queryTerm)]
        
        // Ensure the URL is valid
        guard let queryURL = urlComponents.url else { return nil }
        let request = URLRequest(url: queryURL)

        // Make the network request and await the response
        let (data, response) = try await session.data(for: request)

        // Check if the response is valid
        guard
            let response = response as? HTTPURLResponse,
            (200..<300).contains(response.statusCode)
        else {
            print(">>> getObjectIDs response outside bounds")
            return nil  // Return nil if response status is not in the expected range
        }

        do {
            // Decode the response data into ObjectIDs
            objectIDs = try decoder.decode(ObjectIDs.self, from: data)
        } catch {
            print(error)  // Print any errors encountered during decoding
            return nil
        }
        return objectIDs  // Return the decoded object IDs
    }

    // Fetches an object based on its ID
    func getObject(from objectID: Int) async throws -> Object? {
        let object: Object?  // To hold the decoded object

        // Construct the URL for the specific object
        let objectURLString = baseURLString + "objects/\(objectID)"
        guard let objectURL = URL(string: objectURLString) else { return nil }
        let objectRequest = URLRequest(url: objectURL)

        // Make the network request for the object
        let (data, response) = try await session.data(for: objectRequest)

        // Validate the response status code
        if let response = response as? HTTPURLResponse {
            let statusCode = response.statusCode
            if !(200..<300).contains(statusCode) {
                print(">>> getObject response \(statusCode) outside bounds")
                print(">>> \(objectURLString)")
                return nil  // Return nil if the status code is not valid
            }
        }

        do {
            // Decode the response data into an Object
            object = try decoder.decode(Object.self, from: data)
        } catch {
            print(error)  // Print any decoding errors
            return nil
        }
        return object  // Return the decoded object
    }
}
