//
//  GenresCollectionView.swift
//  RXSwiftMoviesApp
//
//  Created by Роман Важник on 10.06.2020.
//  Copyright © 2020 Роман Важник. All rights reserved.
//

import UIKit

class HorizontalCollectionView: UICollectionView {
    
    init(spacingBetweenElements: CGFloat) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacingBetweenElements
        layout.minimumInteritemSpacing = spacingBetweenElements
        layout.sectionInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
