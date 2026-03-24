import CoreGraphics

func main() {
    guard let windows = CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID) as? [[String: Any]] else { return }
    for w in windows {
        let owner = w[kCGWindowOwnerName as String] as? String ?? ""
        let title = w[kCGWindowName as String] as? String ?? ""
        let layer = w[kCGWindowLayer as String] as? Int ?? -1
        if layer == 0 && !owner.isEmpty && !owner.contains(".") {
            let displayTitle = title.isEmpty ? owner : title
            print("\(owner)\t\(displayTitle)\t\t\t\(owner)")
        }
    }
}

main()
