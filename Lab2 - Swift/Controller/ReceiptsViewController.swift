//
//  ReceiptsViewController.swift
//  Lab2 - Swift
//
//  Created by Jimmie Määttä on 2019-04-25.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit

protocol ReceiptsDelegate {
    func rowTapped(receipt:Receipt)
}

enum FilterSum {
    case all
    case expense
    case income
}

enum FilterStatus {
    case all
    case paid
    case unpaid
}

enum SortDate {
    case due
    case added
}

class ReceiptsViewController: UIViewController, UITextFieldDelegate {
    
    
    // MARK: --- PROPERTIES
    
    let receiptsData = ReceiptsData.handler
    var tempList: [Receipt] = []
    let receipts = Receipts()
    let addEditViewController = AddEditViewController()
    
    let receiptCellId = "receiptCell"
    let defaultCellId = "defaultCell"
    let noReceipts = "No Receipts Found"
    var searchText: String?
    let noResults = " not found"
    
    var delegate: ReceiptsDelegate?
    var searchResults: [Receipt] = []
    
    var remove = false
    
    let dateFormatter = DateFormatter()
    let locale = Locale(identifier: "en_EN")
    
    var filterSum:FilterSum?
    var filterStatus:FilterStatus?
    var sortDate:SortDate?
    
    
    // MARK: --- INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        tempList = receiptsData.receiptsList
        
        view.addSubview(receipts)
        NSLayoutConstraint.activate([
            receipts.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            receipts.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.66),
            receipts.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            receipts.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
            ])
        
        setupTableView()
        setupActions()
        checkFilters()
        updateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateData()
    }
    
    
    // MARK: --- HANDLERS
    
    func updateData() {
        setFilterSum()
        setSortDate()
        receipts.receiptsTableView.reloadData()
    }
    
    func checkFilters() {
        if filterSum == nil {
            filterSum = .all
        }
        
        if filterStatus == nil {
            filterStatus = .all
        }
        
        if sortDate == nil {
            sortDate = .due
        }
    }
    
    func setupActions() {
        receipts.searchTextField.addTarget(self, action: #selector(ReceiptsViewController.textFieldDidChange(_:)),
                                           for: UIControl.Event.editingChanged)
        
        receipts.searchTextField.addTarget(self, action: #selector(ReceiptsViewController.textFieldDidEndEditing(_:)),
                                           for: UIControl.Event.editingDidEndOnExit)
        
        receipts.filterSumSegmentedControl.addTarget(self, action: #selector(sumIndexChanged(_:)), for: .valueChanged)
        
        receipts.filterStatusSegmentedControl.addTarget(self, action: #selector(statusIndexChanged(_:)), for: .valueChanged)
        
        receipts.sortDateSegmentedControl.addTarget(self, action: #selector(dateIndexChanged(_:)), for: .valueChanged)
    }
    
    func setFilterSum() {
        switch filterSum! {
        case .all:
            filterAll()
        case .expense:
            filterExpenses()
        case .income:
            filterIncomes()
        }
    }
    
    func filterAll() {
        tempList = receiptsData.receiptsList
        switch filterStatus! {
        case .all:
            tempList = receiptsData.receiptsList.filter({ $0.status == "None" || $0.status == "Paid" || $0.status == "Unpaid" })
        case .paid:
            tempList = receiptsData.receiptsList.filter({ $0.status == "Paid" })
        case .unpaid:
            tempList = receiptsData.receiptsList.filter({ $0.status == "Unpaid" })
        }
        receipts.statusActive()
    }
    
    func filterExpenses() {
        tempList = receiptsData.receiptsList.filter({ $0.sum < 0 })
        switch filterStatus! {
        case .all:
            tempList = tempList.filter({ $0.status == "Paid" || $0.status == "Unpaid" })
        case .paid:
            tempList = tempList.filter({ $0.status == "Paid" })
        case .unpaid:
            tempList = tempList.filter({ $0.status == "Unpaid" })
        }
        receipts.statusActive()
    }
    
    func filterIncomes() {
        tempList = receiptsData.receiptsList.filter({ $0.sum > 0 })
        tempList = tempList.filter({ $0.status == "None" })
        receipts.statusInactive()
    }
    
    func setSortDate() {
        switch sortDate! {
        case .due:
            tempList.sort(by: { $0.due.compare($1.due) == .orderedDescending })
        case .added:
            tempList.sort(by: { $0.added.compare($1.added) == .orderedDescending })
        }
    }
    
    @objc func sumIndexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            filterSum = .all
        case 1:
            filterSum = .expense
        case 2:
            filterSum = .income
        default:
            break
        }
        
        updateData()
    }
    
    @objc func statusIndexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            filterStatus = .all
        case 1:
            filterStatus = .paid
        case 2:
            filterStatus = .unpaid
        default:
            break
        }
        
        updateData()
    }
    
    @objc func dateIndexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            sortDate = .due
        case 1:
            sortDate = .added
        default:
            break
        }
        
        updateData()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        searchResults.removeAll()
        
        if let search = textField.text {
            searchText = search
            searchAllTitles(searchText: searchText!)
            searchAllReceivers(searchText: searchText!)
            searchAllCategory(searchText: searchText!)
        }
        
        updateData()
    }
    
    func removeItemDialog(title:String, message:String, tableView:UITableView, indexPath:IndexPath) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .destructive,
                                      handler: {(alert: UIAlertAction!) in
                                        self.removeReceipt(indexPath: indexPath, tableView: tableView)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: {(alert: UIAlertAction!) in
                                        return
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func removeReceipt(indexPath:IndexPath, tableView:UITableView) {
        if tempList.count == 0 {
            return
        } else {
            receiptsData.receiptsList = receiptsData.receiptsList.filter({!$0.receiptId.elementsEqual(tempList[indexPath.row].receiptId)})
            if searchResults.count > 0 {
                if let index = tempList.firstIndex(where: {$0.receiptId.elementsEqual(searchResults[indexPath.row].receiptId) } ) {
                    searchResults.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tempList.remove(at: index)
                }
            } else if searchResults.count == 0 && !receipts.searchTextField.text!.isEmpty {
                return
            } else {
                tempList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            receiptsData.saveReceipts()
        }
    }
    
    func searchAllTitles(searchText:String) {
        let titles = tempList.filter {
            $0.title.lowercased().contains(searchText.lowercased()
            )
        }
        
        for result in titles {
            if !searchResults.contains(where: { (existing) -> Bool in
                result.receiptId == existing.receiptId
            }) {
                searchResults.append(result)
            }
        }
    }
    
    func searchAllReceivers(searchText:String) {
        let receivers = tempList.filter {
            $0.receiver.lowercased().contains(searchText.lowercased()
            )
        }
        
        for result in receivers {
            if !searchResults.contains(where: { (existing) -> Bool in
                result.receiptId == existing.receiptId
            }) {
                searchResults.append(result)
            }
        }
    }
    
    func searchAllCategory(searchText:String) {
        let categories = tempList.filter {
            $0.category.lowercased().contains(searchText.lowercased()
            )
        }
        
        for result in categories {
            if !searchResults.contains(where: { (existing) -> Bool in
                result.receiptId == existing.receiptId
            }) {
                searchResults.append(result)
            }
        }
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        resignFirstResponder()
        updateData()
    }
}
