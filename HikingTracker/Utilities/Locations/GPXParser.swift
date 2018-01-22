//
//  GPXParser.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/11/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//


//Thanks To Josh Adams on github for this GTX parsing code, visit https://github.com/vermont42/GpxLocationManager

import UIKit
import CoreLocation

class GpxParser: NSObject, XMLParserDelegate {
    private var parser: XMLParser?
    private var name: String = ""
    private var locations: [CLLocation] = []
    private var buffer: String = ""
    private let dateFormatter = DateFormatter()
    private var curLatString: NSString = ""
    private var curLonString: NSString = ""
    private var curEleString: NSString = ""
    private var curTimeString: String = ""
    private var startedTrackPoints = false
    private static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    private static let accuracy: CLLocationAccuracy = 5.0
    private enum ParsingState: String {
        case Trkpt = "trkpt"
        case Name = "name"
        case Ele = "ele"
        case Time = "time"
        init() {
            self = .Name
        }
    }
    private var alreadySetName = false
    private var parsingState: ParsingState = .Name
    
    init?(file: String) {
        super.init()
        let url = Bundle.main.url(forResource: file, withExtension: "gpx")
        if url == nil {
            return nil
        }
        parser = XMLParser(contentsOf: url!)
        parser?.delegate = self
        dateFormatter.dateFormat = GpxParser.dateFormat
    }
    
    func parse() -> (String, [CLLocation]) {
        parser?.parse()
        return (name, locations)
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        switch elementName {
        case ParsingState.Trkpt.rawValue:
            curLatString = attributeDict["lat"]! as NSString
            curLonString = attributeDict["lon"]! as NSString
            parsingState = .Trkpt
            startedTrackPoints = true
        case ParsingState.Name.rawValue:
            if !alreadySetName {
                buffer = ""
                parsingState = .Name
            }
        case ParsingState.Ele.rawValue:
            buffer = ""
            parsingState = .Ele
        case ParsingState.Time.rawValue:
            if startedTrackPoints {
                buffer = ""
                parsingState = .Time
            }
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if (startedTrackPoints || (parsingState == .Name && !alreadySetName)) && string != "\n" {
            buffer = buffer + string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case ParsingState.Trkpt.rawValue:
            locations.append(CLLocation(coordinate: CLLocationCoordinate2D(latitude: curLatString.doubleValue, longitude: curLonString.doubleValue), altitude: curEleString.doubleValue, horizontalAccuracy: GpxParser.accuracy, verticalAccuracy: GpxParser.accuracy, timestamp: dateFormatter.date(from: curTimeString)!))
        case ParsingState.Name.rawValue:
            name = buffer
            alreadySetName = true
        case ParsingState.Ele.rawValue:
            curEleString = buffer as NSString
        case ParsingState.Time.rawValue:
            if startedTrackPoints {
                curTimeString = buffer
            }
        default:
            break
        }
    }
}





