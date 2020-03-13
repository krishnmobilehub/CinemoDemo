import UIKit

extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentity)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(_: T.Type, for indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentity, for: indexPath) as? T else {
            debugPrint("Could not load view controller with: \(T.reuseIdentity)")
            return UICollectionViewCell() as! T
        }
        
        return cell
    }
}
