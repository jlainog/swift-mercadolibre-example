#  Mercado Libre Example

A simple example app that uses MercadoLibre API to search for products.

## Architecture

It uses the architectural pattern MVVM + Vanilla Combine for the bindings.
The UI is as dumb as posible displaying the state from the ViewModel and sending actions to it. 
This allow to a easy migration to Redux like architecture like [TCA](https://github.com/pointfreeco/swift-composable-architecture)

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
