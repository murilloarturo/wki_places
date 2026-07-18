import XCTest
@testable import PlacesLauncher

final class LocationFeedMapperTests: XCTestCase {
    func testMapsTransportFieldsIntoDomainLocations() {
        let dto = LocationFeedDTO(locations: [
            LocationDTO(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215),
            LocationDTO(name: nil, latitude: 40.4380638, longitude: -3.7495758)
        ])

        let locations = LocationFeedMapper().map(dto)

        XCTAssertEqual(locations, [
            PlaceLocation(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215),
            PlaceLocation(name: nil, latitude: 40.4380638, longitude: -3.7495758)
        ])
    }
}
