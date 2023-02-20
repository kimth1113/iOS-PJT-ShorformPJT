//
//  ViewController.swift
//  ShortformPJT
//
//  Created by 김태현 on 2023/02/09.
//

import UIKit
import AVKit
import Kingfisher
import RxCocoa
import RxSwift
import SnapKit
import Toast

class ShortformViewController: UIViewController {
    
    let mainView = ShortformView()
    
    var viewModel = ShortformViewModel.shared
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        bind()
        
        // 첫 Posts 요청
        viewModel.getinitialContents {
            
        } errorCompletion: {
            self.renderErrorUI()
        }
    }
    
    private func bind() {
        
        // Post-CellForItem
        viewModel.posts
            .bind(to: mainView.postCollectionView.rx.items(cellIdentifier: PostCollectionViewCell.reuseIdentifier, cellType: PostCollectionViewCell.self)) { (row, element, cell) in
                
                let contentPicture = ContentURLSet(videoURL: nil, pictureURL: element.videoPictures[0].picture)
                let contentVideo = ContentURLSet(videoURL: element.videoFiles[0].link, pictureURL: nil)
                cell.contents.accept([contentPicture, contentVideo, contentPicture, contentVideo])
                cell.contentCollectionView.tag = row
                
                cell.bingindCellData(
                    likeCount: element.width,
                    followCount: element.height,
                    description: element.user.name,
                    profileURLString: element.videoPictures[0].picture,
                    displayName: String(element.id)
                )
            }
            .disposed(by: disposeBag)
    }
}

extension ShortformViewController {
    
    func renderErrorUI() {
        
        let errorView = ErrorView()
        
        errorView.refreshButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.viewModel.getinitialContents {
                    vc.view = vc.mainView
                } errorCompletion: {
                    vc.renderErrorUI()
                }
            })
            .disposed(by: disposeBag)
        
        view = errorView
    }
}
