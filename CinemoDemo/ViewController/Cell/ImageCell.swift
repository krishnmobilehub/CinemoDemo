import UIKit

class ImageCell: UICollectionViewCell, ReusableView, NibLoadableView {
    
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var imageDisplayView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewImage.layer.borderWidth = 1
        viewImage.layer.borderColor = UIColor.black.cgColor
    }
    
    func configData(image:UIImage)  {
        imageDisplayView.image = image
    }
}
