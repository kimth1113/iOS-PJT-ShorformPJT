//
//  ErrorView.swift
//  ShortformPJT
//
//  Created by 김태현 on 2023/02/15.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class ErrorView: BaseView {
    let disposeBag = DisposeBag()
    let refreshButton: UIButton = {
        let view = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        let image = UIImage(systemName: "arrow.clockwise", withConfiguration: imageConfig)
        view.setImage(image, for: .normal)
        view.tintColor = .systemRed
        view.backgroundColor = .black
        return view
    }()
    
    override func configureUI() {
        self.addSubview(refreshButton)
    }
    
    override func setConstraint() {
        
        refreshButton.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self)
        }
    }
}
