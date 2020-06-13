//
//  GenresCollectionViewCell.swift
//  RXSwiftMoviesApp
//
//  Created by Роман Важник on 10.06.2020.
//  Copyright © 2020 Роман Важник. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let disabledBorderColor = UIColor.black.withAlphaComponent(0.4).cgColor
    static let selectedBorderColor = UIColor.black.cgColor
}

class GenresCollectionViewCell: UICollectionViewCell {
    
    private let genreLabel: GenresLabel = {
        let label = GenresLabel()
        label.font = UIFont(name: "ProximaNova-Medium", size: 18)
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                genreLabel.layer.borderColor = Constants.selectedBorderColor
            } else {
               genreLabel.layer.borderColor = Constants.disabledBorderColor
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                genreLabel.layer.borderColor = Constants.selectedBorderColor
            } else {
                genreLabel.layer.borderColor = Constants.disabledBorderColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutGenreLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCellWith(genreName: String) {
        genreLabel.text = genreName
    }
    
    private func layoutGenreLabel() {
        addSubview(genreLabel)
        genreLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        genreLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        genreLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        genreLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
