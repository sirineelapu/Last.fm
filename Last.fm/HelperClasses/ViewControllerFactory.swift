//
//  ViewControllerFactory.swift
//  Last.fm
//
//  Created by Sireesha Neelapu on 04/09/19.
//

import Foundation
import UIKit

class ViewControllerFactory {
    
    static var shared = ViewControllerFactory()
    
    func presentSatakamViewController(requestType : ResponseType, data: Any) -> UIViewController {
        
        let presentDetailVC = vcWithId("DetailViewController") as! DetailViewController
        presentDetailVC.requestType = requestType
        presentDetailVC.data = data
        return presentDetailVC
    }

     func vcWithId(_ id: String) -> UIViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: id)
    }
    
     func mainStoryBoard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}

