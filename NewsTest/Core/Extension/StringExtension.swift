//
//  StringExtension.swift
//  NewsTest
//
//  Created by Алексей Ермолаев on 19.03.2019.
//  Copyright © 2019 Алексей Ермолаев. All rights reserved.
//

import Foundation

extension String {
    func convertDatePublishedToDate(publishedAt: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:publishedAt)!
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    
    func convertDatePublishedToTime(publishedAt: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:publishedAt)!
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from: date)
    }
}
