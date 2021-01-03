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

        service.search(query: "asd") { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .noInternetConnection)

            case .success:
                XCTAssert(false, "Should return error")
            }
        }

        service.details(objectNumber: ArtObjectNumber(stringLiteral: "asd")) { result in
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

        service.search(query: "asd") { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .commonError)

            case .success:
                XCTAssert(false, "Should return error")
            }
        }

        service.details(objectNumber: ArtObjectNumber(stringLiteral: "asd")) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .commonError)

            case .success:
                XCTAssert(false, "Should return error")
            }
        }
    }

    func testReturnsCachedHome_noInternetConnection() {
        let session = MockSession { $0(.failure(.noInternetConnection)) }
        let network = ArtObjectsNetworkImpl(session: session)
        let database = MockArtObjectsDatabase()

        let service = ArtObjectsServiceImpl(network: network, database: database)
        // no cached data, no outdated -> return error
        service.loadHome { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .noInternetConnection)

            case .success:
                XCTAssert(false, "Should return error")
            }
        }

        // no cached data, has outdated -> return outdated
        database.outdatedHome = [testObject(id: "outdated")]
        service.loadHome { result in
            switch result {
            case .failure:
                XCTAssert(false, "Should return outdated items")

            case .success(let items):
                XCTAssertEqual(items.count, 1)
                XCTAssertEqual(items.first!.id.rawValue, "outdated")
            }
        }

        // has cached, has outdated -> returns cached
        database.home = [testObject(id: "home")]
        service.loadHome { result in
            switch result {
            case .failure:
                XCTAssert(false, "Should return home items")

            case .success(let items):
                XCTAssertEqual(items.count, 1)
                XCTAssertEqual(items.first!.id.rawValue, "home")
            }
        }
    }

    func testReturnsCachedHome_connected() {
        class MockNetwork: ArtObjectsNetwork {
            func fetchHome(completion: @escaping SessionCompletion<[ArtObject]>) {
                XCTAssert(false, "Should ot call network")
            }
            func fetchSearch(query: String, completion: @escaping SessionCompletion<[ArtObject]>) {
                XCTAssert(false, "Should ot call network")
            }
            func fetchDetails(objectNumber: ArtObjectNumber, completion: @escaping SessionCompletion<ArtObjectDetails>) {
                XCTAssert(false, "Should ot call network")
            }
        }
        let network = MockNetwork()
        let database = MockArtObjectsDatabase()
        database.home = [testObject(id: "home")]

        let service = ArtObjectsServiceImpl(network: network, database: database)
        service.loadHome { result in
            switch result {
            case .failure:
                XCTAssert(false, "Should return home items")

            case .success(let items):
                XCTAssertEqual(items.count, 1)
                XCTAssertEqual(items.first!.id.rawValue, "home")
            }
        }
    }

    private func createServiceWithError(_ error: SessionError) -> ArtObjectsService {
        let session = MockSession { $0(.failure(error)) }
        let network = ArtObjectsNetworkImpl(session: session)
        return ArtObjectsServiceImpl(network: network, database: MockArtObjectsDatabase())
    }

    private func testObject(id: String) -> ArtObject {
        return ArtObject(
            id: ArtObjectId(stringLiteral: id),
            objectNumber: ArtObjectNumber(stringLiteral: "object_number"),
            title: "title",
            author: "author",
            imageURL: URL(string: "http://image.url")!,
            detailsURL: URL(string: "http://detauls.url")!,
            webURL: URL(string: "http://web.url")!)
    }
}
