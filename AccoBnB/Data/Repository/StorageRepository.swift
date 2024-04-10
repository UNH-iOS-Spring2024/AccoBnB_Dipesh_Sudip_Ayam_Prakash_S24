//
//  StorageRepository.swift
//  AccoBnB
//
//  Created by AP on 10/04/2024.
//

import Foundation
import UIKit

protocol StorageRepository{
    func uploadImagetoFirebaseStorage(_ image: UIImage,storageName: String, completion: @escaping (Result<String, Error>) -> Void)
}
