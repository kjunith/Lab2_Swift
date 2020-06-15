//
//  AddEditViewController.swift
//  Lab2 - Swift
//
//  Created by Jimmie Määttä on 2019-04-30.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit

protocol AddEditDelegate {
    func saveTapped()
    func cancelTapped()
}

protocol ReloadDataDelegate {
    func reloadData()
}

class AddEditViewController: UIViewController {
    
    
    // MARK: --- PROPERTIES
    
    let receiptsData = ReceiptsData.handler
    let addEdit = AddEdit()
    
    var delegate: AddEditDelegate?
    var itemTitle: String?
    
    let numberFormatter = NumberFormatter()
    let locale = Locale(identifier: "en_EN")
    
    
    // MARK: --- INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(addEdit)
        NSLayoutConstraint.activate([
            addEdit.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            addEdit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            addEdit.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
            ])
        
        setupGestureRecognizers()
    }
    
    
    // MARK: HANDLERS
    
    func setupGestureRecognizers() {
        let saveGesture = UITapGestureRecognizer(target: self, action: #selector(handleSave))
        addEdit.saveLabel.addGestureRecognizer(saveGesture)
        
        let cancelGesture = UITapGestureRecognizer(target: self, action: #selector(handleCancel))
        addEdit.cancelLabel.addGestureRecognizer(cancelGesture)
        
        addEdit.sumSegmentedControl.addTarget(self, action: #selector(dateIndexChanged(_:)), for: .valueChanged)
    }
    
    @objc func dateIndexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            addEdit.activateStatus()
        case 1:
            addEdit.inactivateStatus()
        default:
            break
        }
    }
    
    @objc func handleSave() {
        addReceipt()
        delegate!.saveTapped()
    }
    
    @objc func handleCancel() {
        delegate!.cancelTapped()
    }
    
    func editReceipt(receipt:Receipt) {
        addEdit.receipt = receipt
    }
    
    func addReceipt() {
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = locale
        
        var sum: Double = 0.0
        var status: String = ""
        
        switch addEdit.sumSegmentedControl.selectedSegmentIndex {
        case 0:
            if let final = numberFormatter.number(from: addEdit.sumTextField.text!) as? Double {
                if final > 0 {
                    sum = final * -1
                } else {
                    sum = final
                }
            }
        case 1:
            if let final = numberFormatter.number(from: addEdit.sumTextField.text!) as? Double {
                if final < 0 {
                    sum = final * -1
                } else {
                    sum = final
                }
            }
        default:
            break
        }
        
        status = checkedStatus()
        
        let receipt = Receipt(
            title: addEdit.titleTextField.text!,
            receiver: addEdit.receiverTextField.text!,
            category: addEdit.categoryTextField.text!,
            sum: sum,
            status: status,
            due: addEdit.datePicker.date,
            added: addEdit.receipt!.added,
            receiptId: addEdit.receipt!.receiptId
        )
        
        if let matchingReceipt = receiptsData.receiptsList.firstIndex(where: {$0.receiptId == receipt.receiptId}) {
            receiptsData.receiptsList[matchingReceipt] = receipt
        } else {
            receiptsData.receiptsList.append(receipt)
        }
        
        receiptsData.saveReceipts()
    }
    
    func checkedStatus() -> String {
        if addEdit.statusState {
            switch addEdit.statusSegmentedControl.selectedSegmentIndex {
            case 0:
                return "Paid"
            case 1:
                return "Unpaid"
            default:
                return "None"
            }
        } else {
            return "None"
        }
    }
}
