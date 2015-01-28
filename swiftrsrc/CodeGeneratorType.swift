//
//  CodeGeneratorType.swift
//  swiftrsrc
//
//  Created by Indragie on 1/26/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

/// A type that can generate Swift source code
protocol CodeGeneratorType {
    func generateCode(#nested: Bool) -> String
}
