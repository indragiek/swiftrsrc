//
//  FSNode.swift
//  swiftrsrc
//
//  Created by Indragie on 1/27/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import Foundation

struct FSNode {
    let URL: NSURL
    let children = [FSNode]()
    
    init(URL: NSURL) {
        self.URL = URL
        var resourceError: NSError?
        var isDirectory: AnyObject?
        if URL.getResourceValue(&isDirectory, forKey: NSURLIsDirectoryKey, error: &resourceError) {
            if (isDirectory as NSNumber).boolValue {
                var contentsError: NSError?
                let fm = NSFileManager.defaultManager()
                if let contents = fm.contentsOfDirectoryAtURL(URL, includingPropertiesForKeys: [NSURLIsDirectoryKey], options: nil, error: &contentsError) as? [NSURL] {
                    children = contents.map { FSNode(URL: $0) }
                } else {
                    fputs("Error getting contents in directory \(URL): \(contentsError)", stderr)
                }
            }
        } else {
            fputs("Error getting resource value for URL \(URL): \(resourceError)", stderr)
        }
    }
}

extension FSNode: Printable {
    var description: String {
        return recursiveDescription(0)
    }
    
    private func recursiveDescription(level: Int) -> String {
        var desc = "FSNode{URL=\(URL), children="
        for node in children {
            desc += "\n"
            for i in 0..<level { desc += "\t" }
            desc += node.recursiveDescription(level + 1)
        }
        desc += "}"
        return desc
    }
}
