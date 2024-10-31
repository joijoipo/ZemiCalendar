import SwiftUI

public enum PageDirection {
    case backward
    case forward
}

public protocol Pageable: Equatable & Identifiable {}

struct InfinitePagingModifier<T: Pageable>: ViewModifier {
    @Binding var objects: [T]
    @Binding var pageWidth: CGFloat
    @State var pagingOffset: CGFloat
    @State var draggingOffset: CGFloat
    let pagingHandler: (PageDirection) -> Void

    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                draggingOffset = value.translation.width
            }
            .onEnded { value in
                let oldIndex = Int(floor(0.5 - (pagingOffset / pageWidth)))
                pagingOffset += value.translation.width
                draggingOffset = 0
                let newIndex = Int(max(0, min(2, floor(0.5 - (pagingOffset / pageWidth)))))
                withAnimation(.linear(duration: 0.1)) {
                    pagingOffset = -pageWidth * CGFloat(newIndex)
                } completion: {
                    if newIndex == oldIndex { return }
                    if newIndex == 0 {
                        pagingHandler(.backward)
                    }
                    if newIndex == 2 {
                        pagingHandler(.forward)
                    }
                }
            }
    }

    init(
        objects: Binding<[T]>,
        pageWidth: Binding<CGFloat>,
        pagingHandler: @escaping (PageDirection) -> Void
    ) {
        _objects = objects
        _pageWidth = pageWidth
        _pagingOffset = State(initialValue: -pageWidth.wrappedValue)
        _draggingOffset = State(initialValue: 0)
        self.pagingHandler = pagingHandler
    }

    func body(content: Content) -> some View {
        content
            .offset(x: pagingOffset + draggingOffset, y: 0)
            .simultaneousGesture(dragGesture)
            .onChange(of: objects) { _, _ in
                pagingOffset = -pageWidth
            }
            .onChange(of: pageWidth) { _, _ in
                pagingOffset = -pageWidth
            }
    }
}

public struct InfinitePaging<T: Pageable, Content: View>: View {
    @Binding var objects: [T]
    let pagingHandler: (PageDirection) -> Void
    let content: (T) -> Content

    public init(
        objects: Binding<[T]>,
        pagingHandler: @escaping (PageDirection) -> Void,
        @ViewBuilder content: @escaping (T) -> Content
    ) {
        assert(objects.wrappedValue.count == 3, "objects count must be 3.")
        _objects = objects
        self.pagingHandler = pagingHandler
        self.content = content
    }

    public var body: some View {
        GeometryReader { proxy in
            HStack(alignment: .center, spacing: 0) {
                ForEach(objects) { object in
                    content(object)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                }
            }
            .modifier(
                InfinitePagingModifier(
                    objects: $objects,
                    pageWidth: Binding<CGFloat>(
                        get: { proxy.size.width },
                        set: { _ in }
                    ),
                    pagingHandler: pagingHandler
                )
            )
        }
        .clipped()
    }
}
