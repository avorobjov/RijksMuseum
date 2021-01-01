//
//  MockSession.swift
//  RijksMuseumTests
//
//  Created by Alexander Vorobjov on 1/1/21.
//

import Foundation
@testable import RijksMuseum

class MockSession: Session {
    var closure: (SessionCompletion<Data>) -> Void

    init(closure: @escaping (SessionCompletion<Data>) -> Void) {
        self.closure = closure
    }

    convenience init(json: String) throws {
        let url = Bundle(for: Self.self).url(forResource: json, withExtension: "json")
        let data = try Data(contentsOf: url!)

        self.init() { completion in
            completion(.success(data))
        }
    }

    func fetch(_ api: API, completion: @escaping SessionCompletion<Data>) {
        closure(completion)
    }
}
