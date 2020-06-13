//
//  SearchedResultsTableViewCell.swift
//  RXSwiftMoviesApp
//
//  Created by Роман Важник on 13.06.2020.
//  Copyright © 2020 Роман Важник. All rights reserved.
//

import UIKit

class SearchedResultsTableViewCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ProximaNova-Medium", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func prepareForReuse() {
        titleLabel.text = ""
        posterImageView.image = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCellWith(result: Movie) {
        titleLabel.text = result.title
        posterImageView.downloadImage(from: result.posterPath, imageSize: .small)
    }
    
    private func layoutElements() {
        addSubview(posterImageView)
        posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        posterImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        posterImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 5).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
