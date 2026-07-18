import Foundation
import XCTest
@testable import PlacesLauncher

final class LocationFeedClientTests: XCTestCase {
    func testFetchDecodesLocationsForSuccessfulHTTPResponse() async throws {
        let data = Data(
            #"{"locations":[{"name":"Copenhagen","lat":55.6713442,"long":12.523785}]}"#.utf8
        )
        let loader = StubHTTPDataLoader(result: .success((data, httpResponse(status: 200))))
        let client = URLSessionLocationFeedClient(dataLoader: loader)

        let locations = try await client.fetchLocations()

        XCTAssertEqual(locations, [
            PlaceLocation(name: "Copenhagen", latitude: 55.6713442, longitude: 12.523785)
        ])
    }

    func testFetchMapsHTTPFailure() async {
        let loader = StubHTTPDataLoader(
            result: .success((Data(), httpResponse(status: 503)))
        )
        let client = URLSessionLocationFeedClient(dataLoader: loader)

        do {
            _ = try await client.fetchLocations()
            XCTFail("Expected an HTTP status error")
        } catch {
            XCTAssertEqual(error as? LocationFeedError, .httpStatus(503))
        }
    }

    func testFetchMapsMalformedJSONToDecodingError() async {
        let loader = StubHTTPDataLoader(
            result: .success((Data("not-json".utf8), httpResponse(status: 200)))
        )
        let client = URLSessionLocationFeedClient(dataLoader: loader)

        do {
            _ = try await client.fetchLocations()
            XCTFail("Expected a decoding error")
        } catch {
            XCTAssertEqual(error as? LocationFeedError, .decodingFailed)
        }
    }

    private func httpResponse(status: Int) -> HTTPURLResponse {
        HTTPURLResponse(
            url: URL(string: "https://example.com/locations.json")!,
            statusCode: status,
            httpVersion: nil,
            headerFields: nil
        )!
    }
}

private struct StubHTTPDataLoader: HTTPDataLoading {
    let result: Result<(Data, URLResponse), Error>

    func data(from url: URL) async throws -> (Data, URLResponse) {
        try result.get()
    }
}

