//
//  CustomPofileView.swift
//  ShortformPJT
//
//  Created by 김태현 on 2023/02/15.
//

import UIKit
import SnapKit

class CustomProfileView: BaseView {
    
    let profileImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let profileNameLabel: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 17)
        view.sizeToFit()
        view.textColor = .white
        return view
    }()
    
    override func configureUI() {
        [profileImageView, profileNameLabel].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraint() {
        profileImageView.snp.makeConstraints { make in
            make.top.bottom.leading.equalTo(self)
            make.width.equalTo(profileImageView.snp.height)
        }
        
        profileNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.trailing.equalTo(self)
            make.centerY.equalTo(self)
        }
    }
}
