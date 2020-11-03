import XCTest
import Combine
import CombineSchedulers
import SnapshotTesting
@testable import MercadoLibreExample

class SearchViewControllerTests: XCTestCase {

    func test_search_detail_navigation() {
        let testSubject = PassthroughSubject<[MercadoLibre.Item], URLError>()
        let testScheduler = DispatchQueue.testScheduler
        let viewModel = SearchViewModel(
            .init(
                search: { _ in testSubject.eraseToAnyPublisher() },
                mainQueue: testScheduler.eraseToAnyScheduler()
            )
        )
        let vc = UINavigationController(
            rootViewController: SearchViewController(viewModel: viewModel)
        )

        viewModel.textDidChange("First")
        testSubject.send([.mock])
        testScheduler.advance(by: .milliseconds(500)) // advance delay
        testScheduler.advance() // receive on main queue
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX(.portrait)))
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX(.landscape)))
        assertSnapshot(matching: vc, as: .recursiveDescription(on: .iPhoneX))
        
        viewModel.navigateToDetail(at: 0)
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX(.portrait)))
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX(.landscape)))
        assertSnapshot(matching: vc, as: .recursiveDescription(on: .iPhoneX))
        
        viewModel.clearDetail()
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX(.portrait)))
        assertSnapshot(matching: vc, as: .recursiveDescription(on: .iPhoneX))
    }

}


