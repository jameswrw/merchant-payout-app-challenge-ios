//
//  NetworkError.swift
//  ios-interview
//
//  Created by James Weatherley on 28/10/2026.
//

import Foundation

enum NetworkError: Error{
    case badStatus(Int, String)
}
