//
//  UserDataStore.swift
//  DataLayer
//
//  Created by Daisuke Kubota on 2019/12/17.
//  Copyright © 2019 Daisuke Kubota. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

public protocol UserDataStore {
    func loadUsers() -> Single<[UserEntity]>
    func loadUser(id: String) -> Single<UserEntity?>
    func addUser(username: String) -> Single<UserEntity>
    func saveUser(user: UserEntity) -> Single<Void>
    func removeUser(id: String) -> Single<Void>
}

private var users = [String: UserEntity]()

public struct UserMemoryDataStore: UserDataStore {
    public init() {
    }

    public func loadUsers() -> Single<[UserEntity]> {
        return Single.create { observer -> Disposable in
            observer(.success(users.values.map { $0 }))
            return Disposables.create()
        }
    }
    public func loadUser(id: String) -> Single<UserEntity?> {
        return Single.create { observer -> Disposable in
            observer(.success(users[id]))
            return Disposables.create()
        }
    }

    public func addUser(username: String) -> Single<UserEntity> {
        let user = UserEntity.instance(name: username)
        return saveUser(user: user).map { user }
    }

    public func saveUser(user: UserEntity) -> Single<Void> {
        return Single.create { observer -> Disposable in
            users[user.id] = user
            observer(.success(()))
            return Disposables.create()
        }
    }

    public func removeUser(id: String) -> Single<Void> {
        return Single.create { observer -> Disposable in
            users.removeValue(forKey: id)
            observer(.success(()))
            return Disposables.create()
        }
    }
}

public struct UserRealmDataStore: UserDataStore {
    public init() {
    }

    public func loadUsers() -> Single<[UserEntity]> {
        return Single.create { observer -> Disposable in
            do {
                let realm = try Realm()
                let users: [UserEntity] = realm.objects(RUser.self).map { UserEntity.instance(user: $0) }
                observer(.success(users))
            } catch let error {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }

    public func loadUser(id: String) -> Single<UserEntity?> {
        return Single.create { observer -> Disposable in
            do {
                let realm = try Realm()
                if let user = realm.object(ofType: RUser.self, forPrimaryKey: id) {
                    observer(.success(UserEntity.instance(user: user)))
                } else {
                    observer(.success(nil))
                }
            } catch let error {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }

    public func saveUser(user: UserEntity) -> Single<Void> {
        return Single.create { observer -> Disposable in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(user.realmObject(), update: .modified)
                }
                observer(.success(()))
            } catch let error {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }

    public func addUser(username: String) -> Single<UserEntity> {
        let user = UserEntity.instance(name: username)
        return saveUser(user: user).map { user }
    }

    public func removeUser(id: String) -> Single<Void> {
        return Single.create { observer -> Disposable in
            do {
                let realm = try Realm()
                if let user = realm.object(ofType: RUser.self, forPrimaryKey: id) {
                    try realm.write {
                        realm.delete(user)
                    }
                }
                observer(.success(()))
            } catch let error {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }
}


