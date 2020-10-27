import Foundation
import Combine

enum MercadoLibre {
    static let host = "api.mercadolibre.com"
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    struct Item: Codable {
        var id: String
        var title: String
    }
    
    struct SearchResponse: Codable {
        let results: [Item]
    }
    
    private static let seachPath = "/search"
    
    static func search(query: String, siteId: String) -> AnyPublisher<SearchResponse, Error> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = "/sites/\(siteId)" + seachPath
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: SearchResponse.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
