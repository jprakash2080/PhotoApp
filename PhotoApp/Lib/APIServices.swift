//
//  APIServices.swift
//  PhotoApp
//
//  Created by Prakash on 21/01/22.
//

import Foundation
import UIKit


class APIServices {

    //API Call - Photo List
    func apiToGetPhotoList(completion: @escaping(PhotoList) ->()){

        var request = URLRequest(url: URL(string: Constants.listPhotos)!,timeoutInterval: Double.infinity)
        request.addValue(APIKEY, forHTTPHeaderField: "Authorization")

        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let dataResponse = data,
                  error == nil else {
                  return }
            do{
                //here dataResponse received from a network request
                let decoder = JSONDecoder()
                let model:PhotoList = try decoder.decode(PhotoList.self, from:
                    dataResponse) //Decode JSON Response Data
                DispatchQueue.main.async {
                    print("photo data")
                    print(model.objects as Any)
                    completion(model)//get top record
                }
              
            } catch _ {
           }
        }
        task.resume()
    }//END
    
    //API Call - view photo details
    func apiToGetPhotoDetails(photoID: String, completion: @escaping(Objects) ->()){
        let url = String(format:  Constants.detailsPhoto, photoID)
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.addValue(APIKEY, forHTTPHeaderField: "Authorization")

        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let dataResponse = data,
                  error == nil else {
                  return }
            do{
                //here dataResponse received from a network request
                let decoder = JSONDecoder()
                let model:Objects = try decoder.decode(Objects.self, from:
                    dataResponse) //Decode JSON Response Data
                DispatchQueue.main.async {
                    print("photo data")
                    print(model as Any)
                    completion(model)//get top record
                }
            } catch _ {
           }
        }
        task.resume()
    }//END
    
    
    //API Call - Update Photo
    func apiToUpdatePhoto(photoID: String, fullimage:UIImage,fullImageName: String, thumbimage:UIImage, thumImageName: String, completion: @escaping(Int) ->()){
        
        let url = NSURL(string: String(format:  Constants.photoUpdate, photoID))

        let request = NSMutableURLRequest(url:url! as URL)
        request.httpMethod = "PUT";
        request.addValue(APIKEY, forHTTPHeaderField: "Authorization")

        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpBody = createHttpBody(fullImageName: fullImageName, thumImageName: thumImageName, fullimage: fullimage, thumbimage: thumbimage, boundary: boundary) as Data
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error!)")
                completion(500)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                if httpResponse.statusCode == 204{
                    print("photo uploaded success!....")
                    completion(httpResponse.statusCode)
                }
            }
        }
        task.resume()
    }//END
    
    //API Call - Delete Photo
    func apiToDeleteSiglePhoto(photoID: String, completion: @escaping(Int) ->())
    {
        let url = String(format:  Constants.deletePhoto, photoID)

        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.addValue(APIKEY, forHTTPHeaderField: "Authorization")

        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("error=\(error!)")
                completion(500)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                if httpResponse.statusCode == 204{
                    print("photo deleted success!....")
                    completion(httpResponse.statusCode)
                }
            }
        }
        task.resume()
    }//END
    
    //API Call - upload photo
    func apiToUplaodPhoto(fullimage:UIImage,fullImageName: String, thumbimage:UIImage, thumImageName: String, completion: @escaping(Int) ->()) {

        let url = NSURL(string: Constants.createPhoto)
        let request = NSMutableURLRequest(url:url! as URL)
        request.httpMethod = "POST";
        request.addValue(APIKEY, forHTTPHeaderField: "Authorization")

        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpBody = createHttpBody(fullImageName: fullImageName, thumImageName: thumImageName, fullimage: fullimage, thumbimage: thumbimage, boundary: boundary) as Data
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error!)")
                completion(500)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                if httpResponse.statusCode == 201{
                    print("photo uploaded success!....")
                    completion(httpResponse.statusCode)
                }
            }
        }
        task.resume()
    }//END

    func createHttpBody(fullImageName: String , thumImageName:String, fullimage:UIImage,thumbimage:UIImage, boundary: String )->NSData{
        let imageData = fullimage.jpegData(compressionQuality: 0.8)
        let imageThumbData = thumbimage.jpegData(compressionQuality: 0.7)
        if imageData == nil || imageThumbData == nil {
            return NSData()
        }
        // full Image
        let body = NSMutableData()
        let mimetype = "image/jpg"
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
          
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"full\"; filename=\"\(fullImageName)\"\r\n".data(using: String.Encoding.utf8)!) // paramenter name
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(imageData!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)


            // thumb Image
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"thumbnail\"; filename=\"\(thumImageName)\"\r\n".data(using: String.Encoding.utf8)!) // paramenter name 1
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(imageThumbData!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        
        return body
    }
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String, imgKey: String) -> NSData {
            let body = NSMutableData();

            if parameters != nil {
                for (key, value) in parameters! {
                    body.appendString(string: "--\(boundary)\r\n")
                    body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendString(string: "\(value)\r\n")
                }
            }

            let filename = "\(imgKey)"
            let mimetype = "image/jpg"

            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
            body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageDataKey as Data)
            body.appendString(string: "\r\n")
            body.appendString(string: "--\(boundary)--\r\n")

            return body
        }
    
    func generateBoundaryString() -> String {
            return "Boundary-\(NSUUID().uuidString)"
        }
   
}
