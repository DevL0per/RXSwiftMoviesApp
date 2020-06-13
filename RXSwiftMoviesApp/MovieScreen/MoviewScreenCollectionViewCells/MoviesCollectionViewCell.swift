//
//  MovieCollectionViewCell.swift
//  RXSwiftMoviesApp
//
//  Created by Роман Важник on 10.06.2020.
//  Copyright © 2020 Роман Важник. All rights reserved.
//

import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {
    
    private let backgroundViewForImageViewWithShadow: BackgroundViewWithShadow = {
        let view = BackgroundViewWithShadow()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ford v Ferrari"
        label.textAlignment = .center
        label.font = UIFont(name: "Proxima Nova", size: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let voteStackView = UIStackView()
    private let voteIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = SVGIconsManager.shared.getSVGImageInUIImage(forResourceName: "star",
                                                                      size: CGSize(width: 15, height: 15))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let voteLabel: UILabel = {
        let label = UILabel()
        label.text = "8.2"
        label.font = UIFont(name: "ProximaNova-Medium", size: 16)
        return label
    }()

    
    override func prepareForReuse() {
        posterImageView.image = nil
        titleLabel.text = nil
        voteLabel.text = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutScoreLabel()
        layoutTitleLabel()
        layoutPosterImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCellWith(movie: Movie) {
        posterImageView.downloadImage(from: movie.posterPath, imageSize: .big)
        titleLabel.text = movie.title
        if let voteAverage = movie.voteAverage {
            voteLabel.text = String(voteAverage)
        }
    }
    
    private func layoutPosterImageView() {
        addSubview(backgroundViewForImageViewWithShadow)
        backgroundViewForImageViewWithShadow.addSubview(posterImageView)
        backgroundViewForImageViewWithShadow.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundViewForImageViewWithShadow.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/1.5).isActive = true
        backgroundViewForImageViewWithShadow.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -20).isActive = true
        backgroundViewForImageViewWithShadow.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        posterImageView.topAnchor.constraint(equalTo: backgroundViewForImageViewWithShadow.topAnchor).isActive = true
        posterImageView.leadingAnchor.constraint(equalTo: backgroundViewForImageViewWithShadow.leadingAnchor).isActive = true
        posterImageView.trailingAnchor.constraint(equalTo: backgroundViewForImageViewWithShadow.trailingAnchor).isActive = true
        posterImageView.bottomAnchor.constraint(equalTo: backgroundViewForImageViewWithShadow.bottomAnchor).isActive = true
        
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.bottomAnchor.constraint(equalTo: voteStackView.topAnchor, constant: -8 ).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
    }
    
    private func layoutScoreLabel() {
        voteStackView.translatesAutoresizingMaskIntoConstraints = false
        voteStackView.axis = .horizontal
        voteStackView.distribution  = .equalSpacing
        voteStackView.alignment = .center
        voteStackView.spacing = 5
        addSubview(voteStackView)
        
        voteStackView.addArrangedSubview(voteIcon)
        voteStackView.addArrangedSubview(voteLabel)
        
        voteStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        voteStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
