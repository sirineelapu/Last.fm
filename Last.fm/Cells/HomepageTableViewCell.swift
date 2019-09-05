//
//  HomepageTableViewCell.swift
//  Last.fm
//
//  Created by Sireesha Neelapu on 04/09/19.
//

import UIKit
import SDWebImage

class HomepageTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgViewWidthCOnstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpData(responseType: ResponseType, data: Any?) {
        imgViewWidthCOnstraint.constant = 35
         titleLabel.textAlignment = .left
        switch responseType {
        case .album:
            if let albumData = data as? Album {
                titleLabel.text = albumData.name
                subTitleLabel.text = albumData.artist
                
                let url = URL(string: albumData.image?.last?.text ?? "")
                imgView.sd_setImage(with: url)
            }
        case .artist:
            if let artistData = data as? Artist {
                titleLabel.text = artistData.name
                
                let url = URL(string: artistData.image?.last?.text ?? "")
                imgView.sd_setImage(with: url)
            }
        case .track:
            if let trackData = data as? Track {
                titleLabel.text = trackData.name
                subTitleLabel.text = trackData.artist
                
                let url = URL(string: trackData.image?.last?.text ?? "")
                imgView.sd_setImage(with: url)
            }
        case .none:
            titleLabel.text =
            """
            
            
            
            
            
            Sorry! No results found....
            
            
            
            
            
            
            """
            titleLabel.textAlignment = .center
            subTitleLabel.text = ""
            imgView.image = UIImage(named: "")
            imgViewWidthCOnstraint.constant = 0
        }
    
    }
}
