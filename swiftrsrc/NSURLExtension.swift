//
//  NSURLExtension.swift
//  swiftrsrc
//
//  Created by Indragie on 1/28/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import Foundation

extension NSURL {
    var fileName: String? {
        return lastPathComponent?.stringByDeletingPathExtension
    }
}
