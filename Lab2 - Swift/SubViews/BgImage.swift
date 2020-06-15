//
//  BgImageView.swift
//  Lab2 - Swift
//
//  Created by Jimmie Määttä on 2019-04-25.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit

class BgImage: UIImageView {
    
    
    // MARK: --- PROPERTIES
    
    let bgImages:[String] = [
        "bg_forest001",
        "bg_forest002",
        "bg_mountain001",
        "bg_mountain002",
        "bg_road001",
        "bg_shore002"
    ]
    
    let bgImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    
    // MARK: --- HANDLERS
    
    func startTimer() {
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(setRandomBgImage), userInfo: nil, repeats: true)
    }
    
    @objc func setRandomBgImage() {
        let newImage = UIImage(named: bgImages.randomElement()!)
        UIView.transition(with: self,
                          duration: 3,
                          options: .transitionCrossDissolve,
                          animations: { self.image = newImage },
                          completion: nil)
    }
    
    
    // MARK: --- INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .scaleAspectFill
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        setRandomBgImage()
        startTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
