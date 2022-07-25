//
//  String.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 12.07.2022.
//

import Foundation
import UIKit

extension UIView {
    func convertDateFormatter(date: String) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date)

        dateFormatter.dateFormat = "dd MMM yyyy"
        
        guard let date = date else {
            return "Error"
        }

        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
    }
}
