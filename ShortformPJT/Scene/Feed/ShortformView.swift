//
//  ShortformView.swift
//  ShortformPJT
//
//  Created by 김태현 on 2023/02/09.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class ShortformView: BaseView {
    
    var viewModel = ShortformViewModel.shared
    
    let disposeBag = DisposeBag()
    
    let muteButton: UIButton = {
        let view = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        let image = UIImage(systemName: "speaker.wave.2.fill", withConfiguration: imageConfig)
        view.setImage(image, for: .normal)
        view.tintColor = .white
        return view
    }()
    
    let postCollectionView: BaseCollectionView = {
        let view = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionView.postCollectionViewLayout())
        view.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.reuseIdentifier)
        return view
    }()
    
    override func bind() {
        
        let input = ShortformViewModel.MainViewInput(prefetch: postCollectionView.rx.prefetchItems, muteButtonTap: muteButton.rx.tap)
        let output = viewModel.mainViewTrasform(input: input)
        
        // Prefetch
        output.prefetch
          .compactMap(\.last?.row)
          .withUnretained(self)
          .bind { (vw, row) in
              if (vw.viewModel.postsCnt - 1) == row {
                  vw.viewModel.page += 1
                  vw.viewModel.getContents(page: vw.viewModel.page) {
                      vw.makeToast("네트워크 오류로 인해 추가 피드를 불러오지 못했습니다.", duration: 2.0, point: CGPoint(x: (vw.bounds.width) / 2, y: (vw.bounds.height) - 150), title: nil, image: nil) { _ in
                      }
                  }
              }
          }
          .disposed(by: self.disposeBag)
        
        viewModel.isMuted
            .withUnretained(self)
            .bind { (vc, onMute) in
                let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
                if onMute {
                    let image = UIImage(systemName: "speaker.wave.2", withConfiguration: imageConfig)
                    vc.muteButton.setImage(image, for: .normal)
                } else {
                    let image = UIImage(systemName: "speaker.wave.2.fill", withConfiguration: imageConfig)
                    vc.muteButton.setImage(image, for: .normal)
                }
            }
            .disposed(by: disposeBag)
        
        output.muteButtonTap
            .withUnretained(self)
            .bind(onNext: { (vc, _) in
                vc.viewModel.isMuted.accept(!(vc.viewModel.isMuted.value))
            })
            .disposed(by: disposeBag)
        
        // 포커스
        postCollectionView.rx.willDisplayCell
            .bind { [weak self] cell, indexPath in
                guard let cell = cell as? PostCollectionViewCell else {
                    return
                }
                
                self?.viewModel.currentTag.accept(cell.contentCollectionView.tag)
                
                // 위아래 스크롤 시, 보던 영상으로 다시 돌아왔을 때 재재생
                if cell.contentCollectionView.visibleCells.count > 0 {
                    guard let currentCell = cell.contentCollectionView.visibleCells[0] as? ContentCollectionViewCell else {
                        return
                    }
                    currentCell.videoView.player?.play()
                }
            }
            .disposed(by: disposeBag)
        
        // 포커스 해제
        postCollectionView.rx.didEndDisplayingCell
            .bind { cell, indexPath in
                guard let cell = cell as? PostCollectionViewCell else {
                    return
                }
                
                // 위아래 스크롤 시, 다른 셀로 이동 시 보던 영상을 중지
                guard let currentCell = cell.contentCollectionView.visibleCells[0] as? ContentCollectionViewCell else {
                    return
                }
                currentCell.videoView.player?.pause()
            }
            .disposed(by: disposeBag)
    }
    
    override func configureUI() {
        [postCollectionView, muteButton].forEach {
            addSubview($0)
        }
    }

    override func setConstraint() {
        postCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        muteButton.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(40)
            make.top.trailing.equalTo(safeAreaLayoutGuide).inset(12)
        }
    }
}


