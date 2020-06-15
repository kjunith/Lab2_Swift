//
//  OverviewViewController.swift
//  Lab2 - Swift
//
//  Created by Jimmie Määttä on 2019-04-26.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    // MARK: --- PROPERTIES
    
    let receiptsData = ReceiptsData.handler
    var currentIncomes:[Receipt] = []
    var currentExpenses:[Receipt] = []
    var overview = Overview()
    
    var cellId = "BarCell"
    
    let dateFormatter = DateFormatter()
    
    
    // MARK: --- INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        overview = Overview(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        view.addSubview(overview)
        NSLayoutConstraint.activate([
            overview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            overview.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            overview.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
            ])
        
        setupCollectionView()
        setupGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        receiptsData.calculateSums()
        overview.updateLabels(date: receiptsData.selectedMonth!)
        overview.collView.reloadData()
    }
    
    
    // MARK: HANDLERS
    
    func setupGestureRecognizers() {
        let nextGesture = UITapGestureRecognizer(target: self, action: #selector(handleNext))
        overview.nextLabel.addGestureRecognizer(nextGesture)
        
        let prevGesture = UITapGestureRecognizer(target: self, action: #selector(handlePrev))
        overview.prevLabel.addGestureRecognizer(prevGesture)
    }
    
    @objc func handleNext() {
        overview.updateLabels(date: receiptsData.nextMonth())
        overview.collView.reloadData()
    }
    
    @objc func handlePrev() {
        overview.updateLabels(date: receiptsData.prevMonth())
        overview.collView.reloadData()
    }
    
    func setupCollectionView() {
        overview.collView.delegate = self
        overview.collView.dataSource = self
        
        overview.layout.itemSize = CGSize(width: (overview.collView.frame.width / CGFloat(numberOfDaysInMonth())), height: overview.collView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDaysInMonth()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BarCollectionViewCell
        
        dateFormatter.locale = Locale(identifier: "en_US")
        refreshLists()
        
        var curString: String = ""
        var totalIncomes: Double = 0
        var totalExpenses: Double = 0
        
        dateFormatter.dateFormat = "MMM yyyy"
        let monthYear: String = dateFormatter.string(from: receiptsData.selectedMonth!)
        dateFormatter.dateFormat = "d MMM yyyy"
        curString = "\(indexPath.row + 1) \(monthYear)"
        cell.dayLabel.text = String(indexPath.row + 1)
        
        for income in currentIncomes {
            dateFormatter.dateFormat = "dd MMM yyyy"
            let dueString = dateFormatter.string(from: income.due)
            let dueDate: Date = dateFormatter.date(from: dueString)!
            let curDate: Date = dateFormatter.date(from: curString)!
            if dueDate.compare(curDate) == .orderedSame {
                totalIncomes += income.sum
            }
        }
        
        for expense in currentExpenses {
            dateFormatter.dateFormat = "dd MMM yyyy"
            let due = dateFormatter.string(from: expense.due)
            let dueDate: Date = dateFormatter.date(from: due)!
            let curDate: Date = dateFormatter.date(from: curString)!
            if dueDate.compare(curDate) == .orderedSame {
                totalExpenses += (expense.sum * -1)
            }
        }
        
        if totalIncomes != 0 {
            cell.incomeHeight?.constant = (CGFloat(totalIncomes) / 10) + 10
        } else {
            cell.incomeHeight?.constant = CGFloat(10)
        }
        
        if totalExpenses != 0 {
            cell.expenseHeight?.constant = (CGFloat(totalExpenses) / 10) + 10
        } else {
            cell.expenseHeight?.constant = CGFloat(10)
        }
        
        UIView.animate(withDuration: 0.66) {
            cell.layoutIfNeeded()
        }
        
        return cell
    }
    
    func numberOfDaysInMonth() -> Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: receiptsData.selectedMonth!)!
        return range.count
    }
    
    func refreshLists() {
        currentIncomes = receiptsData.receiptsList.filter ({ $0.sum > 0 })
        currentExpenses = receiptsData.receiptsList.filter ({ $0.sum < 0 })
    }
}
