//
//  Extension+UIIMageView.swift
//  RXSwiftMoviesApp
//
//  Created by Роман Важник on 10.06.2020.
//  Copyright © 2020 Роман Важник. All rights reserved.
//

import UIKit
import PocketSVG

extension UIImageView {
    
    func downloadImage(from path: String?, imageSize: ImageURLSize) {
        let urlManager = URLManager()
        guard
            let path = path,
            let imageUrl = urlManager.getImageURL(path: path, size: imageSize)
            else { return }
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }

}
