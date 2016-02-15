import UIKit

class ShoeCell: UITableViewCell {
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var shoeImageView: UIImageView!

    func configureWith(shoe: Shoe) {
        userLabel.text = shoe.ownerID.recordName
    }
}
