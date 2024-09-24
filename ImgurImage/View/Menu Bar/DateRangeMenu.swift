import SwiftUI

struct DateRangeMenu: View {
    @EnvironmentObject var viewModel: ImageSearchViewModel
    
    var body: some View {
        Menu {
            Picker(selection: $viewModel.selectedDateRange, label: Text("Select date range")) {
                ForEach(DateRange.allCases, id: \.self) { range in
                    Text(range.displayName).tag(range)
                }
            }
            .onChange(of: viewModel.selectedDateRange) { _, _ in
                Task {
                    await viewModel.performSearch()
                }
            }
        } label: {
            Label("Date Range", systemImage: "calendar")
        }
        .disabled(viewModel.selectedSortOption != .top)
    }
}
