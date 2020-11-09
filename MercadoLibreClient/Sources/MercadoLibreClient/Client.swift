import Combine
import Foundation

public struct MercadoLibreClient {
    public var search: (String) -> AnyPublisher<[MercadoLibre.Item], URLError>
    
    public init(
        search: @escaping (String) -> AnyPublisher<[MercadoLibre.Item], URLError>
    ) {
        self.search = search
    }
}

public enum MercadoLibre {
    
    public struct Item: Codable, Equatable, Identifiable {
        public var id: String
        public var title: String
        public var domainId: String?
        public var category: String?
        public var availableQuantity: Int?
        public var acceptsMercadopago: Bool?
        
        public init(
            id: String,
            title: String,
            domainId: String?,
            category: String?,
            availableQuantity: Int?,
            acceptsMercadopago: Bool?
        ) {
            self.id = id
            self.title = title
            self.domainId = domainId
            self.category = category
            self.availableQuantity = availableQuantity
            self.acceptsMercadopago = acceptsMercadopago
        }
    }
    
    public struct SearchResponse: Codable, Equatable {
        public let results: [Item]
        
        public init(
            results: [Item]
        ) {
            self.results = results
        }
    }
}
