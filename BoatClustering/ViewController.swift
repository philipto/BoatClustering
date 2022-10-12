/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The main view controller containing the map view and acting as the map view's delegate.
*/
import MapKit

class ViewController: UIViewController {

    @IBOutlet private weak var mapView: MKMapView!
    private var userTrackingButton: MKUserTrackingButton!
    private var scaleView: MKScaleView!
    
    // Create a location manager to trigger user tracking
    private let locationManager = CLLocationManager()
    
    private func setupCompassButton() {
        let compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .visible
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: compass)
        mapView.showsCompass = false
    }

    private func setupUserTrackingButtonAndScaleView() {
        mapView.showsUserLocation = true
        
        userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.isHidden = true // Unhides when location authorization is given.
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: userTrackingButton)
        
        // By default, `MKScaleView` uses adaptive visibility, so it only displays when zooming the map.
        // This is behavior is confirgurable with the `scaleVisibility` property.
        scaleView = MKScaleView(mapView: mapView)
        scaleView.legendAlignment = .trailing
        view.addSubview(scaleView)
        
        let stackView = UIStackView(arrangedSubviews: [scaleView, userTrackingButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
                                     stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)])
    }

    private func registerAnnotationViewClasses() {
        mapView.register(AvailableAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(PartlyBookedAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ReservedBoatAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    private func loadDataForMapRegionAndBoats() {
        guard let plistURL = Bundle.main.url(forResource: "blocations", withExtension: "plist") else {
            fatalError("Failed to resolve URL for `blocations.plist` in bundle.")
        }

        do {
            let plistData = try Data(contentsOf: plistURL)
            let decoder = PropertyListDecoder()
            let decodedData = try decoder.decode(MapData.self, from: plistData)
            
//            mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:45.1, longitude:15.2), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
            mapView.addAnnotations(decodedData.boats)
        } catch {
            fatalError("Failed to load provided data, error: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCompassButton()
        setupUserTrackingButtonAndScaleView()
        registerAnnotationViewClasses()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        loadDataForMapRegionAndBoats()
    }
}

extension ViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Boat else { return nil }

        switch annotation.type {
        case .unavailable:
            return UnavailableAnnotationView(annotation: annotation, reuseIdentifier: UnavailableAnnotationView.ReuseID)
        case .available:
            return AvailableAnnotationView(annotation: annotation, reuseIdentifier: AvailableAnnotationView.ReuseID)
        case .partlyBooked:
            return PartlyBookedAnnotationView(annotation: annotation, reuseIdentifier: PartlyBookedAnnotationView.ReuseID)
        case .reserved:
            return ReservedBoatAnnotationView(annotation: annotation, reuseIdentifier: ReservedBoatAnnotationView.ReuseID)
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
 
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let locationAuthorized = status == .authorizedWhenInUse
        userTrackingButton.isHidden = !locationAuthorized
    }
}
