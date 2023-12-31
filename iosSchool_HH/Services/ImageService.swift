//
//  ImageService.swift
//  iosSchool_HH
//
//  Created by student on 30.11.2023.
//

import UIKit

protocol ImageService {
    func getImage(url: String, completion: @escaping (UIImage?) -> Void)
}

class ImageServiceImp: ImageService {

    private var imageDict: [String: UIImage] = [:]
    private let apiClient: ApiClient
    private let updateQueue = DispatchQueue(label: "ImageServiceQueue")

    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }

    func getImage(url: String, completion: @escaping (UIImage?) -> Void) {
        if let image = imageDict[url] {
            completion(image)
            return
        }
        if imageDict.count > 50 {
            imageDict.removeAll()
        }
        DispatchQueue.global().async {
            self.apiClient.requestImageData(url: url) { [weak self] data in
                guard let data else {
                    completion(nil)
                    return
                }
                self?.updateQueue.async {
                    let dataImage = UIImage(data: data)
                    self?.imageDict[url] = dataImage
                    completion(dataImage)
                }
            }
        }
    }
}
