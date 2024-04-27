//
//  NetworkManager.swift
//  bivi
//
//  Created by d.tatarinova on 23.03.2024.
//

import Combine
import Foundation

protocol NetworkManager {
    func fetchStreamsList() -> AnyPublisher<[VideoStream], Error>
    func fetchQualities() -> AnyPublisher<[Quality], Error>
    func sendLogs(fileURL: URL?) -> AnyPublisher<Void, Error>
}

final class NetworkManagerImpl: NetworkManager {
    func fetchStreamsList() -> AnyPublisher<[VideoStream], Error> {
        guard let url = Endpoint.streams.absoluteURL else {
            return Result.Publisher(NetworkError.invalidURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, _ in
                let decoder = JSONDecoder()
                let response = try decoder.decode(FetchStreamsResponse.self, from: data)
                return response.streams.map {
                    VideoStream(previewPath: $0.previewPath, playlistPath: $0.playlistPath, name: $0.name)
                }
            }
            .eraseToAnyPublisher()
    }

    func fetchQualities() -> AnyPublisher<[Quality], Error> {
        guard let url = Endpoint.qualities.absoluteURL else {
            return Result.Publisher(NetworkError.invalidURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, _ in
                let decoder = JSONDecoder()
                let response = try decoder.decode(StreamQualitiesResponse.self, from: data)
                return response.qualities.map {
                    Quality(height: "\($0.height)", preferredPeakBitRate: $0.preferredPeakBitRate)
                }
            }
            .eraseToAnyPublisher()
    }

    func sendLogs(fileURL: URL?) -> AnyPublisher<Void, Error> {
        guard let url = Endpoint.clientLogs.absoluteURL else {
            return Result.Publisher(NetworkError.invalidURL).eraseToAnyPublisher()
        }
        guard let fileURL, let data = try? Data(contentsOf: NSURL(fileURLWithPath: fileURL.absoluteString) as URL) else {
            return Result.Publisher(NetworkError.invalidFile).eraseToAnyPublisher()
        }

        var multipart = MultipartRequest()
        multipart.add(
            key: "logs",
            fileName: fileURL.lastPathComponent,
            fileMimeType: "text/plain",
            fileData: data
        )

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(multipart.httpContentTypeHeadeValue, forHTTPHeaderField: "Content-Type")
        request.httpBody = multipart.httpBody

        return URLSession.shared.dataTaskPublisher(for: request).tryMap { _ in () }.eraseToAnyPublisher()
    }
}

// MARK: - Data Models
extension NetworkManagerImpl {
    struct FetchStreamsResponse: Decodable {
        struct Stream: Decodable {
            let name: String
            let previewPath: String
            let playlistPath: String
        }

        let streams: [Stream]
    }

    struct StreamQualitiesResponse: Decodable {
        struct Quality: Decodable {
            let height: UInt
            let preferredPeakBitRate: Double
        }

        let qualities: [Quality]
    }
}

// MARK: - Errors
extension NetworkManagerImpl {
    enum NetworkError: Error {
        case invalidURL
        case invalidFile
    }
}
