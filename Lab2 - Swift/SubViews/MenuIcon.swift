//
//  MenuIcon.swift
//  Lab2 - Swift
//
//  Created by Jimmie Määttä on 2019-04-28.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit

class MenuIcon: UIImageView {
    
    
    // MARK: --- INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        contentMode = .scaleAspectFill
        clipsToBounds = true
        image = UIImage(named: "ic_menu")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
