import Foundation

struct HTTPEndpoint: Equatable {
    let url: URL
}

enum LocationFeedEndpoint {
    static let assignment = HTTPEndpoint(
        url: URL(
            string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json"
        )!
    )
}

protocol HTTPDataLoading {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: HTTPDataLoading {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request, delegate: nil)
    }
}

protocol HTTPClient {
    func fetch<Value: Codable>(
        _ type: Value.Type,
        from endpoint: HTTPEndpoint
    ) async throws -> Value
}

enum HTTPClientError: LocalizedError, Equatable {
    case invalidResponse
    case httpStatus(Int)
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return L10n.Feed.Error.invalidResponse
        case let .httpStatus(status):
            return L10n.Feed.Error.httpStatus(status)
        case .decodingFailed:
            return L10n.Feed.Error.decoding
        }
    }
}

struct JSONHTTPClient: HTTPClient {
    private let dataLoader: any HTTPDataLoading
    private let decoder: JSONDecoder

    init(
        dataLoader: (any HTTPDataLoading)? = nil,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.dataLoader = dataLoader ?? URLSession.shared
        self.decoder = decoder
    }

    func fetch<Value: Codable>(
        _ type: Value.Type,
        from endpoint: HTTPEndpoint
    ) async throws -> Value {
        let request = URLRequest(
            url: endpoint.url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        let (data, response) = try await dataLoader.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HTTPClientError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw HTTPClientError.httpStatus(httpResponse.statusCode)
        }

        return try decode(type, from: data)
    }

    private func decode<Value: Codable>(
        _ type: Value.Type,
        from data: Data
    ) throws -> Value {
        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw HTTPClientError.decodingFailed
        }
    }
}
