//
//  RootView.swift
//  MercadoLibreExample
//
//  Created by Jaime Laino on 31/10/20.
//

import SwiftUI
import MercadoLibreClient

private let readMe = """
  This screen demonstrates how to share a state with two screens one build in SwiftUI and the other in UIKit. Each get the same ViewModel so any change to one of them will be displayed in the other.\

  The App allow you to search items as you type with a debounce time to avoid firing multiple request each time a character is typed, instead give time to the user to finish a typing intent. Also, if a new query is reached while a request is in-flight it will be cancelled keeping the app consistent on the results for that query.
  """

struct RootView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        Form {
            Section(
                header: Text(readMe),
                content: EmptyView.init
            )
            
            Section {
                NavigationLink(
                    "navigation.search.swiftui",
                    destination: SearchView(viewModel: viewModel.searchViewModel),
                    tag: AppViewModel.Navigation.swiftui,
                    selection: $viewModel.navigation
                )
            }
            
            Section {
                NavigationLink(
                    "navigation.search.uikit",
                    destination: SearchViewControllerView(viewModel: viewModel.searchViewModel),
                    tag: AppViewModel.Navigation.uikit,
                    selection: $viewModel.navigation
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarTitle(Text("navigation.bar.title"), displayMode: .inline)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RootView(
                viewModel: .init(.mock)
            )
        }
    }
}

extension AppDependencies {
    static let mock = Self(
        mercadolibreClient: .echo,
        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
    )
}
