//
//  PostCollectionViewCell.swift
//  ShortformPJT
//
//  Created by 김태현 on 2023/02/13.
//

import UIKit
import AVKit
import Kingfisher
import RxCocoa
import RxSwift
import SnapKit

// contentCollectionView가 랜더링되는 Cell
class PostCollectionViewCell: BaseCollectionViewCell {
    
    var viewModel = ShortformViewModel.shared
    
    let disposeBag = DisposeBag()
    
    let contents = BehaviorRelay<[ContentURLSet]>(value: [])
    
    let heartButtonView: CustomButtonView = {
        let view = CustomButtonView()
        view.imageView.image = UIImage(systemName: "heart.fill")
        return view
    }()
    
    let followedButtonView: CustomButtonView = {
        let view = CustomButtonView()
        view.imageView.image = UIImage(systemName: "person.crop.circle.fill.badge.plus")
        return view
    }()
    
    let contentCollectionView: BaseCollectionView = {
        let view = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionView.contentCollectionViewLayout())
        view.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: ContentCollectionViewCell.reuseIdentifier)
        return view
    }()
    
    let contentDescriptionLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 17)
        view.sizeToFit()
        view.textColor = .white
        view.numberOfLines = 2
        return view
    }()
    
    let moreButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        view.tintColor = .white
        return view
    }()
    
    let profileView: CustomProfileView = {
        let view = CustomProfileView()
        return view
    }()
    
    lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPage = 0
        control.numberOfPages = 4
        control.pageIndicatorTintColor = .darkGray
        control.currentPageIndicatorTintColor = .white
        return control
    }()
    
    override func bind() {
        
        let input = ShortformViewModel.PostCellInput(moreButtonTap: moreButton.rx.tap)
        let output = viewModel.postCellTrasform(input: input)
        
        output.moreButtonTap
            .withUnretained(self)
            .bind { (vc, _) in
                let lines = vc.contentDescriptionLabel.numberOfLines
                if lines == 0 {
                    vc.contentDescriptionLabel.numberOfLines = 2
                    vc.moreButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
                } else {
                    vc.contentDescriptionLabel.numberOfLines = 0
                    vc.moreButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
                }
            }
            .disposed(by: disposeBag)
        
// contents가 동적인 배열 데이터라면 페이징 UI도 변경되는 코드 넣어주기
//        contents
//            .withUnretained(self)
//            .bind { (cv, contents) in
//                cv.pageControl.numberOfPages = contents.count
//                if cv.pageControl.numberOfPages == 1 || cv.pageControl.numberOfPages > 5 {
//                    cv.pageControl.isHidden = true
//                } else {
//                    cv.pageControl.isHidden = false
//                }
//            }
//            .disposed(by: disposeBag)
        
        // CellForItem
        contents
            .bind(to: contentCollectionView.rx.items(cellIdentifier: ContentCollectionViewCell.reuseIdentifier, cellType: ContentCollectionViewCell.self)) { [weak self] (row, element, cell) in
                
//                let url = URL(string: element.contentURL)
//                switch element.type {
//                case .image:
//                    let cell = cell
//                    cell.imageView.kf.setImage(with: url)
//                    cell.videoView.player = nil
//                case .video:
//                    let playerItem = AVPlayerItem(url: url!)
//                    playerItem.preferredForwardBufferDuration = TimeInterval(1.0)
//                    cell.videoView.player = AVPlayer(playerItem: playerItem)
//                    cell.videoView.player?.isMuted = (self?.viewModel.isMuted.value)!
//                    cell.imageView.image = nil
                switch row {
                case 0:
                    let url = URL(string: element.pictureURL!)
                    cell.imageView.kf.setImage(with: url)
                    cell.videoView.player = nil
                    cell.imageView.contentMode = .scaleAspectFit
                case 1:
                    let url = URL(string: element.videoURL!)
                    let playerItem = AVPlayerItem(url: url!)
                    playerItem.preferredForwardBufferDuration = TimeInterval(1.0)
                    cell.videoView.player = AVPlayer(playerItem: playerItem)
                    cell.videoView.player?.isMuted = (self?.viewModel.isMuted.value)!
                    cell.imageView.image = nil
                    cell.videoView.contentMode = .scaleAspectFit
                    cell.designFourthCell()
                case 2:
                    let url = URL(string: element.pictureURL!)
                    cell.imageView.kf.setImage(with: url)
                    cell.videoView.player = nil
                    cell.imageView.contentMode = .scaleAspectFill
                case 3:
                    let url = URL(string: element.videoURL!)
                    let playerItem = AVPlayerItem(url: url!)
                    playerItem.preferredForwardBufferDuration = TimeInterval(1.0)
                    cell.videoView.player = AVPlayer(playerItem: playerItem)
                    cell.videoView.player?.isMuted = (self?.viewModel.isMuted.value)!
                    cell.imageView.image = nil
                    cell.videoView.contentMode = .scaleAspectFill
                    cell.designNormalCell()
                default:
                    print()
                }
            }
            .disposed(by: disposeBag)
        
        // 좌우 스크롤 시, 보던 영상으로 다시 돌아왔을 때 재재생 또는 첫 셀이 비디오일 때 재생
        contentCollectionView.rx.willDisplayCell
            .bind { [weak self] cell, indexPath in
                guard let cell = cell as? ContentCollectionViewCell else {
                    return
                }
                
                // 재사용셀 버그 방지 : 상하 스크롤 시, 현재 화면보다 두세단계 아래 영상이 재생되는 이슈 방지
                if self?.contentCollectionView.tag == self?.viewModel.currentTag.value {
                    cell.videoView.player?.play()
                } else {
                    cell.videoView.player?.pause()
                }
            }
            .disposed(by: disposeBag)

        // 포커스 해제
        contentCollectionView.rx.didEndDisplayingCell
            .bind { cell, indexPath in
                guard let cell = cell as? ContentCollectionViewCell else {
                    return
                }
                cell.videoView.player?.pause()
            }
            .disposed(by: disposeBag)
        
        contentCollectionView.rx.willEndDragging
            .bind { [weak self] velocity, targetContentOffset in
                let page = Int(targetContentOffset.pointee.x / (self?.frame.width)!)
                self?.pageControl.currentPage = page
            }
            .disposed(by: disposeBag)
    }
    
    override func configureUI() {
        [contentCollectionView, pageControl, heartButtonView, followedButtonView, contentDescriptionLabel, profileView, moreButton].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraint() {
        contentCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).inset(20)
        }
        
        heartButtonView.snp.makeConstraints { make in
            make.width.equalTo(32)
            make.height.equalTo(50)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(12)
            make.centerY.equalTo(self).multipliedBy(1.5)
        }
        
        followedButtonView.snp.makeConstraints { make in
            make.width.equalTo(32)
            make.height.equalTo(50)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(12)
            make.top.equalTo(heartButtonView.snp.bottom).offset(20)
        }
        
        contentDescriptionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.leading.equalTo(self).inset(12)
            make.width.equalTo(self).multipliedBy(0.7)
        }
        
        profileView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.bottom.equalTo(contentDescriptionLabel.snp.top).offset(-8)
            make.leading.trailing.equalTo(contentDescriptionLabel)
        }
        
        moreButton.snp.makeConstraints { make in
            make.leading.equalTo(contentDescriptionLabel.snp.trailing).offset(8)
            make.bottom.equalTo(contentDescriptionLabel)
        }
    }
    
    func bingindCellData(likeCount: Int, followCount: Int, description: String, profileURLString: String, displayName: String) {
        
        let likeCount = likeCount > 999 ?
            "\(likeCount / 1000)k"
            : String(likeCount)
        let followCount = followCount > 999 ?
            "\(followCount / 1000)k"
            : String(followCount)
        
        let url = URL(string: profileURLString)
        
        heartButtonView.titleLabel.text = likeCount
        followedButtonView.titleLabel.text = followCount
        contentDescriptionLabel.text = description
        profileView.profileNameLabel.text = displayName
        profileView.profileImageView.kf.setImage(with: url!)
    }
}


