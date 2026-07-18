import Foundation

struct PlacesDeepLink: Equatable {
    let latitude: Double
    let longitude: Double

    init?(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let scheme = components.scheme?.lowercased(),
              ["wikipedia", "wikipedia-official"].contains(scheme),
              components.host?.lowercased() == "places" else {
            return nil
        }

        let queryItems = components.queryItems ?? []
        let latitudeItems = queryItems.filter { $0.name == "lat" }
        let longitudeItems = queryItems.filter { $0.name == "lon" || $0.name == "long" }

        guard latitudeItems.count == 1,
              longitudeItems.count == 1,
              let latitudeString = latitudeItems.first?.value,
              let longitudeString = longitudeItems.first?.value,
              let latitude = Double(latitudeString),
              let longitude = Double(longitudeString),
              latitude.isFinite,
              longitude.isFinite,
              (-90...90).contains(latitude),
              (-180...180).contains(longitude) else {
            return nil
        }

        self.latitude = latitude
        self.longitude = longitude
    }

    fileprivate init?(userInfo: [AnyHashable: Any]?) {
        guard let latitude = userInfo?[Self.latitudeUserInfoKey] as? Double,
              let longitude = userInfo?[Self.longitudeUserInfoKey] as? Double,
              latitude.isFinite,
              longitude.isFinite,
              (-90...90).contains(latitude),
              (-180...180).contains(longitude) else {
            return nil
        }

        self.latitude = latitude
        self.longitude = longitude
    }

    private static let latitudeUserInfoKey = "WMFPlacesLatitude"
    private static let longitudeUserInfoKey = "WMFPlacesLongitude"

    func add(to activity: NSUserActivity) {
        var userInfo = activity.userInfo ?? [:]
        userInfo[Self.latitudeUserInfoKey] = latitude
        userInfo[Self.longitudeUserInfoKey] = longitude
        activity.userInfo = userInfo
    }
}

extension NSUserActivity {
    var wmf_placesDeepLink: PlacesDeepLink? {
        PlacesDeepLink(userInfo: userInfo)
    }
}
