//
//  TextMessage.swift
//  ChattingViewController
//
//  Created by Itallo Rossi Lucas on 04/08/17.
//  Copyright © 2017 kallahir. All rights reserved.
//

import Foundation

class TextMessage: Message {
    
    var msgContent: String!
    
    init(msgId: String, msgTimestamp: Date, content: String, userId: String) {
        super.init(msgId: msgId, msgTimestamp: msgTimestamp, userId: userId)
        self.msgContent = content
    }
    
}
