//
//  Optional.swift
//  swiftrsrc
//
//  Created by Indragie on 1/28/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

extension Optional {
    func chainMap<U>(f: T -> U?) -> U? {
        if let current = self {
            return f(current)
        } else {
            return nil
        }
    }
}
