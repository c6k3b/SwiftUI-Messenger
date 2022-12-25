//  Message.swift
//  Created by aa on 12/24/22.

import Foundation

enum MessageType: String {
    case sent, received
}

struct Message: Hashable {
    let text: String
    let type: MessageType
    let dateCreated: Date
}
