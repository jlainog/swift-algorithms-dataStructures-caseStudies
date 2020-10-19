import SwiftUI

struct SeachAsYouTypeView: View {
    @State var results: [String] = []
    @State var query: String = ""
    
    var body: some View {
        VStack {
            TextField(
                "Search",
                text: self.$query
            )
            .padding()
            
            List {
                ForEach(self.results, id: \.self) { result in
                    Text(result)
                }
            }
        }
    }
}

struct SeachAsYouTypeView_Previews: PreviewProvider {
    static var previews: some View {
        SeachAsYouTypeView()
    }
}
