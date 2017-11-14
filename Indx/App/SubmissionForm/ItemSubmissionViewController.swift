//
//  ItemSubmissionViewController.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/15/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit
import JGProgressHUD
import CoreLocation
import GooglePlaces
import GooglePlacePicker


class ItemSubmissionViewController: UIViewController {

    // MARK: - properties
    
    @IBOutlet weak var entryTypeSegment: UISegmentedControl!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var detailField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    private var placePicker: GMSPlacePicker? = nil
    private var place: GMSPlace? = nil {
        didSet { locationLabel.text = place?.name }
    }
    
    // MARK: view lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.backgroundColor = App.tint
    }
    
    // MARK: private methods
    
    private func validateAndSubmitForm() {
        
        var form = SubmissionForm()
        
        switch entryTypeSegment.selectedSegmentIndex {
        case 0: form.kind = .project
        case 1: form.kind = .tool
        case 2: form.kind = .material
        default: fatalError("unexpected segment index: \(entryTypeSegment.selectedSegmentIndex)")
        }
        
        form.name = nameField.text ?? ""
        form.description = detailField.text ?? ""
        
        if let place = self.place {
            
            form.locationName = place.name
            form.locationAddress = place.formattedAddress
            form.coordinates = Coordinates(coordinates2d: place.coordinate)
        }
        
        if let error = form.validate() {
            let alert = UIAlertController.errorAlert(message: error)
            present(alert, animated: true, completion: nil)
        } else {
            let hud = JGProgressHUD(style: .dark)!
            hud.show(in: view)
            
            App.fire.data.submit(form: form) { opError in
                hud.dismiss()
                
                if let error = opError {
                    let alert = UIAlertController.errorAlert(message: error.localizedDescription)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let presentingController = self.presentingViewController!
                    self.dismiss(animated: true) {
                        let alert = UIAlertController.infoAlert(
                            title: NSLocalizedString("ALERT_TITLE_THANK_YOU", comment: ""),
                            message: NSLocalizedString("ALERT_MSG_THANK_YOU", comment: "")
                        )
                        presentingController.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    // MARK: actions
    
    @IBAction func setLocationPressed(_ sender: AnyObject) {
        
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace { (opPlace: GMSPlace?, opError: Error?) in
            
            self.placePicker = nil
            
            switch (opPlace, opError) {
            case (.some(let place), _):
                self.place = place
            case (_, .some(let error)):
                NSLog("[ERR]: place picker errored - \(error.localizedDescription)")
            case (.none, .none):
                break // no place was selected
            default:
                NSLog("[ERR]: unexpected callback combination")
            }
        }
    
        self.placePicker = placePicker
    }
        
    @IBAction func submitPressed(_ sender: AnyObject) {
        validateAndSubmitForm()
    }
}


extension ItemSubmissionViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == nameField {
            detailField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        
        return false
    }
}


