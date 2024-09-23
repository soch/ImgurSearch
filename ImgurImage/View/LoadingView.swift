//
//  LoadingView.swift
//  ImgurImage
//
//  Created by Amit Jain on 9/22/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView("Loading images...")
            Spacer()
        }
    }
}

