//
//  FilmsViewModel.swift
//  RXSwiftMoviesApp
//
//  Created by Роман Важник on 09.06.2020.
//  Copyright © 2020 Роман Важник. All rights reserved.
//

import RxSwift
import RxCocoa

protocol MoviesViewModelProtocol: class {
    init(viewController: MoviesViewController)
    
    var movies: BehaviorRelay<[Movie]> { get }
    var searchedResults: BehaviorRelay<[Movie]> { get }
    var genres: BehaviorRelay<[Genre]> { get }
    var cateries: Observable<[String]> { get }
    
    func changeFilmsCategory(category: String)
    func changeFilmsGenre(genre: Genre)
    func changePageAndGetNewMovies()
    func searchFilmBy(name: String)
}

class MoviesViewModel: MoviesViewModelProtocol {
    
    var movies = BehaviorRelay<[Movie]>(value: [])
    var genres = BehaviorRelay<[Genre]>(value: [])
    var searchedResults = BehaviorRelay<[Movie]>(value: [])
    
    lazy var cateries: Observable<[String]> = Observable.from(optional: categoriesData)
        
    private var categoriesData = ["Popular", "Top Rated", "Upcoming"]
    private let moviesApiManager = MoviesApiManager()
    private var urlManager = URLManager()
    private var currentPage = 1
    private var currentGenre: Genre?
    private var currentCategory: String!
    
    private var moviesURL: URL?
    private var genresURL: URL?
    
    required init(viewController: MoviesViewController) {
        currentCategory = prepareCategoryToApi(str: categoriesData[0].lowercased())
        moviesURL = urlManager.getMovieURL(category: currentCategory, page: currentPage)
        genresURL = urlManager.getGenresURL()
        getFilms()
        getGenres()
    }
    
    func changeFilmsCategory(category: String) {
        currentPage = 1
        currentCategory = prepareCategoryToApi(str: category)
        moviesURL = urlManager.getMovieURL(category: currentCategory, page: currentPage,
                                           genreId: currentGenre?.id)
        getFilms()
    }
    
    func changeFilmsGenre(genre: Genre) {
        currentPage = 1
        currentGenre = genre
        moviesURL = urlManager.getMovieURL(category: currentCategory, page: currentPage,
                               genreId: currentGenre?.id)
        getFilms()
    }
    
    func searchFilmBy(name: String) {
        if name != "" {
            let url = urlManager.searchFilmByNameURL(name: name)
            moviesApiManager.getDataFromApiWithCurrentURL(url: url, objectType: MovieData.self) { (data) in
                switch data {
                case .Success(let result):
                    self.searchedResults.accept(result.results)
                case .Fail(let error): break
                }
            }
        } else {
            searchedResults.accept([])
        }
    }
    
    func changePageAndGetNewMovies() {
        currentPage+=1
        moviesURL = urlManager.getMovieURL(category: currentCategory, page: currentPage,
                                           genreId: currentGenre?.id)
        moviesApiManager.getDataFromApiWithCurrentURL(url: moviesURL, objectType: MovieData.self) { [unowned self] (data) in
            switch data {
            case .Success(let movieData):
                self.movies.accept(self.movies.value+movieData.results)
            case .Fail(let error): break
            }
        }
    }
    
    private func getGenres() {
        moviesApiManager.getDataFromApiWithCurrentURL(url: genresURL, objectType: GenreData.self) { (genres) in
            switch genres {
            case .Success(let genres):
                self.genres.accept(genres.genres)
            case .Fail(let error): break
            }
        }
    }
    
    private func getFilms() {
        moviesApiManager.getDataFromApiWithCurrentURL(url: moviesURL, objectType: MovieData.self) { (data) in
            switch data {
            case .Success(let movieData):
                self.movies.accept(movieData.results)
            case .Fail(let error): break
            }
        }
    }
    
    private func prepareCategoryToApi(str: String) -> String {
        return str.components(separatedBy: " ")
        .filter { !$0.isEmpty }
        .joined(separator: "_")
        .lowercased()
    }
}
