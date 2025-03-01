//
//  NetworkManager.swift
//  TodayWeather
//
//  Created by 조우현 on 2/17/25.
//

import Foundation
import RxSwift

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func callRequest<T: Decodable>(api: APIRequest, type: T.Type) -> Single<T> {
        return Single.create { value in
            let request = URLRequest(url: api.endpoint)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                print(request.url ?? "URL 없음")
                if let error = error {
                    value(.failure(NetworkError.invalidURL))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode) else {
                    // TODO: 상태코드 대응
                    value(.failure(NetworkError.decodingError))
                    return
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                guard let data = data else {
                    return value(.failure(NetworkError.decodingError))
                }
                
                do {
                    let result = try decoder.decode(T.self, from: data)
                    value(.success(result))
                } catch {
                    value(.failure(NetworkError.missingData))
                }
            }.resume()
            
            return Disposables.create {
                print("🗑️ Disposed")
            }
        }
    }
}
