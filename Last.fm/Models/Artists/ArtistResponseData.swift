//
//  ArtistResponseData.swift
//  Last.fm
//
//  Created by Sireesha Neelapu on 04/09/19.
//


import Foundation
import ObjectMapper

class ArtistResponseData : Mappable{
    var results: ArtistResponse?
    
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        results <-   map["results"]
    }
}

