import UIKit
import CloudKit

class ShoesVC: UIViewController, UITableViewDataSource {
    var shoes: [Shoe] = []
    var userID: CKRecordID?
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchUserID()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.fetchShoes()
    }
    
    func fetchUserID() {
        let container = CKContainer.defaultContainer()
        container.fetchUserRecordIDWithCompletionHandler { recordID, error in
            if let e = error {
                print("error getting user record id: \(e.localizedDescription)")
                return
            }
            
            self.userID = recordID!
        }
    }
    
    func fetchShoes() {
//        let predicate = NSPredicate(value: true) // this means just evaluate to true, so fetch everything
        let predicate = NSPredicate(format: "owner != %@", self.userID!) // get only shoes I posted
        let query = CKQuery(recordType: "Shoe", predicate: predicate)
        
        let db = CKContainer.defaultContainer().publicCloudDatabase
        db.performQuery(query, inZoneWithID: nil) { records, error in
            if let e = error {
                print("error fething shoes: \(e.localizedDescription)")
                return
            }
            
            // regular loop
            for record in records! {
                self.shoes.append(Shoe(record: record))
            }
            
            // fancy map
            self.shoes = records!.map { record -> Shoe in
                
                
                return Shoe(record: record)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        // show UI to let user know that fetching ID failed or is still in progress
        
        return userID != nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "toProfileVC":
            let destination = segue.destinationViewController as! UINavigationController
            let viewController = destination.viewControllers.first as! ProfileVC
            viewController.userID = self.userID
        case "toAddShoeVC":
            let destination = segue.destinationViewController as! UINavigationController
            let viewController = destination.viewControllers.first as! AddShoeVC
            viewController.userID = self.userID
        default:
            return
        }
    }
    
    @IBAction func unwindToShoesVC(segue: UIStoryboardSegue) {}
    
    
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shoes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ShoeCell") as! ShoeCell

        let shoe = self.shoes[indexPath.row]
        cell.configureWith(shoe)
        
        return cell
    }
}

