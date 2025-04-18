import Foundation
import ComposableArchitecture

@Reducer
public struct NameListFeature : Sendable{
    @ObservableState
    public struct State: Equatable {
        public var names: [Name] = []
        public var isLoading = false
        public var error: String?
    }
    
    public enum Action {
        case onAppear
        case refreshButtonTapped
        case namesResponse(TaskResult<[Name]>)
    }
    
    @Dependency(\.nameClient) var nameClient: NameClient
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear, .refreshButtonTapped:
                state.isLoading = true
                state.error = nil
                
                return .run { send in
                    await send(.namesResponse(
                        TaskResult { try await self.nameClient.fetchNames() }
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
