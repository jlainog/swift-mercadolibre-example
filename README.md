#  Mercado Libre Example

A simple example app that uses MercadoLibre API to search for products.

![gif](/RocketSim.gif)

## Architecture

It uses the architectural pattern MVVM + Vanilla Combine for the bindings.
The UI is as dumb as posible displaying the state from the ViewModel and sending actions to it. 
This allow to a easy migration to Redux like architecture like [TCA](https://github.com/pointfreeco/swift-composable-architecture)

## UT Coverage
![coverage](/coverage.png)

Tests are separeted on 3 sides:

- Logic: consist on testing the [ViewModel](/MercadoLibreExampleTests/SearchViewModelTests.swift).
- Client: consist on testing [MercadoLibre Client](/MercadoLibreExampleTests/MercadoLibreApiTests.swift).
- Integration: consist on testing [UI](/MercadoLibreTests/SearchViewModelTests.swift) and navigation.


## Dependencies

The proyect uses SPM for the dependencies 

[Combine Schedulers](https://github.com/pointfreeco/combine-schedulers)
Powerful abstraction tha makes your life easier when testing combine asynchronous operations.

[Snapshot Testing](https://github.com/pointfreeco/swift-snapshot-testing)
Snapshot anything, this allow you to improve your tests by doing thing like:
* snapshot the entire view hierarchy as a text to easily spot differences.
* snapshot the view state to visually check you UI.

[Codable Utils](https://github.com/jlainog/Codable-Utils)
A personal package that leverage type inference when working with codable.

## TODO Next

* Improve UI by using UICollectionView + CompositionalLayout + DiffableDataSource
* Separate *Mercado Libre Client* to its own package to make more explicitly the depency to it
* Separate *Mercado Libre Live Implementation* so it is only imported and used on the SceneDelegate when launching the app
* Cookup Previews for Search and Detail ViewControllers
