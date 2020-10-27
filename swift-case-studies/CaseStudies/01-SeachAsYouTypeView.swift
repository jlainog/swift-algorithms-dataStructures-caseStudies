import SwiftUI
import Combine
import CombineSchedulers

/*:
 Using Combine Schedulers for testablility
 https://www.pointfree.co/blog/posts/45-open-sourcing-combineschedulers
 */

struct SearchClient {
    var search: (String) -> AnyPublisher<[String], URLError>
}

class SearchAsYouTypeViewModel: ObservableObject {
    struct Dependencies {
        var searchClient: SearchClient
        var scheduler: AnySchedulerOf<DispatchQueue> =  DispatchQueue.main.eraseToAnyScheduler()
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let dependencies: Dependencies
    
    @Published var query: String = ""
    @Published var results: [String] = []
    @Published var isRequestInFlight = false
    
    init(dependencies: Dependencies) {
        struct CancelId: Hashable {}
        
        self.dependencies = dependencies
        
        $query
            .filter { $0.count >= 3 }
            .setFailureType(to: URLError.self)
            .debounce(
                for: .milliseconds(300),
                scheduler: dependencies.scheduler
            )
            .removeDuplicates()
            .handleEvents(
                receiveOutput: { _ in self.isRequestInFlight = true }
            )
            .flatMap { query -> AnyPublisher<[String], URLError> in
                dependencies.searchClient
                    .search(query)
                    .cancellable(id: CancelId())
            }
            .receive(on: dependencies.scheduler)
            .handleEvents(
                receiveOutput: { _ in self.isRequestInFlight = false }
            )
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { self.results = $0 }
            )
            .store(in: &cancellables)
    }
}

struct SeachAsYouTypeView: View {
    @ObservedObject var viewModel: SearchAsYouTypeViewModel
    
    var body: some View {
        VStack {
            TextField(
                "Search",
                text: $viewModel.query
            )
            .padding()
            
            List {
                if viewModel.isRequestInFlight {
                    ProgressView()
                }
                
                ForEach(viewModel.results, id: \.self) { result in
                    Text(result)
                }
            }
        }
    }
}

extension SeachAsYouTypeView {
    init(_ searchClient: SearchClient) {
        self.viewModel = .init(
            dependencies: .init(
                searchClient: searchClient
            )
        )
    }
}

struct SearchAsYouTypeOptionsView: View {
    var searchClientes: [(String, SearchClient)] = [
        ("Echo", .echo),
        ("The Movie DB", .theMovieDb),
        ("Mercado Libre", .mercadolibre),
        ("Spotify Artists", .spotifyArtists)
    ]
    
    var body: some View {
        List {
            ForEach(searchClientes, id: \.0) {
                NavigationLink(
                    $0.0,
                    destination: SeachAsYouTypeView($0.1)
                        .navigationTitle($0.0)
                )
            }
        }
        .navigationTitle("Search as you type")
    }
}

struct SeachAsYouTypeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchAsYouTypeOptionsView()
        }
    }
}

extension SearchClient {
    static let echo = Self(
        search: { .just([$0]) }
    )
    
    static let theMovieDb = Self(
        search: {
            TheMovieDb
                .searchMovie(query: $0)
                .map { $0.results.map(\.title) }
                .mapError {
                    ($0 as? URLError) ?? URLError(.networkConnectionLost)
                }
                .eraseToAnyPublisher()
        }
    )
    
    static let mercadolibre = Self(
        search: {
            MercadoLibre
                .search(query: $0, siteId: "MCO")
                .map { $0.results.map(\.title) }
                .mapError {
                    ($0 as? URLError) ?? URLError(.networkConnectionLost)
                }
                .eraseToAnyPublisher()
        }
    )
    
    static let spotifyArtists = Self(
        search: {
            Spotify
                .searchArtist(query: $0)
                .map { $0.artists.items.map(\.name) }
                .mapError {
                    ($0 as? URLError) ?? URLError(.networkConnectionLost)
                }
                .eraseToAnyPublisher()
        }
    )
}
