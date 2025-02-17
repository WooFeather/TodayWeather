//
//  NetworkManager.swift
//  TodayWeather
//
//  Created by 조우현 on 2/17/25.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func callRequest<T: Decodable>(api: APIRequest, type: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) {
        let request = URLRequest(url: api.endpoint)
        URLSession.shared.dataTask(with: request) { data, response, error in
            print(request.url ?? "URL 없음")
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    completionHandler(.failure(NetworkError.invalidURL))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                // TODO: 상태코드 대응
                print(response ?? "")
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            if let data = data,
               let result = try? decoder.decode(T.self, from: data) {
                DispatchQueue.main.async {
                    completionHandler(.success(result))
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(.failure(NetworkError.decodingError))
                }
            }
        }.resume()
    }
}
