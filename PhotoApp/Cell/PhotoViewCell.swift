//
//  PhotoViewCell.swift
//  PhotoApp
//
//  Created by Prakash on 21/01/22.
//

import Foundation
import UIKit

class PhotoViewCell: UICollectionViewCell {
    
    //MARK: - properties
    static var collectionViewId = "photoCell"
    
    //MARK: - IBOutlets
    let photoImageView: ImageViewEx = {
        let image = ImageViewEx()
        return image
    }()
    
     let btnDelete: PUIButton = {
        let tb = PUIButton()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.titleLabel?.textAlignment = .center
        tb.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        tb.setTitle("Delete", for: .normal)
        tb.setTitleColor(UIColor.white, for: .normal)
        //tb.layer.borderWidth = 1
        tb.layer.cornerRadius = 5
        tb.backgroundColor = UIColor(hexString: "#F93154")//UIColor.blue
        
        tb.alpha = 0.6
        //tb.setBackgroundImage((UIColor.red), for: .normal)
        return tb
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        contentView.addSubview(photoImageView)
        contentView.addSubview(btnDelete)
        
        photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30).isActive = true
        
        btnDelete.topAnchor.constraint(equalTo: photoImageView.bottomAnchor,constant: -30).isActive = true
        btnDelete.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 150).isActive = true
        btnDelete.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1).isActive = true
        btnDelete.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    //MARK: - Set Layouts
    override func layoutSubviews() {
        photoImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
}
