//
//  MapRegionUtility.swift
//  Loci
//
//  Created by Sam McGarry on 1/11/21.
//

import UIKit
import MapKit

public enum GeographicRegion: String {
    
    /*
     Where'd these numbers come from?
     1) go to https://boundingbox.klokantech.com
     2) In "Find Place With Google", type whatever you want a bounding box for
     3) Select "CSV RAW" and copy.
     
     Copied format is as follows:
     
     bbox = minLongitude , minLatitude , maxLongitude , maxLatitude
     
     Don't like the spans? Feel free to change them at the site above
     
     */
    
    case asia = "25.5886467,-12.2118513,-168.97788,81.9661865"
    case africa = "-25.383911,-47.1313489,63.8085939,37.5359"
    case northAmerica = "-172.66113495,5.4961,-15.51269745,83.6655766261"
    case southAmerica = "-110.0281,-56.1455,-28.650543,17.6606999"
    case antarctica = "-180.0,-85.0511287798,180.0,-60.1086999"
    case europe = "-25.48824365,32.5960451596,74.3555001,73.1927977675"
    case australia = "110.9510339,-54.8337658,159.2872223,-9.1870264"
    
    case pacificOcean = "128.576489,-77.8225785,-66.5190814,59.4822293"
    case atlanticOcean = "-83.2160952,-83.0204773,20.0000002,68.6187516"
    case indianOcean = "13.0882271,-61.8516375745,146.9166667,25.9666428755"
    case antarcticOcean = "-160.2500533,-68.4421138,-160.2180385,-68.4339125"
    case arcticOcean = "-68.9751267,62.8298713,-55.6975281,67.708443"
}


public class RegionUtility{
    
    public static func region(region: GeographicRegion) -> MKCoordinateRegion {
        return MKCoordinateRegion(coordinates: bboxCoordinates(from: region.rawValue))!
    }
    
    public static func bboxCoordinates(from coordinateString: String) -> [CLLocationCoordinate2D] {
        var coordinateArray: [CLLocationCoordinate2D] = []
        let boundingBoxArray: [Double] = coordinateString.components(separatedBy: ",").map{Double($0)!}
        
        let max = CLLocationCoordinate2D(latitude: boundingBoxArray[1], longitude: boundingBoxArray[0])
        let min = CLLocationCoordinate2D(latitude: boundingBoxArray[3], longitude: boundingBoxArray[2])
        coordinateArray = [min, max]
        
        return coordinateArray
    }
}

extension MKCoordinateRegion {
    
    // From: https://gist.github.com/dionc/46f7e7ee9db7dbd7bddec56bd5418ca6
    init?(coordinates: [CLLocationCoordinate2D]) {
        
        // first create a region centered around the prime meridian
        let primeRegion = MKCoordinateRegion.region(for: coordinates, transform: { $0 }, inverseTransform: { $0 })
        
        // next create a region centered around the 180th meridian
        let transformedRegion = MKCoordinateRegion.region(for: coordinates, transform: MKCoordinateRegion.transform, inverseTransform: MKCoordinateRegion.inverseTransform)
        
        // return the region that has the smallest longitude delta
        if let a = primeRegion,
           let b = transformedRegion,
           let min = [a, b].min(by: { $0.span.longitudeDelta < $1.span.longitudeDelta }) {
            self = min
        }
        
        else if let a = primeRegion {
            self = a
        }
        
        else if let b = transformedRegion {
            self = b
        }
        
        else {
            return nil
        }
    }
    
    // Latitude -180...180 -> 0...360
    private static func transform(c: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        if c.longitude < 0 { return CLLocationCoordinate2DMake(c.latitude, 360 + c.longitude) }
        return c
    }
    
    // Latitude 0...360 -> -180...180
    private static func inverseTransform(c: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        if c.longitude > 180 { return CLLocationCoordinate2DMake(c.latitude, -360 + c.longitude) }
        return c
    }
    
    private typealias Transform = (CLLocationCoordinate2D) -> (CLLocationCoordinate2D)
    
    private static func region(for coordinates: [CLLocationCoordinate2D], transform: Transform, inverseTransform: Transform) -> MKCoordinateRegion? {
        
        // handle empty array
        guard !coordinates.isEmpty else { return nil }
        
        // handle single coordinate
        guard coordinates.count > 1 else {
            return MKCoordinateRegion(center: coordinates[0], span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        }
        
        let transformed = coordinates.map(transform)
        
        // find the span
        let minLat = transformed.min { $0.latitude < $1.latitude }!.latitude
        let maxLat = transformed.max { $0.latitude < $1.latitude }!.latitude
        let minLon = transformed.min { $0.longitude < $1.longitude }!.longitude
        let maxLon = transformed.max { $0.longitude < $1.longitude }!.longitude
        let span = MKCoordinateSpan(latitudeDelta: maxLat - minLat, longitudeDelta: maxLon - minLon)
        
        // find the center of the span
        let center = inverseTransform(CLLocationCoordinate2DMake((maxLat - span.latitudeDelta / 2), maxLon - span.longitudeDelta / 2))
        
        return MKCoordinateRegion(center: center, span: span)
    }
}
