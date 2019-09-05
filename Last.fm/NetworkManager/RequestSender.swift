//
//  RequestSender.swift
//  Last.fm
//
//  Created by Sireesha Neelapu on 03/09/19.
//

import Foundation
import ObjectMapper
import Alamofire

enum ResponseCallback<T> {
    
    case onRequestSuccess(object: T)
    case onRequestFailure(errorResponse: String?)

}

class RequestSender<ExpectingModel> {
}

extension RequestSender where ExpectingModel : Mappable {
    
    static func sendRequest(request: Request?, viewController: UIViewController, shouldShowHUD: Bool = true,showBanner: Bool = true, callback: @escaping ((ResponseCallback<ExpectingModel>) -> Void) ) {
        
        if let dataRequest = request as? DataRequest {
            
            if shouldShowHUD {
                
               viewController.showHUD()
            }
            
            dataRequest.responseJSON { response in
                
                if response.response?.statusCode == 200 {
                    
                    if let expectedModel = Mapper<ExpectingModel>().map(JSONObject: response.result.value) {
                        
                        callback(ResponseCallback.onRequestSuccess(object: expectedModel))
                        viewController.hideHUD()
                        
                    } else {
                        
                        if let error = response.error {
                            
                            if let errorDescription = response.error?.localizedDescription {
                                if errorDescription != "cancelled" {
                                    if showBanner {
                                        viewController.showBanner(message: error.localizedDescription, backgroundColor: UIColor.red)
                                    }
                                }
                            }
                            callback(ResponseCallback.onRequestFailure(errorResponse: error.localizedDescription))
                            viewController.hideHUD()
                            
                        } else {
                            
                            callback(ResponseCallback.onRequestFailure(errorResponse: "Something went wrong"))
                           viewController.hideHUD()
                            
                        }
                    }
                    
                } else  {
                    
                        if let error = response.error {
                            
                            if let errorDescription = response.error?.localizedDescription {
                                if errorDescription != "cancelled" {
                                    if showBanner {
                                        viewController.showBanner(message: error.localizedDescription, backgroundColor: UIColor.red)
                                    }
                                }
                            }
                            callback(ResponseCallback.onRequestFailure(errorResponse: error.localizedDescription))
                    
                            viewController.hideHUD()
                        } else {
                            
                            //callback(ResponseCallback.onRequestFailure(errorResponse: "Something went wrong"))
                            viewController.showBanner(message:  "Something went wrong", backgroundColor: UIColor.red)
                            viewController.hideHUD()
                            
                        }
                        
                
                    
                }
                
            }
            
        } else {
    
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                 viewController.showBanner(message: "NO INTERNET CONNECTIVITY", backgroundColor: UIColor.red)
            })
           
        }
    }
}
