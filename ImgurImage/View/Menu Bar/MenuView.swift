//
//  MenuView.swift
//  ImgurImage
//
//  Created by Amit Jain on 9/22/24.
//
import SwiftUI

struct MenuView: View {
    @EnvironmentObject var viewModel: ImageSearchViewModel
    
    var body: some View {
        HStack {
            SortMenu()
            DateRangeMenu()
        }
    }
}
