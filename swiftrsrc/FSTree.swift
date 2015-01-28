//
//  FSTree.swift
//  swiftrsrc
//
//  Created by Indragie on 1/27/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import Foundation

/// Represents a filesystem tree
struct FSTree {
    let URL: NSURL
    let children = [FSTree]()
    
    /// Leaf in the strict sense -- it is possible for a directory to
    /// be a leaf node if it is empty.
    var isLeaf: Bool { return children.count == 0 }
    
    var isDirectory: Bool { return URL.isDirectory(error: nil) ?? false }
    
    /// Failable initializer that will return `nil` if the file manager
    /// fails to get information for the specified URL.
    init?(URL: NSURL, error: NSErrorPointer) {
        self.URL = URL
        var resourceError: NSError?
        if let isDirectory = URL.isDirectory(error: &resourceError) {
            var contentsError: NSError?
            let fm = NSFileManager.defaultManager()
            if let contents = fm.contentsOfDirectoryAtURL(URL, includingPropertiesForKeys: [NSURLIsDirectoryKey], options: nil, error: &contentsError) as? [NSURL] {
                self.children = mapSome(contents, { FSTree(URL: $0, error: nil) })
            } else if error != nil {
                error.memory = contentsError
                return nil
            }
        } else if error != nil {
            error.memory = resourceError
            return nil
        }
    }
    
    private init(URL: NSURL, children: [FSTree]) {
        self.URL = URL
        self.children = children
    }
    
    /// Returns a new tree by recursively filtering all child nodes of the
    /// root node using the specified function.
    func filter(f: FSTree -> Bool) -> FSTree {
        return _filter(self, f, 0)!
    }
    
    /// Returns a new tree by recursively removing all child nodes of the root
    /// node that represent an empty directory.
    func pruneEmptyDirectories() -> FSTree {
        return _pruneEmptyDirectories(self, 0)!
    }
}

private func _filter(tree: FSTree, f: FSTree -> Bool, level: Int) -> FSTree? {
    if (level != 0 && !f(tree)) { return nil }
    let children = mapSome(tree.children, { _filter($0, f, level + 1) })
    return FSTree(URL: tree.URL, children: children)
}

private func _pruneEmptyDirectories(tree: FSTree, level: Int) -> FSTree? {
    if tree.isLeaf {
        return (level == 0) ? tree : (tree.isDirectory ? nil : tree)
    }
    let children = mapSome(tree.children, { _pruneEmptyDirectories($0, level + 1) })
    if level == 0 || children.count != 0 {
        return FSTree(URL: tree.URL, children: children)
    }
    return nil
}

extension FSTree: Printable {
    var description: String {
        return recursiveDescription(0)
    }
    
    private func recursiveDescription(level: Int) -> String {
        var desc = "FSTree{URL=\(URL), children="
        for node in children {
            desc += "\n"
            for i in 0..<level { desc += "\t" }
            desc += node.recursiveDescription(level + 1)
        }
        desc += "}"
        return desc
    }
}

private extension NSURL {
    func isDirectory(#error: NSErrorPointer) -> Bool? {
        var isDirectory: AnyObject?
        if getResourceValue(&isDirectory, forKey: NSURLIsDirectoryKey, error: error) {
            return (isDirectory as NSNumber).boolValue
        }
        return nil
    }
}
