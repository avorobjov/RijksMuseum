//
//  SessionRequest.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 12/31/20.
//

import Alamofire

protocol SessionRequest {
    typealias Parameters = [String: String]

    var path: String { get }
    var parameters: Parameters { get }
}
