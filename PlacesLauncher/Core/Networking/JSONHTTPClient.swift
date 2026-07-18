import Foundation

struct HTTPEndpoint: Equatable {
    let url: URL
    let cacheLifetime: TimeInterval
}

enum LocationFeedEndpoint {
    static let assignment = HTTPEndpoint(
        url: URL(
            string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json"
        )!,
        cacheLifetime: 30 * 60
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

actor HTTPResponseCache {
    private struct Entry {
        let data: Data
        let expiresAt: Date
    }

    private var entries: [URL: Entry] = [:]

    func data(for url: URL, at date: Date) -> Data? {
        guard let entry = entries[url] else { return nil }
        guard entry.expiresAt > date else {
            entries[url] = nil
            return nil
        }
        return entry.data
    }

    func insert(_ data: Data, for url: URL, expiresAt: Date) {
        entries[url] = Entry(data: data, expiresAt: expiresAt)
    }
}

struct JSONHTTPClient: HTTPClient {
    private let dataLoader: any HTTPDataLoading
    private let decoder: JSONDecoder
    private let cache: HTTPResponseCache
    private let now: () -> Date

    init(
        dataLoader: (any HTTPDataLoading)? = nil,
        decoder: JSONDecoder = JSONDecoder(),
        cache: HTTPResponseCache = HTTPResponseCache(),
        now: @escaping () -> Date = Date.init
    ) {
        self.dataLoader = dataLoader ?? Self.makeSession()
        self.decoder = decoder
        self.cache = cache
        self.now = now
    }

    func fetch<Value: Codable>(
        _ type: Value.Type,
        from endpoint: HTTPEndpoint
    ) async throws -> Value {
        let requestDate = now()
        if let cachedData = await cache.data(for: endpoint.url, at: requestDate) {
            return try decode(type, from: cachedData)
        }

        let (data, response) = try await dataLoader.data(for: URLRequest(url: endpoint.url))
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HTTPClientError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw HTTPClientError.httpStatus(httpResponse.statusCode)
        }

        let value = try decode(type, from: data)
        await cache.insert(
            data,
            for: endpoint.url,
            expiresAt: requestDate.addingTimeInterval(endpoint.cacheLifetime)
        )
        return value
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

    private static func makeSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.urlCache = nil
        return URLSession(configuration: configuration)
    }
}
