//
//  Receipt.swift
//  Lab2 - Swift
//
//  Created by Jimmie Määttä on 2019-04-25.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import Foundation

enum Status: String {
    case none   = "None"
    case paid   = "Paid"
    case unpaid = "Unpaid"
}

struct Receipt {
    var title: String
    var receiver: String
    var category: String
    var sum: Double
    var status: Status.RawValue
    var due: Date
    var added: Date
    var receiptId: String
}
