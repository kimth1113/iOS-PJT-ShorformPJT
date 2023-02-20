//
//  BaseCollectionViewCell.swift
//  ShortformPJT
//
//  Created by 김태현 on 2023/02/10.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
        configureUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("Error was caused at BaseCollectionViewCell.")
    }
    
    func bind() { }
    func configureUI() { }
    func setConstraint() { }
}
