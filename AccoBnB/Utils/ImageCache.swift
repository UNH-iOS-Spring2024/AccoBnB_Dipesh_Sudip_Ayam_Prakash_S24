//
//  ImageCache.swift
//  AccoBnB
//
//  Created by Sudip Thapa on 4/10/24.
//
import SwiftUI

extension URLCache {
    static let imageCache = URLCache(memoryCapacity: 512_000_000, diskCapacity: 10_000_000_000)
}
