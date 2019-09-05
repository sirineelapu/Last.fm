//
//  TrackResponse.swift
//  Last.fm
//
//  Created by Sireesha Neelapu on 04/09/19.
//  Copyright © 2019 Tilicho labs LLP. All rights reserved.
//

import Foundation
import ObjectMapper

class TrackResponse: BaseResponse {
    var trackMatches: TrackMatches?

    required init?(map: Map) {
        super.init(map: map)
    }
    override func mapping(map: Map) {
        super.mapping(map: map)
        trackMatches  <- map["trackmatches"]
    }
}
