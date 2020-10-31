import Foundation

final class AppViewModel: ObservableObject {
    enum Navigation: Hashable {
        case uikit, swiftui
    }
    
    let dependencies: AppDependencies
    @Published var navigation: Navigation?
    @Published var searchViewModel: SearchViewModel
    
    init(_ dependencies: AppDependencies) {
        self.dependencies = dependencies
        self.searchViewModel = SearchViewModel(dependencies.search)
    }
}

extension AppDependencies {
    var search: SearchViewModel.Dependencies {
        .init(
            search: mercadolibreClient.search,
            mainQueue: mainQueue
        )
    }
}
