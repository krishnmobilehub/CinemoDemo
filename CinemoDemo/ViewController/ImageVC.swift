import UIKit

class ImageVC: UIViewController {
    
    @IBOutlet weak var noListLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    var arrImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Home"
        noListLabel.isHidden = true
        showActivityView()
        getAllImages()
        NotificationCenter.default.addObserver(self, selector: #selector(getAllImages), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @IBAction func addClicked(_ sender: Any) {
        openGallery()
    }
}

//MARK:-
extension ImageVC {
  @objc func getAllImages() {
        arrImages.removeAll()
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
            if fileURLs.count == 0 {
                noListLabel.isHidden = false
                hideActivityView()
            }
            for fileURL in fileURLs {
                let image = UIImage(contentsOfFile: fileURL.path)
                arrImages.append(image ?? UIImage(named: "plus")!)
            }
            collectionView.reloadData()
        } catch  {
            debugPrint(error)
        }
    }
    
    func saveImageToDocumentDirectory(image: UIImage ) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let number = randomSequenceGenerator(min: 0, max: 10000)
        let fileName = "image\(number().description).tiff"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        if let data = image.jpegData(compressionQuality: 1.0),
            !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data.write(to: fileURL)
                getAllImages()
                debugPrint("file saved")
            } catch {
                alertShowWithOK("Error", message: error.localizedDescription)
                debugPrint("error saving file:", error)
            }
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func randomSequenceGenerator(min: Int, max: Int) -> () -> Int {
        var numbers: [Int] = []
        return {
            if numbers.isEmpty {
                numbers = Array(min ... max)
            }
            let index = Int(arc4random_uniform(UInt32(numbers.count)))
            return numbers.remove(at: index)
        }
    }
    
    func alertShowWithOK(_ title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showActivityView() {
        activityView.isHidden = false
        activityView.startAnimating()
    }
    
    func hideActivityView() {
        activityView.isHidden = true
        activityView.stopAnimating()
    }
}

//MARK:-
extension ImageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        noListLabel.isHidden = true
        showActivityView()
        DispatchQueue.main.async() {
            self.saveImageToDocumentDirectory(image: image)
        }
        dismiss(animated:true, completion: nil)
    }
}

//MARK:-
extension ImageVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ImageCell.self, for: indexPath)
        let isLast = (indexPath.row == (arrImages.count - 1))
        if isLast {
            hideActivityView()
        }
        cell.configData(image: arrImages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:(collectionView.frame.width)/2, height: collectionView.frame.size.height/3)
    }
}

