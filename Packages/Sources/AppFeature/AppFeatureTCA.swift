import SwiftUI
import SharedModels
import DataFeature
import HomeFeature

struct AppState: Equatable {
    
}


/**
 ```swift
 @main
 struct NameFetcherApp: App {
     var body: some Scene {
         WindowGroup {
             NameListView(
                 store: Store(initialState: NameListFeature.State()) {
                     NameListFeature()
                 }
             )
         }
     }
 }
 */
