protocol RandomIndexGenerating {
    func nextIndex(upperBound: Int) -> Int
}

struct SystemRandomIndexGenerator: RandomIndexGenerating {
    func nextIndex(upperBound: Int) -> Int {
        Int.random(in: 0..<upperBound)
    }
}

struct SuggestionPicker {
    private let random: any RandomIndexGenerating

    init(random: any RandomIndexGenerating = SystemRandomIndexGenerator()) {
        self.random = random
    }

    func surprise(from suggestions: [SuggestedPlace]) -> SuggestedPlace? {
        guard !suggestions.isEmpty else { return nil }
        let index = random.nextIndex(upperBound: suggestions.count)
        guard suggestions.indices.contains(index) else { return nil }
        return suggestions[index]
    }
}
