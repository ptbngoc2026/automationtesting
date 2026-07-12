//
//  Item.swift
//  automation_testing_safari_1
//
//  Created by Phan Thi Bich Ngoc on 12/7/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
