//
//  NetworkError.swift
//  Fluffy
//
//  Created by Turan Çabuk on 29.10.2024.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case decodingError
    case unknownError
}
