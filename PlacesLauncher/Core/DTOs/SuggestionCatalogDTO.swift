import Foundation

struct SuggestionCatalogDTO: Codable, Equatable, Sendable {
    let suggestions: [SuggestionDTO]
}

struct SuggestionDTO: Codable, Equatable, Sendable {
    let id: String
    let titleKey: String
    let subtitleKey: String
    let locationNameKey: String?
    let latitude: Double
    let longitude: Double
    let symbol: String
    let tone: String
}
