//
//  FullImageView.swift
//  ImgurImage
//
//  Created by Amit Jain on 9/22/24.
//

import SwiftUI
import Kingfisher

struct FullImageView: View {
    var imageUrl: String
    
    var body: some View {
        if let url = URL(string: imageUrl) {
            KFImage(url)
                .resizable()
                .scaledToFit()
                .padding()
        }
    }
}
