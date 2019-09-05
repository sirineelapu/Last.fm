//
//  HomePageViewController.swift
//  Last.fm
//
//  Created by Sireesha Neelapu on 03/09/19.
//

import UIKit
import Alamofire

struct ResultsDataSource {
    var sectionName: ResponseType?
    var data: [Any]?
}

class HomePageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchKey: String? = "" {
        didSet {
            self.fetchAllData()
        }
    }
    var albumResponse: AlbumResponse?
    var artistResponse: ArtistResponse?
    var tracksResponse: TrackResponse?
    
    var albumRequest: Request?
    var trackRequest: Request?
    var artistRequest: Request?
    
    var albumLoaded: Bool = false
    var artistLoaded: Bool = false
    var trackLoaded: Bool = false
    var isLoaded: Bool = false
    var resultsView: UIView!
    var dataSource: [ResultsDataSource] = []
    var isLoading: Bool = false
    var canLoadMoreDict: [ResponseType: Bool] = [:]
    var pageNumberDict: [ResponseType: Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageNumberDict[.album] = 1
        pageNumberDict[.artist] = 1
        pageNumberDict[.track] = 1
        
        self.navigationItem.title = "Last.fm"

        //self.showHUD()
        setUpTableView()
        setupSearchVC()
        setNavigationTitleTheme()
        setupThemedNavbar()
        setupBackButton()
        registerNoResultsView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !NetworkManager.shared.isReachable {
            self.showBanner(message: "Please check your internet connectivity")
        }
        self.tableView.reloadData()
    }
    func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.estimatedRowHeight = 80
        tableView.tableFooterView = UIView()
    }

    func fetchAllData() {
       
        if !NetworkManager.shared.isReachable {
            self.showBanner(message: "Please check your internet connectivity")
        }
        
        albumLoaded = false
        artistLoaded = false
        trackLoaded = false
        
        DispatchQueue.main.async {
            
           // group.enter()
            self.fetchAlbumResult(onSuccess: {
                self.albumLoaded = true
                self.prepareDataSource()
            }, onFailure: {
                self.albumLoaded = true
            })
            //group.enter()
            self.fetchArtistResult(onSuccess: {
                self.artistLoaded = true
                self.prepareDataSource()
            }, onFailure: {
                self.artistLoaded = true
            })
            
            self.fetchTracksResult (onSuccess: {
                self.trackLoaded = true
                self.prepareDataSource()
            }, onFailure: {
                self.trackLoaded = true
            })
        }
    }
    
    func fetchAlbumResult(shouldShowHUD: Bool = false, onSuccess: @escaping (() -> Void), onFailure: @escaping (() -> Void)) {
        let params: [String: Any] = [
            "method": "album.search",
            "album" : searchKey ?? "",
            "api_key": Constants.shared.API_KEY,
            "format": "json",
            "limit": "7",
            "page": "\(pageNumberDict[.album] ?? 1)"
        ]
        
        albumRequest = RequestBulider.shared.request(ForType: RequestType.Search, params: params)
        if let request = albumRequest {
            RequestSender.sendRequest(request: request, viewController: self, shouldShowHUD: shouldShowHUD) { (callBack: ResponseCallback<AlbumResponseData>) in
                switch callBack {
                case .onRequestSuccess(let obj):
                    self.albumResponse = obj.results
                    onSuccess()
                case .onRequestFailure:
                    onFailure()
                }
            }
        }
    }
    
    func fetchArtistResult(shouldShowHUD: Bool = false, onSuccess: @escaping (() -> Void), onFailure: @escaping (() -> Void)) {
        let params: [String: Any] = [
            "method": "artist.search",
            "artist" : searchKey ?? "",
            "api_key": Constants.shared.API_KEY,
            "format": "json",
            "limit": "7",
            "page": "\(pageNumberDict[.artist] ?? 1)"
        ]
        
        artistRequest = RequestBulider.shared.request(ForType: RequestType.Search, params: params)
        if let request = artistRequest {
            RequestSender.sendRequest(request: request, viewController: self, shouldShowHUD: shouldShowHUD) { (callBack: ResponseCallback<ArtistResponseData>) in
                switch callBack {
                case .onRequestSuccess(let obj):
                    self.artistResponse = obj.results
                    onSuccess()
                case .onRequestFailure:
                    onFailure()
                }
            }
        }
    }
    
    func fetchTracksResult(shouldShowHUD: Bool = false, onSuccess: @escaping (() -> Void), onFailure: @escaping (() -> Void)) {
        let params: [String: Any] = [
            "method": "track.search",
            "track" : searchKey ?? "",
            "api_key": Constants.shared.API_KEY,
            "format": "json",
            "limit": "7",
            "page": "\(pageNumberDict[.track] ?? 1)"
        ]
        
        trackRequest = RequestBulider.shared.request(ForType: RequestType.Search, params: params)
        if let request = trackRequest {
            RequestSender.sendRequest(request: request, viewController: self, shouldShowHUD: shouldShowHUD) { (callBack: ResponseCallback<TrackResponseData>) in
                switch callBack {
                case .onRequestSuccess(let obj):
                    self.tracksResponse = obj.results
                    onSuccess()
                case .onRequestFailure:
                    onFailure()
                }
            }
        }
    }
    
    func prepareDataSource() {
        
        if albumLoaded && artistLoaded && trackLoaded {
            isLoaded = true
            dataSource = []
            
            pageNumberDict[.album] = 1
            pageNumberDict[.artist] = 1
            pageNumberDict[.track] = 1
            
            if let albumMatches = albumResponse?.albumMatches, let albums = albumMatches.albums, albums.count > 0 {
                let albumnDataSource = ResultsDataSource(sectionName: ResponseType.album, data: albums)
                canLoadMoreDict[ResponseType.album] = albums.count < 7 ? false : true
                dataSource.append(albumnDataSource)
            }
            
            if let artistMatches = artistResponse?.artistMatches, let artists = artistMatches.artists, artists.count > 0 {
                let artistDataSource = ResultsDataSource(sectionName: ResponseType.artist, data: artists)
                canLoadMoreDict[ResponseType.artist] = artists.count < 7 ? false : true
                dataSource.append(artistDataSource)
            }
            
            if let trackMatches = tracksResponse?.trackMatches, let tracks = trackMatches.tracks, tracks.count > 0 {
                let trackDataSource = ResultsDataSource(sectionName: ResponseType.track, data: tracks)
                canLoadMoreDict[ResponseType.track] = tracks.count < 7 ? false : true
                dataSource.append(trackDataSource)
            }
            self.tableView.reloadData()
        }
    }
    
    func registerNoResultsView() {
        
        let noResultsView = UINib(nibName: "NoResultsView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? NoResultsView
        
        noResultsView?.noResultsImageView.image = UIImage(named: "addPlaceholder")
        noResultsView?.noResultsLabel.text = "Tap on the plus on any bhajan to add them into your playlist"
        self.resultsView = noResultsView ?? UIView()
    }
    
    
    func setupSearchVC() {
        
        definesPresentationContext = true
        searchBar.delegate = self
        searchBar.tintColor = UIColor.black
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.backgroundColor = UIColor.white
    }
}

extension HomePageViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        artistRequest?.cancel()
        albumRequest?.cancel()
        trackRequest?.cancel()
        
        searchKey = searchText.count > 0 ? searchText : " "
    }
}

extension HomePageViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if (searchKey?.trimmingCharacters(in: CharacterSet.whitespaces) ?? "").count > 0 {
            if dataSource.count > 0 {
            return self.dataSource.count
            } else {
                return 1
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.count > 0, dataSource[section].data?.count ?? 0 > 0 {
            return dataSource[section].data?.count ?? 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if dataSource.count > 0,  dataSource[section].data?.count ?? 0 > 0 {
            
            return dataSource[section].sectionName!.rawValue.capitalized
        }
        return ""
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomepageTableViewCell") as! HomepageTableViewCell
        if dataSource.count > 0, dataSource[indexPath.section].data?.count ?? 0 > 0 {
            if let sectionName = dataSource[indexPath.section].sectionName {
                switch sectionName{
                case .album:
                    if let album = dataSource[indexPath.section].data as? [Album] {
                       
                        cell.setUpData(responseType: sectionName, data: album[indexPath.row])
                    }
                case.artist:
                    if let artist = dataSource[indexPath.section].data as? [Artist] {
                        cell.setUpData(responseType: sectionName, data: artist[indexPath.row])
                    }
                case .track:
                    if let track = dataSource[indexPath.section].data as? [Track] {
                        cell.setUpData(responseType: sectionName, data:  track[indexPath.row])
                    }
                    
                default: break
                }
            }
        } else {
            if searchKey?.trimmingCharacters(in: CharacterSet.whitespaces) != "" {
                cell.setUpData(responseType: .none, data: nil)
            } else {
                cell.titleLabel.text =
                """
                
                
                
                
                
                Welcome to Last.fm!
                Search songs and enjoy listening.
                
                
                
                
                
                """
                cell.titleLabel.textAlignment = .center
                cell.subTitleLabel.text = ""
                cell.imgView.image = UIImage(named: "")
                cell.imgViewWidthCOnstraint.constant = 0
                
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        pagenation(indexPath: indexPath)
    }
    
    func pagenation(indexPath: IndexPath) {
        
        let cellsRemaining = 2
        
        if indexPath.section == dataSource.count - 1 {
            
            let thisSectionObjs = dataSource[indexPath.section].data ?? []
            
            if indexPath.row + 1 >= thisSectionObjs.count - cellsRemaining {
                
                if self.canLoadMoreDict[ResponseType.album] == true {
                    fetchAlbumResult(shouldShowHUD: false, onSuccess: {
                        
                        let pageNumber = self.pageNumberDict[.album] ?? 1
                        self.pageNumberDict[.album] = pageNumber + 1
                        
                        if let albumMatches = self.albumResponse?.albumMatches, let albums = albumMatches.albums, albums.count > 0 {
                            self.canLoadMoreDict[ResponseType.album] = albums.count < 7 ? false : true
                            if let indexOfAlbum = self.dataSource.firstIndex(where: {$0.sectionName! == .album}){
                                self.dataSource[indexOfAlbum].data?.append(contentsOf: albums)
                            }
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }, onFailure: {
                        
                    })
                }
                
                if self.canLoadMoreDict[.artist] == true {
                    fetchArtistResult(shouldShowHUD: false, onSuccess: {
                        
                        let pageNumber = self.pageNumberDict[.artist] ?? 1
                        self.pageNumberDict[.artist] = pageNumber + 1
                        
                        if let artistMatches = self.artistResponse?.artistMatches, let artists = artistMatches.artists, artists.count > 0 {
                            self.canLoadMoreDict[.artist] = artists.count < 7 ? false : true
                            if let indexOfArtist = self.dataSource.firstIndex(where: {$0.sectionName! == .artist}){
                                self.dataSource[indexOfArtist].data?.append(contentsOf: artists)
                            }
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }, onFailure: {
                        
                    })
                }
                
                if self.canLoadMoreDict[.track] == true {
                    fetchTracksResult(shouldShowHUD: false, onSuccess: {
                        
                        let pageNumber = self.pageNumberDict[.track] ?? 1
                        self.pageNumberDict[.track] = pageNumber + 1
                        
                        if let trackMatches = self.tracksResponse?.trackMatches, let tracks = trackMatches.tracks, tracks.count > 0 {
                            self.canLoadMoreDict[.track] = tracks.count < 7 ? false : true
                            if let indexOfTrack = self.dataSource.firstIndex(where: {$0.sectionName! == .track}){
                                self.dataSource[indexOfTrack].data?.append(contentsOf: tracks)
                            }
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }, onFailure: {
                        
                    })
                }
            }
        }
    }
    
}

extension HomePageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (searchKey?.trimmingCharacters(in: CharacterSet.whitespaces) ?? "").count > 0 {
            let detailVc = ViewControllerFactory.shared.presentSatakamViewController(requestType:dataSource[indexPath.section].sectionName!, data: dataSource[indexPath.section].data?[indexPath.row] ?? [])
            searchBar.text = ""
            searchKey = " "
            self.view.endEditing(true)
            self.navigationController?.pushViewController(detailVc, animated: true)
        }
    }
}
