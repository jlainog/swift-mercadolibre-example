import XCTest
import Combine
import CombineSchedulers
import SnapshotTesting
import SwiftUI
@testable import MercadoLibreExample

class SearchViewTests: XCTestCase {
    
    func test_search_detail_navigation() {
        let testSubject = PassthroughSubject<[MercadoLibre.Item], URLError>()
        let testScheduler = DispatchQueue.testScheduler
        let viewModel = SearchViewModel(
            .init(
                search: { _ in testSubject.eraseToAnyPublisher() },
                mainQueue: testScheduler.eraseToAnyScheduler()
            )
        )
        let hostingController = UIHostingController(
            rootView: NavigationView {
                SearchView(viewModel: viewModel)
                    .navigationBarTitle("test", displayMode: .inline)
            }
        )
        
        viewModel.textDidChange("First")
        testSubject.send([.mock, .mock, .mock])
        testScheduler.advance(by: .milliseconds(500)) // advance delay
        testScheduler.advance() // receive on main queue
        assertSnapshot(matching: hostingController, as: .windowedImage)

        viewModel.navigateToDetail(at: 0)
        assertSnapshot(matching: hostingController, as: .wait(for: 0.3, on: .windowedImage))

        viewModel.clearDetail()
        assertSnapshot(matching: hostingController, as: .wait(for: 0.3, on: .windowedImage))
    }
    
}
