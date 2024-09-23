//
//  ImageGridView.swift
//  ImgurImage
//
//  Created by Amit Jain on 9/22/24.
//

import SwiftUI
import Kingfisher

struct ImageGridView: View {
    var images: [ImgurImage]
    var isLoading: Bool
    var onImageTap: (ImgurImage) -> Void
    var onLoadMore: (ImgurImage) -> Void

    let gridItems = [GridItem(.adaptive(minimum: 100))]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems) {
                ForEach(images, id: \.id) { image in
                    if let thumbnailLink = image.thumbnailLink, let thumbnailURL = URL(string: thumbnailLink) {
                        KFImage(thumbnailURL)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipped()
                            .onTapGesture {
                                onImageTap(image)
                            }
                            .onAppear {
                                onLoadMore(image)
                            }
                    }
                }
            }

            if isLoading {
                ProgressView("Loading more images...")
            }
        }
    }
}

