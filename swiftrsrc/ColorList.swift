//
//  ColorList.swift
//  swiftrsrc
//
//  Created by Indragie on 1/28/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import Cocoa

/// Color list loaded from a *.clr file
struct ColorList {
    let URL: NSURL
    let name: String
    private let list: NSColorList
    
    init?(URL: NSURL) {
        if let list = NSColorList(name: URL.fileName!, fromFile: URL.path) {
            self.list = list
            self.URL = URL
            self.name = list.name!
        } else {
            return nil
        }
    }
}

// MARK: Printable

extension ColorList: Printable {
    var description: String {
        return "ColorList{name=\(name), URL=\(URL)}"
    }
}

// MARK: CodeGeneratorType

extension ColorList: CodeGeneratorType {
    func generateCode(#nested: Bool) -> String {
        var code = "struct \(name.camelCaseString) {\n"
        for key in list.allKeys as [String] {
            code += "\tstatic let \(key.camelCaseString) = "
            code += UIColorStringForColor(list.colorWithKey(key)!) + "\n"
        }
        code += "}"
        return code
    }
}
