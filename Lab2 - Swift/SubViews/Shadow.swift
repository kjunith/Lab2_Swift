//
//  BlackView.swift
//  Lab2 - Swift
//
//  Created by Jimmie Määttä on 2019-04-28.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit

class Shadow: UIView {
    
    
    // MARK: --- INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(named: "NotQuiteBlack")
        alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
