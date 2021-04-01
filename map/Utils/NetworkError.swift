//
//  NetworkError.swift
//  map
//
//  Created by 코드잉 on 2021/02/10.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case noData
    case clientError
    case serverError
    case decodingError
    case cancelError
}
