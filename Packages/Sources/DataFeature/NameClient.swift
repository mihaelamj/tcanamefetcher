import Foundation
import ComposableArchitecture
import SharedModels

public struct NameClient: Sendable {
    public var fetchNames: @Sendable () async throws -> [Name]
    
    // Add this initializer
    public init(fetchNames: @escaping @Sendable () async throws -> [Name]) {
        self.fetchNames = fetchNames
    }
    
    public enum Error: Swift.Error, Equatable {
        case networkError
    }
}

extension NameClient: DependencyKey {
    public static let liveValue = Self(
        fetchNames: {
            // Simulate network delay
            try await Task.sleep(for: .seconds(1))
            
            // Simulate potential error (20% chance)
            let shouldFail = Int.random(in: 1...10) <= 2
            if shouldFail {
                throw Error.networkError
            }
            
            // Return mock data
            return [
                Name(id: UUID(), firstName: "John", lastName: "Doe"),
                Name(id: UUID(), firstName: "Jane", lastName: "Smith"),
                Name(id: UUID(), firstName: "Robert", lastName: "Johnson"),
                Name(id: UUID(), firstName: "Emma", lastName: "Williams"),
                Name(id: UUID(), firstName: "Michael", lastName: "Brown")
            ]
        }
    )
    
    public static let testValue = Self(
        fetchNames: {
            [
                Name(id: UUID(), firstName: "Test", lastName: "User"),
                Name(id: UUID(), firstName: "Sample", lastName: "Name")
            ]
        }
    )
}

extension DependencyValues {
    public var nameClient: NameClient {
        get { self[NameClient.self] }
        set { self[NameClient.self] = newValue }
    }
}
