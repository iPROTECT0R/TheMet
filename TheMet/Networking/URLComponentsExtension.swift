// URLComponentsExtensions
// Created by Raymond Shelton on 9/26/24.
// This file extends URLComponents to make it easier to set query parameters for URLs.

import Foundation
public extension URLComponents {
    //Sets the query items from a dictionary of parameters.
    // Parameter parameters: A dictionary of query parameter names and values.
    mutating func setQueryItems(with parameters: [String: String]) {
        // Map the dictionary to URLQueryItem and assign it to queryItems
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
