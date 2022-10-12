/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The annotation views that represent the different types of cycles.
*/
import MapKit
import SwiftUI

private let multiAvailabilityTypeBoatsClusterID = "multipleAvailabilityTypeBoats"

/// - Tag: UnavailableAnnotationView
class UnavailableAnnotationView: MKMarkerAnnotationView {

    static let ReuseID = "unavailableAnnotation"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "unavailableBoat"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// - Tag: DisplayConfiguration
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = UIColor.gray
        let boatImage = UIImage(named: "boat")
        if #available(iOS 15.0, *) {
            glyphImage = boatImage?.withTintColor(markerTintColor ?? UIColor(Color.gray))
        } else {
            // Fallback on earlier versions
        }
    }
}

/// - Tag: AvailableAnnotationView
class AvailableAnnotationView: MKMarkerAnnotationView {

    static let ReuseID = "availableAnnotation"

    /// - Tag: ClusterIdentifier
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "availableBoat"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow
        markerTintColor = UIColor.availableColor
        let boatImage = UIImage(named: "boat")
        if #available(iOS 15.0, *) {
            glyphImage = boatImage?.withTintColor(markerTintColor ?? UIColor(Color.green))
        } else {
            // Fallback on earlier versions
        }
        
    }
}

/// - Tag: PartlyBookedAnnotationView
class PartlyBookedAnnotationView: MKMarkerAnnotationView {

    static let ReuseID = "partlyBookedAnnotation"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
//        clusteringIdentifier = multiAvailabilityTypeBoatsClusterID
        clusteringIdentifier = "partlyBookedBoat"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// - Tag: DisplayConfiguration
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = UIColor.partlyBookedColor
        let boatImage = UIImage(named: "boat")
        if #available(iOS 15.0, *) {
            glyphImage = boatImage?.withTintColor(markerTintColor ?? UIColor(Color.yellow))
        } else {
            // Fallback on earlier versions
        }
    }
}

class ReservedBoatAnnotationView: MKMarkerAnnotationView {

    static let ReuseID = "reservedAnnotation"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
//        clusteringIdentifier = multiAvailabilityTypeBoatsClusterID
        clusteringIdentifier = "reserverBoat"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = UIColor.reservedColor
        let boatImage = UIImage(named: "boat")
        if #available(iOS 15.0, *) {
            glyphImage = boatImage?.withTintColor(markerTintColor ?? UIColor(Color.red))
        } else {
            // Fallback on earlier versions
        }
    }
}
