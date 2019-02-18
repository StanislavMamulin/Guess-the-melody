//
//  TrackInfo.swift
//  Guess the melody
//
//  Created by StanislavPM on 16/02/2019.
//  Copyright © 2019 StanislavPM. All rights reserved.
//

import Foundation

struct ItunesInfo: Codable {
    var resultCount: Int
    var results: [TrackInfo]
    
    enum CodingKeys: String, CodingKey {
        case resultCount
        case results
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        resultCount = try valueContainer.decode(Int.self, forKey: .resultCount)
        results = try valueContainer.decode([TrackInfo].self, forKey: .results)
    }
}
    
struct TrackInfo: Codable {
    var artist: String
    var track: String
    var album: String
    var artwork: URL
    var preview: URL
    
    enum CodingKeys: String, CodingKey {
        case artist = "artistName"
        case track = "trackCensoredName"
        case album = "collectionCensoredName"
        case artwork = "artworkUrl100"
        case preview = "previewUrl"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self) // значения в нераскодированном виде
        
        artist = try valueContainer.decode(String.self, forKey: CodingKeys.artist)
        track = try valueContainer.decode(String.self, forKey: .track)
        album = try valueContainer.decode(String.self, forKey: .album)
        artwork = try valueContainer.decode(URL.self, forKey: .artwork)
        preview = try valueContainer.decode(URL.self, forKey: .preview)
    }
}
