//
//  Constants.swift
//  PhotoApp
//
//  Created by Prakash on 21/01/22.
//

import Foundation
import UIKit


//Api Keys
var APIKEY = "ApiKey user:key"
// Userdefaults
var userdefaults = UserDefaults.standard
var noImageName = "noimage"

// Navigation Title Name
var PhotoGalleryTitle = "Photo Gallery"
var PhotoDetailsTitle = "Photo Details"

// Application API Request
var applicationJosn = "application/json"
var acceptType = "Accept"
var ImageCropSize = 400
struct Constants {
   
    static let versionApi = "v1"
    static let mediaURL = "https://testapi.iceindia.com/media"
    static let apiDomain = "https://testapi.iceindia.com/"
    static let baseURL = "\(apiDomain)api/\(versionApi)"
    
    static let listPhotos = baseURL + "/photo/"

    static let detailsPhoto = baseURL + "/photo/%@/"
    static let createPhoto = baseURL + "/photo/"
    static let photoUpdate = baseURL + "/photo/%@/"
    static let deletePhoto = baseURL + "/photo/%@/"
}


