//
//  APIService.swift
//  ShortformPJT
//
//  Created by 김태현 on 2023/02/10.
//

import Foundation
import Alamofire

enum FeedError: Int, Error {
    case invalidAuthorization = 401
    case takenEmail = 406
    case internalServerError = 500
    case emptyParameters = 501
}

extension FeedError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidAuthorization:
            return "토큰이 만료되었습니다. 다시 로그인 해주세요."
        case .takenEmail:
            return "이미 가입된 회원입니다. 로그인 해주세요."
        case .internalServerError:
            return "서버에 문제가 발생하였습니다."
        case .emptyParameters:
            return "잘못된 요청정보입니다."
        }
    }
}

final class APIService {
    
    static let shared = APIService()
    
    private init() { }
    
    func getContents(page: Int, completion: @escaping (Result<PixelContent, Error>) -> Void) {
        let url = "https://api.pexels.com/videos/popular?per_page=5&page=\(page)"
        
        AF.request(url)
            .responseDecodable(of: PixelContent.self) { response in
                
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(_):
                    guard let statudCode = response.response?.statusCode else { return }
                    guard let feedError = FeedError(rawValue: statudCode) else { return }
                    
                    completion(.failure(feedError))
                }
            }
        
    }
}
