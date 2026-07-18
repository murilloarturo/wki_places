import CoreLocation
import XCTest
@testable import PlacesLauncher

final class SearchLocationUseCaseTests: XCTestCase {
    func testTrimsQueryAndReturnsSearcherResult() async throws {
        let result = PlaceSearchResult(
            title: "Apple Park",
            subtitle: "Cupertino",
            coordinate: CLLocationCoordinate2D(latitude: 37.33489, longitude: -122.00899)
        )
        let searcher = SearcherSpy(result: .success(result))
        let useCase = DefaultSearchLocationUseCase(locationSearcher: searcher)

        let received = try await useCase.execute(query: "  Apple Park  ")

        XCTAssertEqual(received.title, result.title)
        XCTAssertEqual(received.coordinate.latitude, result.coordinate.latitude)
        XCTAssertEqual(searcher.queries, ["Apple Park"])
    }

    func testRejectsBlankQueryWithoutCallingSearcher() async {
        let searcher = SearcherSpy(result: .failure(LocationSearchError.unavailable))
        let useCase = DefaultSearchLocationUseCase(locationSearcher: searcher)

        do {
            _ = try await useCase.execute(query: "   ")
            XCTFail("Expected empty-query validation")
        } catch {
            XCTAssertEqual(error as? LocationSearchError, .emptyQuery)
            XCTAssertTrue(searcher.queries.isEmpty)
        }
    }
}

private final class SearcherSpy: LocationSearching {
    let result: Result<PlaceSearchResult, Error>
    private(set) var queries: [String] = []

    init(result: Result<PlaceSearchResult, Error>) {
        self.result = result
    }

    func search(query: String) async throws -> PlaceSearchResult {
        queries.append(query)
        return try result.get()
    }
}
