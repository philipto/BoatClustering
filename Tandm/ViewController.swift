/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The main view controller containing the map view and acting as the map view's delegate.
*/
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    // Create a location manager to trigger user tracking
    let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        return manager
    }()
    
    func setupCompassButton() {
        let compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .visible
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: compass)
        mapView.showsCompass = false
    }

    func setupUserTrackingButtonAndScaleView() {
        mapView.showsUserLocation = true
        
        let button = MKUserTrackingButton(mapView: mapView)
        button.layer.backgroundColor = UIColor.translucentButtonColor?.cgColor
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        let scale = MKScaleView(mapView: mapView)
        scale.legendAlignment = .trailing
        scale.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scale)
        
        NSLayoutConstraint.activate([button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
                                     button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
                                     scale.trailingAnchor.constraint(equalTo: button.safeAreaLayoutGuide.leadingAnchor, constant: -10),
                                     scale.centerYAnchor.constraint(equalTo: button.safeAreaLayoutGuide.centerYAnchor)])
    }

    func registerAnnotationViewClasses() {
        mapView.register(UnicycleAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(BicycleAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(TricycleAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    func loadDataForMapRegionAndBikes() {
        guard let plistURL = Bundle.main.url(forResource: "Data", withExtension: "plist") else {
            fatalError("Failed to resolve URL for `Data.plist` in bundle.")
        }

        do {
            let plistData = try Data(contentsOf: plistURL)
            let decoder = PropertyListDecoder()
            let decodedData = try decoder.decode(MapData.self, from: plistData)
            mapView.region = decodedData.region
            mapView.addAnnotations(decodedData.cycles)
        } catch {
            fatalError("Failed to load provided data, error: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCompassButton()
        setupUserTrackingButtonAndScaleView()
        registerAnnotationViewClasses()
        loadDataForMapRegionAndBikes()
    }
}

extension ViewController : MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Cycle else { return nil }

        switch annotation.type {
        case .unicycle:
            return UnicycleAnnotationView(annotation: annotation, reuseIdentifier: UnicycleAnnotationView.ReuseID)
        case .bicycle:
            return BicycleAnnotationView(annotation: annotation, reuseIdentifier: BicycleAnnotationView.ReuseID)
        case .tricycle:
            return TricycleAnnotationView(annotation: annotation, reuseIdentifier: TricycleAnnotationView.ReuseID)
        }
    }

}
