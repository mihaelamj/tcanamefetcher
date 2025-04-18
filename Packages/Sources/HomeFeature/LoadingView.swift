import SwiftUI

struct LoadingView: View {
    let message: String
    
    init(message: String = "Loading...") {
        self.message = message
    }
    
    var body: some View {
        VStack {
            ProgressView()
                .controlSize(.large)
            
            Text(message)
                .foregroundColor(.secondary)
                .padding(.top)
        }
    }
}

#Preview("Custom Message") {
    LoadingView(message: "Loading names...")
}

#Preview("Default") {
    LoadingView()
}
