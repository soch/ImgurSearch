import SwiftUI

struct SearchBarView: View {
    @Binding var searchTerm: String
    var onSearch: () -> Void

    var body: some View {
        TextField("Search for images...", text: $searchTerm, onCommit: onSearch)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
    }
}
