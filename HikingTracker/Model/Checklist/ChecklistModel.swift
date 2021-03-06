//
//  ChecklistModel.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/26/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation
import Firebase

struct FirebaseCheckListService {


    private let checkListKey = "Checklist"

    init() {
//        if let userUID = Auth.auth().currentUser?.uid  {
//            print(Auth.auth().currentUser?.email)
//            ref = Database.database().reference().child(userUID).child(checkListKey)
//        }
//        else {
//            ref = nil
//        }
    }




    func clearAllCheckedValues() {
        let ref: DatabaseReference!
        let userUID = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child(userUID!).child(checkListKey)

        ref.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                for item in snapshot.children {
                    let newCheckListItem = ChecklistItem(snapshot: item as! DataSnapshot)
                    self.changeFirebaseCheckedValueForItem(newCheckListItem, checked: false)
                }
            }
        }
    }

    func manageChecklistItemsFromFirebase(completion: @escaping ([ChecklistItem]) -> Void) {
        let ref: DatabaseReference!
        let userUID = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child(userUID!).child(checkListKey)
        ref.observe(.value) { (snapshot) in
            if snapshot.exists() {
                var checkListItems = [ChecklistItem]()
                for item in snapshot.children {
                    let newCheckListItem = ChecklistItem(snapshot: item as! DataSnapshot)
                    checkListItems.append(newCheckListItem)
                }
                checkListItems.sort() {
                    $0.dateAdded > $1.dateAdded
                }
                completion(checkListItems)
            }
        }
    }

    private func convertStringDateToDate(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        let dateFromString = dateFormatter.date(from: string)
        return dateFromString
    }

    func deleteChecklistItem(_ item: ChecklistItem) {
        let ref: DatabaseReference!
        let userUID = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child(userUID!).child(checkListKey)

        ref.child(item.name).removeValue()
        
    }

    func changeFirebaseCheckedValueForItem(_ item: ChecklistItem, checked: Bool) {
        let ref: DatabaseReference!
        let userUID = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child(userUID!).child(checkListKey)

        let databaseRef = Database.database().reference()
        if let userUID = Auth.auth().currentUser?.uid {
            databaseRef.child(userUID).child("Checklist").child(item.name).child("Checked").setValue(checked)
        } else {
            print("Problem getting userUID")
        }
    }

    func uploadChecklistItemToFirebase(_ item: ChecklistItem) {
        var fireBaseDict = [String: Any]()
        let stringDate = item.dateAdded.longStringVersionForArchive
        fireBaseDict["Date"] = stringDate

        let name = item.name
        fireBaseDict["Name"] = name

        let checked = item.checked
        fireBaseDict["Checked"] = checked


        let databaseRef = Database.database().reference()
        if let userUID = Auth.auth().currentUser?.uid {
            databaseRef.child(userUID).child("Checklist").child(name).setValue(fireBaseDict)
        } else {
            print("Problem getting userUID")
        }
    }
}
