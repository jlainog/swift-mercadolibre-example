//
//  MercadoLibreApiTests.swift
//  MercadoLibreExampleTests
//
//  Created by Jaime Laino on 28/10/20.
//

import XCTest
import Combine
import Codable_Utils
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

class MercadoLibreApiTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    func test_Search_Success() throws {
        let mockResponse = MercadoLibre.SearchResponse(results: [.mock])
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try mockResponse.encode(using: encoder)
        let query = "first"
        let siteId = "siteID"
       
        MercadoLibre.urlSession = .makeStub()
        URLSession.stub { request in
            XCTAssertEqual(request.url, URL(string: "https://api.mercadolibre.com/sites/\(siteId)/search?q=\(query)"))
            return (.init(), data)
        }
        
        let expectation = XCTestExpectation(description: "response")
        MercadoLibre
            .search(query: query, siteId: siteId)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { response in
                    expectation.fulfill()
                    XCTAssertEqual(response, mockResponse)
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }

    func test_Search_Failure() throws {
        MercadoLibre.urlSession = .makeStub()
        URLSession.stub { request in
            throw URLError(.cannotLoadFromNetwork)
        }
        
        let expectation = XCTestExpectation(description: "response")
        MercadoLibre
            .search(query: "query", siteId: "siteId")
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        XCTAssertEqual(error.localizedDescription,
                                       "The operation couldn’t be completed. (NSURLErrorDomain error -2000.)")
                        expectation.fulfill()
                    } else {
                        fatalError("This should not be executed")
                    }
                },
                receiveValue: { _ in
                    fatalError("This should not be executed")
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}

extension URLSession {
    static func makeStub() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }
    
    static func stub(with handler: ((URLRequest) throws -> (HTTPURLResponse, Data))?) {
        MockURLProtocol.requestHandler = handler
    }
}

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Receive request with no handler")
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
    
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
}
