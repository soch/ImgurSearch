//
//  DateRangeMenu.swift
//  ImgurImage
//
//  Created by Amit Jain on 9/22/24.
//

import SwiftUI

struct DateRangeMenu: View {
    @ObservedObject var viewModel: ImageSearchViewModel
    
    var body: some View {
        Menu {
            ForEach(DateRange.allCases) { range in
                Button(action: {
                    viewModel.selectedDateRange = range
                    Task {
                        await viewModel.performSearch()
                    }
                }) {
                    HStack {
                        Text(range.displayName)
                        if viewModel.selectedDateRange == range {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Label("Date Range", systemImage: "calendar")
        }
        .disabled(viewModel.selectedSortOption == .top)
    }
}

