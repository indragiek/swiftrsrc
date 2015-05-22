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

        func uniqueSorted(array: [String]) -> [String] {
            return Array(Set(array)).sorted(<)
        }
        
        let storyboardIdentifiers = uniqueSorted(stringsForXPath("//@storyboardIdentifier"))
        let reuseIdentifiers = uniqueSorted(stringsForXPath("//@reuseIdentifier"))
        let segueIdentifiers = uniqueSorted(stringsForXPath("//segue/@identifier"))
        // For WatchKit Storyboards
        let controllerIdentifiers = uniqueSorted(stringsForXPath("//controller/@identifier"))
        let rowControllerIdentifiers = uniqueSorted(stringsForXPath("//tableRow/@identifier"))

        var code = "struct \(name.camelCaseString) {\n"

        // Skip empty category
        let categories = [
            ("StoryboardIdentifiers", storyboardIdentifiers),
            ("ReuseIdentifiers", reuseIdentifiers),
            ("SegueIdentifiers", segueIdentifiers),
            ("ControllerIdentifiers", controllerIdentifiers),
            ("RowControllerIdentifiers", rowControllerIdentifiers),
        ].filter { !$0.1.isEmpty }

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
