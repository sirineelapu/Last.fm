//
//  MusicBanner.swift
//  Last.fm
//
//  Created by Sireesha Neelapu on 03/09/19.
//

import Foundation
import SwiftMessages

enum AlertType {
    case success
    case error
    case info
}

class MusicBanner {
    
    fileprivate init() { }
    
    static var shared: MusicBanner {
        return MusicBanner()
    }
    
    
    fileprivate let errorView: MessageView = {
        let error = MessageView.viewFromNib(layout: .tabView)
        error.configureTheme(.error)
        error.configureContent(title: "", body: "Please activate WIFI or LTE")
        error.button?.setTitle("", for: .normal)
        error.button?.isHidden = true
        
        return error
    }()
    
    
    fileprivate let messageView: MessageView = {
        let messageView = MessageView.viewFromNib(layout: .cardView)
        messageView.configureDropShadow()
        messageView.button?.isHidden = true
        return messageView
    }()
    
    fileprivate func alertConfig(_ type: AlertType) -> SwiftMessages.Config {
        var config = SwiftMessages.Config()
        config.interactiveHide = true
        config.presentationContext = .automatic
        
        switch type {
        case .success, .error:
            // Bottom alert style
            config.presentationStyle = .bottom
            //config.dimMode = .gray(interactive: true)
            config.duration = .automatic
        case .info:
            // Top alert style
            config.presentationStyle = .top
            config.dimMode = .none
            config.duration = .seconds(seconds: 5)
        }
        
        return config
        
        
    }
    
    func showError(title: String? = nil,
                   rightIcon: UIImage? = nil,
                   leftIcon: UIImage? = Icon.success.image, message: String, tapHandler: (( _ view: BaseView) -> Void)? = nil,
                   backgroundColor: UIColor = UIColor.red,
                   foregroundColor: UIColor = UIColor.white,
                   duration: SwiftMessages.Duration = .automatic,
                   presentationStyle: SwiftMessages.PresentationStyle = .top,
                   presentationContext: SwiftMessages.PresentationContext? = .automatic) {
        
        let infoView : MessageView = try! SwiftMessages.viewFromNib()
        
        infoView.configureContent(title: title, body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "", buttonTapHandler: { _ in SwiftMessages.hide() })
        infoView.configureTheme(backgroundColor: backgroundColor, foregroundColor: foregroundColor)
        infoView.button?.isHidden = true
        
        var config = SwiftMessages.defaultConfig
        
        config.duration = .seconds(seconds: 8.0)
        config.dimMode = .none
        config.presentationContext = presentationContext!
        SwiftMessages.show(config: config, view: infoView)
    }
    
    func hideAll() {
        SwiftMessages.hideAll()
    }
}
