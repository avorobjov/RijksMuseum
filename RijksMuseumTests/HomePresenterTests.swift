//
//  HomePresenterTests.swift
//  RijksMuseumTests
//
//  Created by Alexander Vorobjov on 1/3/21.
//

import XCTest
@testable import RijksMuseum

class HomePresenterTests: XCTestCase {
    class MockView: HomeView {
        var title: String?
        var msgTitle: String?
        var msgText: String?
        var items: [ArtObjectCell.ViewModel]?

        func show(items: [ArtObjectCell.ViewModel]) {
            self.items = items
        }

        func presentMessage(title: String, message: String) {
            self.msgTitle = title
            self.msgText = message
        }

        func set(title: String) {
            self.title = title
        }
    }

    class MockDelegate: HomePresenterDelegate {
        var details: ArtObject?

        func showDetails(artObject: ArtObject) {
            self.details = artObject
        }
    }

    var view: MockView!
    var delegate: MockDelegate!
    var service: MockArtObjectsService!

    override func setUpWithError() throws {
        view = MockView()
        delegate = MockDelegate()
        service = MockArtObjectsService()
    }

    override func tearDownWithError() throws {
        view = nil
        delegate = nil
        service = nil
    }

    func testTitleSet() throws {
        let presenter = HomePresenterImpl(artObjectsService: service, delegate: delegate)
        presenter.view = view

        XCTAssertEqual(view.title, "Home")
    }

    func testHomeErrorDisplayed_noInternetConnection() throws {
        let error = ArtObjectsServiceError.noInternetConnection
        service.home = .failure(error)

        let presenter = HomePresenterImpl(artObjectsService: service, delegate: delegate)
        presenter.view = view

        XCTAssertEqual(view.msgTitle, "Failed to load data")
        XCTAssertEqual(view.msgText, error.localizedDescription)
    }

    func testHomeErrorDisplayed_commonError() throws {
        let error = ArtObjectsServiceError.commonError
        service.home = .failure(error)

        let presenter = HomePresenterImpl(artObjectsService: service, delegate: delegate)
        presenter.view = view

        XCTAssertEqual(view.msgTitle, "Failed to load data")
        XCTAssertEqual(view.msgText, error.localizedDescription)
    }

    func testHomeItems() throws {
        let home = testObject(title: "home_title", author: "home_author", imageURL: "http://test.home.url")
        service.home = .success([home])

        let presenter = HomePresenterImpl(artObjectsService: service, delegate: delegate)
        presenter.view = view

        XCTAssertEqual(view.items?.count, 1)

        let item = view.items!.first!
        XCTAssertEqual(item.title, home.title)
        XCTAssertEqual(item.author, home.author)
        XCTAssertEqual(item.imageURL.absoluteString, home.imageURL.absoluteString)
    }

    func testSearchError() throws {
        let home = testObject(title: "home_title", author: "home_author", imageURL: "http://test.home.url")
        service.home = .success([home])

        let error = ArtObjectsServiceError.noInternetConnection
        service.search = .failure(error)

        let presenter = HomePresenterImpl(artObjectsService: service, delegate: delegate)
        presenter.view = view

        XCTAssertEqual(view.items?.count, 1)
        XCTAssertEqual(view.items!.first!.title, home.title)

        // load search and check items changed
        presenter.search(query: "asdasd")

        let expectation = XCTestExpectation()
        // there is delay before search, wait for update!
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.view.msgTitle, "Failed to load data")
            XCTAssertEqual(self.view.msgText, error.localizedDescription)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }

    func testSearchItems() throws {
        let home = testObject(title: "home_title", author: "home_author", imageURL: "http://test.home.url")
        service.home = .success([home])

        let search = testObject(title: "search_title", author: "search_author", imageURL: "http://test.search.url")
        service.search = .success([search])

        let presenter = HomePresenterImpl(artObjectsService: service, delegate: delegate)
        presenter.view = view

        XCTAssertEqual(view.items?.count, 1)
        XCTAssertEqual(view.items!.first!.title, home.title)

        // load search and check items changed
        presenter.search(query: "asdasd")

        let expectation = XCTestExpectation()
        // there is delay before search, wait for update!
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let title = self.view.items?.first?.title, title == search.title {
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 2)
    }

    func testOpenDetails() {
        let home = testObject(title: "home_title", author: "home_author", imageURL: "http://test.home.url")
        service.home = .success([home])

        let presenter = HomePresenterImpl(artObjectsService: service, delegate: delegate)
        presenter.view = view

        XCTAssertNil(delegate.details)

        XCTAssertEqual(view.items?.count, 1)
        presenter.showDetails(at: 0)

        XCTAssertNotNil(delegate.details)
        XCTAssertEqual(delegate.details?.id.rawValue, home.id.rawValue)
    }

    private func testObject(title: String, author: String, imageURL: String) -> ArtObject {
        return ArtObject(
            id: ArtObjectId(stringLiteral: "identifier"),
            objectNumber: ArtObjectNumber(stringLiteral: "object_number"),
            title: title,
            author: author,
            imageURL: URL(string: imageURL)!,
            detailsURL: URL(string: "http://detauls.url")!,
            webURL: URL(string: "http://web.url")!)
    }
}
