//
//  AlbumMatches.swift
//  Last.fm
//
//  Created by Sireesha Neelapu on 04/09/19.
//

import Foundation
import ObjectMapper

class AlbumMatches: Mappable {
    var albums: [Album]?
    
    required init?(map: Map) {
      
    }
    
    func mapping(map: Map) {
        albums  <- map["album"]
    }
}
