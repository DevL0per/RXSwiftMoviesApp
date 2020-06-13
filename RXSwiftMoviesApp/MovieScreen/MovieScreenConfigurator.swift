//
//  MovieScreenConfigurator.swift
//  RXSwiftMoviesApp
//
//  Created by Роман Важник on 11.06.2020.
//  Copyright © 2020 Роман Важник. All rights reserved.
//

import Foundation

protocol MovieScreenConfiguratorProtocol: class {
    func configure(view: MoviesViewController)
}

class MovieScreenConfigurator: MovieScreenConfiguratorProtocol {
    func configure(view: MoviesViewController) {
        let viewModel = MoviesViewModel(viewController: view)
        view.viewModel = viewModel
    }
}
