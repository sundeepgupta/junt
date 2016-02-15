import CloudKit

struct DataController {
    
    
    
    func updateProfile(profile: Profile) {
        
    }
    
    
    func container() -> CKContainer {
        return CKContainer.defaultContainer()
    }
    
    func publicDB() -> CKDatabase {
        return self.container().publicCloudDatabase
    }
    
    func privateDB() -> CKDatabase {
        return self.container().privateCloudDatabase
    }
}
