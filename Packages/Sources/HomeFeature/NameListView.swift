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
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            viewStore.send(.refreshButtonTapped)
                        } label: {
                            Label("Refresh", systemImage: "arrow.clockwise")
                        }
                        .disabled(viewStore.isLoading)
                    }
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
        .listStyle(.insetGrouped)
        .overlay {
            if names.isEmpty {
                EmptyListView(message: "No names available")
            }
        }
    }
}

// MARK: - Preview

#Preview("With Names") {
    NameListView(
        store: Store(initialState: NameListFeature.State(
            names: [
                Name(firstName: "John", lastName: "Doe"),
                Name(firstName: "Jane", lastName: "Smith"),
                Name(firstName: "Robert", lastName: "Johnson"),
                Name(firstName: "Emma", lastName: "Williams"),
                Name(firstName: "Michael", lastName: "Brown")
            ]
        )) {
            NameListFeature()
        }
    )
}

#Preview("Loading") {
    NameListView(
        store: Store(initialState: NameListFeature.State(
            isLoading: true
        )) {
            NameListFeature()
        }
    )
}

#Preview("Error") {
    NameListView(
        store: Store(initialState: NameListFeature.State(
            error: "Failed to load names: Network connection lost"
        )) {
            NameListFeature()
        }
    )
}

#Preview("Empty") {
    NameListView(
        store: Store(initialState: NameListFeature.State(
            names: []
        )) {
            NameListFeature()
        }
    )
}
