import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appViewModel = AppViewModel(.live)
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        self.window = (scene as? UIWindowScene).map { UIWindow(windowScene: $0) }
        self.window?.rootViewController = UIHostingController(
            rootView: NavigationView { RootView(viewModel: appViewModel) }
        )
        self.window?.makeKeyAndVisible()
    }

}

fileprivate extension AppDependencies {
    static let live = Self(
        mercadolibreClient: .live,
        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
    )
}

fileprivate extension MercadoLibreClient {
    /// Live client: calls to mercado libre API
    static let live = Self(
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
