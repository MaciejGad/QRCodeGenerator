import CoreImage
import CoreImage.CIFilterBuiltins
import AppKit

func generateQRCode(from string: String, outputFilePath: String) {
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    guard let data = string.data(using: .ascii) else {
        print("Invalid input string")
        return
    }
    
    filter.message = data
    
    if let qrCodeImage = filter.outputImage {
        let transformedImage = qrCodeImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        
        if let cgImage = context.createCGImage(transformedImage, from: transformedImage.extent) {
            let nsImage = NSImage(cgImage: cgImage, size: NSSize(width: transformedImage.extent.width, height: transformedImage.extent.height))
            saveImage(nsImage, to: outputFilePath)
            print("QR Code saved at: \(outputFilePath)")
        }
    }
}
