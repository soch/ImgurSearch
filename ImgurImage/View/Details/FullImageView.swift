import SwiftUI
import Kingfisher

struct FullImageView: View {
    let images: [ImgurImage]
    @State private var currentIndex: Int

    init(images: [ImgurImage], startIndex: Int) {
        self.images = images
        self._currentIndex = State(initialValue: startIndex)
    }

    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(0..<images.count, id: \.self) { index in
                if let link = images[index].link, let url = URL(string: link) {
                    KFImage(url)
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .tag(index)
                } else {
                    Text("Image not available")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}
