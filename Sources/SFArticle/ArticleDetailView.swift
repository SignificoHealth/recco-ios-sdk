import SwiftUI
import SFSharedUI
import SFEntities
import NukeUI

public struct ArticleDetailView: View {
    public init(
        viewModel: ArticleDetailViewModel
    ) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    @Environment(\.presentationMode) var dismiss
    @StateObject var viewModel: ArticleDetailViewModel
    
    public var body: some View {
        BouncyHeaderScrollview(
            navTitle: viewModel.heading,
            backAction: { dismiss.wrappedValue.dismiss() }
        ) {
            LazyImage(
                url: viewModel.imageUrl
            ) { state in
                if let image = state.image {
                    ZStack {
                        image
                            .resizable()
                            .scaledToFill()
                        
                        LinearGradient(
                            colors: [.black.opacity(0.35), .clear, .clear], startPoint: .top, endPoint: .bottom
                        )
                    }
                } else if state.error != nil {
                    Color.sfPrimary20.overlay(
                        Image(systemName: "exclamationmark.icloud.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60)
                            .foregroundColor(.sfPrimary)
                    )
                } else {
                    ProgressView()
                }
            }
            .processors([.resize(width: UIScreen.main.bounds.width)])
        } content: {
            VStack(alignment: .leading, spacing: .M) {
                Text(viewModel.heading)
                    .h1()
                    .fixedSize(horizontal: false, vertical: true)
                
                Rectangle()
                    .fill(Color.sfAccent)
                    .frame(height: 8)
                    .frame(maxWidth: .infinity)
                
                SFLoadingView(viewModel.isLoading) {
                    VStack(alignment: .leading, spacing: .L) {
                        if let article = viewModel.article {
                            if let lead = article.lead {
                                Text(lead).body1bold()
                            }
                            
                            if let body = article.articleBodyHtml {
                                Text(body)
                                    .body2()
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, .L)
            .padding(.horizontal, .S)
            .background(Color.sfBackground)
            .cornerRadius(.L, corners: [.topLeft, .topRight])
            .padding(.top, -UIScreen.main.bounds.height * 0.05)
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.getArticle()
        }
    }
}

struct ArticleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        withAssembly { r in
            ArticleDetailView(viewModel: r.get(argument: (ContentId(itemId: "", catalogId: ""), "This is a header", URL(string: "https://images.pexels.com/photos/708440/pexels-photo-708440.jpeg"))))
        }
    }
}
