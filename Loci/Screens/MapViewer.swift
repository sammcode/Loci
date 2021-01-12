//
//  MapViewer.swift
//  Loci
//
//  Created by Sam McGarry on 1/9/21.
//

import UIKit
import MapKit

class MapViewer: UIViewController {
    
    var mapView: MKMapView!
    var worldButton: ImageButton = ImageButton(image: Images.globe!)
    var currentPinType: UIImage = Images.filledperson!
    let defaultPinType: PinType = PinType(name: "Pin", image: Images.filledpin!)
    
    var pins: [Pin] = []
    var pintypes: [PinType] = []
    
    var annotations: [MKAnnotation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpMapView()
        setUpWorldButton()
        
        getPinsAndPinTypes()
        addPinsToMap()
        print(pins)
        
    }
    
    func getPinsAndPinTypes(){
        pins = PersistenceManager.retrievePins()
        pintypes = PersistenceManager.retrievePinTypes()
    }
    
    func addPinsToMap(){
        for pin in pins {
            addAnnotation(coordinate: pin.coordinate, title: pin.title!, subtitle: pin.subtitle ?? "")
        }
    }
    
    func setUpMapView() {
        mapView = MKMapView(frame: view.frame)
        view.addSubview(mapView)
        setUpMapViewConstraints()
        addGestureRecognizerToMapView()
        mapView.delegate = self
        mapView.mapType = MKMapType.satellite
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
    }
    
    func setUpMapViewConstraints() {
        mapView.frame = view.frame
    }
    
    func setUpWorldButton(){
        view.addSubview(worldButton)
        worldButton.adjustsImageWhenHighlighted = false
        setUpWorldButtonConstraints()
        addTargetToWorldButton()
    }
    
    func setUpWorldButtonConstraints(){
        worldButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            worldButton.heightAnchor.constraint(equalToConstant: 80),
            worldButton.widthAnchor.constraint(equalToConstant: 80),
            worldButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            worldButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    func addTargetToWorldButton() {
        worldButton.addTarget(self, action: #selector(worldButtonTapped), for: .touchUpInside)
    }
    
    @objc func worldButtonTapped(){
        worldButton.pulsate()
        let region = RegionUtility.region(region: .northAmerica)
        mapView.setRegion(region, animated: true)
    }
    
    func addGestureRecognizerToMapView(){
        let longTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLongTap))
            mapView.addGestureRecognizer(longTapGesture)
    }
    
    @objc func handleLongTap(gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        let pin = Pin()
        pin.coordinate = coordinate
        pin.title = "My Pin"
        pin.subtitle = defaultPinType.name
        pin.Pintype = defaultPinType
        
        print("JFKLASD:JFKLJASK:LFJK:")
        
        print(pin.coordinate.latitude)
        
        PersistenceManager.saveNewPin(pin: pin)
        addAnnotation(coordinate: coordinate, title: pin.title!, subtitle: pin.subtitle!)
    }
    
    func addAnnotation(coordinate: CLLocationCoordinate2D, title: String, subtitle: String){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = subtitle
        self.mapView.addAnnotation(annotation)
        print("**********")
    }
}

extension MapViewer: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if(pinView == nil) {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
        }
        pinView?.image = currentPinType
        pinView!.frame.size = CGSize(width: 40, height: 40)
        return pinView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("tapped on pin ")
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let doSomething = view.annotation?.title! {
               print("do something")
            }
        }
    }
}
