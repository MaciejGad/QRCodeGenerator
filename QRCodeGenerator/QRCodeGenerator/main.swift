import Foundation

// Script usage
let arguments = CommandLine.arguments
if arguments.count < 3 {
    print("Usage: \(arguments[0]) <URL> <Output Path>")
    exit(1)
}

let url = arguments[1]
let outputFilePath = arguments[2].expandingTildeInPath
generateQRCode(from: url, outputFilePath: outputFilePath)
