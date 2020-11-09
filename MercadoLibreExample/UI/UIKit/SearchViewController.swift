import UIKit
import Combine
import MercadoLibreClient
import SwiftUI

struct SearchViewControllerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UINavigationController
    
    @ObservedObject var viewModel: SearchViewModel
    
    func makeUIViewController(context: Context) -> UINavigationController {
        UINavigationController(rootViewController: SearchViewController(viewModel: viewModel))
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
//        if uiViewController.presentedViewController == nil {
//            viewModel.clearDetail()
//        }
    }
    
}

final class SearchViewController: UITableViewController {
    private let cellIdentifier = "cellIdentifier"
    private var cancellables = Set<AnyCancellable>()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController()
        
        searchController.searchBar.text = viewModel.query
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "search.bar.title".localized
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        configureBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.searchController?.isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.isMovingToParent {
            viewModel.clearDetail()
        }
    }
}

// MARK: - UITableViewDatasource
extension SearchViewController {
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = viewModel.results[indexPath.row].title
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.navigateToDetail(at: indexPath.row)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.textDidChange(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resignFirstResponder()
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
         searchController.searchBar.becomeFirstResponder()
     }
}

// MARK: Private Methods
private extension SearchViewController {
    func configureBindings() {
        viewModel.$isRequestInFlight.sink { [weak self] isRequestInFlight in
            guard let self = self else { return }
            
            if isRequestInFlight {
                self.navigationItem.searchController?.searchBar.searchTextField.leftView = self.activityIndicator
                self.activityIndicator.startAnimating()
            } else {
                self.navigationItem.searchController?.searchBar.searchTextField.leftView = nil
                self.activityIndicator.stopAnimating()
            }
        }
        .store(in: &cancellables)
        
        viewModel.$results
            .removeDuplicates()
            // WORKAROUND: This is needed since the publisher is been call on the object will change
            // and create a crash when the array of results is about to be empty.
            .receive(on: viewModel.dependencies.mainQueue)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$selectedResult.sink { [weak self] (result) in
            guard let self = self else { return }
            if let selected = result {
                self.present(
                    UINavigationController(rootViewController: DetailViewController(selected)),
                    animated: true
                )
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        .store(in: &cancellables)
    }
}
