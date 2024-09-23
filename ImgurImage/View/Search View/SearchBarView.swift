import SwiftUI

struct SearchBarView: View {
    @EnvironmentObject var viewModel: ImageSearchViewModel
    @Binding var searchTerm: String
    @Binding var searchTask: Task<Void, Never>?

    var body: some View {
        TextField("Search for images...", text: $searchTerm, onCommit: {
            performSearch()
        })
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
        .onChange(of: searchTerm) { _, _ in
            // Cancel the previous search task if it exists
            searchTask?.cancel()
            // Start a new search task
            performSearch()
        }
    }

    private func performSearch() {
        // Start a new debounced search task
        searchTask = Task {
            await debounceSearch()
        }
    }

    private func debounceSearch() async {
        // Delay the search operation by 0.5 seconds
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Perform the search if the task has not been cancelled
        if !Task.isCancelled {
            // Call the performSearch method from the view model
            await viewModel.performSearch()
        }
    }
}

