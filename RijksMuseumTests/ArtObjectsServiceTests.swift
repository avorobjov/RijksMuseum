//
//  ArtObjectsServiceTests.swift
//  RijksMuseumTests
//
//  Created by Alexander Vorobjov on 1/2/21.
//

import XCTest
@testable import RijksMuseum

class ArtObjectsServiceTests: XCTestCase {
    func testError_noInternetConnection() throws {
        let service = createServiceWithError(.noInternetConnection)
        service.loadHome { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .noInternetConnection)

            case .success:
                XCTAssert(false, "Should return error")
            }
        }
    }

    func testError_other() throws {
        let service = createServiceWithError(.connectionError)
        service.loadHome { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .commonError)

            case .success:
                XCTAssert(false, "Should return error")
            }
        }
    }

    private func createServiceWithError(_ error: SessionError) -> ArtObjectsService {
        let session = MockSession { $0(.failure(error)) }
        let network = ArtObjectsNetworkImpl(session: session)
        return ArtObjectsServiceImpl(network: network)
    }
}
