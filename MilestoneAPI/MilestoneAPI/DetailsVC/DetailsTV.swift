//
//  DetailsTV.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 11.07.2022.
//

import UIKit

class DetailsTV: UITableView {

    @IBOutlet weak var height: NSLayoutConstraint!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let header = tableHeaderView else { return }
        let offsetY = -contentOffset.y
        height.constant = max(header.bounds.height, header.bounds.height +  offsetY)
//        height.constant = min(header.bounds.height, header.bounds.height + offsetY)
        
    }
}
//func scrollViewDidScroll(_ scrollView: UIScrollView) {
//      var offset = min(scrollView.contentOffset.y, 0)
//      if offset > -scrollView.safeAreaInsets.top {
//          offset = -scrollView.safeAreaInsets.top
//      }
//      contentViewTopConstraint.constant = offset
//  }
