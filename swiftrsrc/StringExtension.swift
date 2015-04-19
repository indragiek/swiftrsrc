//
//  StringExtension.swift
//  swiftrsrc
//
//  Created by Indragie on 1/27/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import Foundation

extension String {
    func indent(level: Int) -> String {
        let lines = componentsSeparatedByString("\n")
        let indentedLines: [String] = lines.map { line in
            var indent = ""
            for _ in 0..<level { indent += "\t" }
            return indent + line
        }
        return "\n".join(indentedLines)
    }
    
    var camelCaseString: String {
        struct Cached {
            static var CamelCaseCharacterSet = NSCharacterSet(charactersInString: ".-_ ")
        }
        let components = componentsSeparatedByCharactersInSet(Cached.CamelCaseCharacterSet)
        let camelCaseString = "".join(components.map({ $0.firstLetterCapitalizedString }))
        return camelCaseString.stringByRemovingCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
    }
    
    private func stringByRemovingCharactersInSet(set: NSCharacterSet) -> String {
        let components = componentsSeparatedByCharactersInSet(set)
        return "".join(components)
    }
    
    private var firstLetterCapitalizedString: String {
        if count(self) == 0 { return self }
        
        let index = advance(startIndex, 1)
        let capitalized = substringToIndex(index).uppercaseString
        let rest = substringFromIndex(index)
        return capitalized + rest
    }
    
    func writeToURL(URL: NSURL, atomically: Bool, encoding: NSStringEncoding) -> Result<(), NSError> {
        var error: NSError?
        if writeToURL(URL, atomically: atomically, encoding: encoding, error: &error) {
            return success(())
        } else {
            return failure(error!)
        }
    }
}
