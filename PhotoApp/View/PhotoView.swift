//
//  PhotoView.swift
//  PhotoApp
//
//  Created by Prakash on 21/01/22.
//

import Foundation
import UIKit
import SnapKit

class PhotoView: UIView {

    //MARK: - Properties
    let fullSize = UIScreen.main.bounds
    
    //MARK: - IBOutlets
    lazy var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: fullSize.width/2, height: fullSize.width/2)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoViewCell.self, forCellWithReuseIdentifier: PhotoViewCell.collectionViewId)
        return collectionView
    }()
    
    let addBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.blue, for: .highlighted)
        return button
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        photoCollectionView.backgroundColor = .white
    
        addSubview(photoCollectionView)
        addSubview(addBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Set Layout
    override func layoutSubviews() {
        photoCollectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
    }
    
    }
    
}
