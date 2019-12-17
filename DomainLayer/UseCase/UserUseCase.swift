//
//  UserUseCase.swift
//  DomainLayer
//
//  Created by Daisuke Kubota on 2019/12/17.
//  Copyright © 2019 Daisuke Kubota. All rights reserved.
//

import Foundation
import DataLayer
import RxSwift
import RxCocoa

public protocol UserUseCase {
    func loadUsers() -> Single<[User]>
    func loadUser(id: String) -> Single<User?>
    func saveUser(user: User) -> Single<Void>
    func addUser(username: String) -> Single<User>
    func removeUser(id: String) -> Single<Void>
}

public class UserUseCaseImpl: UserUseCase {

    private let userRepository: UserRepository

    public init(userRepository: UserRepository = UserRepositoryImpl()) {
        self.userRepository = userRepository
    }

    public func loadUsers() -> Single<[User]> {
        return self.userRepository
            .loadUsers()
            .map { $0.map { User.instance(entity: $0) } }
    }

    public func loadUser(id: String) -> Single<User?> {
        return self.userRepository
            .loadUser(id: id)
            .map { User.nullableInstall(entity: $0) }
    }

    public func saveUser(user: User) -> Single<Void> {
        return self.userRepository.saveUser(user: user.entity())
    }

    public func addUser(username: String) -> Single<User> {
        return self.userRepository
            .addUser(username: username)
            .map { User.instance(entity: $0) }
    }

    public func removeUser(id: String) -> Single<Void> {
        return self.userRepository.removeUser(id: id)
    }
}
