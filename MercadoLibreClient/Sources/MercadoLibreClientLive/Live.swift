import Combine
import MercadoLibreClient
import Foundation

extension MercadoLibreClient {
    /// Live client: calls to mercado libre API
    public static func live(siteId: String) -> Self {
        Self(
            search: { query in
                searchFor(query: query, siteId: siteId)
                    .map { $0.results }
                    .mapError {
                        ($0 as? URLError) ?? URLError(.cannotLoadFromNetwork)
                    }
                    .eraseToAnyPublisher()
            }
        )
    }
}

var urlSession: URLSession = .shared
private let host = "api.mercadolibre.com"
private let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
}()

private let seachPath = "/search"

private func searchFor(query: String, siteId: String) -> AnyPublisher<MercadoLibre.SearchResponse, Error> {
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
        .decode(type: MercadoLibre.SearchResponse.self, decoder: decoder)
        .eraseToAnyPublisher()
}
