//
//  BaseResponse.swift
//  Last.fm
//
//  Created by Sireesha Neelapu on 04/09/19.
//

import Foundation
import ObjectMapper

enum ResponseType: String {
    
    case album, artist,track, none
}

class BaseResponse : Mappable{
     var query: Query?
    var totalResults:String?
    var startIndex: String?
    var itemsPerPage: String?
    var attr: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        query <-   map["opensearch:Query"]
        totalResults <-   map["opensearch:totalResults"]
        startIndex <-   map["opensearch:startIndex"]
        itemsPerPage <-  map["opensearch:itemsPerPage"]
        attr <-   map["@attr.for"]
    }
}
