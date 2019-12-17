//
//  Sender+UserDefaults.swift
//  Message Board
//
//  Created by Niranjan Kumar on 12/17/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import MessageKit

extension Sender {
    
    // Convert a snder to a dictionary to be saved to User Defaults
    
    var dictionaryRepresents: [String : String] {
        return ["id": senderId, // 293082-90384-01021312041
            "displayName": displayName] // Nar
    }
    
    // Convert a dictionary back to a Sender object to be used by the rest of the app
    
    init?(dictionary: [String: String]) {
        guard let id = dictionary["id"],
            let displayName = dictionary["displayName"] else { return nil }
        self.init(senderId: id, displayName: displayName)
    }
    
    
    
}
