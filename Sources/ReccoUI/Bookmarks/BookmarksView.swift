import SwiftUI

struct BookmarksView: View {
    @StateObject var viewModel: BookmarksViewModel
    
    init(viewModel: BookmarksViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    let gridLayout = [
        GridItem(.flexible(), spacing: .XXS, alignment: .top),
        GridItem(.flexible(), spacing: .XXS, alignment: .top),
        GridItem(.flexible(), spacing: .XXS, alignment: .top)
        ]
    
    var body: some View {
        ReccoLoadingView(viewModel.isLoading) {
            RefreshableScrollView(
                refreshAction: viewModel.getBookmarks
            ) {
                LazyVGrid(columns: gridLayout, spacing: .S) {
                    ForEach(viewModel.items, id: \.self) { item in
                        Button {
                            viewModel.goToDetail(of: item)
                        } label: {
                            FeedItemView(item: item)
                        }
                    }
                }
                .padding(.S)
            }
        }
        .padding(.top, .M)
        .reccoErrorView(
            error: $viewModel.error,
            onRetry: { await viewModel.getBookmarks() },
            onClose: viewModel.dismiss
        )
        .background(
            Color.reccoBackground.ignoresSafeArea()
        )
        .showNavigationBarOnScroll()
        .addCloseSDKToNavbar()
        .navigationTitle("bookmarks.navTitle".localized)
        .navigationBarHidden(false)
        .task {
            if viewModel.items.isEmpty {
                await viewModel.getBookmarks()
            }
        }
    }
}

struct BookmarksView_Previews: PreviewProvider {
    static var previews: some View {
        withAssembly { r in
            BookmarksView(viewModel: r.get())
        }
    }
}
