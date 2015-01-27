//
//  FSTree.swift
//  swiftrsrc
//
//  Created by Indragie on 1/27/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import Foundation

func filter(tree: FSTree, f: FSTree -> Bool) -> FSTree? {
    if tree.isLeaf {
        return f(tree) ? tree : nil
    }
    let children = mapNonNil(tree.children, { filter($0, f) })
    return FSTree(URL: tree.URL, children: children)
}

func pruneEmptyDirectories(tree: FSTree) -> FSTree? {
    if tree.isLeaf {
        return (tree.URL.isDirectory(error: nil) ?? false) ? nil : tree
    }
    let children = mapNonNil(tree.children, { pruneEmptyDirectories($0) })
    if children.count != 0 {
        return FSTree(URL: tree.URL, children: children)
    }
    return nil
}

struct FSTree {
    let URL: NSURL
    let children = [FSTree]()
    
    var isLeaf: Bool { return children.count == 0 }
    
    init?(URL: NSURL, error: NSErrorPointer) {
        self.URL = URL
        var resourceError: NSError?
        var isDirectory: AnyObject?
        if let isDirectory = URL.isDirectory(error: &resourceError) {
            var contentsError: NSError?
            let fm = NSFileManager.defaultManager()
            if let contents = fm.contentsOfDirectoryAtURL(URL, includingPropertiesForKeys: [NSURLIsDirectoryKey], options: nil, error: &contentsError) as? [NSURL] {
                var children = [FSTree]()
                for URL in contents {
                    if let node = FSTree(URL: URL, error: nil) {
                        children.append(node)
                    }
                }
                self.children = children
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

extension NSURL {
    func isDirectory(#error: NSErrorPointer) -> Bool? {
        var isDirectory: AnyObject?
        if getResourceValue(&isDirectory, forKey: NSURLIsDirectoryKey, error: error) {
            return (isDirectory as NSNumber).boolValue
        }
        return nil
    }
}
