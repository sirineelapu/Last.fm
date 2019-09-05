//
//  Query.swift
//  Last.fm
//
//  Created by Sireesha Neelapu on 04/09/19.
//

import Foundation
import ObjectMapper

class Query: Mappable
{
    var text:  String?
    var role:  String?
    var searchTerms:  String?
    var startPage:  String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        text   <- map["#text"]
        role    <- map["role"]
        searchTerms     <- map["searchTerms"]
        startPage   <- map["startPage"]
    }
    
}
