import UIKit
import SwiftUI
import MercadoLibreClientLive

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
        mercadolibreClient: .live(siteId: "MCO"),
        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
    )
}
