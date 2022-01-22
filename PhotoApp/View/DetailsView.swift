//
//  DetailsView.swift
//  PhotoApp
//
//  Created by Prakash on 22/01/22.
//

import UIKit

class DetailsView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    //MARK: - Properties
    let fullSize = UIScreen.main.bounds
    
    //MARK: - IBOutlets
    var PhotoImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 10
        img.clipsToBounds = true
        img.layer.borderWidth = 1.0
        img.layer.borderColor = UIColor.lightGray.cgColor
        img.translatesAutoresizingMaskIntoConstraints = false //You need to call this property so the image is added to your view

        return img
    }()
    
    let addBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.blue, for: .highlighted)
        return button
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(PhotoImageView)
        addSubview(addBtn)
    }
    override func layoutSubviews() {
        PhotoImageView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self)
            make.width.equalTo(400)
            make.height.equalTo(500)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
