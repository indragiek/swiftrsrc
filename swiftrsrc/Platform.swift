//
//  Platform.swift
//  swiftrsrc
//
//  Created by Indragie on 1/31/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

enum Platform: String {
    case iOS = "ios"
    case OSX = "osx"
}

extension Platform: Printable {
    var description: String {
        return rawValue
    }
}

extension Platform: ArgumentType {
    static let name = "platform"
    
    static func fromString(string: String) -> Platform? {
        return Platform(rawValue: string)
    }
}
