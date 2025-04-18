import SwiftUI
import ComposableArchitecture
import DataFeature
import HomeFeature

public struct AppView: View {
    public init() {}
    
    public var body: some View {
        NameListView(
            store: Store(initialState: NameListFeature.State()) {
                NameListFeature()._printChanges()
            }
        )
    }
}
