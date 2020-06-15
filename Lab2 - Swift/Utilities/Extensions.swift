//
//  Extensions.swift
//  Lab2 - Swift
//
//  Created by Jimmie Määttä on 2019-04-25.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit
import YCBarcodeReader


// MARK: --- NAVIGATION

extension MainViewController {
    
    @objc func handleTap() {
        switch menu.state! {
        case .active:
            hideMenu()
        case .inactive:
            showMenu()
        }
    }
    
    func showMenu() {
        menu.state = .active
        
        NSLayoutConstraint.deactivate([hideMenuCosntraint])
        NSLayoutConstraint.activate([showMenuConstraint])
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.shadow.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hideMenu() {
        menu.state = .inactive
        
        NSLayoutConstraint.deactivate([showMenuConstraint])
        NSLayoutConstraint.activate([hideMenuCosntraint])
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.shadow.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func handleStartpage() {
        hideMenu()
        
        if children.count != 0 {
            let oldViewController = children[0]
            prevViewController = startpageViewController
            if oldViewController != startpageViewController {
                changeViewController(oldViewController: oldViewController, newViewController: startpageViewController!)
                removeSubView(viewController: oldViewController)
            } else {
                return
            }
        } else {
            addSubView(subViewController: startpageViewController!, parentView: containerView)
        }
    }
    
    @objc func handleOverview() {
        hideMenu()
        
        if children.count != 0 {
            let oldViewController = children[0]
            prevViewController = overviewViewController
            if oldViewController != overviewViewController {
                changeViewController(oldViewController: oldViewController, newViewController: overviewViewController!)
                removeSubView(viewController: oldViewController)
            } else {
                return
            }
        } else {
            addSubView(subViewController: overviewViewController!, parentView: containerView)
        }
    }
    
    @objc func handleReceipts() {
        hideMenu()
        
        if children.count != 0 {
            let oldViewController = children[0]
            prevViewController = receiptsViewController
            if oldViewController != receiptsViewController {
                changeViewController(oldViewController: oldViewController, newViewController: receiptsViewController!)
                removeSubView(viewController: oldViewController)
            } else {
                return
            }
        } else {
            addSubView(subViewController: receiptsViewController!, parentView: containerView)
        }
    }
    
    func changeViewController(oldViewController:UIViewController, newViewController:UIViewController) {
        oldViewController.willMove(toParent: nil)
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubView(subViewController: newViewController, parentView: containerView)
        
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
        }) { (finished) in
            oldViewController.view.removeFromSuperview()
            oldViewController.removeFromParent()
            newViewController.didMove(toParent: self)
        }
    }
    
    func addSubView(subViewController:UIViewController, parentView:UIView) {
        addChild(subViewController)
        
        view.layoutIfNeeded()
        parentView.addSubview(subViewController.view)
        
        subViewController.view.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        subViewController.view.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        subViewController.view.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
        subViewController.view.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive  = true
    }
    
    func removeSubView(viewController:UIViewController) {
        viewController.willMove(toParent: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut, animations: {
            viewController.view.alpha = 0
        }) { (finished) in
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }
    }
}


// MARK: --- DELEGATE STARTPAGE

extension MainViewController: StartpageDelegate {
    func manuallyTapped() {
        if children.count != 0 {
            let oldViewController = children[0]
            prevViewController = oldViewController
            if oldViewController != addEditViewController {
                addEditViewController?.addEdit.receipt = Receipt(title: "", receiver: "", category: "", sum: 0, status: "None", due: Date(), added: Date(), receiptId: UUID().uuidString)
                changeViewController(oldViewController: oldViewController, newViewController: addEditViewController!)
                removeSubView(viewController: oldViewController)
            } else {
                return
            }
        } else {
            addSubView(subViewController: addEditViewController!, parentView: containerView)
        }
    }
    
    func scannerTapped(xmlItem: XMLItem) {
        let itemTitle = xmlItem.title
        
        if children.count != 0 {
            let oldViewController = children[0]
            prevViewController = oldViewController
            if oldViewController != addEditViewController {
                addEditViewController?.addEdit.receipt = Receipt(title: itemTitle, receiver: "", category: "", sum: 0, status: "None", due: Date(), added: Date(), receiptId: UUID().uuidString)
                changeViewController(oldViewController: oldViewController, newViewController: addEditViewController!)
                removeSubView(viewController: oldViewController)
            } else {
                return
            }
        } else {
            addEditViewController?.itemTitle = itemTitle
            addSubView(subViewController: addEditViewController!, parentView: containerView)
        }
    }
}


// MARK: --- DELEGATE ADDEDIT

extension MainViewController: AddEditDelegate {
    func saveTapped() {
        if children.count != 0 {
            let oldViewController = children[0]
            prevViewController = receiptsViewController
            if oldViewController != receiptsViewController {
                changeViewController(oldViewController: oldViewController, newViewController: receiptsViewController!)
                removeSubView(viewController: oldViewController)
            } else {
                return
            }
        } else {
            addSubView(subViewController: receiptsViewController!, parentView: containerView)
        }
    }
    
    func cancelTapped() {
        if children.count != 0 {
            let oldViewController = children[0]
            if oldViewController == addEditViewController {
                changeViewController(oldViewController: oldViewController, newViewController: prevViewController!)
                removeSubView(viewController: oldViewController)
            } else {
                return
            }
        } else {
            addSubView(subViewController: prevViewController!, parentView: containerView)
        }
    }
}


// MARK: --- DELEGATE RECEIPTS

extension MainViewController: ReceiptsDelegate {
    func rowTapped(receipt: Receipt) {
        if children.count != 0 {
            let oldViewController = children[0]
            if oldViewController != addEditViewController {
                addEditViewController?.addEdit.receipt = receipt
                changeViewController(oldViewController: oldViewController, newViewController: addEditViewController!)
                removeSubView(viewController: oldViewController)
            } else {
                return
            }
        } else {
            addEditViewController?.addEdit.receipt = receipt
            addSubView(subViewController: addEditViewController!, parentView: containerView)
        }
    }
}


// MARK: --- TABLEVIEW

extension ReceiptsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        receipts.receiptsTableView.delegate = self
        receipts.receiptsTableView.dataSource = self
        receipts.receiptsTableView.register(ReceiptsTableViewCell.self, forCellReuseIdentifier: receiptCellId)
        
        receipts.receiptsTableView.rowHeight = UITableView.automaticDimension
        receipts.receiptsTableView.estimatedRowHeight = 64
        receipts.receiptsTableView.separatorColor = UIColor(named: "NotQuiteBlack")
        receipts.receiptsTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        receipts.receiptsTableView.showsVerticalScrollIndicator = false
        receipts.receiptsTableView.showsHorizontalScrollIndicator = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tempList.count == 0 {
            let noReceiptsLabel = AvenirBig()
            noReceiptsLabel.text = noReceipts
            noReceiptsLabel.textAlignment = .center
            noReceiptsLabel.translatesAutoresizingMaskIntoConstraints = true
            tableView.backgroundView = noReceiptsLabel
            tableView.separatorStyle = .none
            return 0
        } else {
            if searchResults.count > 0 {
                tableView.backgroundView = nil
                return searchResults.count
            } else if searchResults.count == 0 && !receipts.searchTextField.text!.isEmpty {
                let noReceiptsLabel = AvenirBig()
                noReceiptsLabel.text = "\"\(searchText!)\"" + noResults
                noReceiptsLabel.textAlignment = .center
                noReceiptsLabel.translatesAutoresizingMaskIntoConstraints = true
                tableView.backgroundView = noReceiptsLabel
                tableView.separatorStyle = .none
                return 0
            } else {
                tableView.backgroundView = nil
                return tempList.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: receiptCellId, for: indexPath) as! ReceiptsTableViewCell
        if searchResults.count > 0 {
            tableView.separatorStyle = .singleLine
            cell.receipt = searchResults[indexPath.row]
        } else {
            tableView.separatorStyle = .singleLine
            cell.receipt = tempList[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tempList.count == 0 {
            return
        } else {
            if searchResults.count > 0 {
                delegate?.rowTapped(receipt: searchResults[indexPath.row])
            } else if searchResults.count == 0 && !receipts.searchTextField.text!.isEmpty {
                return
            } else {
                delegate?.rowTapped(receipt: tempList[indexPath.row])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeItemDialog(title: "\(receiptsData.receiptsList[indexPath.row].title)", message: "Are you sure you want to remove receipt?", tableView: tableView, indexPath: indexPath)
        }
    }
}


// MARK: --- UIFONT

extension UIFont {
    var bold: UIFont {
        return with(traits: .traitBold)
    }
    
    var italic: UIFont {
        return with(traits: .traitItalic)
    }
    
    var boldItalic: UIFont {
        return with(traits: [.traitBold, .traitItalic])
    }
    
    func with(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}
