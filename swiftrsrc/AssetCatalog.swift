//
//  AssetCatalog.swift
//  swiftrsrc
//
//  Created by Indragie on 1/25/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import Foundation

private let ImagesetFileExtension = "imageset"

/// Xcode asset catalog (*.xcassets)
struct AssetCatalog {
    let URL: NSURL
    let name: String
    private let tree: FSTree
    
    /// Failable initializer that returns `nil` if the URL cannot be accessed.
    init?(URL: NSURL, error: NSErrorPointer) {
        if let tree = FSTree(URL: URL, error: error) {
            self.tree = tree.filter { node in
                if node.isLeaf { return false }
                let ext = node.URL.pathExtension
                return ext == nil || countElements(ext!) == 0 || ext == ImagesetFileExtension
            }
            self.URL = URL
            self.name = URL.fileName!
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

extension AssetCatalog: CodeGeneratorType {
    func generateCode() -> String {
        return _generateCode(tree, 0)
    }
}

private func _generateCode(tree: FSTree, level: Int) -> String {
    let name = tree.URL.fileName!
    let indentNewline: (String) -> String = { $0.indent(level) + "\n" }
    
    if tree.URL.pathExtension == ImagesetFileExtension {
        return indentNewline("static let \(name) = UIImage(named: \"\(name)\")")
    } else {
        var code = ""
        code += indentNewline("struct \(name) {")
        code += reduce(tree.children, "", { $0 + _generateCode($1, level + 1) })
        code += indentNewline("}")
        return code
    }
}

private extension NSURL {
    var fileName: String? {
        return lastPathComponent?.stringByDeletingPathExtension
    }
}

