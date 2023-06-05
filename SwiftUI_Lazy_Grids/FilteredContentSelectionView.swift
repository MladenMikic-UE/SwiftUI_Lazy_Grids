import SwiftUI


public final class FilterSelectionViewModel: ObservableObject, Identifiable {

    public var id: String = ""
    let title: String
    @Published var selected: Bool
    @Published var isRemoveable: Bool

    public init(id: String,
                title: String,
                selected: Bool = false,
                isRemoveable: Bool = false) {
        self.id = id
        self.title = title
        self.selected = selected
        self.isRemoveable = isRemoveable
    }

}

public struct FilteredContentSelectionView: View {

    let viewConfig: Self.ViewConfig
    @ObservedObject var viewModel: Self.ViewModel

    public var body: some View {

        ScrollView(.horizontal) {

            LazyHGrid(rows: viewConfig.rows, spacing: viewConfig.verticalPadding) {

                ForEach(0..<viewModel.items.count) { i in

                    if viewModel.items.indices.contains(i) {
                        RoundButton(viewModel: .init(imageName: "x.circle.fill",
                                                     titleName: viewModel.items[i].title,
                                                     selected: $viewModel.items[i].selected,
                                                     action:
                        {
                            if viewModel.items.indices.contains(i) {

                                if viewModel.items[i].isRemoveable {
                                    viewModel.items.remove(at: i)
                                } else {
                                    viewModel.items[i].selected.toggle()
                                    viewModel.objectWillChange.send()
                                    print("i: \(i)")
                                }

                            }

                        }), viewConfig: viewConfig.roundButtonViewConfig)
                        .frame(height: viewConfig.rowElementSize)
                    }

                }

            }
        }
        .frame(height: viewConfig.calculatedHeight)
        .border(Color.red)
    }
}

public extension FilteredContentSelectionView {

    final class ViewModel: ObservableObject {

        @Published var items: [FilterSelectionViewModel] = []

        public init(items: [FilterSelectionViewModel]) {
            self.items = items
            if items.isEmpty {
                assertionFailure("No FilterSelectionViewModels have been provided")
            }
        }

    }

}

public extension FilteredContentSelectionView {

    struct ViewConfig {

        let rowElementSize: CGFloat
        let verticalPadding: CGFloat
        let rows: [GridItem]
        let calculatedHeight: CGFloat
        let roundButtonViewConfig: RoundButton.ViewConfig

        public init(rowElementSize: CGFloat,
                    verticalPadding: CGFloat,
                    rows: [GridItem],
                    roundButtonViewConfig: RoundButton.ViewConfig) {
            self.rowElementSize = rowElementSize
            self.verticalPadding = verticalPadding
            self.rows = rows
            let h = (rowElementSize * CGFloat(rows.count)) + (CGFloat((rows.count - 1)) * verticalPadding)
            self.calculatedHeight = h
            self.roundButtonViewConfig = roundButtonViewConfig
        }
    }

}

public struct RoundButton: View {

    let viewModel: Self.ViewModel
    let viewConfig: Self.ViewConfig

    public init(viewModel: Self.ViewModel,
                viewConfig: Self.ViewConfig) {
        self.viewModel = viewModel
        self.viewConfig = viewConfig
    }

    public var body: some View {

        Button(action: self.viewModel.action) {

            HStack(spacing: .zero) {

                Spacer().frame(width: viewConfig.padding.leading)

                if let imageName = viewModel.imageName,
                   let imageVC = viewConfig.imageViewConfig, imageVC.alignment == .leading {

                    getImage(from: imageVC, imageName: imageName)

                    Spacer().frame(width: viewConfig.imageToTextHorizontalPadding)
                }

                Text(viewModel.titleName)
                    .foregroundColor(viewModel.selected ?
                                     viewConfig.selectedTitleVC.foregroundColor :
                                     viewConfig.deSelectedTitleVC.foregroundColor)

                if let imageName = viewModel.imageName,
                   let imageVC = viewConfig.imageViewConfig, imageVC.alignment == .trailing {

                    Spacer().frame(width: viewConfig.imageToTextHorizontalPadding)

                    getImage(from: imageVC, imageName: imageName)
                }

                Spacer().frame(width: viewConfig.padding.trailing)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(viewModel.selected ? viewConfig.backgroundColors.selected :
                                         viewConfig.backgroundColors.deSelected)
        .cornerRadius(viewConfig.cornerRadius)
    }

    private func getImage(from imageVC: ImageViewConfig, imageName: String) -> AnyView {
        if imageVC.isSystem {
            return AnyView(Image(systemName: imageName)
                .resizable()
                .foregroundColor(.white)
                .frame(width: imageVC.size.width, height: imageVC.size.height))
        } else {
            return AnyView(Image(imageName)
                .resizable()
                .foregroundColor(.white)
                .frame(width: imageVC.size.width, height: imageVC.size.height))

        }
    }
}

public extension RoundButton {

    final class ViewModel {
        ///
        let imageName: String?
        let titleName: String
        @Binding var selected: Bool
        let action: (() -> Void)


        public init(imageName: String? = nil,
                    titleName: String,
                    selected: Binding<Bool>,
                    action: @escaping (() -> Void)) {
            self.imageName = imageName
            self.titleName = titleName
            self.action = action
            self._selected = selected
        }
    }

    struct ViewConfig {

        let imageViewConfig: ImageViewConfig?
        let selectedTitleVC: TextViewConfig
        let deSelectedTitleVC: TextViewConfig
        /// RoundButton (button) cornerRadius
        let cornerRadius: CGFloat
        /// RoundButton (button) background color.
        let backgroundColors: (selected: Color, deSelected: Color)
        /// Horizontal padding used to add space between the text and the button round edge.
        let padding: EdgeInsets
        let imageToTextHorizontalPadding: CGFloat

        public init(imageViewConfig: ImageViewConfig? = nil,
                    selectedTitleVC: TextViewConfig,
                    deSelectedTitleVC: TextViewConfig,
                    cornerRadius: CGFloat,
                    backgroundColors: (selected: Color, deSelected: Color),
                    padding: EdgeInsets,
                    imageToTextHorizontalPadding: CGFloat = 0.0) {
            self.imageViewConfig = imageViewConfig
            self.selectedTitleVC = selectedTitleVC
            self.deSelectedTitleVC = deSelectedTitleVC
            self.cornerRadius = cornerRadius
            self.backgroundColors = backgroundColors
            self.padding = padding
            self.imageToTextHorizontalPadding = imageToTextHorizontalPadding
        }
    }
}


public struct ImageViewConfig {

    let foregroundColor: Color
    let size: CGSize
    let bundle: Bundle
    let alignment: Alignment
    let isSystem: Bool

    public init(foregroundColor: Color = .white,
                size: CGSize,
                bundle: Bundle = .main,
                alignment: Alignment = .trailing,
                isSystem: Bool = false) {
        self.foregroundColor = foregroundColor
        self.bundle = bundle
        self.size = size
        self.alignment = alignment
        self.isSystem = isSystem
    }
}

public struct TextViewConfig {

    let font: Font
    let foregroundColor: Color
    let padding: EdgeInsets
    let bundle: Bundle

    public init(font: Font,
                foregroundColor: Color,
                padding: EdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0),
                bundle: Bundle = .main) {
        self.font = font
        self.foregroundColor = foregroundColor
        self.padding = padding
        self.bundle = bundle
    }
}
