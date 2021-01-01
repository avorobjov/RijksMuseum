//
//  MockSession.swift
//  RijksMuseumTests
//
//  Created by Alexander Vorobjov on 1/1/21.
//

import Foundation
@testable import RijksMuseum

struct MockSession: Session {
    var closure: (SessionCompletion<Data>) -> Void

    init(closure: @escaping (SessionCompletion<Data>) -> Void) {
        self.closure = closure
    }

    func fetch(_ api: API, completion: @escaping SessionCompletion<Data>) {
        closure(completion)
    }
}
