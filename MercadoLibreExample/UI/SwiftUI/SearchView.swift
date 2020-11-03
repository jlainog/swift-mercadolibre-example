import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack {
            HStack {
                if viewModel.isRequestInFlight {
                    ActivityIndicator()
                }
                
                TextField(
                    "search.bar.title",
                    text: .init(
                        get: { viewModel.query },
                        set: { viewModel.textDidChange($0) }
                    )
                )
            }
            .padding(7)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal, 10)
            .padding(.top)
            
            List {
                ForEach(
                    ContiguousArray(zip(viewModel.results.indices, viewModel.results)),
                    id: \(Int, MercadoLibre.Item).1.id
                ) { index, item in
                    Button(item.title, action: { viewModel.navigateToDetail(at: index) })
                }
            }
            .sheet(
                item: .init(
                    get: { viewModel.selectedResult },
                    set: { _ in viewModel.clearDetail() }
                ),
                content: DetailView.init(selected:)
            )
        }
    }
}

import UIKit
struct ActivityIndicator: UIViewRepresentable {
    
    typealias UIViewType = UIActivityIndicatorView
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchView(viewModel: .init(.echo))
        }
    }
}

extension SearchViewModel.Dependencies {
    static let echo = Self(
        search: { .just([.mock($0)]) },
        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
    )
}
