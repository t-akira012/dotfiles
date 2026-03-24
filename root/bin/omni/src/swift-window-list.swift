import AppKit
import CoreGraphics

func main() {
    var appsWithWindows = Set<String>()

    let windows = CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID) as? [[String: Any]] ?? []
    for w in windows {
        let owner = w[kCGWindowOwnerName as String] as? String ?? ""
        let title = w[kCGWindowName as String] as? String ?? ""
        let layer = w[kCGWindowLayer as String] as? Int ?? -1
        if layer == 0 && !owner.isEmpty && !owner.contains(".") {
            appsWithWindows.insert(owner)
            let displayTitle = title.isEmpty ? owner : title
            print("\(owner)\t\(displayTitle)\t\t\t\(owner)")
        }
    }

    for app in NSWorkspace.shared.runningApplications {
        guard app.activationPolicy == .regular,
              let name = app.localizedName,
              !appsWithWindows.contains(name) else { continue }
        print("\(name)\t\(name)\t\t\t\(name)")
    }
}

main()
