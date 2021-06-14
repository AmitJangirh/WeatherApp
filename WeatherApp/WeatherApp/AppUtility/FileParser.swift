//
//  FileParser.swift
//  CarFit
//
//

import Foundation

enum FileParserError: Error {
    case fileNotFound
}

protocol FileJsonEncoder {
    static func jsonDecode<T: Decodable>(jsonFile: JsonFile, modelType: T.Type) throws -> T
}

// Json file names
enum JsonFile: String {
    case cityList = "City_List"
}

// Class to parse file from self bundle
// by default used to parse JSON file type
class FileParser {
    /// Parses the given filename from bundle
    /// - Returns: returns parsed data
    func parsedFile(fileName: String, fileType: String = "json") throws -> Data {
        let bundle = Bundle(for: FileParser.self)
        guard let jsonFile = bundle.path(forResource: fileName, ofType: fileType) else {
            throw FileParserError.fileNotFound
        }
        do {
            let fileURL = URL(fileURLWithPath: jsonFile)
            return try Data(contentsOf: fileURL, options: .alwaysMapped)
        } catch {
            Logger.log(object: "JsonParser, Parsing failed with error: \(error.localizedDescription)")
            throw error
        }
    }
}

// Extension to support JSON encoding
extension FileParser: FileJsonEncoder {
    /// static func as support for Json encoding object from bundle file
    /// - Parameters:
    ///   - jsonFile: Jsion file name
    ///   - modelType: Object type for which json is parsed
    /// - Returns: Initialised Object after parsing, if available
    static func jsonDecode<T: Decodable>(jsonFile: JsonFile, modelType: T.Type) throws -> T {
        do {
            let fileParser = FileParser()
            let jsonData = try fileParser.parsedFile(fileName: jsonFile.rawValue)
            let model = try JSONDecoder().decode(modelType, from: jsonData)
            return model
        } catch {
            Logger.log(object: "JsonEncoder, Encoding failed with error: \(error.localizedDescription)")
            throw error
        }
    }
}
