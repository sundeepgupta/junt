import CloudKit


struct Profile {
    let nickname: String
    
    init(record: CKRecord) {
        if let nickname = record["nickname"] as? String {
            self.nickname = nickname
        } else {
            self.nickname = ""
        }
    }
}
