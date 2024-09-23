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
            // Cancel the previous search task if it exists
            searchTask?.cancel()
            // Start a new search task
            performSearch()
        }
    }

    private func performSearch() {
        // Start a new debounced search task
        searchTask = Task {
            await viewModel.debounceSearch()
        }
    }
}

