import UIKit
import CloudKit

class ProfileVC: UIViewController {
    var userID: CKRecordID!
    @IBOutlet var nicknameField: UITextField!
    var profileRecord: CKRecord!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = CKContainer.defaultContainer().publicCloudDatabase
        db.fetchRecordWithID(self.userID) { record, error in
            // if version
            if let r = record {
                self.profileRecord = r
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.nicknameField.text = r["nickname"] as? String ?? ""
                }
            } else {
                print("error getting user record")
            }
            
            // guard version
            guard let r = record else {
                print("error getting user record")
                return
            }
            
            self.profileRecord = r
            
            dispatch_async(dispatch_get_main_queue()) {
                self.nicknameField.text = r["nickname"] as? String ?? ""
            }
        }
    }
    
    @IBAction func save() {
        self.profileRecord["nickname"] = self.nicknameField.text
    
        let db = CKContainer.defaultContainer().publicCloudDatabase
        db.saveRecord(self.profileRecord) { record, error in
            guard record != nil else {
                print("error saving profile")
                return
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("backToShoesVC", sender: nil)
            }
        }
    }
}