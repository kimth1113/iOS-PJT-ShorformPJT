//
//  ShortformViewModel.swift
//  ShortformPJT
//
//  Created by 김태현 on 2023/02/14.
//

import Foundation
import RxCocoa
import RxSwift

protocol ShortformViewModelProtocol {
    
    associatedtype ControllerInput
    associatedtype ControllerOutput
    
    func controllerTrasform(input: ControllerInput) -> ControllerOutput
    
    associatedtype MainViewInput
    associatedtype MainViewOutput
    
    func mainViewTrasform(input: MainViewInput) -> MainViewOutput
    
    associatedtype PostCellInput
    associatedtype PostCellOutput
    
    func postCellTrasform(input: PostCellInput) -> PostCellOutput
    
    associatedtype ContentCellInput
    associatedtype ContentCellOutput
    
    func contentCellTrasform(input: ContentCellInput) -> ContentCellOutput
}

class ShortformViewModel: ShortformViewModelProtocol {
    
    static let shared = ShortformViewModel()
    
    private init() { }
    
    let posts = BehaviorRelay<[Video]>(value: [])
    var postsCnt = 0
    var page = 1
    
    // 세로 몇번쨰
    var currentTag = BehaviorRelay<Int>(value: 0)
    
    var isMuted = BehaviorRelay(value: false)
    
    let disposeBag: DisposeBag = DisposeBag()
}

// ShortformController
extension ShortformViewModel {
    
    struct ControllerInput { }
    
    struct ControllerOutput { }
    
    func controllerTrasform(input: ControllerInput) -> ControllerOutput {
        return ControllerOutput()
    }
    
    // APIService에 있으면 더 좋은 코드
    func getinitialContents(completion: @escaping () -> Void, errorCompletion: @escaping () -> Void) {
        // Posts 요청
        APIService.shared.getContents(page: 1) { [weak self] response in
            switch response {
            case .success(let success):
                completion()
                self?.postsCnt += success.perPage
                self?.posts.accept((self?.posts.value)! + success.videos)

            case .failure(_):
                errorCompletion()
            }
        }
    }
    
    func getContents(page: Int, completion: @escaping () -> Void) {
        // Posts 요청
        APIService.shared.getContents(page: page) { [weak self] response in
            switch response {
            case .success(let success):
                self?.postsCnt += success.perPage
                self?.posts.accept((self?.posts.value)! + success.videos)
            case .failure(_):
                completion()
            }
        }
    }
}

extension ShortformViewModel {
    
    struct MainViewInput {
        let prefetch: ControlEvent<[IndexPath]>
        let muteButtonTap: ControlEvent<Void>
    }
    
    struct MainViewOutput {
        let prefetch: ControlEvent<[IndexPath]>
        let muteButtonTap: ControlEvent<Void>
    }
    
    func mainViewTrasform(input: MainViewInput) -> MainViewOutput {
        return MainViewOutput(prefetch: input.prefetch, muteButtonTap: input.muteButtonTap)
    }
}

extension ShortformViewModel {
    
    struct PostCellInput {
        let moreButtonTap: ControlEvent<Void>
    }
    
    struct PostCellOutput {
        let moreButtonTap: ControlEvent<Void>
    }
    
    func postCellTrasform(input: PostCellInput) -> PostCellOutput {
        return PostCellOutput(moreButtonTap: input.moreButtonTap)
    }
}

extension ShortformViewModel {
    
    struct ContentCellInput { }
    
    struct ContentCellOutput { }
    
    func contentCellTrasform(input: ContentCellInput) -> ContentCellOutput {
        return ContentCellOutput()
    }
}
