//
//  DetailViewController.swift
//  Last.fm
//
//  Created by Sireesha Neelapu on 04/09/19.
//

import UIKit
import SafariServices
import IDMPhotoBrowser

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var requestType: ResponseType!
    var data: Any!
    var playUrl: String? = nil
    var images: [Image] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Last.fm"
        setNavigationTitleTheme(setLargeTitles: false)
        //setupThemedNavbar()
        setupBackButton()
        setUpCollectionView()
        setUpData()
    }
    
    func setUpData() {
        if let type = requestType {
            switch type {
            case .album:
                if let albumData = data as? Album {
                    titleLabel.text = albumData.name
                    subTitleLabel.text = albumData.artist
                    self.images = albumData.image ?? []
                    playUrl = albumData.url
                }
            case .artist:
                if let artistData = data as? Artist {
                    titleLabel.text = artistData.name
                    
                    self.images = artistData.image ?? []
                    playUrl = artistData.url
                }
            case .track:
                if let trackData = data as? Track {
                    titleLabel.text = trackData.name
                    subTitleLabel.text = trackData.artist
                    
                   self.images = trackData.image ?? []
                    playUrl = trackData.url
                }
                
            default: break
            }
        }
    }

    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func openPage(pageURL : String) {
        
        let pageURL = URL(string: pageURL)!
        
        let safariVC = SFSafariViewController(url: pageURL)
        self.present(safariVC, animated: true, completion: nil)
    }
}

//IBActions

extension DetailViewController {
    @IBAction func onclickPlay(_ sender: UIButton) {
        if let url = playUrl {
            openPage(pageURL: url)
        }
    }
}

extension DetailViewController: UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as! DetailCollectionViewCell
        cell.parent = self
        if let url = URL(string: images[indexPath.row].text ?? "") {  
            cell.imgView.sd_setImage(with: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DetailCollectionViewCell
        cell.showFullImageView(imageUrls: [images[indexPath.row].text], in: collectionView)
        
    }
}
