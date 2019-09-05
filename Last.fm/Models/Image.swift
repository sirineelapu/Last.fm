//
//  Image.swift
//  Last.fm
//
//  Created by Sireesha Neelapu on 04/09/19.
//

import Foundation
import ObjectMapper

class Image: Mappable {
    
    var text: String?
    var size: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        text <- map["#text"]
        size <- map["size"]
    }
}
