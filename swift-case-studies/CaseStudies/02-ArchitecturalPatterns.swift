import SwiftUI

private let readMe = """
  An architectural pattern is a general, reusable solution to a commonly occurring problem in software architecture.
  In iOS, we encounter multiple architectural patterns from popular ones to the most common MVC.

  Our goal here is to create the same app following different patterns to learn the pros and cons of each while discovering that there can be more layers and abstractions than the ones outlined in each pattern.
  """

struct ArchitecturalPatternsView: View {
    var body: some View {
        Form {
            Section(header: Text(readMe)) {
                NavigationLink(
                    "MVC",
                    destination: MVCView()
                )
            }
        }
        .navigationTitle("Architectural Patterns")
    }
}

struct MVCView: UIViewControllerRepresentable {
    typealias UIViewControllerType = MVCViewController
    
    func makeUIViewController(context: Context) -> MVCViewController { .init() }
    func updateUIViewController(_ uiViewController: MVCViewController, context: Context) { }
}

struct ArchitecturalPatternsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArchitecturalPatternsView()
        }
    }
}
