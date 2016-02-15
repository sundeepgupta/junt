import UIKit
import CloudKit

class AddShoeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var userID: CKRecordID!
    @IBOutlet weak var sizeField: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    var imageURL: NSURL!
    
    @IBAction func chooseImage() {
        let picker = UIImagePickerController()
        picker.sourceType = .PhotoLibrary
        picker.delegate = self
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func save() {
        // should validate inputs first
        
        let size = Int(self.sizeField.text!)
        let shoe = Shoe(ownerID: self.userID, size: size!, imageURL: self.imageURL)
        let record = shoe.toRecord()
        
        let container = CKContainer.defaultContainer()
        let db = container.publicCloudDatabase
        
//        db.saveRecord(<#T##record: CKRecord##CKRecord#>, completionHandler: <#T##(CKRecord?, NSError?) -> Void#>)
        
        db.saveRecord(record) { record, error in
            if let e = error {
                print("error saving shoe: \(e.localizedDescription)")
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.performSegueWithIdentifier("backToShoesVC", sender: nil)
            })
        }
    }
    
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.imageButton.setBackgroundImage(image, forState: .Normal)
        
        let data = UIImagePNGRepresentation(image)
        let directory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let path = directory.path! + "/shoe.png"
        data!.writeToFile(path, atomically: true)
        
        self.imageURL = NSURL(fileURLWithPath: path)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}