//
//  TitleSettable.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import UIKit

protocol TitleSettable {
    func set(title: String)
}

extension TitleSettable where Self: UIViewController {
    func set(title: String) {
        navigationItem.title = title
    }
}
