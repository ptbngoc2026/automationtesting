//
//  automation_testing_safari_1UITests.swift
//  automation_testing_safari_1UITests
//
//  Created by Phan Thi Bich Ngoc on 12/7/26.
//

import SwiftUI
import XCTest
import ScreenCaptureKit
import Foundation
import ImageIO
import UniformTypeIdentifiers

final class automation_testing_safari_1UITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor
    func captureSafariWindow() async -> NSImage? {
        do {
            // 1. Get all shareable content on the screen
            let content = try await SCShareableContent.current
            
            // 2. Find the Safari window
            guard let safariWindow = content.windows.first(where: {
                $0.owningApplication?.bundleIdentifier == "com.apple.Safari" && $0.isOnScreen
            }) else {
                print("Safari window not found or is not currently active on screen.")
                return nil
            }
            
            // 3. Create a content filter targeting only the Safari window
            let filter = SCContentFilter(desktopIndependentWindow: safariWindow)
            
            // 4. Configure screenshot properties (Default settings)
            let configuration = SCScreenshotConfiguration()
            
            // 5. Capture the screenshot as a CGImage
            let output = try await SCScreenshotManager.captureScreenshot(
                contentFilter: filter,
                configuration: configuration
            )
            
            // 6. Convert the SDR/HDR image to an NSImage for macOS UI usage
            guard let cgImage = output.sdrImage else {
                fatalError()
            }
            
            let nsImage = NSImage(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height))
            
            return nsImage
            
        } catch {
            print("Failed to capture screenshot: \(error.localizedDescription)")
            return nil
        }
    }
    
    @discardableResult
    func saveCGImage(_ cgImage: CGImage, to destinationURL: URL) -> Bool {
        // 1. Create an image destination for a PNG file (change to .jpeg if needed)
        guard let destination = CGImageDestinationCreateWithURL(
            destinationURL as CFURL,
            UTType.png.identifier as CFString,
            1,
            nil
        ) else {
            return false
        }
        
        // 2. Add the CGImage to the destination pipeline
        CGImageDestinationAddImage(destination, cgImage, nil)
        
        // 3. Finalize and write the data out to disk
        return CGImageDestinationFinalize(destination)
    }
    
    @MainActor
    func takeRegionScreenshot() async {
        //waitForExpectations(timeout: 5.0, handler: nil)
        

        let config = SCScreenshotConfiguration()
        let captureRect = CGRect(x: 0, y: 0, width: 500, height: 500)
        
        do {
            // Capture the specified screen bounds asynchronously
            let output = try await SCScreenshotManager.captureScreenshot(
                rect: captureRect,
                configuration: config
            )
            
            //let opensettingsbtn = app.buttons["_NS:67"]
            //let exists = opensettingsbtn.waitForExistence(timeout: 20.0)
            //XCTAssertTrue(exists, "The Open Settings button did not appear in time.")
            //opensettingsbtn.tap()
            //let toogle = app.switches["automation_testing_safari_1UITests-Runner_Toggle"]
            //toogle.tap()
            
            // Retrieve the standard dynamic range image representation
            if let cgImage = output.sdrImage {
                // Process or save your captured CGImage
                // Define where you want to save the screenshot
                let fileManager = FileManager.default
                guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                    fatalError("Could not locate Documents directory.")
                }

                // Create a unique filename
                let destinationURL = documentsDirectory.appendingPathComponent("screenshot_\(Date().timeIntervalSince1970).png")

                // Assuming 'myScreenshotCGImage' is your captured CGImage object
                let success = saveCGImage(cgImage, to: destinationURL)
                //let success = saveCGImage(cgImage, to: //"/Users/phanthibichngoc/Desktop/automation_testing_safari_1/screenshot_\(Date()//////.timeIntervalSince1970).png")
                print("Successfully captured screenshot: \(cgImage.width)x\(cgImage.height)")
            }
        } catch {
            print("Failed to capture screenshot: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        //let couterText = app.staticTexts.firstMatch
        //XCTAssert(couterText.label, "0")
        
        //let increaseButton = app.buttons["Increase counter"]
        //increaseButton.tap()
        
        //XCTAssertEqual(couterText.label, "1")
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // XCUIAutomation Documentation
        // https://developer.apple.com/documentation/xcuiautomation
        
        // 1. Launch the native Safari application using its bundle identifier
        let safariApp = XCUIApplication(bundleIdentifier: "com.apple.Safari") // Use "com.apple.Safari" for macOS
        safariApp.launch()
        
        // 2. Locate and tap the address bar (Smart Search Field)
        let addressBar = safariApp.textFields["smart search field"]
        XCTAssertTrue(addressBar.waitForExistence(timeout: 10.0))
        addressBar.tap()
        
        // 3. Type the URL and press enter
        addressBar.typeText("https://www.google.com\n")
        
        // 4. Interact with elements on the loaded webpage
        let webViews = safariApp.webViews
        let storeButton = webViews.links["AI Mode"]
        
        if storeButton.waitForExistence(timeout: 10.0) {
            storeButton.tap()
        }
        
        Task {
            await takeRegionScreenshot()
        }
        
        //xcodebuild test \-scheme automation_testing_safari_1 \-destination 'platform=macOS' \-resultBundlePath ./TestResults.xcresult
        //xctesthtmlreport -r ./TestResults.xcresult
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        //measure(metrics: [XCTApplicationLaunchMetric()]) {
            //XCUIApplication().launch()
        //}
    }
}
