import SwiftUI


@main
struct SwiftUI_Lazy_GridsApp: App {
    var body: some Scene {
        WindowGroup {
            FilteredContentSelectionViewExampleView()
        }
    }
}


struct FilteredContentSelectionViewExampleView: View {

    @StateObject var vm1 = FilteredContentSelectionView.ViewModel(items: [
        FilterSelectionViewModel(id: UUID.init().uuidString, title: "Test1", isRemoveable: true),
        FilterSelectionViewModel(id: UUID.init().uuidString, title: "Test2", isRemoveable: true),
        FilterSelectionViewModel(id: UUID.init().uuidString, title: "Test3", isRemoveable: true)
    ])
    @StateObject var vm2 = FilteredContentSelectionView.ViewModel(items: [
        FilterSelectionViewModel(id: UUID.init().uuidString, title: "Test1"),
        FilterSelectionViewModel(id: UUID.init().uuidString, title: "Test2"),
        FilterSelectionViewModel(id: UUID.init().uuidString, title: "Test3"),
        FilterSelectionViewModel(id: UUID.init().uuidString, title: "Test4")
    ])

    var body: some View {
        VStack(spacing: 0) {

            Spacer()

            FilteredContentSelectionView(viewConfig: FilteredContentSelectionView.ViewConfig(rowElementSize: 50,
                                                                                             verticalPadding: 8,
                                                                                             rows: [
                                                                                                GridItem(.fixed(50), spacing: 16)
                                                                                             ],
                                                                                             roundButtonViewConfig: .defaultBlue(rowElementSize: 50)),
                                         viewModel: vm1)

            Spacer()

            FilteredContentSelectionView(viewConfig: FilteredContentSelectionView.ViewConfig(rowElementSize: 50,
                                                                                             verticalPadding: 16,
                                                                                             rows: [
                                                                                                GridItem(.fixed(50), spacing: 16)
                                                                                                ,GridItem(.fixed(50), spacing: 16)
                                                                                             ], roundButtonViewConfig: .defaultGreen(rowElementSize: 50)),
                                         viewModel: vm2)

            Spacer()
        }

    }
}


extension RoundButton.ViewConfig {
    static func defaultBlue(rowElementSize: CGFloat) -> RoundButton.ViewConfig {
        return RoundButton.ViewConfig(imageViewConfig: .init(size: .init(width: 20, height: 20), isSystem: true),
                          selectedTitleVC: .init(font: .system(.caption), foregroundColor: .white),
                          deSelectedTitleVC: .init(font: .system(.caption), foregroundColor: .black),
                          cornerRadius: rowElementSize,
                          backgroundColors: (selected: .blue, deSelected: .gray),
                          padding: .init(top: 0,
                                         leading: rowElementSize / 2,
                                         bottom: 0,
                                         trailing: rowElementSize / 2),
                                    imageToTextHorizontalPadding: 10)
    }

    static func defaultGreen(rowElementSize: CGFloat) -> RoundButton.ViewConfig {
        return RoundButton.ViewConfig(imageViewConfig: nil,
                          selectedTitleVC: .init(font: .system(.caption), foregroundColor: .white),
                          deSelectedTitleVC: .init(font: .system(.caption), foregroundColor: .black),
                          cornerRadius: rowElementSize,
                          backgroundColors: (selected: .green, deSelected: .gray),
                          padding: .init(top: 0,
                                         leading: rowElementSize / 2,
                                         bottom: 0,
                                         trailing: rowElementSize / 2),
                                    imageToTextHorizontalPadding: 10)
    }
}
