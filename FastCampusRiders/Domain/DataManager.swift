//
//  DataManager.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/08/27.
//

import Foundation
import MBAkit

class DataManager {
    static let `default` = DataManager()
    private init() { }
    
    private lazy var fileQueue = DispatchQueue(label: "DataManager", qos: .background)
    private lazy var memCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = 100_000_000
        return cache
    }()
    
    enum DataLocationType {
        case cache
        case document
        
        var directoryPath: String? {
            switch self {
            case .cache:
                return NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                           .allDomainsMask, true).first
            case .document:
                return NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .allDomainsMask, true).first
            }
        }
    }
    
    enum DataStorageType {
        case cache(data: Data)
        case document(data: Data)
        
        var directoryPath: String? {
            switch self {
            case .cache:
                return NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                           .allDomainsMask, true).first
            case .document:
                return NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .allDomainsMask, true).first
            }
        }
        
        var data: Data {
            switch self {
            case .cache(let Data), .document(let Data):
                return Data
            }
        }
    }
}

extension DataManager {
    func loadObject(object: DataLocationType, forKey key: String) -> Result<ResponseType, Error> {
        let cacheKey = NSString(string: key)
        if let cachedData = self.memCache.object(forKey: cacheKey) as? Data {
            return .success(.rawData(data: cachedData))
        }
        
        guard let directoryPath = object.directoryPath else {
            return .failure(ErrorType.noFilePath)
        }
        
        return self.loadFile(from: directoryPath, forKey: key)
    }
    
    
    func saveObject(object: DataStorageType, forKey key: String) {
        let cacheKey = NSString(string: key)
        let cacheData = NSData(data: object.data)
        self.memCache.setObject(cacheData, forKey: cacheKey)
        
        guard let directoryPath = object.directoryPath else {
            return
        }
        
        self.saveFile(data: object.data, to: directoryPath, forKey: key)
    }
}

extension DataManager {
    private func loadFile(from directoryPath: String, forKey fileName: String) -> Result<ResponseType, Error> {
        var data: Data?
        if #available(iOS 16.0, *) {
            let directoryURL = URL(filePath: directoryPath)
            let fileURL = directoryURL.appendingPathComponent(fileName)
            data = try? Data(contentsOf: fileURL)
            
        } else {
            // Fallback on earlier versions
            let directoryURL = URL(fileURLWithPath: directoryPath)
            let fileURL = directoryURL.appendingPathComponent(fileName)
            data = try? Data(contentsOf: fileURL)
        }
        
        if let data = data {
            return .success(.rawData(data: data))
        } else {
            return .failure(ErrorType.fileNotFound)
        }
    }
    
    private func saveFile(data: Data, to directoryPath: String, forKey fileName: String) {
        if #available(iOS 16.0, *) {
            let directoryURL = URL(filePath: directoryPath)
            let fileURL = directoryURL.appendingPathComponent(fileName)
            
            self.fileQueue.async { [weak self] in
                guard let self = self else { return }
                do {
                    if !self.checkDirectory(directoryPath: directoryURL.absoluteString) {
                        try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
                    }
                    try data.write(to: fileURL)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            
        } else {
            // Fallback on earlier versions
            let directoryURL = URL(fileURLWithPath: directoryPath)
            let fileURL = directoryURL.appendingPathComponent(fileName)
            
            self.fileQueue.async { [weak self] in
                guard let self = self else { return }
                do {
                    if !self.checkDirectory(directoryPath: directoryURL.absoluteString) {
                        try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
                    }
                    try data.write(to: fileURL)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - utility
extension DataManager {
    private func checkDirectory(directoryPath: String) -> Bool {
        var isDirectory: ObjCBool = false
        if !FileManager.default.fileExists(atPath: directoryPath, isDirectory: &isDirectory)
            || isDirectory.boolValue == false {
            return false
        }
        
        return true
    }
}
