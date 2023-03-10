//
//  BaseView.swift
//  ShortformPJT
//
//  Created by κΉνν on 2023/02/10.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
        configureUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("Error was caused at BaseView.")
    }
    
    func configureUI() { }
    func setConstraint() { }
    func bind() { }
}
