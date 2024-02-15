//
//  PostDataModel.swift
//  FirebaseSample
//
//  Created by Admin on 15/02/24.
//

import Foundation

struct Post {
    var title: String
    var description: String
    var uid: String
    var imageUrl: String
    var creationDate: String

    init?(documentData: [String: Any]) {
        guard
            let title = documentData["title"] as? String,
            let description = documentData["description"] as? String,
            let uid = documentData["uid"] as? String,
            let imageUrl = documentData["imageUrl"] as? String,
            let creationDate = documentData["creationDate"] as? String
        else {
            return nil
        }

        self.title = title
        self.description = description
        self.uid = uid
        self.imageUrl = imageUrl
        self.creationDate = creationDate
    }
}
