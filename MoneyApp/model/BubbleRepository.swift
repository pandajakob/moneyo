//
//  BubbleRepository.swift
//  MoneyApp
//
//  Created by Jakob Michaelsen on 05/04/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct BubbleRepository {
    static let collection = Firestore.firestore().collection("bubbles")
    
    static func create(_ bubble: Bubble) async throws {
        let document = collection.document(bubble.id.uuidString)
        try await document.setData(from: bubble)
        
    }
    
    static func fetchData() async throws -> [Bubble] {
        let snapshot = try await collection
//            .order(by: "timeStamp", descending: true)
            .getDocuments()
        let data = snapshot.documents.compactMap { document in
            try! document.data(as: Bubble.self)
        }
        
        return data
    }
    
    static func updateBubble(bubble: Bubble) async throws {
        let document = collection.document(bubble.id.uuidString)
        try await document.setData(from: bubble)
    }
}

private extension DocumentReference {
    func setData<T: Encodable>(from value: T) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            // Method only throws if there’s an encoding error, which indicates a problem with our model.
            // We handled this with a force try, while all other errors are passed to the completion handler.
            try! setData(from: value) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume()
            }
        }
    }
}

