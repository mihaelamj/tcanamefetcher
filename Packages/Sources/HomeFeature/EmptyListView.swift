import SwiftUI

struct EmptyListView: View {
    let message: String
    
    init(message: String = "No items available") {
        self.message = message
    }
    
    var body: some View {
        Text(message)
            .foregroundColor(.secondary)
    }
}
