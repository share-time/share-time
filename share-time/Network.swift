//
//  Network.swift
//  share-time
//
//  Created by Godwin Pang on 8/16/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import Foundation
import Parse
import PromiseKit

class Network {
    
    private static let success = "success"
    
    static func loginUserWithBlock(username: String, password: String) -> Promise<String> {
        return Promise { seal in
            PFUser.logInWithUsername(inBackground: username, password: password) { (_: PFUser?, error: Error?) in
                if error != nil {
                    seal.reject(error!)
                } else {
                    seal.fulfill(Network.success)
                }
            }
        }
    }
    
}
