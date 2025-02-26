#!/usr/bin/swift

import Foundation

class DirectoryWatcher {
    private let directoryURL: URL
    private var fileDescriptor: CInt = -1
    private var source: DispatchSourceFileSystemObject?
    private var lastFileList: Set<String> = .init()

    public var onDirectoryChange: (String) -> Void = { _ in }

    init(directoryPath: String) {
        self.directoryURL = URL(fileURLWithPath: directoryPath)
    }
    
    func startWatching() {
        lastFileList = currentFileList()
        fileDescriptor = open(directoryURL.path, O_EVTONLY)
        guard fileDescriptor != -1 else {
            print("Failed to open directory: \(directoryURL.path)")
            return
        }
        
        source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fileDescriptor,
            eventMask: .write,
            queue: DispatchQueue.global()
        )
        
        source?.setEventHandler { [weak self] in
        
            self?.directoryDidChange()
        }
        
        source?.setCancelHandler { [weak self] in
            guard let self = self else { return }
            close(self.fileDescriptor)
            self.fileDescriptor = -1
        }
       
        source?.resume()
        print("Started watching \(directoryURL.path)")
    }
    
    func stopWatching() {
        source?.cancel()
        source = nil
    }
    
    private func directoryDidChange() {
        print("Directory contents have changed!")
        let newFileList = currentFileList()
        
        let addedFiles = newFileList.subtracting(lastFileList).filter { 
            $0.hasSuffix("webloc")
        }
        for file in addedFiles{
            let fullFileName = directoryURL.appending(path: file).path
            print("\(fullFileName) was added")
            onDirectoryChange(fullFileName)            
        }
        lastFileList = newFileList
    }

    private func currentFileList() -> Set<String> {
        if let files = try? FileManager.default.contentsOfDirectory(atPath: directoryURL.path) {
            return Set(files)
        }
        return .init()
    }
}

extension String {
    var expandingTildeInPath: String {
        return (self as NSString).expandingTildeInPath
    }
}

@discardableResult
func shell(_ command: String) -> String {
    let process = Process()
    process.launchPath = "/bin/bash"
    print(command)
    process.arguments = ["-c", command]

    let outputPipe = Pipe()
    process.standardOutput = outputPipe
    process.launch()

    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    return String(data: outputData, encoding: .utf8) ?? ""
}

// Function to handle SIGINT (Ctrl+C)
func handleSIGINT(_ signal: Int32) {
    print("\nReceived SIGINT, stopping RunLoop...")
    CFRunLoopStop(CFRunLoopGetCurrent()) // Stop the RunLoop safely
    CFRunLoopStop(CFRunLoopGetMain())
    exit(0)
}

signal(SIGINT, handleSIGINT)

let scriptDirectory = URL(fileURLWithPath: CommandLine.arguments[0]).deletingLastPathComponent().path
print("Script is running from directory: \(scriptDirectory)")

let directoryPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : scriptDirectory + "/CreateQR"
let watcher = DirectoryWatcher(directoryPath: directoryPath.expandingTildeInPath)
watcher.onDirectoryChange = { file in 
    let url = shell("/usr/libexec/PlistBuddy -c \"Print :URL\" \"\(file)\" 2>/dev/null")
    let output = shell(scriptDirectory + "/qr.sh \"\(url)\"")
    print(output)
    try? FileManager.default.removeItem(atPath: file)
}
watcher.startWatching()

RunLoop.current.run()
watcher.stopWatching()
print("Script has stopped.")