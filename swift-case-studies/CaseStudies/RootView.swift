import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationView {
            Form {
                NavigationLink(
                    "Search as you type",
                    destination: SearchAsYouTypeOptionsView()
                )
                
                NavigationLink(
                    "Architectural Patterns",
                    destination: ArchitecturalPatternsView()
                )
            }
            .navigationTitle("Case Studies")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
