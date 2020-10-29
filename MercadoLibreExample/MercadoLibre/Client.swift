import Foundation
import Combine

public enum MercadoLibre {
    static var urlSession: URLSession = .shared
    static let host = "api.mercadolibre.com"
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    public struct Item: Codable, Equatable {
        public var id: String
        public var title: String
        public var domainId: String?
        public var category: String?
        public var availableQuantity: Int?
        public var acceptsMercadopago: Bool?
    }
    
    public struct SearchResponse: Codable, Equatable {
        public let results: [Item]
    }
    
    private static let seachPath = "/search"
    
    public static func search(query: String, siteId: String) -> AnyPublisher<SearchResponse, Error> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = "/sites/\(siteId)" + seachPath
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        return urlSession
            .dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: SearchResponse.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
