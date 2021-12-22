//
//  ViewController.swift
//  ToyDonation
//
//  Created by user195143 on 12/21/21.
//

import UIKit
import Firebase

class ToyDonationFormViewController: UIViewController {

    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var segmentControlState: UISegmentedControl!
    @IBOutlet weak var textFieldDonor: UITextField!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var buttonSave: UIButton!
    
    let collection = "toyDonation"
    lazy var firestore: Firestore = {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        
        let firestore = Firestore.firestore()
        firestore.settings = settings
        
        return firestore
    }()
    var listener: ListenerRegistration!

    var toyDonation: ToyDonation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let toyDonation = toyDonation {
            title = "Edição"
            textFieldName.text = toyDonation.name
            segmentControlState.selectedSegmentIndex = toyDonation.state
            textFieldDonor.text = toyDonation.donor
            textFieldAddress.text = toyDonation.address
            textFieldPhone.text = toyDonation.phone

            buttonSave.setTitle("Alterar", for: .normal)
        }
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func saveToyDonation(_ sender: UIButton) {
        guard let name = textFieldName.text,
              let donor = textFieldDonor.text,
              let address = textFieldAddress.text,
              let phone = textFieldPhone.text else { return }

        let data: [String: Any] = [
            "name": name,
            "state": segmentControlState.selectedSegmentIndex,
            "donor": donor,
            "address": address,
            "phone": phone
        ]
        
        if let toyDonation = toyDonation {
            self.firestore.collection(self.collection).document(toyDonation.id).updateData(data)
        } else {
            self.firestore.collection(self.collection).addDocument(data: data)
        }
        
        self.navigationController?.popViewController(animated: true)
    }

}

