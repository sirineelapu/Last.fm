//
//  NoResultsView.swift
//  Last.fm
//
//  Created by Sireesha Neelapu on 03/09/19.
//


import UIKit

class NoResultsView: UIView {
        
    @IBOutlet weak var noResultsImageView: UIImageView!
    @IBOutlet weak var noResultsLabel: UILabel! {
        didSet{
            
            noResultsLabel.textColor = UIColor.lightGray
        }
    }
}
