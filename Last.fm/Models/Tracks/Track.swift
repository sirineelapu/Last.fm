//
//  Track.swift
//  Last.fm
//
//  Created by Sireesha Neelapu on 04/09/19.
//

import Foundation
import ObjectMapper

class Track: HomogeneousModel {
    var listeners: String?
    var artist: String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        listeners <- map["listeners"]
        artist  <- map["artist"]
    }
}
