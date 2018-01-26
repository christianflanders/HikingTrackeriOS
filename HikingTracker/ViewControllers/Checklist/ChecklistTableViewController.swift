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
    let checklistService = FirebaseCheckListService()


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


        checklistService.manageChecklistItemsFromFirebase() { (downloadedCheckListItems) in
            self.checklistItems = downloadedCheckListItems
            self.tableView.reloadData()
        }






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
            let selectedList = checklistItems[indexPath.row]
            checklistService.deleteChecklistItem(selectedList)
        }
    }

    // MARK: ChecklistButtonFlipped Delegate

    func checklistButtonFlipped(index: Int) { // Called by the containing Table View Cell
        print(index)
        let selectedItem = checklistItems[index]
        let checked = selectedItem.checked
        if checked {
            selectedItem.checked = false
        } else {
            selectedItem.checked = true
        }
        checklistService.changeFirebaseCheckedValueForItem(selectedItem,checked: selectedItem.checked)
    }



    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        let alert = UIAlertController(title: "Add New Checklist Entry", message: "", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Enter Entry Name"

        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            guard let text = textField.text else {return}
            let newChecklistItem = ChecklistItem(name: text, checked: false, dateAdded: Date())
            self.checklistService.uploadChecklistItemToFirebase(newChecklistItem)
            self.tableView.reloadData()
        }))
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
    }





}
