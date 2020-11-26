import Foundation
import Combine

enum TheMovieDb {
    static let host = "api.themoviedb.org"
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    struct Movie: Codable {
        var id: Int
        var title: String
    }
    
    struct SearchResponse: Codable {
        let results: [Movie]
    }
    
    private static let seachPath = "/3/search"
    
    static func searchMovie(query: String) -> AnyPublisher<SearchResponse, Error> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = seachPath + "/movie"
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "api_key", value: "1f4d7de5836b788bdfd897c3e0d0a24b"),
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
