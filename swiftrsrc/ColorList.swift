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
            if let colorString = list.colorWithKey(key)?.UIColorString {
                code += "\tstatic let \(key.camelCaseString) = "
                code += colorString + "\n"
            }
        }
        code += "}"
        return code
    }
}

private extension NSColor {
    var UIColorString: String? {
        if let srgbColor = colorUsingColorSpace(NSColorSpace.sRGBColorSpace()) {
            var components = [CGFloat](count: 4, repeatedValue: 0)
            srgbColor.getComponents(&components)
            return String(format: "UIColor(red: %.3f, green: %.3f, blue: %.3f, alpha: %.3f)", arguments: components.map { $0.native })
        }
        return nil
    }
}
