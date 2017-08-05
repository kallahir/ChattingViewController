//
//  Message.swift
//  ChattingViewController
//
//  Created by Itallo Rossi Lucas on 04/08/17.
//  Copyright © 2017 kallahir. All rights reserved.
//

import Foundation

class Message {
    
    var msgId: String
    var msgTimestamp: Date
    var userId: String
    
    init(msgId: String, msgTimestamp: Date, userId: String) {
        self.msgId = msgId
        self.msgTimestamp = msgTimestamp
        self.userId = userId
    }
    
}
