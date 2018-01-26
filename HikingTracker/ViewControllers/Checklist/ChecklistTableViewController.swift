//
//  ChecklistTableViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/13/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import UIKit
import M13Checkbox
import Firebase

class ChecklistTableViewController: UITableViewController, ChecklistButtonFlippedDelegate {


    // MARK: Enums

    // MARK: Constants



    var checklistItems = [ChecklistItem]()

    // MARK: Variables


    // MARK: Outlets

    @IBOutlet var addToChecklistView: AddItemToChecklistView!

    // MARK: Weak Vars


    // MARK: Public Variables
    var ref: DatabaseReference!
    var handle: DatabaseHandle!

    // MARK: Private Variables


    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsSelection = false

        ref = Database.database().reference()
        let userUID = Auth.auth().currentUser?.uid
        handle = ref.child(userUID!).child("Checklist").observe(.childAdded, with: { (snapshot) in
            let checkListDict = snapshot.value as? [String:Any] ?? [:]
            let name = checkListDict["Name"] as! String
            let checked = checkListDict["Checked"] as! Bool
            let date = checkListDict["Date"] as! String
            let dateFromString = self.convertStringDateToDate(string: date)
            let newChecklistItem = ChecklistItem(name: name, checked: checked, dateAdded: dateFromString!)
            self.checklistItems.append(newChecklistItem)
            self.tableView.reloadData()
        })


    }


    // MARK: IBActions


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklistItems.count

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistCell", for: indexPath) as! ChecklistTableViewCell
        cell.index = indexPath.row
        cell.delegate = self
        cell.checklistItemToDisplay = checklistItems[indexPath.row]
        cell.setUpCell()

        return cell
    }



    // MARK: Table View Editing

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: ChecklistButtonFlipped Delegate

    func checklistButtonFlipped(index: Int) {
        print(index)
        let selectedItem = checklistItems[index]
        let checked = selectedItem.checked
        if checked {
            selectedItem.checked = false
        } else {
            selectedItem.checked = true
        }
        changeFirebaseCheckedValueForItem(selectedItem,checked: selectedItem.checked)
        print(selectedItem.name)
        print(selectedItem.checked)
    }

    func changeFirebaseCheckedValueForItem(_ item: ChecklistItem, checked: Bool) {
        let databaseRef = Database.database().reference()
        if let userUID = Auth.auth().currentUser?.uid {
            databaseRef.child(userUID).child("Checklist").child(item.name).child("Checked").setValue(checked)
        } else {
            print("Problem getting userUID")
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add", message: "Add a checklist item", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = "Add Item"
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            guard let text = textField.text else {return}
            let newChecklistItem = ChecklistItem(name: text, checked: false, dateAdded: Date())
//            self.checklistItems.append(newChecklistItem)
            self.uploadChecklistItemToFirebase(newChecklistItem)
            self.tableView.reloadData()
        }))
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }


    private func convertStringDateToDate(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        let dateFromString = dateFormatter.date(from: string)
        return dateFromString
    }

    private func uploadChecklistItemToFirebase(_ item: ChecklistItem) {
        var fireBaseDict = [String: Any]()
         let stringDate = item.dateAdded.displayString
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
