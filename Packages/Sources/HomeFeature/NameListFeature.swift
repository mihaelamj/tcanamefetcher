import Foundation
import ComposableArchitecture
import SharedModels
import DataFeature

@Reducer
public struct NameListFeature : Sendable{
    @Dependency(\.dataService) var dataService
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public var names: [Name] = []
        public var isLoading = false
        public var error: String?
        
        public init() {}
    }
    
    public enum Action {
        case onAppear
        case refreshButtonTapped
        case namesResponse(TaskResult<[Name]>)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear, .refreshButtonTapped:
                state.isLoading = true
                state.error = nil
                
                return .run { send in
                    await send(.namesResponse(
                        TaskResult { try await self.dataService.fetchNames() }
                    ))
                }
                
            case .namesResponse(.success(let names)):
                state.isLoading = false
                state.names = names
                return .none
                
            case .namesResponse(.failure(let error)):
                state.isLoading = false
                state.error = "Failed to load names: \(error.localizedDescription)"
                return .none
            }
        }
    }
} 
