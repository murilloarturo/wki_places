import Foundation
import XCTest
@testable import PlacesLauncher

final class LocationsProviderTests: XCTestCase {
    func testFetchesRemoteFeedFromConfiguredEndpoint() async throws {
        let dto = LocationFeedDTO(locations: [
            LocationDTO(name: "Copenhagen", latitude: 55.6713442, longitude: 12.523785)
        ])
        let client = LocationsProviderHTTPClient(result: .success(dto))
        let endpoint = HTTPEndpoint(
            url: URL(string: "https://example.com/places")!,
            method: .get
        )
        let provider = DefaultLocationsProvider(
            httpClient: client,
            feedEndpoint: endpoint
        )

        let feed = try await provider.fetchFeed()

        XCTAssertEqual(feed, dto)
        XCTAssertEqual(client.requestedEndpoints, [endpoint])
    }

    func testLoadsAndDecodesBundledCatalog() async throws {
        let provider = DefaultLocationsProvider(
            bundle: Bundle(for: LocationsProviderTests.self)
        )

        let catalog = try await provider.fetchCatalog()

        XCTAssertEqual(catalog.suggestions, [
            SuggestionDTO(
                id: "test-place",
                titleKey: "test.title",
                subtitleKey: "test.subtitle",
                locationNameKey: nil,
                latitude: 1.25,
                longitude: 2.5,
                symbol: "star.fill",
                tone: "cyan"
            )
        ])
    }

    func testMissingCatalogProducesClearError() async {
        let provider = DefaultLocationsProvider(
            bundle: Bundle(for: LocationsProviderTests.self),
            catalogResourceName: "missing-suggestions"
        )

        do {
            _ = try await provider.fetchCatalog()
            XCTFail("Expected a missing resource error")
        } catch {
            XCTAssertEqual(
                error as? LocationsProviderError,
                .missingResource("missing-suggestions")
            )
        }
    }
}

private final class LocationsProviderHTTPClient: HTTPClient {
    let result: Result<LocationFeedDTO, Error>
    private(set) var requestedEndpoints: [HTTPEndpoint] = []

    init(result: Result<LocationFeedDTO, Error>) {
        self.result = result
    }

    func fetch<Value: Codable>(
        _ type: Value.Type,
        from endpoint: HTTPEndpoint
    ) async throws -> Value {
        requestedEndpoints.append(endpoint)
        let dto = try result.get()
        guard let value = dto as? Value else {
            throw LocationsProviderTestError.unexpectedType
        }
        return value
    }
}

private enum LocationsProviderTestError: Error {
    case unexpectedType
}
