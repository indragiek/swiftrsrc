//
//  SequenceOperations.swift
//  swiftrsrc
//
//  Created by Indragie on 1/28/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

func elementPassingTest<S: SequenceType>(sequence: S, test: S.Generator.Element -> Bool) -> S.Generator.Element? {
    for element in sequence {
        if test(element) { return element }
    }
    return nil
}
