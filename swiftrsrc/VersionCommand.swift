//
//  VersionCommand.swift
//  swiftrsrc
//
//  Created by Syo Ikeda on 5/19/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

struct VersionCommand: CommandType {
    let verb = "version"
    let function = "Display the current version of swiftrsrc"

    let version: String

    init(version: String) {
        self.version = version
    }

    func run(mode: CommandMode) -> Result<(), CommandantError> {
        switch mode {
        case .Arguments:
            println(version)

        default:
            break
        }

        return success(())
    }
}
