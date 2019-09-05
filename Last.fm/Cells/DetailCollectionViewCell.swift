//
//  DetailCollectionViewCell.swift
//  Last.fm
//
//  Created by Sireesha Neelapu on 05/09/19.
//

import UIKit
import IDMPhotoBrowser

class DetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    var parent: UIViewController!
    
    func showFullImageView(imageUrls urls: [Any], in containerView: UIView, pageIndex: Int = 0, completion: (()-> Void)? = nil) {
        
        let vc = IDMPhotoBrowser(photoURLs: urls, animatedFrom: containerView)!
        
        vc.setInitialPageIndex(UInt(pageIndex))
        vc.dismissOnTouch = true
        vc.displayDoneButton = false
        vc.displayActionButton = false
        vc.scaleImage = (containerView as? UIImageView)?.image
        parent.present(vc, animated: true, completion: completion)
    }
}
