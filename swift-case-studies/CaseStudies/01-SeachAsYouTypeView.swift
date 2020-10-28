import SwiftUI
import Combine
import CombineSchedulers

class SeachAsYouTypeViewModel: ObservableObject {

  struct Dependencies {
    var search: (String) -> AnyPublisher<[String], Never>
    var mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler()
  }

  private var dependencies: Dependencies

  @Published var results: [String] = []
  @Published var query: String = ""

  var cancellable: AnyCancellable?

  init(dependencies: Dependencies) {
    self.dependencies = dependencies

    cancellable = $query
      .flatMap(dependencies.search)
      .receive(on: dependencies.mainQueue)
      .assign(to: \.results, on: self)
//      .sink { (results) in
//        self.results = results
//      }

  }
}

extension SeachAsYouTypeViewModel.Dependencies {
  static let live = Self(
    search: { query in
      return URLSession.shared
        .dataTaskPublisher(for: URL(string: "https://api.mercadolibre.com/sites/MCO/search?category=MCO1744&BRAND=56870&q=\(query)")!)
        .map( \.data)
        .decode(type: CarModelResult.self, decoder: JSONDecoder())
        .map{ $0.results.map(\.title) }
        .assertNoFailure()
        .eraseToAnyPublisher()
    }
  )
}

struct SeachAsYouTypeView: View {
  @ObservedObject var viewModel: SeachAsYouTypeViewModel

  var body: some View {
    VStack {
      TextField(
        "Search",
        text: $viewModel.query
      )
      .padding()

      List {
        ForEach(viewModel.results, id: \.self) { result in
          Text(result)
        }
      }
    }
  }
}

struct SeachAsYouTypeView_Previews: PreviewProvider {
    static var previews: some View {
      SeachAsYouTypeView(viewModel: SeachAsYouTypeViewModel(dependencies: .live))
    }
}
