//
//  Session.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 12/31/20.
//

import Alamofire

protocol Session {
    func perform<T: Decodable>(request: SessionRequest, completion: @escaping (Result<T, SessionError>) -> Void)
}

class SessionImpl {
    private let baseURL: URL
    private let key: String

    init(baseURL: URL, key: String) {
        self.baseURL = baseURL
        self.key = key
    }
}

extension SessionImpl: Session {
    func perform<T: Decodable>(request: SessionRequest, completion: @escaping (Result<T, SessionError>) -> Void) {
        guard let url = URL(string: request.path, relativeTo: baseURL) else {
            return completion(.failure(.badRequest))
        }

        var parameters = [
            "key": key,
            "culture": "en",
        ]

        request.parameters.forEach { key, value in
            parameters[key] = value
        }

        AF.request(url,
                   method: .get,
                   parameters: parameters)
            .validate()
            .responseDecodable(of: T.self) { response in
                let result = response
                    .mapError { SessionError($0) }
                    .result

                completion(result)
            }
    }
}
