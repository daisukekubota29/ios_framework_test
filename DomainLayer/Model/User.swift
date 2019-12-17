//
//  User.swift
//  DomainLayer
//
//  Created by Daisuke Kubota on 2019/12/17.
//  Copyright © 2019 Daisuke Kubota. All rights reserved.
//

import Foundation
import DataLayer

public class User {
    public let id: String
    public let name: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

extension User {
    static func instance(entity: UserEntity) -> User {
        return User(id: entity.id, name: entity.name)
    }

    static func nullableInstall(entity: UserEntity?) -> User? {
        guard let entity = entity else { return nil }
        return instance(entity: entity)
    }
}

extension User {
    func entity() -> UserEntity {
        return UserEntity(id: id, name: name)
    }
}
