//
//  PhotoGalleryView.swift
//  PhotoApp
//
//  Created by Prakash on 21/01/22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import UIKit
import Photos
import Toast_Swift
//import DetailsPhotoViewController

class PhotoGalleryView: UIViewController & UINavigationControllerDelegate {
    
    //var imagePicker = UIImagePickerController()
    //MARK: - Properties
    private lazy var imagePicker: ImagePicker = {
            let imagePicker = ImagePicker()
            imagePicker.delegate = self
            return imagePicker
    }()
    
    let photoView = PhotoView()
    var pictureInfo = [PhotoDataModel]() {
        didSet{
            DispatchQueue.main.async { [self] in
                reloadCollectionView()
                
            }
        }
    }
    
    func reloadCollectionView(){
        self.photoView.photoCollectionView.reloadData()

    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = PhotoGalleryTitle
        view = photoView
        
        photoView.photoCollectionView.dataSource = self
        photoView.photoCollectionView.delegate = self
        
        setNavBtn()
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            loadImagesFromAPI()
        }
    //MARK: - Functions
    func setNavBtn() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: photoView.addBtn)
        photoView.addBtn.addTarget(self, action: #selector(addImages), for: .touchUpInside)
    }
    
    @objc func addImages() {
        self.showUploadOption()
    }
    
    @IBAction func deleteAction(_ sender: PUIButton) {
        print(sender.pid ?? "")
        self.deletImagesFromAPI(photoID: sender.pid!)
    }
    
    func deletImagesFromAPI(photoID: String){
        self.showSpinner(onView: self.view)
        APIServices().apiToDeleteSiglePhoto(photoID:photoID) { success in
            DispatchQueue.main.async {
                //getter and setter call for PhotoList
                self.removeSpinner()
                if success == 204{
                    self.view.makeToast("Photo deleted successfully!", duration: 3.0, position: .bottom)
                    
                    self.loadImagesFromAPI()
                }
            }
        }
    }

    func loadImagesFromAPI(){
        //self.showSpinner(onView: self.view)
        APIServices().apiToGetPhotoList { photolist in
            DispatchQueue.main.async {
                //getter and setter call for PhotoList
                self.pictureInfo = photolist.objects.map(PhotoDataModel.init)
            }
        }
    }
        
    //upload image call
    func uploadImageToAPI(full:UIImage, fullname:String, thumb:UIImage, thumbname: String){
        self.showSpinner(onView: self.view)

        APIServices().apiToUplaodPhoto(fullimage: full, fullImageName:fullname, thumbimage: thumb, thumImageName: thumbname) { success in
            DispatchQueue.main.async {
                self.removeSpinner()
                if success == 201{
                    self.view.makeToast("Photo uploaded successfully!", duration: 3.0, position: .bottom)
                    self.loadImagesFromAPI()//relaod photo list
                }
            }
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension PhotoGalleryView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.pictureInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoViewCell.collectionViewId, for: indexPath) as? PhotoViewCell else { return UICollectionViewCell() }
        ///https://testapi.iceindia.com/media/user_15/20190704_113442.jpg
        
        let ph = self.pictureInfo[indexPath.row]
        cell.btnDelete.addTarget(self, action: #selector(deleteAction(_:)), for:.touchUpInside)
        cell.btnDelete.pid = String(ph.uid)
        
        DispatchQueue.main.async {
            cell.photoImageView.imageFromServerURL(ph.thumbImage, placeHolder: UIImage(named: "noimage"))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoId = self.pictureInfo[indexPath.row]

        let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        controller.photoID = String(photoId.uid)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

//elf.removeSpinner()

extension PhotoGalleryView : UIActionSheetDelegate{

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

extension PhotoGalleryView: ImagePickerDelegate {

    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage) {
        //imageView.image = image
       // detailsView.PhotoImageView.image = image
        let fullname =  NSUUID().uuidString + ".jpg"
        uploadImageToAPI(full:image.resizeImage(targetSize: CGSize(width: 1000, height: 1000)), fullname:fullname, thumb:image.getThumbnail()!, thumbname: fullname)

        imagePicker.dismiss()
    }

    func cancelButtonDidClick(on imageView: ImagePicker) { imagePicker.dismiss() }
    func imagePicker(_ imagePicker: ImagePicker, grantedAccess: Bool,
                     to sourceType: UIImagePickerController.SourceType) {
        guard grantedAccess else { return }
        imagePicker.present(parent: self, sourceType: sourceType)
    }
}

/*extension PhotoGalleryView: UIImagePickerControllerDelegate {
    func showCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
          let selectedImage : UIImage = image
      print(selectedImage)
         //upload(image: selectedImage)
      }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     
        var fullname =  NSUUID().uuidString + ".jpg"
        //var thumname = ""
        
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                    
            let assets = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)
            if let firstAsset = assets.firstObject,
            let firstResource = PHAssetResource.assetResources(for: firstAsset).first {
                    fullname = firstResource.originalFilename
                } else {
                    fullname = NSUUID().uuidString + ".jpg"
                }
                
        } else {
        
            fullname =  NSUUID().uuidString + ".jpg"

        }
        
        if let pickedImage = info[.originalImage] as? UIImage {
        // imageViewPic.contentMode = .scaleToFill
            //upload(image: pickedImage)
            uploadImageToAPI(full:pickedImage, fullname:fullname, thumb:pickedImage.getThumbnail()!, thumbname: fullname)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}*/
