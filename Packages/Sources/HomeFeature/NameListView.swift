import SwiftUI
import ComposableArchitecture
import DataFeature
import SharedModels

public struct NameListView: View {
    let store: StoreOf<NameListFeature>
    
    public init(store: StoreOf<NameListFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                ZStack {
                    if viewStore.isLoading {
                        LoadingView(message: "Loading names...")
                    } else if let error = viewStore.error {
                        ErrorView(message: error) {
                            viewStore.send(.refreshButtonTapped)
                        }
                    } else {
                        nameListView(names: viewStore.names)
                    }
                }
                .navigationTitle("Names")
                .toolbar {
                    #if os(iOS)
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            viewStore.send(.refreshButtonTapped)
                        } label: {
                            Label("Refresh", systemImage: "arrow.clockwise")
                        }
                        .disabled(viewStore.isLoading)
                    }
                    #else
                    ToolbarItem(placement: .automatic) {
                        Button {
                            viewStore.send(.refreshButtonTapped)
                        } label: {
                            Label("Refresh", systemImage: "arrow.clockwise")
                        }
                        .disabled(viewStore.isLoading)
                    }
                    #endif
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
        }
    }
    
    private func nameListView(names: [Name]) -> some View {
        List {
            ForEach(names) { name in
                Text(name.fullName)
            }
        }
        #if os(iOS)
        .listStyle(.insetGrouped)
        #else
        .listStyle(.inset)
        #endif
        .overlay {
            if names.isEmpty {
                EmptyListView(message: "No names available")
            }
        }
    }
}

// MARK: - Preview

#Preview("With Names") {
    { 
        var state = NameListFeature.State()
        state.names = [
            Name(firstName: "John", lastName: "Doe"),
            Name(firstName: "Jane", lastName: "Smith"),
            Name(firstName: "Robert", lastName: "Johnson"),
            Name(firstName: "Emma", lastName: "Williams"),
            Name(firstName: "Michael", lastName: "Brown")
        ]
        return NameListView(
            store: Store(initialState: state) {
                NameListFeature()
            }
        )
    }()
}

#Preview("Loading") {
    {
        var state = NameListFeature.State()
        state.isLoading = true
        return NameListView(
            store: Store(initialState: state) {
                NameListFeature()
            }
        )
    }()
}

#Preview("Error") {
    {
        var state = NameListFeature.State()
        state.error = "Failed to load names: Network connection lost"
        return NameListView(
            store: Store(initialState: state) {
                NameListFeature()
            }
        )
    }()
}

#Preview("Empty") {
    NameListView(
        store: Store(initialState: NameListFeature.State()) {
            NameListFeature()
        }
    )
}
