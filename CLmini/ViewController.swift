//
//  ViewController.swift
//  CLmini
//
//  Created by Kate Carlton on 3/11/21.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    lazy var locationManager = CLLocationManager() //not calculated until 1st use
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // sets VC as delegate of location manager
        locationManager.delegate = self
        // requests user to authorize location access for when app is being used
        locationManager.requestWhenInUseAuthorization()
        
    }
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Arrived at: \(region.identifier)")
        arrivalAlert(message: "Arrived at: \(region.identifier) region.", entered: true)
        locationManager.stopUpdatingLocation() //stops fetching GPS data
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("You left: \(region.identifier)")
        arrivalAlert(message: "Exited \(region.identifier) region.", entered: false)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorized status changed")
        // gets authorization status from manager
        let status = manager.authorizationStatus
        
        if status == CLAuthorizationStatus.authorizedAlways || status == CLAuthorizationStatus.authorizedWhenInUse {
            // only show user location when authorized to do so
            mapView.showsUserLocation = (status == CLAuthorizationStatus.authorizedWhenInUse)
            
            let latitude: CLLocationDegrees = 42.076064
            let longitude: CLLocationDegrees = -71.255018
            let location: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
            
            render(location)
        } else {
            // If location access not given, can't proceed so alert user
            let message = """
            Please grant location access to enable accurate directions.
            """
            showAlert(withTitle: "Warning", message: message)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //defines how precise we want location accuracy to be - impacts battery
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation() //starts fetching GPS data
    }
    /*called when startUpdatingLocation is called - */
    /*func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /* "locations is an array of locations as they change sent from CL */
        /* we just grab first location we get and stop updating - TODO: CHANGE */
        /*if let location = locations.first {
            manager.stopUpdatingLocation()
         
            render(location)
        }*/
        let latitude: CLLocationDegrees = 42.07
        let longitude: CLLocationDegrees = -71.25
        
        let location: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        render(location)
    }*/

    /*zooms in map to the area where you are and adds pin*/
    func render(_ location: CLLocation) {
        /*declare coordinate w/ lat and long of input param*/
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let circularRegion = CLCircularRegion.init(center: coordinate,
                                                   radius: 50.0,
                                                   identifier: "Home")
        
        circularRegion.notifyOnEntry = true
        circularRegion.notifyOnExit = true
        
        locationManager.startMonitoring(for: circularRegion)
        /*
        /* sets the span on map w/ lat and long */
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: true)*/
        /*mark map to show where coord is*/
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
    
}

private extension MKMapView {
  func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

