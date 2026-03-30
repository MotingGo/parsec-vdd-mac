import Foundation
import CoreGraphics
import CGVirtualDisplayPrivate

// MARK: - Argument Parsing

struct Config {
    var width: UInt = 1920
    var height: UInt = 1080
    var fps: Double = 60.0
}

func parseArgs() -> Config {
    var config = Config()
    let args = CommandLine.arguments
    var i = 1
    while i < args.count {
        switch args[i] {
        case "--width" where i + 1 < args.count:
            i += 1; config.width = UInt(args[i]) ?? config.width
        case "--height" where i + 1 < args.count:
            i += 1; config.height = UInt(args[i]) ?? config.height
        case "--fps" where i + 1 < args.count:
            i += 1; config.fps = Double(args[i]) ?? config.fps
        case "--help", "-h":
            print("Usage: parsec-vdd [--width 1920] [--height 1080] [--fps 60]")
            exit(0)
        default:
            print("Unknown argument: \(args[i]). Use --help for usage.")
            exit(1)
        }
        i += 1
    }
    return config
}

// MARK: - Virtual Display

var virtualDisplay: CGVirtualDisplay?

func createVirtualDisplay(config: Config) -> CGVirtualDisplay? {
    let descriptor = CGVirtualDisplayDescriptor()
    descriptor.name = "ParsecVDD"
    descriptor.maxPixelsWide = UInt32(config.width)
    descriptor.maxPixelsHigh = UInt32(config.height)
    descriptor.sizeInMillimeters = CGSize(width: 530, height: 300)
    descriptor.vendorID = 0x1234
    descriptor.productID = 0x1001
    descriptor.serialNum = 0x0001
    descriptor.setDispatchQueue(DispatchQueue.main)
    descriptor.terminationHandler = { _, _ in
        print("Virtual display terminated.")
    }

    let display = CGVirtualDisplay(descriptor: descriptor)
    guard display.displayID != 0 else {
        print("Error: Failed to create virtual display.")
        return nil
    }

    let mode = CGVirtualDisplayMode(width: config.width, height: config.height, refreshRate: config.fps)
    let settings = CGVirtualDisplaySettings()
    settings.hiDPI = 0
    settings.modes = [mode]

    guard display.apply(settings) else {
        print("Error: Failed to apply display settings.")
        return nil
    }

    return display
}

// MARK: - Signal Handling

func setupSignalHandler() {
    let handler: @convention(c) (Int32) -> Void = { sig in
        print("\nShutting down virtual display...")
        virtualDisplay = nil
        exit(0)
    }
    signal(SIGINT, handler)
    signal(SIGTERM, handler)
}

// MARK: - Main

let config = parseArgs()
print("Creating virtual display: \(config.width)x\(config.height) @ \(Int(config.fps))fps")

guard let display = createVirtualDisplay(config: config) else {
    exit(1)
}
virtualDisplay = display

print("Virtual display created successfully!")
print("Display ID: \(display.displayID)")
print("Configure Sunshine to capture this display ID.")
print("Press Ctrl+C to stop.")

setupSignalHandler()
RunLoop.main.run()
