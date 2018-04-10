/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The annotation data object representing all types of cycles.
*/

import MapKit

enum CycleType: Int, Decodable {
    case unicycle
    case bicycle
    case tricycle
}

class Cycle: NSObject, Decodable, MKAnnotation {
    var type: CycleType = .unicycle

    var latitude: CLLocationDegrees = 0
    var longitude: CLLocationDegrees = 0

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
