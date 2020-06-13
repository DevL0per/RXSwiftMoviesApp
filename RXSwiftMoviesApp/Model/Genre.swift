//
//  Genre.swift
//  RXSwiftMoviesApp
//
//  Created by Роман Важник on 09.06.2020.
//  Copyright © 2020 Роман Важник. All rights reserved.
//

import Foundation


struct GenreData: Decodable {
    let genres: [Genre]
}

struct Genre: Decodable {
    let id: Int
    let name: String
}
