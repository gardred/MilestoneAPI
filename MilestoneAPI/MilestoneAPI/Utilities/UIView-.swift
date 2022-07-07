//
//  UIView-.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 07.07.2022.
//

import UIKit

extension UIView {
    
    // Calculate view size
        public func sizeToFit(inViewWidth width: CGFloat) -> CGSize {
            setNeedsDisplay()
            layoutIfNeeded()
            
            let fitSize = systemLayoutSizeFitting(CGSize(width: width, height: 0))
            return CGSize(width: width, height: fitSize.height)
        }
        
        // Calculate view size
        public func sizeToFit(inViewHeight height: CGFloat) -> CGSize {
            setNeedsDisplay()
            layoutIfNeeded()
            
            let fitSize = systemLayoutSizeFitting(CGSize(width: 0, height: height))
            return CGSize(width: fitSize.width, height: height)
        }
}
