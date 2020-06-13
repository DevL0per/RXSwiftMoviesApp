//
//  SearchedTableView.swift
//  RXSwiftMoviesApp
//
//  Created by Роман Важник on 13.06.2020.
//  Copyright © 2020 Роман Важник. All rights reserved.
//

import UIKit

class SearchedResultsTableView: UITableView {
    
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height/2

    override func reloadData() {
      super.reloadData()
      self.invalidateIntrinsicContentSize()
      self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
       setNeedsLayout()
       layoutIfNeeded()
       let height = min(contentSize.height, maxHeight)
       return CGSize(width: contentSize.width, height: height)
    }
}

