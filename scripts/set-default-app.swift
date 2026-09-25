#!/usr/bin/env swift
// Set the default macOS app for a file extension.
// Usage: scripts/set-default-app.swift <bundle-id> <extension>
// Example: scripts/set-default-app.swift com.microsoft.VSCode code-workspace
//
// `duti` can't set handlers for extensions with dynamic UTIs (e.g. .code-workspace)
// on recent macOS, so this uses the NSWorkspace API directly.
import AppKit
import UniformTypeIdentifiers

let args = CommandLine.arguments
guard args.count == 3 else {
  FileHandle.standardError.write("Usage: \(args[0]) <bundle-id> <extension>\n".data(using: .utf8)!)
  exit(2)
}
let (bundleID, ext) = (args[1], args[2])

guard let app = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleID) else {
  FileHandle.standardError.write("App not installed: \(bundleID)\n".data(using: .utf8)!)
  exit(1)
}
guard let type = UTType(filenameExtension: ext) else {
  FileHandle.standardError.write("Unknown extension: \(ext)\n".data(using: .utf8)!)
  exit(1)
}

let done = DispatchSemaphore(value: 0)
var failed = false
NSWorkspace.shared.setDefaultApplication(at: app, toOpen: type) { error in
  if let error {
    FileHandle.standardError.write("Failed for .\(ext): \(error.localizedDescription)\n".data(using: .utf8)!)
    failed = true
  } else {
    print("  .\(ext) → \(app.lastPathComponent)")
  }
  done.signal()
}
done.wait()
exit(failed ? 1 : 0)
