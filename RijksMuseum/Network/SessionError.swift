//
//  SessionError.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 12/31/20.
//

import Alamofire

enum SessionError: Error {
    case badRequest
    case noInternetConnection
    case connectionError
    case decodeError

    init(_ error: Error) {
        if let urlError = error as? URLError {
            if urlError.code == .notConnectedToInternet {
                self = .noInternetConnection
                return
            }

            self = .connectionError
            return
        }

        switch error {
        case AFError.sessionTaskFailed(error: let underlying):
            self = SessionError(underlying)

        default:
            self = .connectionError
        }
    }
}
