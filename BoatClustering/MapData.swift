/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The structures representing the map's location and data.
*/

import MapKit
import CoreLocation

struct MapData: Decodable {
    let boats: [Boat]

    let centerLatitude: CLLocationDegrees = 45.1
    let centerLongitude: CLLocationDegrees = 15.2
    let latitudeDelta: CLLocationDegrees = 10
    let longitudeDelta: CLLocationDegrees

    var region: MKCoordinateRegion {
        let center = CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        return MKCoordinateRegion(center: center, span: span)
    }
}
