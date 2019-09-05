//
//  Album.swift
//  Last.fm
//
//  Created by Sireesha Neelapu on 04/09/19.
//

import Foundation
import ObjectMapper

class Album: HomogeneousModel {
    
    var artist: String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        artist <- map["artist"]
    }
}
