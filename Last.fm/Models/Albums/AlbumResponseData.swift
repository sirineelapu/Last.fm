//
//  AlbumResponseData.swift
//  Last.fm
//
//  Created by Sireesha Neelapu on 04/09/19.
//

import Foundation
import ObjectMapper

class AlbumResponseData : Mappable{
    var results: AlbumResponse?
    
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        results <-   map["results"]
    }
}
