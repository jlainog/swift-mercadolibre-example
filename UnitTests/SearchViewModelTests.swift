//
//  SearchViewModelTests.swift
//  MercadoLibreExampleTests
//
//  Created by Jaime Laino on 28/10/20.
//

import XCTest
import Combine
import CombineSchedulers
import MercadoLibreClient
@testable import MercadoLibreExample

extension MercadoLibre.Item {
    static var mock = Self(
        id: "MCO53",
        title: "Celular iphone",
        domainId: "MCO-CELLPHONES",
        category: "MCO123",
        availableQuantity: 1,
        acceptsMercadopago: true
    )
}

class SearchViewModelTests: XCTestCase {

    func test_SearchTriggered() throws {
        let testSubject = PassthroughSubject<[MercadoLibre.Item], URLError>()
        let testScheduler = DispatchQueue.testScheduler
        let sut = SearchViewModel(
            .init(
                search: { _ in testSubject.eraseToAnyPublisher() },
                mainQueue: testScheduler.eraseToAnyScheduler()
            )
        )
        
        sut.textDidChange("ip")
        XCTAssertEqual(sut.query, "")
        XCTAssertFalse(sut.isRequestInFlight)
        
        sut.textDidChange("iphone Xr")
        XCTAssertEqual(sut.query, "iphone Xr")
        XCTAssertTrue(sut.isRequestInFlight)
        
        testSubject.send([.mock])
        testScheduler.advance(by: .milliseconds(500)) // advance delay
        testScheduler.advance() // receive on main queue
        XCTAssertFalse(sut.isRequestInFlight)
        XCTAssertEqual(sut.results, [.mock])
        
        sut.textDidChange("ip")
        XCTAssertEqual(sut.query, "")
        XCTAssertFalse(sut.isRequestInFlight)
    }

    func test_cancelInFlight() {
        let testScheduler = DispatchQueue.testScheduler
        let sut = SearchViewModel(
            .init(
                search: { _ in
                    AnyPublisher<[MercadoLibre.Item], URLError>
                        .just([.mock])
                        .delay(for: .milliseconds(300), scheduler: testScheduler)
                        .eraseToAnyPublisher()
                },
                mainQueue: testScheduler.eraseToAnyScheduler()
            )
        )
        
        sut.textDidChange("first")
        testScheduler.advance(by: .milliseconds(500)) // advance delay
        XCTAssertEqual(sut.results, [])
        XCTAssertTrue(sut.isRequestInFlight)
        
        sut.textDidChange("second")
        testScheduler.advance(by: .milliseconds(500)) // advance delay
        XCTAssertEqual(sut.results, [])
        XCTAssertTrue(sut.isRequestInFlight)
        
        testScheduler.advance(by: .milliseconds(300)) // advance search publisher delay
        XCTAssertEqual(sut.results, [.mock])
        XCTAssertFalse(sut.isRequestInFlight)
    }
    
    func test_requestError() {
        let testScheduler = DispatchQueue.testScheduler
        let sut = SearchViewModel(
            .init(
                search: { _ in
                    AnyPublisher<[MercadoLibre.Item], URLError>
                        .fail(error: URLError(.cannotLoadFromNetwork))
                        .eraseToAnyPublisher()
                },
                mainQueue: testScheduler.eraseToAnyScheduler()
            )
        )
        
        sut.textDidChange("first")
        testScheduler.advance(by: .milliseconds(500)) // advance delay
        testScheduler.advance() // receive on main queue
        XCTAssertEqual(sut.results, [])
        XCTAssertFalse(sut.isRequestInFlight)
        XCTAssertEqual(sut.errorMessage, "The operation couldn’t be completed. (NSURLErrorDomain error -2000.)")
    }
}
