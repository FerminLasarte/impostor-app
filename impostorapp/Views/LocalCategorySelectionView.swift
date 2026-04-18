import SwiftUI

struct LocalCategorySelectionView: View {
    @Bindable var viewModel: GameViewModel
    @Binding var path: NavigationPath

    let columns = [GridItem(.adaptive(minimum: 155), spacing: 12)]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            Circle()
                .fill(Color.indigo.opacity(0.22))
                .frame(width: 380)
                .blur(radius: 110)
                .offset(x: 60, y: -80)
                .ignoresSafeArea()

            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(viewModel.categories) { category in
                        CategoryCard(category: category)
                            .onTapGesture {
                                guard !category.isCustom else { return }
                                viewModel.selectedCategory = category
                                path.append(category)
                            }
                    }
                }
                .padding(20)
                .padding(.top, 4)
            }
        }
        .navigationTitle("Elige un tema")
        .navigationBarTitleDisplayMode(.large)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

struct CategoryCard: View {
    let category: GameCategory

    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(category.color.opacity(0.16))
                    .frame(width: 66, height: 66)
                Image(systemName: category.iconName)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(category.color)
            }
            .shadow(color: category.color.opacity(0.25), radius: 12)

            Text(category.name)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 26)
        .padding(.horizontal, 12)
        .glassEffect(
            .regular.tint(category.color.opacity(0.08)),
            in: RoundedRectangle(cornerRadius: 24, style: .continuous)
        )
    }
}

#Preview {
    LocalCategorySelectionView(
        viewModel: GameViewModel(),
        path: .constant(NavigationPath())
    )
}
