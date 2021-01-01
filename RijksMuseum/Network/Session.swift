//
//  Session.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 12/31/20.
//

import Alamofire

typealias SessionResult<T> = Result<T, SessionError>
typealias SessionCompletion<T> = (SessionResult<T>) -> Void

protocol Session {
    func fetch(_ api: API, completion: @escaping SessionCompletion<Data>)
    func fetch<T: Decodable>(_ type: T.Type, _ api: API, completion: @escaping SessionCompletion<T>)
}

extension Session {
    func fetch<T: Decodable>(_ type: T.Type, _ api: API, completion: @escaping SessionCompletion<T>) {
        fetch(api) { result in
            completion(result.flatMap { data -> SessionResult<T> in
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    return .success(try decoder.decode(T.self, from: data))
                }
                catch {
                    print("Session: decode error \(error)")
                }

                return .failure(.decodeError)
            })
        }
    }
}

final class SessionImpl {
    private let defaultParameters: Alamofire.Parameters

    init(key: String) {
        defaultParameters = [
            "key": key,
            "culture": "en",
        ]
    }

    func buildRequest(for api: API) -> URLRequest? {
        return try? api.asURLRequest(defaultParameters: defaultParameters)
    }
}

extension SessionImpl: Session {
    func fetch(_ api: API, completion: @escaping SessionCompletion<Data>) {
        guard let request = buildRequest(for: api) else {
            return completion(.failure(.badRequest))
        }

        AF.request(request)
            .validate()
            .responseData { response in
                let result = response
                    .mapError { SessionError($0) }
                    .result

                completion(result)
            }
    }
}
