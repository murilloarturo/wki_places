import Foundation

enum LocationFeedEndpoint {
    static let assignment = URL(
        string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json"
    )!
}

protocol HTTPDataLoading {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: HTTPDataLoading {}

protocol LocationFeedClient {
    func fetchLocations() async throws -> [PlaceLocation]
}

enum LocationFeedError: LocalizedError, Equatable {
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

struct URLSessionLocationFeedClient: LocationFeedClient {
    private let endpoint: URL
    private let dataLoader: any HTTPDataLoading
    private let decoder: JSONDecoder

    init(
        endpoint: URL = LocationFeedEndpoint.assignment,
        dataLoader: any HTTPDataLoading = URLSession.shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.endpoint = endpoint
        self.dataLoader = dataLoader
        self.decoder = decoder
    }

    func fetchLocations() async throws -> [PlaceLocation] {
        let (data, response) = try await dataLoader.data(from: endpoint)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw LocationFeedError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw LocationFeedError.httpStatus(httpResponse.statusCode)
        }

        do {
            return try decoder.decode(LocationFeedResponse.self, from: data).locations
        } catch {
            throw LocationFeedError.decodingFailed
        }
    }
}
