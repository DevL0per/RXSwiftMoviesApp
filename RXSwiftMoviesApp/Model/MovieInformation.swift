//
//  MovieInformation.swift
//  RXSwiftMoviesApp
//
//  Created by Роман Важник on 09.06.2020.
//  Copyright © 2020 Роман Важник. All rights reserved.
//

import Foundation

struct MovieInformation: Decodable {
    let popularity: Double?
    let voteCount: Int?
    let releaseDate: String?
    let genres: [Genre]?
    let runtime: Int?
    let overview: String?
    let status: String?
}
