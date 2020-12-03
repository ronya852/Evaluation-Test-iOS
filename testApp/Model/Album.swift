//
//  Album.swift
//  testApp
//
//  Created by RonchPonchPomkins on 1/12/2020.
//

import Foundation

class Album: NSObject {
    
    var resultCount: Int? = nil
    var artistName: String? = nil
    var artworkUrl100: String? = nil
    var collectionId: Int? = nil
    var collectionName: String? = nil
    var country: String? = nil
    var primaryGenreName: String? = nil
    var releaseYear: String? = nil
    
    init(data: [String: AnyObject]?) {
        super.init()
        
        guard let data = data else { return }
        
        resultCount = data["resultCount"] as? Int
        artistName = data["artistName"] as? String
        artworkUrl100 = data["artworkUrl100"] as? String
        collectionId = data["collectionId"] as? Int
        collectionName = data["collectionName"] as? String
        country = data["country"] as? String
        primaryGenreName = data["primaryGenreName"] as? String
        
        if let releaseDate = data["releaseDate"] as? String {
            releaseYear = String(releaseDate.prefix(4))
        }
    }
}

