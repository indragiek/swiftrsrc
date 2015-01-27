//
//  Map.swift
//  swiftrsrc
//
//  Created by Indragie on 1/27/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

func mapNonNil<S: SequenceType, T>(source: S, transform: S.Generator.Element -> T?) -> [T] {
    return reduce(source, []) { (var collection, element) in
        if let x = transform(element) {
            collection.append(x)
            return collection
        }
        return collection
    }
}
