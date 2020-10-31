import Foundation
import CombineSchedulers

struct AppDependencies {
    var mercadolibreClient: MercadoLibreClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

