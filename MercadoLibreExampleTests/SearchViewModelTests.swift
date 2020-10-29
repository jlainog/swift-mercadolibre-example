//
//  SearchViewModelTests.swift
//  MercadoLibreExampleTests
//
//  Created by Jaime Laino on 28/10/20.
//

import XCTest
import Combine
import CombineSchedulers
@testable import MercadoLibreExample

class SearchViewModelTests: XCTestCase {

    func test_SearchTriggered() throws {
        let testSubject = PassthroughSubject<[String], URLError>()
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
        
        testSubject.send(["1", "2"])
        testScheduler.advance(by: .milliseconds(500)) // advance delay
        testScheduler.advance() // receive on main queue
        XCTAssertFalse(sut.isRequestInFlight)
        XCTAssertEqual(sut.results, ["1", "2"])
        
        sut.textDidChange("ip")
        XCTAssertEqual(sut.query, "")
        XCTAssertFalse(sut.isRequestInFlight)
    }

    func test_cancelInFlight() {
        let testScheduler = DispatchQueue.testScheduler
        let sut = SearchViewModel(
            .init(
                search: {
                    AnyPublisher<[String], URLError>
                        .just([$0])
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
        XCTAssertEqual(sut.results, ["second"])
        XCTAssertFalse(sut.isRequestInFlight)
    }
    
    func test_requestError() {
        let testScheduler = DispatchQueue.testScheduler
        let sut = SearchViewModel(
            .init(
                search: { _ in
                    AnyPublisher<[String], URLError>
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
