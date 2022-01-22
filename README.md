# PhotoApp

**A Simple Photo  App using Swift and MVC pattern**  
After App launch, you will see a gallery view , "Add" option to upload new photos from device gallery or camera. Users can also delete photos by pressing the Delete button on photos.   
Details view where the user can full image and its details. There is an option to update a new photo using the Edit option.    

**Technology and Methodology which used**  
MVC - MVC stands for Model, View, Controller. It is a structural design pattern that allows for the separation of code into 3 groups .  
Swift and Storyboard - implementing functionality and building user interface .  
CocoaPods - CocoaPods is a dependency manager .  

**The Model**   
Define Data Structure (photo lists and photo info), e.g Update application to reflect added photos

**The View**  
Defines UI, e.g Add button, delete button, Imageview etc

**The Controller**  
Contains control logic, e.g receive update from view then notifies model to add/remove objects/items

**Libraries used**  
Swift  
SnapKit  
Photos
UIKit  
Toast_Swift


**Architecture Diagram**  
![alt text](https://github.com/jprakash2080/PhotoApp/blob/MusicPlayerMVVM-Main/Documentation/MVCPattern.jpg?raw=true "MVCPattern")  

------------
 ![alt text](https://github.com/jprakash2080/PhotoApp/blob/MusicPlayerMVVM-Main/Documentation/PhotoAppArchitecture.jpg?raw=true "PhotoAppArchitecture")  

**App Screens**  
![alt text](https://github.com/jprakash2080/PhotoApp/blob/MusicPlayerMVVM-Main/screens/galleryview.jpeg?raw=true "GalleryView")  

------------
 ![alt text](https://github.com/jprakash2080/PhotoApp/blob/MusicPlayerMVVM-Main/screens/detailsview.jpeg?raw=true "DetailsView") 


**TODO:**  
1. Smooth loading of images without any flickering 
2. Capture photo using latest framework AVCam
