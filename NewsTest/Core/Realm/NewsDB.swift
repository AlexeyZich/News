//
//  NewsDB.swift
//  NewsTest
//
//  Created by Алексей Ермолаев on 17.03.2019.
//  Copyright © 2019 Алексей Ермолаев. All rights reserved.
//

import Foundation
import RealmSwift

class NewsDB: Object {
    @objc dynamic var newsImage = ""
    @objc dynamic var newsTitle = ""
    @objc dynamic var newsDescription = ""
    @objc dynamic var newsUrl = ""
    @objc dynamic var newsPublishedDate = ""
    @objc dynamic var newsPublishedTime = ""
}
