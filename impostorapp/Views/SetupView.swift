import SwiftUI

struct SetupView: View {
    @State private var viewModel = GameViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                // (UI igual que antes)

                Button("Comenzar Juego") {
                    viewModel.startGame()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .navigationDestination(isPresented: $viewModel.gameStarted) {
                RevealView(viewModel: viewModel)
            }
        }
    }
}
