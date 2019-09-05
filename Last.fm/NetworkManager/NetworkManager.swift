//
//  NetworkManager.swift
//  Last.fm
//
//  Created by Sireesha Neelapu on 03/09/19.
//

import Foundation
import Reachability

class NetworkManager {

    static var shared = NetworkManager()
    
    var reachability = Reachability()
    
    init() {
        do {
            try reachability?.startNotifier()
        } catch {
            print("\(error)")
        }
    }
    
    var isReachable: Bool {
        return reachability?.connection != .none
    }
}

