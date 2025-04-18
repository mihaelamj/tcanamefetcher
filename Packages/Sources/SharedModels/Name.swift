import Foundation

public struct Name: Equatable, Identifiable, Sendable {
    public let id: UUID
    public let firstName: String
    public let lastName: String
    
    public var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    public init(id: UUID = UUID(), firstName: String, lastName: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
}
