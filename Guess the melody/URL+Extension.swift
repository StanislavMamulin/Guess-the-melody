//
//  URL+Extension.swift
//  Guess the melody
//
//  Created by StanislavPM on 16/02/2019.
//  Copyright © 2019 StanislavPM. All rights reserved.
//

import Foundation

extension URL {
    func withQueries(_ queries: [String : String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        
        components?.queryItems = queries.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        return components?.url
    }
}
