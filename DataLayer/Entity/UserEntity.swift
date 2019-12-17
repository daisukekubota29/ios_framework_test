//
//  UserEntity.swift
//  DataLayer
//
//  Created by Daisuke Kubota on 2019/12/17.
//  Copyright © 2019 Daisuke Kubota. All rights reserved.
//

import Foundation

public class UserEntity {
    public let id: String
    public let name: String

    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

extension UserEntity {
    func realmObject() -> RUser {
        return RUser(value: ["id": id, "name": name])
    }

    static func instance(user: RUser) -> UserEntity {
        return UserEntity(id: user.id, name: user.name)
    }
}

extension UserEntity {
    static func instance(name: String) -> UserEntity {
        return UserEntity(id: "\(Int(Date().timeIntervalSince1970))", name: name)
    }
}
