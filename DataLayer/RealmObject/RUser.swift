//
//  RUser.swift
//  DataLayer
//
//  Created by Daisuke Kubota on 2019/12/17.
//  Copyright © 2019 Daisuke Kubota. All rights reserved.
//

import Foundation
import RealmSwift

class RUser: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}
