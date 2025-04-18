import SwiftUI

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
            
            Text("Error")
                .font(.headline)
            
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.red)
                .font(.subheadline)
            
            Button("Try Again") {
                retryAction()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview("Network Error") {
    ErrorView(
        message: "Failed to load names: Network connection lost",
        retryAction: {}
    )
}

#Preview("Long Error") {
    ErrorView(
        message: "Failed to load names: The operation couldn't be completed. Please check your internet connection and try again later.",
        retryAction: {}
    )
}
