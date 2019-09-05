//
//  TrackMatches.swift
//  Last.fm
//
//  Created by Sireesha Neelapu on 04/09/19.
//

import Foundation
import ObjectMapper

class TrackMatches: Mappable {
    var tracks: [Track]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        tracks  <- map["track"]
    }
}
