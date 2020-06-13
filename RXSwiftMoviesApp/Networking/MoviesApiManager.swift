//
//  MoviesApiManager.swift
//  RXSwiftMoviesApp
//
//  Created by Роман Важник on 11.06.2020.
//  Copyright © 2020 Роман Важник. All rights reserved.
//

import Foundation

enum ParsedData<T: Decodable> {
    case Success(T)
    case Fail(Error)
}

protocol MoviesApiManagerProtocol {
    func getDataFromApiWithCurrentURL<T: Decodable>(url: URL?, objectType: T.Type, complition: @escaping((ParsedData<T>)->Void))
}

final class MoviesApiManager: MoviesApiManagerProtocol {
    
    static let domain = "RxSwiftMovies.com"
    
    private var urlSession: URLSession = URLSession(configuration: .default)
    
    private func getJsonData(url: URL, complition: @escaping(Data?, URLResponse?, Error?)->Void) {
        urlSession.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                let userInfo = [
                    NSLocalizedDescriptionKey :
                    NSLocalizedString("fail",
                                      value: "Fail loading data",
                                      comment: "")
                ]
                let error = NSError(domain: MoviesApiManager.domain, code: 202, userInfo: userInfo)
                complition(nil, nil, error)
                return
            }
            guard let data = data else {
                complition(nil, nil, error)
                return
            }
            complition(data, response, nil)
        }.resume()
    }
    
    func getDataFromApiWithCurrentURL<T: Decodable>(url: URL?, objectType: T.Type, complition: @escaping((ParsedData<T>)->Void)) {
        guard let url = url else { return }
        getJsonData(url: url) { (data, response, error) in
            if let error = error {
                complition(.Fail(error))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(objectType.self, from: data!)
                complition(.Success(result))
            } catch {
                print(error)
                let userInfo = [
                    NSLocalizedDescriptionKey : NSLocalizedString("fail", value: "There are some mistakes with data",
                                                                  comment: "")
                ]
                let error = NSError(domain: MoviesApiManager.domain, code: 202, userInfo: userInfo)
                complition(.Fail(error))
            }
        }
    }

    
    
}
