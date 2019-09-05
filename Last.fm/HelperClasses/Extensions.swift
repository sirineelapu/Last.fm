//
//  Extensions.swift
//  Last.fm
//
//  Created by Sireesha Neelapu on 03/09/19.
//

import UIKit
import SwiftMessages
import MBProgressHUD

extension UIViewController {
    
    func showBanner(message: String?, backgroundColor: UIColor? = UIColor.red, presentationContext: SwiftMessages.PresentationContext? = .automatic) {
        MusicBanner.shared.showError(message: message ?? "Something went wrong", backgroundColor: backgroundColor!, presentationContext: presentationContext)
    }
    
    func  showHUD() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.bezelView.color = UIColor.black.withAlphaComponent(0.6)
        hud.tintColor = .white
    }
    
    func hideHUD()
    {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    func setNavigationTitleTheme(setLargeTitles: Bool = true) {
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
            self.navigationController?.navigationBar.isTranslucent = true
            if setLargeTitles {
                
                self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .black)]
            }
            navigationController?.navigationBar.sizeToFit()
        } else {
            // Fallback on earlier versions
        }
        let attributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    func setupThemedNavbar() {
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        
    }
    
    func setupBackButton() {
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        self.navigationController?.navigationBar.tintColor = UIColor.black
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButtonItem
    }
}

