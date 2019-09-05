//
//  HomogeneousModel.swift
//  Last.fm
//
//  Created by Sireesha Neelapu on 04/09/19.
//

import Foundation
import ObjectMapper

class HomogeneousModel: Mappable {
    
    var name: String?
    var url: String?
    var image: [Image]?
    var streamable: String?
    var mbid: String?

    required init?(map: Map) {}
    
    func mapping(map: Map) {
        name <- map["name"]
        url <- map["url"]
        image <- map["image"]
        streamable <- map["streamable"]
        mbid <- map["mbid"]
    }
}
