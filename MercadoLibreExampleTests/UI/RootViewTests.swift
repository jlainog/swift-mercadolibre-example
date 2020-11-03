import XCTest
import Combine
import CombineSchedulers
import SnapshotTesting
import SwiftUI
@testable import MercadoLibreExample

class RootViewTests: XCTestCase {

    func test_navigation() {
        let testScheduler = DispatchQueue.testScheduler
        let appDependencies = AppDependencies(
            mercadolibreClient: .echo,
            mainQueue: testScheduler.eraseToAnyScheduler()
        )
        let appViewModel = AppViewModel(appDependencies)
        let hostingController = UIHostingController(
            rootView: NavigationView {
                RootView(viewModel: appViewModel)
            }
        )
        
        assertSnapshot(matching: hostingController, as: .windowedImage)
        
        appViewModel.navigation = .swiftui
        assertSnapshot(matching: hostingController, as: .wait(for: 0.3, on: .windowedImage))
        
        appViewModel.navigation = nil
        assertSnapshot(matching: hostingController, as: .wait(for: 0.3, on: .windowedImage))
        
        appViewModel.navigation = .uikit
        assertSnapshot(matching: hostingController, as: .wait(for: 0.3, on: .windowedImage))
    }
    
}
