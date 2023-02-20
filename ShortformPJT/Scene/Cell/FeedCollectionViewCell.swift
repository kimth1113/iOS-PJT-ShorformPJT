//
//  contentCollectionViewCell.swift
//  ShortformPJT
//
//  Created by 김태현 on 2023/02/10.
//

import UIKit
import AVKit
import RxCocoa
import RxSwift
import SnapKit

class ContentCollectionViewCell: BaseCollectionViewCell {
    
    private var player = AVPlayer()
    
    var viewModel = ShortformViewModel.shared
    
    let disposeBag = DisposeBag()
    
    let videoView: CustomVideoView = {
        let view = CustomVideoView()
        return view
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    override func bind() {
        
        viewModel.isMuted
            .bind { test in
                self.videoView.player?.isMuted = test
            }
            .disposed(by: disposeBag)
    }
    
    override func configureUI() {
        layer.masksToBounds = true
        backgroundColor = .black
        
        [videoView, imageView].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraint() {
        
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(self)
            make.width.equalTo(UIScreen.main.bounds.width)
        }
    }
    
    func designNormalCell() {
        videoView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    func designFourthCell() {
        videoView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(videoView.snp.width).multipliedBy(0.7)
            make.centerX.centerY.equalTo(self)
        }
    }
}
