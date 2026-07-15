//
//  ContentView.swift
//  automation_testing_safari_1
//
//  Created by Phan Thi Bich Ngoc on 12/7/26.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State public var isImporting = false
    @State public var selectedFolderURL: URL?

    var body: some View {
        VStack(spacing: 20) {
            if let url = selectedFolderURL {
                Text("Selected Folder:")
                    .font(.headline)
                Text(url.path)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                Text("No folder selected")
                    .foregroundColor(.secondary)
            }

            Button(action: { isImporting = true }) {
                Label("Open Folder", systemImage: "folder.badge.plus")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        // Configured specifically to target directories
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.directory],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                // Grab the first selected directory URL
                if let url = urls.first {
                    handleSelectedFolder(url: url)
                }
            case .failure(let error):
                print("Error selecting folder: \(error.localizedDescription)")
            }
        }
    }

    public func handleSelectedFolder(url: URL) {
        // Essential step for reading files outside of your app sandbox
        guard url.startAccessingSecurityScopedResource() else {
            print("Permission denied to access folder.")
            return
        }
        
        // Defer ensures the resource is properly released when exiting this scope
        defer { url.stopAccessingSecurityScopedResource() }
        
        self.selectedFolderURL = url
        
        // Read contents example
        do {
            let contents = try FileManager.default.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles
            )
            print("Found \(contents.count) items inside this directory.")
        } catch {
            print("Failed to read folder contents: \(error.localizedDescription)")
        }
    }
}
