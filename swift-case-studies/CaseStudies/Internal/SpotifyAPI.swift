import Combine
import Foundation

// MARK: Spotify
enum Spotify {
    static let host = "api.spotify.com"
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    struct AuthorizationToken: Decodable {
        let requestedAt: Date = Date()
        let expiresIn: Int
        let tokenType: String
        let accessToken: String
        
        var OAuthToken: String { "\(tokenType) \(accessToken)" }
    }
    
    struct RawImage : Codable {
        let url: String
        let height: Int
        let width: Int
    }
    
    struct Artist: Codable {
        let id: String
        let followers: Int
        let images: [RawImage]
        let name: String
        let popularity: Int
        
        enum FollowersKeys: String, CodingKey {
            case total
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: Artist.CodingKeys.self)
            let followersValues = try values.nestedContainer(keyedBy: FollowersKeys.self, forKey: .followers)
            
            followers = try followersValues.decode(Int.self, forKey: .total)
            id = try values.decode(String.self, forKey: .id)
            name = try values.decode(String.self, forKey: .name)
            images = try values.decode([RawImage].self, forKey: .images)
            popularity = try values.decode(Int.self, forKey: .popularity)
        }
    }
    
    struct Album: Codable {
        let id: String
        let availableMarkets : [String]?
        let externalURL : URL
        let images: [RawImage]
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case availableMarkets = "available_markets"
            case externalURL = "external_urls"
            case name
            case images
        }
        
        enum ExternalURLKeys: String, CodingKey {
            case spotify
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: Album.CodingKeys.self)
            let externalURLValues = try values.nestedContainer(keyedBy: ExternalURLKeys.self, forKey: .externalURL)
            let urlString = try externalURLValues.decode(String.self, forKey: .spotify)
            
            id = try values.decode(String.self, forKey: .id)
            name = try values.decode(String.self, forKey: .name)
            images = try values.decode([RawImage].self, forKey: .images)
            availableMarkets = try values.decodeIfPresent([String].self, forKey: .availableMarkets)
            externalURL = URL(string: urlString) ?? URL(string: "https://open.spotify.com")!
        }
    }
    
    struct SearchResponse: Codable {
        struct List<Element: Codable>: Codable {
            let items: [Element]
            let total: Int
        }
        
        var query: String?
        let artists: List<Artist>
        let albums: List<Album>?
    }
}

// MARK: Token
extension Spotify {
    private static var token: AuthorizationToken?
    private static let clientId = ""
    private static let clientSecret = ""
    private static var oAuth: String {
        if clientId.isEmpty || clientSecret.isEmpty {
            fatalError("Make sure to set credentials above")
        }
        return (clientId + ":" + clientSecret).data(using: .utf8)!.base64EncodedString()
    }
    private static var autorizationHeaders: [String: String] { ["Authorization": "Basic " + Self.oAuth] }
    private static let clientCredentialParameters = ["grant_type": "client_credentials"]
    private static let tokenEndpoint = "https://accounts.spotify.com/api/token"
    
    static func isValidToken(_ token: AuthorizationToken) -> Bool {
        let comps = (Calendar.current as NSCalendar)
            .components(
                .second,
                from: token.requestedAt as Date,
                to: Date(),
                options: NSCalendar.Options(rawValue: 0)
            )
        return comps.second! < token.expiresIn
    }
    
    static let requestToken: AnyPublisher<AuthorizationToken, Error> = {
        if let token = token, isValidToken(token) {
            return Just(token)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        let url = URL(string: Spotify.tokenEndpoint)!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = Spotify.autorizationHeaders
        request.httpMethod = "POST"
        request.httpBody = Spotify.clientCredentialParameters
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: ",")
            .data(using: .utf8)
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: AuthorizationToken.self, decoder: decoder)
            .handleEvents(receiveOutput: { token = $0 } )
            .eraseToAnyPublisher()
    }()
}

// MARK: Search
extension Spotify {
    private static let seachPath = "/v1/search"
    
    static func searchArtist(query: String) -> AnyPublisher<SearchResponse, Error> {
        requestToken
            .flatMap { token -> AnyPublisher<Spotify.SearchResponse, Error> in
                var components = URLComponents()
                components.scheme = "https"
                components.host = host
                components.path = seachPath
                components.queryItems = [
                    URLQueryItem(name: "q", value: query),
                    URLQueryItem(name: "type", value: "artist")
                ]
                
                var request = URLRequest(url: components.url!)
                request.httpMethod = "GET"
                request.allHTTPHeaderFields = .init()
                request.allHTTPHeaderFields?["Authorization"] = token.OAuthToken
                
                return URLSession.shared
                    .dataTaskPublisher(for: request).map(\.data)
                    .decode(type: SearchResponse.self, decoder: decoder)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
