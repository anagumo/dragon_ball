//
//  UIImage+Remote.swift
//  KCDragonBall
//
//  Created by Ariana Rodríguez on 12/03/25.
//

import UIKit
import OSLog

extension UIImageView {
    
    func setImage(stringURL: String) {
        guard let url = URL(string: stringURL) else {
            Logger.debug.error("\(APIClientError.malformedURL.message)")
            return
        }
        
        downloadWithURLSession(url: url) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.image = image
                }
            case .failure:
                Logger.debug.error("Image Download Error")
            }
        }
    }
    
    private func downloadWithURLSession(url: URL, completion: @escaping (Result<UIImage, Error>)  -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data,
                  let image = UIImage(data: data) else {
                Logger.debug.error("Image Download Error")
                completion(.failure(NSError(domain: "Image Download Error", code: 0)))
                return
            }
            
            completion(.success(image))
        }
        .resume()
    }
}
