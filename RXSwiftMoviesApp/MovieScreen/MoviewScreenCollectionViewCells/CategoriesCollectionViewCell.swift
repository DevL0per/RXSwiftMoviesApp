//
//  CategoriesCollectionViewCell.swift
//  RXSwiftMoviesApp
//
//  Created by Роман Важник on 10.06.2020.
//  Copyright © 2020 Роман Важник. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let disabledCategoryColor = UIColor.black.withAlphaComponent(0.5)
    static let selectedCategoryColor = UIColor.black
    static let bottomSelectedStateViewColor = UIColor(red: 0.966, green: 0.427, blue: 0.557, alpha: 1)
}

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Proxima Nova", size: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.disabledCategoryColor
        return label
    }()
    //Appears when cell is selected
    private let bottomSelectedStateView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.layer.cornerRadius = 3
        view.backgroundColor = Constants.bottomSelectedStateViewColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                categoryLabel.textColor = Constants.selectedCategoryColor
                setAlphaOfBottomViewWithAnimation(alpha: 1)
            } else {
                categoryLabel.textColor = Constants.disabledCategoryColor
                setAlphaOfBottomViewWithAnimation(alpha: 0)
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                categoryLabel.textColor = Constants.selectedCategoryColor
                setAlphaOfBottomViewWithAnimation(alpha: 1)
            } else {
                categoryLabel.textColor = Constants.disabledCategoryColor
                setAlphaOfBottomViewWithAnimation(alpha: 0)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutCategoryLabel()
        layoutBottomSelectedStateView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCellWith(category: String) {
        categoryLabel.text = category
    }
    
    private func setAlphaOfBottomViewWithAnimation(alpha: CGFloat) {
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.bottomSelectedStateView.alpha = alpha
        }
    }
    
    private func layoutCategoryLabel() {
        addSubview(categoryLabel)
        categoryLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func layoutBottomSelectedStateView() {
        addSubview(bottomSelectedStateView)
        bottomSelectedStateView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        bottomSelectedStateView.heightAnchor.constraint(equalToConstant: 6).isActive = true
        bottomSelectedStateView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 6).isActive = true
        bottomSelectedStateView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    }
}
