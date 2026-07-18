protocol LocationFeedMapping {
    func map(_ dto: LocationFeedDTO) -> [PlaceLocation]
}

struct LocationFeedMapper: LocationFeedMapping {
    func map(_ dto: LocationFeedDTO) -> [PlaceLocation] {
        dto.locations.map { location in
            PlaceLocation(
                name: location.name,
                latitude: location.latitude,
                longitude: location.longitude
            )
        }
    }
}
