import SwiftUI

struct SortMenu: View {
    @EnvironmentObject var viewModel: ImageSearchViewModel
    
    var body: some View {
        Menu {
            Picker("Sort by", selection: $viewModel.selectedSortOption) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Text(option.displayName).tag(option)
                }
            }
            .onChange(of: viewModel.selectedSortOption) { _, _ in
                Task {
                    await viewModel.performSearch()
                }
            }
        } label: {
            Label("Sort by", systemImage: "arrow.up.arrow.down.circle.fill")
        }
    }
}
