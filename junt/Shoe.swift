import CloudKit


struct Shoe {
    let ownerID: CKRecordID
    let size: Int
    let imageURL: NSURL
    
    init(ownerID: CKRecordID, size: Int, imageURL: NSURL) {
        self.ownerID = ownerID
        self.size = size
        self.imageURL = imageURL
    }
    
    init(record: CKRecord) {
        let ownerReference = record["owner"] as! CKReference
        self.ownerID = ownerReference.recordID
        
        self.size = record["size"] as! Int

        let imageAsset = record["image"] as! CKAsset
        self.imageURL = imageAsset.fileURL
    }
    
    func toRecord() -> CKRecord {
        let record = CKRecord(recordType: "Shoe")
        record["size"] = self.size
        
        let ownerReference = CKReference(recordID: self.ownerID, action: .DeleteSelf)
        record["owner"] = ownerReference
        
        let imageAsset = CKAsset(fileURL: self.imageURL)
        record["image"] = imageAsset
        

        
        return record
    }
}
