import XCTest
@testable import PlacesLauncher

final class FetchLocationsUseCaseTests: XCTestCase {
    func testFetchesFeedFromProviderAndReturnsMappedDomainModels() async throws {
        let provider = StubLocationsProvider(
            feedResult: .success(
                LocationFeedDTO(locations: [
                    LocationDTO(name: "Copenhagen", latitude: 55.6713442, longitude: 12.523785)
                ])
            )
        )
        let useCase = DefaultFetchLocationsUseCase(provider: provider)

        let locations = try await useCase.execute()

        XCTAssertEqual(locations, [
            PlaceLocation(name: "Copenhagen", latitude: 55.6713442, longitude: 12.523785)
        ])
        XCTAssertEqual(provider.feedCallCount, 1)
        XCTAssertEqual(provider.catalogCallCount, 0)
    }

    func testPropagatesProviderFailure() async {
        let provider = StubLocationsProvider(
            feedResult: .failure(HTTPClientError.httpStatus(503))
        )
        let useCase = DefaultFetchLocationsUseCase(provider: provider)

        do {
            _ = try await useCase.execute()
            XCTFail("Expected the client error")
        } catch {
            XCTAssertEqual(error as? HTTPClientError, .httpStatus(503))
        }
    }
}
