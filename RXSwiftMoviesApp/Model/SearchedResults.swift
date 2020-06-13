//
//  SearchedResults.swift
//  RXSwiftMoviesApp
//
//  Created by Роман Важник on 12.06.2020.
//  Copyright © 2020 Роман Важник. All rights reserved.
//

import Foundation

struct SearchedResultsData: Decodable {
    let results: [SearchedResults] = []
}

struct SearchedResults: Decodable {
    let id: Int?
    let title: String?
}
