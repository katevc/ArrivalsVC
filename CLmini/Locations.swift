//
//  Locations.swift
//  CLmini
//
//  Created by Kate Carlton on 3/12/21.
//

import UIKit
import MapKit
import CoreLocation

class Locations: NSObject, MKAnnotation {
    enum EventType: String {
      case onEntry = "On Entry"
      case onExit = "On Exit"
    }

    enum CodingKeys: String, CodingKey {
      case latitude, longitude, radius, identifier, note, eventType
    }

    let coordinate: CLLocationCoordinate2D
    let radius: CLLocationDistance?
    let locationName: String?
    
    init(
        radius: CLLocationDistance?,
        locationName: String?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.locationName = locationName
        self.radius = radius
        self.coordinate = coordinate

        super.init()
    }
}
