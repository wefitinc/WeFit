//
//  CircleView.swift
//  WeFit
//
//  Created by Junior Alvarado on 9/17/19.
//  Copyright © 2019 WeFit. All rights reserved.
//

import UIKit

@IBDesignable class CircleView: UIView {
    
    // ...
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (frame.width != frame.height) {
            NSLog("Ended up with a non-square frame -- so it may not be a circle");
        }
        layer.cornerRadius = frame.width / 2
        layer.masksToBounds = true
    }
    
    // ...
}
