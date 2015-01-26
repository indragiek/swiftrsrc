//
//  FilesystemEnumeration.swift
//  swiftrsrc
//
//  Created by Indragie on 1/25/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import Foundation

extension NSDirectoryEnumerator: SequenceType {
    public func generate() -> GeneratorOf<NSURL> {
        let generator = NSFastGenerator(self)
        return GeneratorOf<NSURL> {
            generator.next() as? NSURL
        }
    }
}

func contentsOfURL(URL: NSURL, options: NSDirectoryEnumerationOptions = .allZeros, propertyKeys: [String]? = nil) -> NSDirectoryEnumerator {
    return NSFileManager.defaultManager().enumeratorAtURL(URL, includingPropertiesForKeys: propertyKeys, options: options, errorHandler: { (URL, error) in
        fputs("Enumeration error for \(URL): \(error)", stderr)
        return false
    })!
}
