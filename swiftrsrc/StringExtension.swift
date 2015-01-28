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
        let indentedLines: [String] = lines.map { (var line) in
            var indent = ""
            for i in 0..<level { indent += "\t" }
            return indent + line
        }
        return "\n".join(indentedLines)
    }
}
