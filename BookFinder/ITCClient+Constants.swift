//
//  ITCClient+Constants.swift
//  BookFinder
//
//  Created by Atikur Rahman on 6/17/16.
//  Copyright © 2016 Atikur Rahman. All rights reserved.
//

extension ITCClient {
    
    struct Constants {
        static let APIScheme = "https"
        static let APIHost = "itunes.apple.com"
        static let APIPath = "/search"
    }
    
    struct ParameterKeys {
        static let Term = "term"
        static let Entity = "entity"
    }
    
    struct ParameterValues {
        static let EntityEbook = "ebook"
    }
    
    struct ResponseKeys {
        static let Results = "results"
        static let TrackName = "trackName"
        static let ArtistName = "artistName"
        static let ArtworkUrl60 = "artworkUrl60"
        static let ArtworkUrl100 = "artworkUrl100"
        static let TrackViewUrl = "trackViewUrl"
        static let Kind = "kind"
        static let Currency = "currency"
        static let Price = "price"
        static let Genres = "genres"
    }
}