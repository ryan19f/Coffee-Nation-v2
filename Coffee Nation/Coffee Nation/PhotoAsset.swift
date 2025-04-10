//
//  PhotoAsset.swift
//  Location
//
//  Created by Student on 3/17/25.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers


class PhotoAsset: Codable, Hashable, Identifiable {
    
    
    let id: UUID
    var url: URL
    var contentType: UTType
    
    var absoluteURL: URL {
        let documetsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return documetsDirectoryURL!.appending(component: url.path())
    }
    
    var uiImage: UIImage{
        if let img = UIImage(contentsOfFile: absoluteURL.path()){
            return img
        }
        else{
            return UIImage(systemName:"photo")!
        }
    }
    var image: Image{
        return Image(uiImage: uiImage)
    }
    
    init(id: UUID, url: URL, contentType: UTType) {
        self.id = id
        self.url = url
        self.contentType = contentType
    }
    
    static func debugPhotoAsset () -> PhotoAsset {
        guard let bundleUrl = Bundle.main.url(forResource: "screen1.png", withExtension: nil) else{
            return PhotoAsset(id: UUID(), url: URL(string: "screen1.png")!, contentType: UTType.png)
        }
        let documentsDirectionURL = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first
        
        let destinationUrl = documentsDirectionURL!.appending(component:"screen1.png")
        try! FileManager.default.copyItem(at: bundleUrl, to: destinationUrl)
        let asset = PhotoAsset(id: UUID(), url: URL(string: "screen1.png")!, contentType: UTType.png)
        return asset
        
    }
    
    static func == (lhs: PhotoAsset, rhs: PhotoAsset) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(url)
        hasher.combine(contentType)
    }
    func deleteFile() {
        do {
            try FileManager.default.removeItem(at: absoluteURL)
        } catch {
            print(error)
        }
    }
    
}

extension PhotoAsset: Transferable {
    
    static var transferRepresentation: some TransferRepresentation {
        
        FileRepresentation(importedContentType: .png, importing: { received in
            return PhotoAsset.copyReceivedFile(received, contentType: .png)
        })
        FileRepresentation(importedContentType: .jpeg, importing: { received in
            return PhotoAsset.copyReceivedFile(received, contentType: .jpeg)
        })
        FileRepresentation(importedContentType: .heic, importing: { received in
            return PhotoAsset.copyReceivedFile(received, contentType: .heic)
        })
        
    }
    static func copyReceivedFile(_ received: ReceivedTransferredFile, contentType: UTType) -> PhotoAsset{
        let now = Date().formatted(Date.ISO8601FormatStyle().timeSeparator(.omitted))
        let name = "\(now)-\(received.file.lastPathComponent)"
        guard let assetUrl = URL(string: name) else {
            return PhotoAsset(id: UUID(), url: URL(string: "missing")!, contentType: contentType)
        }
        
        //construct the url to copy the received file
        let documentsDirectionURL = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first
        
        let destinationUrl = documentsDirectionURL!.appending(path: assetUrl.path())
        
        //actual copy
        try? FileManager.default.copyItem(at: received.file, to: destinationUrl)
        
        //retun the photoasset
        return PhotoAsset(id: UUID(), url: assetUrl, contentType: contentType)
    }
}
