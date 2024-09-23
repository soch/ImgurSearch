//
//  SortMenu.swift
//  ImgurImage
//
//  Created by Amit Jain on 9/22/24.
//

import SwiftUI

struct SortMenu: View {
    @ObservedObject var viewModel: ImageSearchViewModel
    
    var body: some View {
        Menu {
            ForEach(SortOption.allCases) { option in
                Button(action: {
                    viewModel.selectedSortOption = option
                    if option == .top {
                        viewModel.selectedDateRange = .allTime // Automatically set to All Time when Top is selected
                    }
                    Task {
                        await viewModel.performSearch()
                    }
                }) {
                    HStack {
                        Text(option.displayName)
                        if viewModel.selectedSortOption == option {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Label("Sort by", systemImage: "arrow.up.arrow.down.circle.fill")
        }
    }
}

