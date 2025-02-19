import AppKit

func saveImage(_ image: NSImage, to filePath: String) {
    guard let tiffData = image.tiffRepresentation else {
        print("Failed to get TIFF data")
        return
    }
    
    guard let bitmap = NSBitmapImageRep(data: tiffData) else {
        print("Failed to create bitmap")
        return
    }
    
    guard let pngData = bitmap.representation(using: .png, properties: [:]) else {
        print("Failed to convert image to PNG")
        return
    }
    
    do {
        try pngData.write(to: URL(fileURLWithPath: filePath))
    } catch {
        print("File write error: \(error)")
    }
}
