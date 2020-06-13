//
//  GenresLabel.swift
//  RXSwiftMoviesApp
//
//  Created by Роман Важник on 10.06.2020.
//  Copyright © 2020 Роман Важник. All rights reserved.
//

import UIKit

class GenresLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 7
    @IBInspectable var bottomInset: CGFloat = 7
    @IBInspectable var leftInset: CGFloat = 21
    @IBInspectable var rightInset: CGFloat = 21
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBorder()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
    
    private func setBorder() {
        layer.borderWidth = 1
        layer.cornerRadius = 15
        layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
    }
}
