//
//  Model.swift
//  Momento_proto
//
//  Created by 김예훈 on 3/15/25.
//

import Foundation

struct WisdomItem: Identifiable, Codable {
    let id: UUID
    var createdAt: Date
    var description: String
    var group: WisdomGroup?
    var content: WisdomContent
    var tags: [String]
    var summary: String
}

enum WisdomGroup: String, Identifiable, Codable, CaseIterable {
    case one, two
    var id: String { self.rawValue }
}

enum WisdomURLCase: String, Codable {
    case youtube, instagram, twitter, linkedin, notion, pinterest, youtubePlaylist, extra
}

enum WisdomContent: Identifiable, Codable {
    case text(id: UUID, text: String)
    case image(id: UUID, imageURL: String)
    case url(id: UUID, urlCase: WisdomURLCase, imageURL: String, description: String, author: String)
    case file(id: UUID, imageURL: String, description: String)
    
    var id: String {
        switch self {
        case .text(let id, _):
            return id.uuidString
        case .image(let id, _):
            return id.uuidString
        case .url(let id, _, _, _, _):
            return id.uuidString
        case .file(let id, _, _):
            return id.uuidString
        }
    }
}
