import Foundation

// Extension for expanding tilde in paths
extension String {
    var expandingTildeInPath: String {
        return (self as NSString).expandingTildeInPath
    }
}
