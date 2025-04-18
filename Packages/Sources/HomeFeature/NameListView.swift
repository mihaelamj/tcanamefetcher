import SwiftUI
import ComposableArchitecture
import SharedModels

struct NameListView: View {
    let store: StoreOf<NameListFeature>
    
    var body: some View {
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

#Preview {
    NameListView(
        store: Store(initialState: NameListFeature.State()) {
            NameListFeature()
        }
    )
}
