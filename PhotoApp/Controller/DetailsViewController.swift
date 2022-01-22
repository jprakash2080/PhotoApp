//
//  DetailsViewController.swift
//  PhotoApp
//
//  Created by Prakash on 22/01/22.
//

import UIKit
import Toast_Swift

//for shwoing full image and its details
class DetailsViewController: UIViewController {

    var photoID :String = ""
    let detailsView = DetailsView()
   
    private lazy var imagePicker: ImagePicker = {
            let imagePicker = ImagePicker()
            imagePicker.delegate = self
            return imagePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailsView
        self.title = PhotoDetailsTitle
        setNavBtn()
        print("photo id \(photoID)")
        loadPhotoDetailsFromAPI()
    }
    
    var photoDetails: PhotoDataModel = PhotoDataModel(photos: nil){
        didSet{
            DispatchQueue.main.async { [self] in
                if photoDetails.fullImage != nil{
                    print(photoDetails.fullImage)

                    detailsView.PhotoImageView.imageFromServerURL(photoDetails.fullImage, placeHolder: UIImage(named: "noimage"))
                }
            }
        }
    }
    
    func setNavBtn() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: detailsView.addBtn)
        detailsView.addBtn.addTarget(self, action: #selector(editImages), for: .touchUpInside)

    }
    
    @objc func editImages() {
        showUploadOption()
    }
    
    func loadPhotoDetailsFromAPI(){
        APIServices().apiToGetPhotoDetails(photoID: photoID) { photo in
            DispatchQueue.main.async {
                //getter and setter call for PhotoList
                self.photoDetails =  PhotoDataModel(photos: photo)
            }
        }
    }
    
    //update image call
    func updateImageToAPI(full:UIImage, fullname:String, thumb:UIImage, thumbname: String){
        self.showSpinner(onView: self.view)

        APIServices().apiToUpdatePhoto(photoID:photoID, fullimage: full, fullImageName:fullname, thumbimage: thumb, thumImageName: thumbname) { success in
            DispatchQueue.main.async {
                self.removeSpinner()
                if success == 204{
                    self.view.makeToast("Photo updated successfully!", duration: 3.0, position: .bottom)
                    self.loadPhotoDetailsFromAPI()
                   // self.loadImagesFromAPI()//relaod photo list
                }
            }
        }
    }
}

extension DetailsViewController : UIActionSheetDelegate{

    func showUploadOption() {
        let alert = UIAlertController(title: "Photo", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
            self.imagePicker.photoGalleryAsscessRequest()//show photo albmun view
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            self.imagePicker.cameraAsscessRequest() //Camera view
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("photo presented")
        })
    }
}

extension DetailsViewController: ImagePickerDelegate {

    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage) {
        //imageView.image = image
        detailsView.PhotoImageView.image = image
        let fullname =  NSUUID().uuidString + ".jpg"
        updateImageToAPI(full:image.resizeImage(targetSize: CGSize(width: 1000, height: 1000)), fullname:fullname, thumb:image.getThumbnail()!, thumbname: fullname)
        imagePicker.dismiss()
    }

    func cancelButtonDidClick(on imageView: ImagePicker) { imagePicker.dismiss() }
    func imagePicker(_ imagePicker: ImagePicker, grantedAccess: Bool,
                     to sourceType: UIImagePickerController.SourceType) {
        guard grantedAccess else { return }
        imagePicker.present(parent: self, sourceType: sourceType)
    }
}
