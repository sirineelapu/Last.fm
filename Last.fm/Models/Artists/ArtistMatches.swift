//
//  ArtistMatches.swift
//  Last.fm
//
//  Created by Sireesha Neelapu on 04/09/19.
//

import Foundation
import ObjectMapper

class ArtistMatches: Mappable {
    var artists: [Artist]?
    
    required init?(map: Map) {
        //super.init(map: map)
    }
    
    func mapping(map: Map) {
        artists  <- map["artist"]
    }
}
