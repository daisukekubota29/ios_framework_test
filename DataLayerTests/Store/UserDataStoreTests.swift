//
//  UserDataStoreTests.swift
//  DataLayerTests
//
//  Created by Daisuke Kubota on 2019/12/17.
//  Copyright © 2019 Daisuke Kubota. All rights reserved.
//
@testable import DataLayer

import XCTest
import RxSwift
import RealmSwift
import RxBlocking

class UserDataStoreTests: XCTestCase {

    override func setUp() {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(inMemoryIdentifier: "memories")
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }

    override func tearDown() {
    }

    func testLoadUsers() {
        let realm = try! Realm()
        let userCount = 10
        try! realm.write {
            (1...userCount).forEach {
                realm.add(RUser(value: ["id": "\($0)", "name": "user\($0)"]))
            }
        }
        let store = UserRealmDataStore()
        let users = try? store.loadUsers().toBlocking().single()
        XCTAssertEqual(users?.count, userCount)
    }

    func testLoadUserNotExists() {
        let id = "1234"
        let user = try? UserRealmDataStore().loadUser(id: id).toBlocking().single()
        XCTAssertNil(user)
    }

    func testLoadUserExists() {
        let id = "test_load_user_exists_user_id_1"
        let realm = try! Realm()
        try! realm.write {
            realm.add(RUser(value: ["id": id, "name": "username"]))
        }

        let user = try? UserRealmDataStore().loadUser(id: id).toBlocking().single()
        XCTAssertNotNil(user)
        XCTAssertEqual(user?.id, id)
    }

    func testSaveUser() {
        let id = "test_save_user_user_id_1"
        let user = UserEntity(id: id, name: "user1")
        try! UserRealmDataStore().saveUser(user: user).toBlocking().single()
        let realm = try! Realm()
        let count = realm.objects(RUser.self).count
        XCTAssertEqual(count, 1)
    }

    func testSaveUserOverride() {
        let id = "test_save_user_override_user_id_1"
        let username = "user1"
        let realm = try! Realm()
        try! realm.write {
            realm.add(RUser(value: ["id": id, "name": "\(username)_old"]))
        }
        let user = UserEntity(id: id, name: username)
        try! UserRealmDataStore().saveUser(user: user).toBlocking().single()

        let result = realm.object(ofType: RUser.self, forPrimaryKey: id)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.name, username)
    }

    func testAddUser() {
        let username = "test_add_user_name_1"
        let user = try! UserRealmDataStore().addUser(username: username).toBlocking().single()
        let realm = try! Realm()
        let result = realm.object(ofType: RUser.self, forPrimaryKey: user.id)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.name, username)
        XCTAssertEqual(user.name, username)
    }

    func testRemoveUserNotExists() {
        let id = "test_remove_user_not_exists_user_id_1"
        do {
            try UserRealmDataStore().removeUser(id: id).toBlocking().single()
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }

    func testRemoveUserExists() {
        let id = "test_remove_user_exists_user_id_1"
        let realm = try! Realm()
        try! realm.write {
            realm.add(RUser(value: ["id": id, "name": "user1"]))
        }

        try! UserRealmDataStore().removeUser(id: id).toBlocking().single()
        XCTAssertEqual(realm.objects(RUser.self).count, 0)
    }
}
