import SwiftUI
import Combine

struct AsyncImage<Placeholder: View>: View {
    @StateObject private var imageLoader = ImageLoader()
    private let url: URL
    private let placeholder: Placeholder
    
    init(url: URL, @ViewBuilder placeholder: () -> Placeholder) {
        self.url = url
        self.placeholder = placeholder()
    }
    
    var body: some View {
        content
            .onAppear { imageLoader.load(from: url) }
    }
    
    @ViewBuilder
    private var content: some View {
        if let image = imageLoader.image {
            Image(uiImage: image)
                .resizable()
        } else {
            placeholder
        }
    }
}



class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?
    
    func load(from url: URL) {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
}
