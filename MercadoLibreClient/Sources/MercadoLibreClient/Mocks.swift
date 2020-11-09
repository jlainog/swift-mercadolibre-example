import Combine
import Foundation

extension MercadoLibreClient {
    public static let echo = Self(
        search: {
            Just([.mock($0)])
                .setFailureType(to: URLError.self)
                .eraseToAnyPublisher()
        }
    )
}

extension MercadoLibre.Item {
    public static func mock(_ value: String) -> Self {
        Self(
            id: "MCO\(value)",
            title: value,
            domainId: "MCO-\(value)",
            category: "MCO123",
            availableQuantity: 1,
            acceptsMercadopago: true
        )
    }
}
