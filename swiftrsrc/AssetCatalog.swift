//
//  AssetCatalog.swift
//  swiftrsrc
//
//  Created by Indragie on 1/25/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import Foundation

/// Xcode asset catalog (*.xcassets)
struct AssetCatalog {
    let URL: NSURL
    let name: String
    private let tree: FSTree
    
    /// Failable initializer that returns `nil` if the URL cannot be accessed.
    init?(URL: NSURL, error: NSErrorPointer) {
        self.URL = URL
        self.name = URL.lastPathComponent!.stringByDeletingPathExtension
        if let tree = FSTree(URL: URL, error: error) {
            self.tree = tree.filter { node in
                if node.isLeaf { return false }
                let ext = node.URL.pathExtension
                return ext == nil || countElements(ext!) == 0 || ext == "imageset"
            }.pruneEmptyDirectories()
        } else {
            return nil
        }
    }
}

extension AssetCatalog: Printable {
    var description: String {
        return "AssetCatalog{name=\(name), URL=\(URL)}"
    }
}
