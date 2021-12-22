//
//  ToyDonationListTableViewController.swift
//  ToyDonation
//
//  Created by user195143 on 12/21/21.
//

import UIKit
import Firebase

class ToyDonationListTableViewController: UITableViewController {

    let collection = "toyDonation"
    var toyDonationList: [ToyDonation] = []
    lazy var firestore: Firestore = {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        
        let firestore = Firestore.firestore()
        firestore.settings = settings
        
        return firestore
    }()
    var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadToyDonationList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let toyDoantionFormViewController = segue.destination as? ToyDonationFormViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            toyDoantionFormViewController.toyDonation = toyDonationList[indexPath.row]
        }
    }
   
    func loadToyDonationList() {
        listener = firestore.collection(collection).order(by: "name", descending: false).addSnapshotListener(includeMetadataChanges: true, listener: { (snapshot, error) in
            if let error = error {
                print(error)
                return
            } else {
                guard let snapshot = snapshot else { return }
                print("Total de documentos alterados: \(snapshot.documentChanges.count)")
                if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0 {
                    self.showItemsFrom(snapshot)
                }
            }
        })
    }
    
    func showItemsFrom(_ snapshot: QuerySnapshot) {
        toyDonationList.removeAll()
        for document in snapshot.documents {
            let data = document.data()
            if let name = data["name"] as? String,
               let state = data["state"] as? Int,
               let donor = data["donor"] as? String,
               let address = data["address"] as? String,
               let phone = data["phone"] as? String {
                
                let toyDonation = ToyDonation(id: document.documentID, name: name, state: state, donor: donor, address: address, phone: phone)
                toyDonationList.append(toyDonation)
            }
        }
        
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toyDonationList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let toyDonation = toyDonationList[indexPath.row]
        cell.textLabel?.text = toyDonation.name
        cell.detailTextLabel?.text = toyDonation.toyState
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toyDonation = toyDonationList[indexPath.row]
            firestore.collection(collection).document(toyDonation.id).delete()
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
