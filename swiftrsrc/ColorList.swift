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
    static let ErrorDomain = "ColorListErrorDomain"
    enum ErrorCode: Int {
        case UnableToOpen = 1
    }
    
    let URL: NSURL
    let name: String
    private let list: NSColorList
    
    init?(URL: NSURL, error: NSErrorPointer) {
        if let list = NSColorList(name: URL.fileName!, fromFile: URL.path) {
            self.list = list
            self.URL = URL
            self.name = list.name! + "ColorList"
        } else {
            if error != nil {
                error.memory = NSError(
                    domain: ColorList.ErrorDomain,
                    code: ErrorCode.UnableToOpen.rawValue,
                    userInfo: [NSLocalizedDescriptionKey: "Unable to open color list at URL \(URL)"]
                )
            }
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
    func generateCodeForPlatform(platform: Platform) -> String {
        var code = "struct \(name.camelCaseString) {\n"
        for key in list.allKeys as [String] {
            if let colorString = list.colorWithKey(key)?.colorStringForPlatform(platform) {
                code += "\tstatic let \(key.camelCaseString) = "
                code += colorString + "\n"
            }
        }
        code += "}"
        return code
    }
}

private extension NSColor {
    func colorStringForPlatform(platform: Platform) -> String? {
        let colorSpace: NSColorSpace = {
            switch platform {
            case .iOS: return NSColorSpace.sRGBColorSpace()
            case .OSX: return NSColorSpace.deviceRGBColorSpace()
            }
        }()
        if let color = colorUsingColorSpace(colorSpace) {
            let colorFormat: String = {
                switch platform {
                case .iOS: return "UIColor(red: %.3f, green: %.3f, blue: %.3f, alpha: %.3f)"
                case .OSX: return "NSColor(deviceRed: %.3f, green: %.3f, blue: %.3f, alpha: %.3f)"
                }
            }()
            
            var components = [CGFloat](count: 4, repeatedValue: 0)
            color.getComponents(&components)
            return String(format: colorFormat, arguments: components.map { $0.native })
        }
        return nil
    }
}
