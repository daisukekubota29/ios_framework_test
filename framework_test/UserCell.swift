//
//  UserCell.swift
//  framework_test
//
//  Created by Daisuke Kubota on 2019/12/17.
//  Copyright © 2019 Daisuke Kubota. All rights reserved.
//

import UIKit
import DomainLayer

class UserCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!

    func bind(user: User) {
        self.label.text = "\(user.id): \(user.name)"
    }
}
