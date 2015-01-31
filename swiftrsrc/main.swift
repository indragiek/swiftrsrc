//
//  main.swift
//  swiftrsrc
//
//  Created by Indragie on 1/25/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import Foundation

struct GenerateCommand: CommandType {
    let verb = "generate"
    let function = "Generate Swift source code"
    
    func run(mode: CommandMode) -> Result<()> {
        return GenerateOptions.evaluate(mode).map { options in
            return ()
        }
    }
}

extension Platform: ArgumentType {
    static let name = "platform"
    
    static func fromString(string: String) -> Platform? {
        return Platform(rawValue: string)
    }
}

struct GenerateOptions: OptionsType {
    let platform: Platform
    let inputPath: String
    let outputPath: String
    
    static func create(platform: Platform)(inputPath: String)(outputPath: String) -> GenerateOptions {
        return GenerateOptions(platform: platform, inputPath: inputPath, outputPath: outputPath)
    }
    
    static func evaluate(m: CommandMode) -> Result<GenerateOptions> {
        return create
            <*> m <| Option(key: "platform", defaultValue: Platform.iOS, usage: "platform to generate code for. Must be either \"ios\" or \"osx\"")
            <*> m <| Option(usage: "input path to generate code from. Must be an *.xcassets, *.storyboard, or *.clr path")
            <*> m <| Option(usage: "output path to write the generated code to. If a directory path is specified, the generated code will be placed in a Swift source code file with the same name as the struct")
    }
}

let commands = CommandRegistry()
commands.register(GenerateCommand())
commands.register(HelpCommand(registry: commands))

var arguments = Process.arguments
assert(arguments.count >= 1)
arguments.removeAtIndex(0)

let helpMessage = "Please run \"swiftrsrc help\" to see a listing of the available commands."
if let verb = arguments.first {
    arguments.removeAtIndex(0)
    if let result = commands.runCommand(verb, arguments: arguments) {
        switch result {
        case .Failure(let error):
            println(error.localizedDescription)
        default: break
        }
    } else {
        fputs("Unrecognized command \(verb). " + helpMessage, stderr)
    }
} else {
    fputs("No command specified. " + helpMessage, stderr)
}
