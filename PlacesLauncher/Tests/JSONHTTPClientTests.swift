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
        XCTAssertEqual(loader.requests.first?.httpMethod, HTTPMethod.get.rawValue)
        XCTAssertEqual(loader.requests.first?.cachePolicy, .useProtocolCachePolicy)
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
