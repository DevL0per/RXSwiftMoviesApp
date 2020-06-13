//
//  URLManager.swift
//  RXSwiftMoviesApp
//
//  Created by Роман Важник on 11.06.2020.
//  Copyright © 2020 Роман Важник. All rights reserved.
//

import Foundation

enum ImageURLSize {
    case small
    case big
}

//create URL for request
struct URLManager {
    private let baseURL = URL(string: "https://api.themoviedb.org/3/")
    private let imageBaseURLString = "https://image.tmdb.org/t/p/"
    private let key = "api_key=73f271a6f258ca94177eaa3e83abb714"
    private let language = "&language=en-US"
    
    func getMovieURL(category: String, page: Int, genreId: Int? = nil) -> URL? {
        var path = "movie/" + category+"?"+key+language+"&page="+String(page)
        if genreId != nil {
            path+="&with_genres="+String(genreId!)
        }
        guard let url = URL(string: path, relativeTo: baseURL) else { return nil }
        return url
    }
    
    func searchFilmByNameURL(name: String) -> URL? {
        let path = "search/movie?"+key+language+"&query="+name+"&page=1"
        guard let url = URL(string: path, relativeTo: baseURL) else { return nil }
        return url
    }
    
    func getGenresURL() -> URL? {
        let path = "genre/movie/list?"+key+language
        guard let url = URL(string: path, relativeTo: baseURL) else { return nil }
        return url
    }
    
    func getMovieInDetailsURL(forMovieId id: Int) -> URL? {
        let path = String(id)+"?"+key+language
        guard let url = URL(string: path, relativeTo: baseURL) else { return nil }
        return url
    }
    
    func getImageURL(path: String, size: ImageURLSize) -> URL? {
        var sizePath = ""
        switch size {
        case .small:
            sizePath = "w92"
        case .big:
            sizePath = "w500"
        }
        guard let url = URL(string: imageBaseURLString+sizePath+path) else { return nil }
        return url
    }
}
