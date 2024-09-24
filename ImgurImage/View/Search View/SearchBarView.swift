import SwiftUI

struct SearchBarView: View {
    @EnvironmentObject var viewModel: ImageSearchViewModel
    @State private var searchTask: Task<Void, Never>? = nil

    var body: some View {
        TextField("Search for images...", text: $viewModel.searchTerm, onCommit: {
            performSearch()
        })
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
        .onChange(of: viewModel.searchTerm) { _, _ in
            searchTask?.cancel()
            performSearch()
        }
    }

    private func performSearch() {
        searchTask = Task {
            await viewModel.debounceSearch()
        }
    }
}

