//
//  NoResultCustomDisplayer.swift
//  Last.fm
//
//  Created by Sireesha Neelapu on 04/09/19.
//

import Foundation
import UIKit

protocol NoResultsCustomDisplayerDelegate {
    
    func reloadDataViews()
    
    func display(noResultsView : UIView , orDataView view1 : UIView , basedOn results : Int, onViewController vc : UIViewController, completely : Bool )
    
}

extension NoResultsCustomDisplayerDelegate {
    
    func display(noResultsView : UIView , orDataView view1 : UIView , basedOn results : Int,onViewController vc : UIViewController,completely : Bool ){
        
        if results == 0 {
            
            if completely {
                
                NoResultsCustomDisplayer.sharedManager.showView(view: noResultsView, onVC: vc, wrap: true)
            } else {
                
                NoResultsCustomDisplayer.sharedManager.showView(view: noResultsView, onVC: vc, insteadOf: view1)
            }
        } else {
            
            NoResultsCustomDisplayer.sharedManager.removeView(view: noResultsView, fromVC: vc)
        }
    }
}

class NoResultsCustomDisplayer {
    
    static let sharedManager = NoResultsCustomDisplayer()
    
    private init(){}
    
    func showView(view : UIView , onVC vc : UIViewController , wrap: Bool ) {
        showView(view: view, onVC: vc, withFrame: vc.view.bounds)
    }
    
    func showView(view : UIView , onVC vc : UIViewController , withFrame frame : CGRect) {
        
        let mainView =  vc.view
        
        mainView?.tag = 100
        view.tag = 200
        
        DispatchQueue.main.async {
            
            //view1.hidden = true
            
            var alreadyAdded : Bool = false
            
            for subview in mainView?.subviews ?? [] {
                if subview.tag == 200  {
                    subview.isHidden = false
                    subview.frame = frame
                    alreadyAdded = true
                    break
                }
            }
            
            if !alreadyAdded {
                
                mainView?.addSubview(view)
                view.frame = frame
            }
            mainView?.layoutIfNeeded()
        }
    }
    
    func removeView(view : UIView , fromVC vc : UIViewController ) {
        
        let mainView =  vc.view
        view.tag = 200
        DispatchQueue.main.async {
            
            for subview in mainView?.subviews ?? [] {
                if subview.tag == 200 {
                    subview.removeFromSuperview()
                    break
                }
            }
        }
    }
    
    func showView(view : UIView , onVC vc : UIViewController, insteadOf view1 : UIView) {
        
        let mainView =  vc.view
        
        view.tag = 200
        
        DispatchQueue.main.async {
            
            var alreadyAdded : Bool = false
            
            for subview in mainView?.subviews ?? [] {
                if subview.tag == 200 {
                    subview.isHidden = false
                    subview.frame = view1.frame
                    alreadyAdded = true
                    break
                }
            }
            
            if !alreadyAdded {
                
                mainView?.addSubview(view)
                view.frame = view1.frame
            }
            mainView?.layoutIfNeeded()
        }
    }
}

