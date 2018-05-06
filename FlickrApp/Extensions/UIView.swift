//
//  UIView.swift
//  FlickrApp
//
//  Created by David Vallas on 5/6/18.
//  Copyright © 2018 David Vallas. All rights reserved.
//

import UIKit

extension UIView {

    func shadowAndCorner() {
        self.layer.cornerRadius = 20.0
        self.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        self.layer.shadowRadius = 10.0
        self.layer.shadowOpacity = 0.8
    }
    
}
