import Foundation
import SharedModels
import ComposableArchitecture

public final class DataService: @unchecked Sendable {
    private let persistenceManager: PersistenceManager
    
    public init(persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
    }
    
    public func fetchNames() async throws -> [Name] {
        // Simulate network delay (2 seconds)
        try await Task.sleep(for: .seconds(2))
        
        return [
            Name(firstName: "John", lastName: "Doe"),
            Name(firstName: "Jane", lastName: "Smith"),
            Name(firstName: "Robert", lastName: "Johnson"),
            Name(firstName: "Emma", lastName: "Williams"),
            Name(firstName: "Michael", lastName: "Brown")
        ]
    }
}

extension DataService: DependencyKey {
    public static let liveValue: DataService = {
        let persistenceManager = PersistenceManager()
        return DataService(persistenceManager: persistenceManager)
    }()
}

extension DependencyValues {
    public var dataService: DataService {
        get { self[DataService.self] }
        set { self[DataService.self] = newValue }
    }
} 