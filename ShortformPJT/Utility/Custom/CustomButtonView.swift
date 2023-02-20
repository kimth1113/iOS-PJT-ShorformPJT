//
//  CustomButtonView.swift
//  ShortformPJT
//
//  Created by 김태현 on 2023/02/15.
//

import UIKit
import SnapKit

class CustomButtonView: BaseView {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = .white
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.sizeToFit()
        view.textAlignment = .center
        view.textColor = .white
        return view
    }()
    
    let customButton: UIButton = {
        let view = UIButton()
        return view
    }()
    
    override func configureUI() {
        [imageView, titleLabel, customButton].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraint() {
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self)
            make.height.equalTo(imageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(self)
        }
        
        customButton.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}
