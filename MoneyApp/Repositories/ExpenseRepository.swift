//
//  ExpenseRepository.swift
//  MoneyApp
//
//  Created by Jakob Michaelsen on 08/04/2024.
//
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ExpenseRepository {
    static let collectionRefference = Firestore.firestore().collection("expenses")
    
    static func create(_ expense: Expense) async throws {
        let document = collectionRefference.document(expense.id.uuidString)
        try await document.setData(from: expense)
    }
    
    static func fetchAllExpenses() async throws -> [Expense] {
        let snapshot = try await collectionRefference
//            .order(by: "timestamp", descending: true)
            .getDocuments()
        let data = snapshot.documents.compactMap { document in
            try! document.data(as: Expense.self)
        }
        return data
    }
    
    static func getSumOfAllExpensesInABubble() async throws -> Double {
        let aggregateQuery = collectionRefference.aggregate([AggregateField.sum("price")])
    
        let snapshot = try await aggregateQuery.getAggregation(source: .server)
        
        let data = snapshot.get(AggregateField.sum("price"))

        return data as! Double
    }
    
    static func deleteExpense(expense: Expense) async throws {
        let document = collectionRefference.document(expense.id.uuidString)
        try await document.delete()
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

