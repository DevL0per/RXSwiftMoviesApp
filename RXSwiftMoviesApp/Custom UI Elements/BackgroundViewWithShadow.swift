//
//  ImageViewWithShadow.swift
//  RXSwiftMoviesApp
//
//  Created by Роман Важник on 10.06.2020.
//  Copyright © 2020 Роман Важник. All rights reserved.
//

import UIKit

class BackgroundViewWithShadow: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 13)
        layer.shadowRadius = 12
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        let roundedRect = CGRect(x: bounds.origin.x+20,
                                 y: bounds.origin.y,
                                 width: bounds.width-40,
                                 height: bounds.height)
        layer.shadowPath = UIBezierPath(roundedRect: roundedRect,
                                        cornerRadius: self.layer.cornerRadius).cgPath
    }
}
