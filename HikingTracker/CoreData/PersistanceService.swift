//
//  PersistanceService.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/12/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation


final class PersistanceService {
    
    static let store = PersistanceService()
    
    private init() {}
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var fetchedWorkouts = [HikeWorkout]()
    
    func storeHikeWorkout(hikeWorkout: HikeWorkout, name: String) {
        let newHikeWorkout = SavedHikeWorkout(context: context)
        newHikeWorkout.startDate = hikeWorkout.startDate
        newHikeWorkout.name = name
        newHikeWorkout.endDate = hikeWorkout.endDate
        newHikeWorkout.amountOfSecondsPaused = Int64(hikeWorkout.pausedTime)
        for storedLocation in hikeWorkout.storedLocations {
            let locationToStore = Locations(context: context)
            locationToStore.altitude = storedLocation.altitude
            locationToStore.latitude = storedLocation.coordinate.latitude
            locationToStore.longitude = storedLocation.coordinate.longitude
            locationToStore.verticalAccuracy = storedLocation.verticalAccuracy
            locationToStore.horizontalAccuracy = storedLocation.horizontalAccuracy
            locationToStore.timestamp = storedLocation.timestamp
            newHikeWorkout.addToLocations(locationToStore)
        }
        do {
            try context.save()
        } catch {
            print("Problem saving to coreData")
        }
        fetchWorkouts()
        
    }
    
    //TODO: Delete Saved Hike
    
    //TODO: Edit Saved Hike
    
    func fetchWorkouts() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedHikeWorkout")
        let dateSort = NSSortDescriptor(key: "startDate", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        var fetchedHikeWorkouts = [SavedHikeWorkout]()
        do {
            try fetchedHikeWorkouts = context.fetch(fetchRequest) as! [SavedHikeWorkout]
        } catch {
            print("problem retriving workouts from coreData")
        }
        fetchedWorkouts = convertSavedHikesToRegularClass(fetchedHikeWorkouts)
    }
    
    private func convertSavedHikesToRegularClass(_ fetched: [SavedHikeWorkout]) -> [HikeWorkout] {
        var convertedHikes = [HikeWorkout]()
        for hike in fetched {
            let convertedHike = HikeWorkout()
            if let startDate = hike.startDate {
                convertedHike.startDate = startDate
            } else {
                if let firstLocationTimeStamp = fetched.first?.startDate {
                    convertedHike.startDate = firstLocationTimeStamp
                }
            }
            convertedHike.endDate = hike.endDate
            convertedHike.hikeName = hike.name!
            convertedHike.pausedTime = Double(hike.amountOfSecondsPaused)
            for coordinate in hike.locations! {
                if let savedLocation = coordinate as? Locations {
                    let coordinate = CLLocationCoordinate2DMake(savedLocation.latitude, savedLocation.longitude)
                    let newLocation = CLLocation(coordinate: coordinate,
                                                 altitude: savedLocation.altitude,
                                                 horizontalAccuracy: savedLocation.horizontalAccuracy,
                                                 verticalAccuracy: savedLocation.verticalAccuracy,
                                                 timestamp: savedLocation.timestamp!)
                    convertedHike.lastLocation = newLocation
                }
            }
            convertedHikes.append(convertedHike)
        }
        return convertedHikes
    }
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "HikingTracker")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
