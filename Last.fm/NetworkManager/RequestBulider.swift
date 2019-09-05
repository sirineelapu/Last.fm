//
//  RequestBulider.swift
//  Last.fm
//
//  Created by Sireesha Neelapu on 03/09/19.
//

import Foundation
import ObjectMapper
import Alamofire

typealias UploadableImageInfo = (image: UIImage, filePath:String, keyPath: String)

enum RequestType: String {
    
    case Search
    case none
}

struct RequestDetails {
    
    var urlString: String
    var method: HTTPMethod
}

class RequestBulider {
    
    static let shared = RequestBulider()
    
    private init() {
        
        let sessionConfig = URLSessionConfiguration.default
//        sessionConfig.httpShouldSetCookies = false
//        sessionConfig.httpCookieAcceptPolicy = HTTPCookie.AcceptPolicy.never
//        sessionConfig.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        sessionManager = SessionManager(configuration: sessionConfig)
    }
    
    private var sessionManager: SessionManager!
    
    var headers: HTTPHeaders {
        return  [
            "Content-Type": "application/json"
        ]
    }
    
    private let baseUrl = "http://ws.audioscrobbler.com/2.0/"
    
    var searchURL: String {
        return "\(baseUrl)?"
    }
    
    func getEncoding(method: HTTPMethod) ->  ParameterEncoding {
        return method == .get ? URLEncoding.default : JSONEncoding.default
    }
    
    func request(ForType type: RequestType ,params: Parameters) -> Request? {
        
        guard NetworkManager.shared.isReachable else  {

            return nil

        }
        
        if let request = getRequest(id: nil ,type: type) {
        print("request url \(request.urlString)")
        return sessionManager.request(request.urlString, method: request.method, parameters: params, encoding: getEncoding(method: request.method), headers: headers)
        }
        
        return nil
    }
    
    func request(ForType type: RequestType ,model: Mappable) -> Request? {
        
        guard NetworkManager.shared.isReachable else  {

            return nil

        }
        
        return self.request(ForType: type, params: model.toJSON())
    }
    
    func getRequest(id: String? = nil, type: RequestType) -> RequestDetails? {
        
        switch type {
            
        case .Search: return RequestDetails(urlString: searchURL, method: .get)
        default: return nil
        }
    }
}
