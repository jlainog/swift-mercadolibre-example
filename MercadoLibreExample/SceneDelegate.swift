import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appViewModel = SearchViewModel(.mercadolibre)
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        self.window = (scene as? UIWindowScene).map { UIWindow(windowScene: $0) }
        self.window?.rootViewController = UINavigationController(
            rootViewController: SearchViewController(viewModel: appViewModel)
        )
        self.window?.makeKeyAndVisible()
    }

}

fileprivate extension SearchViewModel.Dependencies {
    /// Live client: calls to mercado libre API
    static let mercadolibre = Self(
        search: {
            MercadoLibre
                .search(query: $0, siteId: "MCO")
                .map { $0.results }
                .mapError {
                    ($0 as? URLError) ?? URLError(.cannotLoadFromNetwork)
                }
                .eraseToAnyPublisher()
        }
    )
}
