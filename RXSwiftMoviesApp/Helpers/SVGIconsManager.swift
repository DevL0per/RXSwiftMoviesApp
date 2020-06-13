//
//  SVGIconsManager.swift
//  RXSwiftMoviesApp
//
//  Created by Роман Важник on 12.06.2020.
//  Copyright © 2020 Роман Важник. All rights reserved.
//

import UIKit
import PocketSVG

class SVGIconsManager {
    
    static let shared = SVGIconsManager()
    
    func getSVGImageInUIImage(forResourceName name: String, size: CGSize) -> UIImage {
        let layer = createSVGLayer(forResourceName: name, size: size)
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return image
    }
    
    private func createSVGLayer(forResourceName name: String, size: CGSize) -> CALayer {
        let url = Bundle.main.url(forResource: name , withExtension: "svg")!
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let svgLayer = SVGLayer(contentsOf: url)
        svgLayer.frame = frame
        return svgLayer
    }
}
