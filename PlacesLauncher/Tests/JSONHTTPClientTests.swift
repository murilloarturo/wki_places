import Foundation
import XCTest
@testable import PlacesLauncher

final class JSONHTTPClientTests: XCTestCase {
    func testFetchGenericallyDecodesSuccessfulHTTPResponse() async throws {
        let data = feedData(name: "Copenhagen")
        let loader = StubHTTPDataLoader(responses: [
            .success((data, httpResponse(status: 200)))
        ])
        let client = JSONHTTPClient(dataLoader: loader)

        let response = try await client.fetch(
            LocationFeedDTO.self,
            from: LocationFeedEndpoint.assignment
        )

        XCTAssertEqual(response.locations, [
            LocationDTO(name: "Copenhagen", latitude: 55.6713442, longitude: 12.523785)
        ])
        XCTAssertEqual(loader.requests.map(\.url), [LocationFeedEndpoint.assignment.url])
    }

    func testFetchUsesCachedResponseForThirtyMinutesThenReloads() async throws {
        let clock = TestClock(now: Date(timeIntervalSince1970: 1_000))
        let loader = StubHTTPDataLoader(responses: [
            .success((feedData(name: "First"), httpResponse(status: 200))),
            .success((feedData(name: "Fresh"), httpResponse(status: 200)))
        ])
        let client = JSONHTTPClient(dataLoader: loader, now: { clock.now })

        let first = try await client.fetch(
            LocationFeedDTO.self,
            from: LocationFeedEndpoint.assignment
        )
        clock.advance(by: 29 * 60)
        let cached = try await client.fetch(
            LocationFeedDTO.self,
            from: LocationFeedEndpoint.assignment
        )
        clock.advance(by: 61)
        let fresh = try await client.fetch(
            LocationFeedDTO.self,
            from: LocationFeedEndpoint.assignment
        )

        XCTAssertEqual(first.locations.first?.name, "First")
        XCTAssertEqual(cached.locations.first?.name, "First")
        XCTAssertEqual(fresh.locations.first?.name, "Fresh")
        XCTAssertEqual(loader.requests.count, 2)
    }

    func testFetchMapsHTTPFailure() async {
        let loader = StubHTTPDataLoader(responses: [
            .success((Data(), httpResponse(status: 503)))
        ])
        let client = JSONHTTPClient(dataLoader: loader)

        do {
            _ = try await client.fetch(
                LocationFeedDTO.self,
                from: LocationFeedEndpoint.assignment
            )
            XCTFail("Expected an HTTP status error")
        } catch {
            XCTAssertEqual(error as? HTTPClientError, .httpStatus(503))
        }
    }

    func testFetchMapsMalformedJSONToDecodingError() async {
        let loader = StubHTTPDataLoader(responses: [
            .success((Data("not-json".utf8), httpResponse(status: 200)))
        ])
        let client = JSONHTTPClient(dataLoader: loader)

        do {
            _ = try await client.fetch(
                LocationFeedDTO.self,
                from: LocationFeedEndpoint.assignment
            )
            XCTFail("Expected a decoding error")
        } catch {
            XCTAssertEqual(error as? HTTPClientError, .decodingFailed)
        }
    }

    private func feedData(name: String) -> Data {
        Data(
            """
            {"locations":[{"name":"\(name)","lat":55.6713442,"long":12.523785}]}
            """.utf8
        )
    }

    private func httpResponse(status: Int) -> HTTPURLResponse {
        HTTPURLResponse(
            url: LocationFeedEndpoint.assignment.url,
            statusCode: status,
            httpVersion: nil,
            headerFields: nil
        )!
    }
}

private final class StubHTTPDataLoader: HTTPDataLoading {
    private var responses: [Result<(Data, URLResponse), Error>]
    private(set) var requests: [URLRequest] = []

    init(responses: [Result<(Data, URLResponse), Error>]) {
        self.responses = responses
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        requests.append(request)
        return try responses.removeFirst().get()
    }
}

private final class TestClock {
    private(set) var now: Date

    init(now: Date) {
        self.now = now
    }

    func advance(by interval: TimeInterval) {
        now.addTimeInterval(interval)
    }
}
