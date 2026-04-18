import SwiftUI

struct SetupView: View {
    @Bindable var viewModel: GameViewModel
    @Binding var path: NavigationPath

    private var categoryColor: Color {
        viewModel.selectedCategory?.color ?? .indigo
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            GeometryReader { geo in
                Circle()
                    .fill(categoryColor.opacity(0.3))
                    .frame(width: geo.size.width * 1.1)
                    .blur(radius: geo.size.width * 0.28)
                    .offset(x: 0, y: -geo.size.height * 0.08)
            }
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Icono de categoría
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(categoryColor.opacity(0.18))
                            .frame(width: 96, height: 96)
                        Image(systemName: viewModel.selectedCategory?.iconName ?? "questionmark")
                            .font(.system(size: 42, weight: .medium))
                            .foregroundStyle(categoryColor)
                    }
                    .shadow(color: categoryColor.opacity(0.45), radius: 22)

                    Text(viewModel.selectedCategory?.name ?? "Configuración")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
                .padding(.top, 36)

                Spacer()

                // Panel de configuración
                VStack(spacing: 0) {
                    SettingRow(
                        icon: "person.2.fill",
                        color: .blue,
                        title: "Jugadores",
                        value: $viewModel.playerCount,
                        range: 2...50
                    )
                    .onChange(of: viewModel.playerCount) { _, newValue in
                        if viewModel.impostorCount > newValue {
                            viewModel.impostorCount = newValue
                        }
                    }

                    Rectangle()
                        .fill(.white.opacity(0.08))
                        .frame(height: 1)
                        .padding(.vertical, 4)

                    SettingRow(
                        icon: "theatermasks.fill",
                        color: .red,
                        title: "Impostores",
                        value: $viewModel.impostorCount,
                        range: 1...viewModel.playerCount
                    )
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 26, style: .continuous))
                .padding(.horizontal, 20)

                Spacer()

                // Botón Jugar
                Button {
                    viewModel.startGame()
                    path.append("revealGame")
                } label: {
                    Text("Jugar Ahora")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(categoryColor.gradient)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(color: categoryColor.opacity(0.45), radius: 16, y: 6)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 44)
                .buttonStyle(ScaleButtonStyle())
            }
        }
        .navigationTitle("Configurar")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationDestination(for: String.self) { value in
            if value == "revealGame" {
                RevealView(viewModel: viewModel, path: $path)
            }
        }
    }
}

struct SettingRow: View {
    let icon: String
    let color: Color
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>

    var body: some View {
        HStack {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(color)
                    .frame(width: 24)
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white)
            }

            Spacer()

            HStack(spacing: 18) {
                Button {
                    if value > range.lowerBound { value -= 1 }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(value > range.lowerBound ? .white.opacity(0.55) : .white.opacity(0.18))
                }
                .disabled(value <= range.lowerBound)

                Text("\(value)")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(minWidth: 38)
                    .contentTransition(.numericText())

                Button {
                    if value < range.upperBound { value += 1 }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(value < range.upperBound ? color : color.opacity(0.22))
                }
                .disabled(value >= range.upperBound)
            }
        }
        .padding(.vertical, 10)
        .animation(.snappy, value: value)
    }
}

#Preview {
    let vm = GameViewModel()
    vm.selectedCategory = vm.categories.first
    return SetupView(viewModel: vm, path: .constant(NavigationPath()))
}
