//
//  AssetCatalog.swift
//  swiftrsrc
//
//  Created by Indragie on 1/25/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import Foundation

/// Xcode asset catalog (*.xcassets)
struct AssetCatalog: Printable {
    
    /// Image set contained within an asset catalog (*.imageset)
    struct ImageSet: Printable {
        let URL: NSURL
        let name: String
        
        init(URL: NSURL) {
            self.URL = URL
            self.name = URL.lastPathComponent!.stringByDeletingPathExtension
        }
        
        // MARK: Printable
        
        var description: String {
            return "ImageSet{name=\(name), URL=\(URL)}"
        }
    }
    
    let URL: NSURL
    let name: String
    let imageSets: [ImageSet]
    
    init(URL: NSURL) {
        self.URL = URL
        self.name = URL.lastPathComponent!.stringByDeletingPathExtension
        
        var imageSets = [ImageSet]()
        for URL in contentsOfURL(URL, options: .SkipsHiddenFiles) {
            if URL.pathExtension! == "imageset" {
                imageSets.append(ImageSet(URL: URL))
            }
        }
        self.imageSets = imageSets
    }
    
    // MARK: Printable
    
    var description: String {
        return "AssetCatalog{name=\(name), URL=\(URL), imageSets=\(imageSets)"
    }
}
