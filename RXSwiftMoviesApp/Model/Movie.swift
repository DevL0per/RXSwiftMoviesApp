//
//  Movie.swift
//  RXSwiftMoviesApp
//
//  Created by Роман Важник on 09.06.2020.
//  Copyright © 2020 Роман Важник. All rights reserved.
//

import Foundation

struct MovieData: Decodable {
    let results: [Movie]
}

struct Movie: Decodable {
    let title: String?
    let posterPath: String?
    let voteAverage: Double?
}
