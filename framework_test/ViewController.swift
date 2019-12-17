//
//  ViewController.swift
//  framework_test
//
//  Created by Daisuke Kubota on 2019/12/17.
//  Copyright © 2019 Daisuke Kubota. All rights reserved.
//

import UIKit
import DomainLayer
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    private let disposeBag = DisposeBag()

    private var users = [User]()

    private let userUseCase = UserUseCaseImpl()

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    @IBOutlet weak var userNameInput: UITextField! {
        didSet {
            userNameInput.rx
                .text
                .bind { [weak self] text in
                    self?.addButton.isEnabled = text?.count ?? 0 > 0
                }
                .disposed(by: disposeBag)
        }
    }

    @IBOutlet weak var addButton: UIButton! {
        didSet {
            addButton.rx
                .tap
                .bind { [weak self] in
                    if let username = self?.userNameInput.text {
                        self?.addUser(username: username)
                    }
                    self?.addButton.isEnabled = false
                    self?.userNameInput.text = ""
                }
                .disposed(by: disposeBag)
        }
    }
}

// MARK: - lifecycle
extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUsers()
    }
}

extension ViewController {
    private func addUser(username: String) {
        userUseCase.addUser(username: username)
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] user in
                self?.users.append(user)
                self?.tableView.reloadData()
            }, onError: { error in
                debugPrint(error)
            })
            .disposed(by: disposeBag)
    }

    private func loadUsers() {
        userUseCase.loadUsers()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] users in
                self?.users.removeAll()
                self?.users.append(contentsOf: users)
                self?.tableView.reloadData()
            }, onError: { error in
                debugPrint(error)
            })
            .disposed(by: disposeBag)
    }

    private func removeUser(id: String) {
        userUseCase.removeUser(id: id)
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] in
                self?.removeLocalUser(id: id)
            }, onError: { error in
                debugPrint(error)
            })
            .disposed(by: disposeBag)
    }

    private func removeLocalUser(id: String) {
        debugPrint("id: \(id)")
        guard let index = users.firstIndex(where: { $0.id == id }) else {
            return
        }
        debugPrint("index: \(index)")
        users.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        cell.bind(user: users[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "削除しますか？", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "はい", style: .default, handler: { _ in
            let user = self.users[indexPath.row]
            self.removeUser(id: user.id)
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
