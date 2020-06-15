//
//  ReceiptsData.swift
//  Lab2 - Swift
//
//  Created by Jimmie Määttä on 2019-04-27.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit

class ReceiptsData: NSObject {
    
    
    // MARK: --- PROPERTIES
    
    static let handler = ReceiptsData()
    
    let userDefaults = UserDefaults.standard
    let receiptsKey = "ReceiptsKey"
    
    var receiptsList: [Receipt] = []
    var savedReceipts: [Data]?
    
    let dateFormatter = DateFormatter()
    var selectedMonth: Date?
    
    var incomesSum: Double = 0.0
    var expensesSum: Double = 0.0
    var totalSum: Double = 0.0
    
    // MARK: --- INIT
    
    override init() {
        super.init()
        
        selectedMonth = Date()
    }
    
    
    // MARK: --- HANDLERS
    
    func saveReceipts() {
        var allReceiptsData:[[Data]] = []
        
        for receipt in receiptsList {
            let title = try? NSKeyedArchiver.archivedData(withRootObject: receipt.title, requiringSecureCoding: false)
            let receiver = try? NSKeyedArchiver.archivedData(withRootObject: receipt.receiver, requiringSecureCoding: false)
            let category = try? NSKeyedArchiver.archivedData(withRootObject: receipt.category, requiringSecureCoding: false)
            let sum = try? NSKeyedArchiver.archivedData(withRootObject: receipt.sum, requiringSecureCoding: false)
            let status = try? NSKeyedArchiver.archivedData(withRootObject: receipt.status, requiringSecureCoding: false)
            let due = try? NSKeyedArchiver.archivedData(withRootObject: receipt.due, requiringSecureCoding: false)
            let added = try? NSKeyedArchiver.archivedData(withRootObject: receipt.added, requiringSecureCoding: false)
            let receiptId = try? NSKeyedArchiver.archivedData(withRootObject: receipt.receiptId, requiringSecureCoding: false)
            
            let receiptData:[Data] = [
                title! as Data,
                receiver! as Data,
                category! as Data,
                sum! as Data,
                status! as Data,
                due! as Data,
                added! as Data,
                receiptId! as Data,
            ]
            
            allReceiptsData.append(receiptData)
        }
        
        userDefaults.set(allReceiptsData, forKey: receiptsKey)
    }
    
    func loadReceipts() {
        receiptsList.removeAll()
        
        if let allReceiptsData:[[Data]] = userDefaults.object(forKey: receiptsKey) as? [[Data]] {
            for receiptData in allReceiptsData {
                let title:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(receiptData[0] as Data) as! String
                let receiver:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(receiptData[1] as Data) as! String
                let category:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(receiptData[2] as Data) as! String
                let sum:Double = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(receiptData[3] as Data) as! Double
                let status:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(receiptData[4] as Data) as! String
                let due:Date = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(receiptData[5] as Data) as! Date
                let added:Date = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(receiptData[6] as Data) as! Date
                let receiptId:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(receiptData[7] as Data) as! String
                
                let receipt = Receipt(title: title, receiver: receiver, category: category, sum: sum, status: status, due: due, added: added, receiptId: receiptId)
                
                receiptsList.append(receipt)
            }
        } else {
            setupTempReceipts()
        }
    }
    
    func calculateSums() {
        dateFormatter.dateFormat = "MMM yyyy"
        
        incomesSum = 0.0
        expensesSum = 0.0
        totalSum = 0.0
        
        for receipt in receiptsList {
            if dateFormatter.string(from: receipt.due).uppercased().elementsEqual(dateFormatter.string(from: selectedMonth!).uppercased()) {
                if receipt.sum > 0 {
                    incomesSum += receipt.sum
                }
                if receipt.sum < 0 {
                    expensesSum += receipt.sum
                }
                totalSum += receipt.sum
            }
        }
    }
    
    func nextMonth() -> Date {
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth!)
        selectedMonth = nextMonth
        calculateSums()
        return selectedMonth!
    }
    
    func prevMonth() -> Date {
        let prevMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth!)
        selectedMonth = prevMonth
        calculateSums()
        return selectedMonth!
    }
    
    func setupTempReceipts() {
        receiptsList.removeAll()
        
        let titles: [String] = ["Ice Cream", "Tent", "Bucket", "Clothes", "Ticket"]
        let receivers: [String] = ["MONEY MAKERS", "REC.t", "Disco Dough", "MaeWik", "K-Unit"]
        let categories: [String] = ["Secret", "Home", "Misc", "Hobby", "Business"]
        let sums: [Double] = [-99, -1234.56, 4567, -249.90, -499]
        
        for _ in 0 ..< 1000 {
            let title = titles[Int(arc4random_uniform(UInt32(titles.count)))]
            let receiver = receivers[Int(arc4random_uniform(UInt32(receivers.count)))]
            let category = categories[Int(arc4random_uniform(UInt32(categories.count)))]
            let sum = sums[Int(arc4random_uniform(UInt32(sums.count)))]
            
            let month = Int(arc4random_uniform(12)) + 1
            var monthNext = month + 1
            if month == 12 {
                monthNext -= 1
            }
            let day = Int(arc4random_uniform(28)) + 1
            let formatter = DateFormatter()
            let dueString = "\(day) \(monthNext) 2019"
            let addedString = "\(day) \(month) 2019"
            
            formatter.dateFormat = "d M yyyy"
            let due = formatter.date(from: dueString)
            let added = formatter.date(from: addedString)
            
            var status = "None"
            let statuses: [String] = ["Paid", "Unpaid"]
            if sum < 0 {
                status = statuses[Int(arc4random_uniform(2))]
            }
            
            let receipt = Receipt(
                title: title,
                receiver: receiver,
                category: category,
                sum: sum,
                status: status,
                due: due!,
                added: added!,
                receiptId: UUID().uuidString
            )
            
            receiptsList.append(receipt)
        }
        
        saveReceipts()
    }
}
