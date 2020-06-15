//
//  Scanner.swift
//  Lab2 - Swift
//
//  Created by Jimmie Määttä on 2019-04-30.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit
import YCBarcodeReader

class Scanner: UIView {

    
    // MARK: --- PROPERTIES
    
    let scannerView: YCBarcodeReaderView = {
        let view = YCBarcodeReaderView()
        view.showTorchButton = true
        view.torchButtonPosition = .topRight
        view.torchButtonInsets = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 16)
        view.landscapeOrientation = true
        view.focusViewShowed = true
        view.focusViewBorderColor = UIColor(named: "YieldingYellow")!
        view.focusViewLineWidth = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cancelLabel: UILabel = {
        let label = AvenirMedium()
        label.textAlignment = .center
        label.textColor = UIColor(named: "RegretRed")
        label.font = label.font.bold
        label.isUserInteractionEnabled = true
        label.text = "Cancel".uppercased()
        return label
    }()
    
    
    // MARK: --- INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(scannerView)
        addSubview(cancelLabel)
        
        NSLayoutConstraint.activate([
            cancelLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -64),
            cancelLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
            ])
        
        NSLayoutConstraint.activate([
            scannerView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            scannerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            scannerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            scannerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
