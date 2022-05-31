//
//  HTTPURLResponse+StatusCode.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2022-03-29.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int {
        return 200
    }
    
    var isOk: Bool {
        statusCode == Self.OK_200
    }
}
