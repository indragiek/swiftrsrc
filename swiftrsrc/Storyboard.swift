//
//  Storyboard.swift
//  swiftrsrc
//
//  Created by Indragie on 1/29/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import Foundation

/// Storyboard file (*.storyboard)
struct Storyboard {
    let URL: NSURL
    let name: String
    private let document: NSXMLDocument
    
    init?(URL: NSURL, error: NSErrorPointer) {
        if let document = NSXMLDocument(contentsOfURL: URL, options: .allZeros, error: error) {
            self.document = document
            self.URL = URL
            self.name = URL.fileName! + "Storyboard"
        } else {
            return nil
        }
    }
}

// MARK: Printable

extension Storyboard: Printable {
    var description: String {
        return "Storyboard{name=\(name), URL=\(URL)}"
    }
}

// MARK: CodeGeneratorType

extension Storyboard: CodeGeneratorType {
    func generateCodeForPlatform(platform: Platform) -> String {
        let stringsForXPath: String -> [String] = {
            let nodes = self.document.nodesForXPath($0, error: nil) as! [NSXMLNode]
            return mapSome(nodes, { $0.stringValue })
        }
        
        let constantDeclaration: String -> String = {
            return "static let \($0.camelCaseString) = \"\($0)\"\n"
        }
        
        let storyboardIdentifiers = Set(stringsForXPath("//@storyboardIdentifier"))
        let reuseIdentifiers = Set(stringsForXPath("//@reuseIdentifier"))
        let segueIdentifiers = Set(stringsForXPath("//segue/@identifier"))
        
        var code = "struct \(name.camelCaseString) {\n"
        let categories = [
            ("StoryboardIdentifiers", storyboardIdentifiers),
            ("ReuseIdentifiers", reuseIdentifiers),
            ("SegueIdentifiers", segueIdentifiers)
        ]
        for (name, identifiers) in categories {
            code += "\tstruct \(name) {\n"
            for id in identifiers {
                code += "\t\tstatic let \(id.camelCaseString) = \"\(id)\"\n"
            }
            code += "\t}\n"
        }
        code += "}"
        return code
    }
}
