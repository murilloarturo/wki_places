import Foundation
import XCTest
@testable import PlacesLauncher

final class FetchLocationsUseCaseTests: XCTestCase {
    func testFetchesDTOFromConfiguredEndpointAndReturnsMappedDomainModels() async throws {
        let client = FetchLocationsHTTPClient(
            result: .success(
                LocationFeedDTO(locations: [
                    LocationDTO(name: "Copenhagen", latitude: 55.6713442, longitude: 12.523785)
                ])
            )
        )
        let endpoint = HTTPEndpoint(
            url: URL(string: "https://example.com/places")!,
            cacheLifetime: 60
        )
        let useCase = DefaultFetchLocationsUseCase(httpClient: client, endpoint: endpoint)

        let locations = try await useCase.execute()

        XCTAssertEqual(locations, [
            PlaceLocation(name: "Copenhagen", latitude: 55.6713442, longitude: 12.523785)
        ])
        XCTAssertEqual(client.requestedEndpoints, [endpoint])
    }

    func testPropagatesClientFailure() async {
        let client = FetchLocationsHTTPClient(
            result: .failure(HTTPClientError.httpStatus(503))
        )
        let useCase = DefaultFetchLocationsUseCase(httpClient: client)

        do {
            _ = try await useCase.execute()
            XCTFail("Expected the client error")
        } catch {
            XCTAssertEqual(error as? HTTPClientError, .httpStatus(503))
        }
    }
}

private final class FetchLocationsHTTPClient: HTTPClient {
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
            throw TestUseCaseError.unexpectedType
        }
        return value
    }
}

private enum TestUseCaseError: Error {
    case unexpectedType
}
