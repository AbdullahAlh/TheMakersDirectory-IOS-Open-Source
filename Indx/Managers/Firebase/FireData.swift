//
//  FireData.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/14/16.
//  Copyright © 2016 level3. All rights reserved.
//

import Foundation
import FirebaseDatabase


final class FireData {
    
    // MARK: - properties
    
    lazy var root: FIRDatabaseReference = FIRDatabase.database().reference()
    
    lazy var projects: FIRDatabaseReference = self.root.child("Project")
    lazy var locations: FIRDatabaseReference = self.root.child("Location")
    lazy var materials: FIRDatabaseReference = self.root.child("Material")
    lazy var tools: FIRDatabaseReference = self.root.child("Tool")
    lazy var addForm: FIRDatabaseReference = self.root.child("add-form")
    
    
    // MARK: - public methods
    
    func setup() {
        FIRDatabase.database().persistenceEnabled = true
    }
    
    func submit(form: SubmissionForm, callback: @escaping (Error?) -> ()) {
        
        var submission = form.asDict
        submission["user"] = App.fire.auth.currentUser!.uid
        
        addForm.childByAutoId().updateChildValues(submission) { (opError, fireRef) in
            
            var error: Error? = nil
            switch opError {
            case .some(let err):
                error = err
                NSLog("[ERR]: form submission failed. \(err.localizedDescription)")
                
            case .none:
                NSLog("[INFO]: successful item submission")
            }
            
            callback(error)
        }
    }
    
}
