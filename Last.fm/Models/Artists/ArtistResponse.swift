//
//  ArtistResponse.swift
//  Last.fm
//
//  Created by Sireesha Neelapu on 04/09/19.
//

import Foundation
import ObjectMapper

class ArtistResponse: BaseResponse {
    var artistMatches: ArtistMatches?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        artistMatches  <- map["artistmatches"]
    }
}
