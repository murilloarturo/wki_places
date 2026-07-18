import CoreLocation
import Foundation

enum CustomLocationConfirmationError: LocalizedError, Equatable {
    case noSelection

    var errorDescription: String? {
        L10n.Custom.Error.noSelection
    }
}

protocol ConfirmCustomLocationUseCase {
    func execute(
        name: String?,
        coordinate: CLLocationCoordinate2D?
    ) throws -> PlaceLocation
}

struct DefaultConfirmCustomLocationUseCase: ConfirmCustomLocationUseCase {
    func execute(
        name: String?,
        coordinate: CLLocationCoordinate2D?
    ) throws -> PlaceLocation {
        guard let coordinate else {
            throw CustomLocationConfirmationError.noSelection
        }
        try CoordinateValidator.validate(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        return PlaceLocation(
            name: name ?? L10n.Custom.droppedPinName,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
    }
}
