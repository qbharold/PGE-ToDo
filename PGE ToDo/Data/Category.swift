//
//  Category.swift
//  PGE ToDo
//
//  Created by Harold Peterson on 11/3/18.
//  Copyright © 2018 Harold Peterson, Jr. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
