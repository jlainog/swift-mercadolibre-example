import Foundation
import MercadoLibreClient
import CombineSchedulers

struct AppDependencies {
    var mercadolibreClient: MercadoLibreClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

