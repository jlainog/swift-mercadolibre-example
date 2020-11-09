#  Mercado Libre Example

A simple example app that uses MercadoLibre API to search for products.

![gif](/RocketSim.gif)

## Architecture

It uses the architectural pattern MVVM + Vanilla Combine for the bindings.
The UI is as dumb as posible displaying the state from the ViewModel and sending actions to it. 
This allow to a easy migration to Redux like architecture like [TCA](https://github.com/pointfreeco/swift-composable-architecture)

## UT Coverage

![coverage_app](/coverage_app.png)
![coverage_client](/coverage_client.png)

Tests are separeted on 3 sides:

- Logic: consist on testing the [ViewModel](/UnitTests/SearchViewModelTests.swift).
- Client: consist on testing [MercadoLibre Client](/MercadoLibreClient/Tests/MercadoLibreClientLiveTests/LiveClientTests.swift).
- Integration: consist on testing [UI](/SnapshotTests/) and navigation.


## Dependencies

The proyect uses SPM for the dependencies 

- [Combine Schedulers](https://github.com/pointfreeco/combine-schedulers)
Powerful abstraction tha makes your life easier when testing combine asynchronous operations.

- [Snapshot Testing](https://github.com/pointfreeco/swift-snapshot-testing)
Snapshot anything, this allow you to improve your tests by doing thing like:
    * snapshot the entire view hierarchy as a text to easily spot differences.
    * snapshot the view state to visually check you UI.

- [Codable Utils](https://github.com/jlainog/Codable-Utils)
A personal package that leverage type inference when working with codable.

## TODO Next
* Show an alert when an error occurs. (right now the VM gets the error but is not displayed in UI)
* Improve UI by using UICollectionView + CompositionalLayout + DiffableDataSource
* Cookup Previews for Search and Detail ViewControllers
