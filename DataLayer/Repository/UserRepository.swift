//
//  UserRepository.swift
//  DataLayer
//
//  Created by Daisuke Kubota on 2019/12/17.
//  Copyright © 2019 Daisuke Kubota. All rights reserved.
//

import Foundation
import RxSwift

public protocol UserRepository {
    func loadUsers() -> Single<[UserEntity]>
    func loadUser(id: String) -> Single<UserEntity?>
    func saveUser(user: UserEntity) -> Single<Void>
    func addUser(username: String) -> Single<UserEntity>
    func removeUser(id: String) -> Single<Void>
}

public struct UserRepositoryImpl: UserRepository {
    let memoryStore: UserDataStore

    public init(memoryStore: UserDataStore = UserRealmDataStore()) {
        self.memoryStore = memoryStore
    }
    public func loadUsers() -> Single<[UserEntity]> {
        return memoryStore.loadUsers()
    }
    public func loadUser(id: String) -> Single<UserEntity?> {
        return memoryStore.loadUser(id: id)
    }
    public func saveUser(user: UserEntity) -> Single<Void> {
        return memoryStore.saveUser(user: user)
    }
    public func addUser(username: String) -> Single<UserEntity> {
        return memoryStore.addUser(username: username)
    }
    public func removeUser(id: String) -> Single<Void> {
        return memoryStore.removeUser(id: id)
    }
}
