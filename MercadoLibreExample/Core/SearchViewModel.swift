import Combine
import CombineSchedulers

final class SearchViewModel: ObservableObject {
    struct Dependencies {
        var search: (String) -> AnyPublisher<[MercadoLibre.Item], URLError>
        var mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler()
    }

    private var cancellables = Set<AnyCancellable>()
    let dependencies: Dependencies
    @Published private(set) var query = ""
    @Published private(set) var results = [MercadoLibre.Item]()
    @Published private(set) var selectedResult: MercadoLibre.Item?
    @Published private(set) var isRequestInFlight = false
    @Published private(set) var errorMessage = ""
    
    init(_ dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func textDidChange(_ searchText: String) {
        guard searchText.count >= 3 else {
            self.query = ""
            results.removeAll()
            return
        }
        
        struct CancellableId: Hashable {}
        
        self.query = searchText
        self.isRequestInFlight = true
        dependencies.search(searchText)
            .delay(for: .milliseconds(500), scheduler: dependencies.mainQueue)
            .removeDuplicates()
            .cancellable(id: CancellableId(), cancelInFlight: true)
            .receive(on: dependencies.mainQueue)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }

                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.isRequestInFlight = false
                        self.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    self.results = value
                    self.isRequestInFlight = false
                }
            )
            .store(in: &cancellables)
    }
    
    func navigateToDetail(at index: Int) {
        selectedResult = results[index]
    }
    
    func clearDetail() {
        self.selectedResult = nil
    }
}
