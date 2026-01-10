//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct AlignedFixedContainer<Content: View>: View {

    let alignment: Alignment
    let spacing: CGFloat
    let content: Content


    init(
        alignment: Alignment = .inner(.center),
        spacing: CGFloat = .zero,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            switch alignment {
            case .inner(let innerAlignment):
                // TODO: zero spacing here? to allow caller to define their own spacing? or default to simplify?
                VStack(alignment: innerAlignment.horizontal.swiftAlignment, spacing: 2) {
                    content
                }
                .font(.caption)
                .monospaced()
                .foregroundStyle(.secondary)
                .padding(spacing)
                // Prevents info view from collapsing in small sizes.
                .fixedSize()
                .border(.red)
                // Centers the view based in the alignment even when the frame is smaller that the view.
                .frame(size: geometry.size, alignment: innerAlignment.swiftAlignment)
                .border(.green)

            case .outer(let outerAlignment):
                // TODO: Dry!
                let yOffset: CGFloat = switch outerAlignment {
                case .top:    -geometry.size.height
                case .bottom: geometry.size.height
                case .leading(let outerVerticalAlignment), .trailing(let outerVerticalAlignment):
                    switch outerVerticalAlignment {
                    case .above:
                        -geometry.size.height
                    case .top, .center, .bottom:
                            .zero
                    case .below:
                        geometry.size.height
                    }

                }

                let xOffset: CGFloat = switch outerAlignment {
                case .leading:  -geometry.size.width
                case .trailing: geometry.size.width
                case .top, .bottom: .zero
                }

                // TODO: zero spacing here? to allow caller to define their own spacing? or default to simplify?
                // TODO: better name? textContainer? VStackAlignment?
                VStack(alignment: outerAlignment.containerHorizontal.swiftAlignment, spacing: 2) {
                    content
                }
                .font(.caption)
                .monospaced()
                .foregroundStyle(.secondary)
                // TODO: padding should be selective of alignment
                .padding(spacing)
                // Prevents info view from collapsing in small sizes.
                .fixedSize()
                .border(.red)
                // Centers the view based in the alignment even when the frame is smaller that the view.
                .frame(size: geometry.size, alignment: outerAlignment.frameAlignment)
                .border(.green)
                .offset(x: xOffset, y: yOffset)
            } // switch
        } // GeometryReader
    }
}


// MARK: - Alignment


extension AlignedFixedContainer {

    enum Alignment {

        case inner(InnerAlignment)
        case outer(OuterAlignment)

        enum Key: String, CaseIterable, SelfIdentifiable {
            case inner, outer
        }

        var key: Key {
            switch self {
            case .inner: .inner
            case .outer: .outer
            }
        }

        // TODO: might make more sense to have along the views, also for other textAlignment vars.
        var textAlignment: SwiftUI.TextAlignment {
            switch self {
            case .inner(let innerAlignment):
                return innerAlignment.horizontal.textAlignment
            case .outer(let outerAlignment):
                return outerAlignment.textAlignment
            }
        }

    }

}


// MARK: - InnerAlignment


extension AlignedFixedContainer {

    struct InnerAlignment {
        let horizontal: HorizontalAlignment
        let vertical: VerticalAlignment

        // TODO: add other static properties
        static var center: InnerAlignment { .init(horizontal: .center, vertical: .center) }
        static var topLeading: InnerAlignment { .init(horizontal: .leading, vertical: .top) }

        var swiftAlignment: SwiftUI.Alignment {
            .init(horizontal: horizontal.swiftAlignment, vertical: vertical.swiftAlignment)
        }
    }


    enum HorizontalAlignment: String, CaseIterable, SelfIdentifiable {
        case leading, center, trailing

        var swiftAlignment: SwiftUI.HorizontalAlignment {
            switch self {
            case .leading:  .leading
            case .center:   .center
            case .trailing: .trailing
            }
        }

        var textAlignment: SwiftUI.TextAlignment {
            switch self {
            case .leading:  .leading
            case .center:   .center
            case .trailing: .trailing
            }
        }
    }


    enum VerticalAlignment: String, CaseIterable, SelfIdentifiable {
        case top, center, bottom

        var swiftAlignment: SwiftUI.VerticalAlignment {
            switch self {
            case .top:    .top
            case .center: .center
            case .bottom: .bottom
            }
        }
    }

}


// MARK: - OuterAlignment


extension AlignedFixedContainer {

    enum OuterAlignment {
        case top(HorizontalAlignment)
        case leading(OuterVerticalAlignment)
        case bottom(HorizontalAlignment)
        case trailing(OuterVerticalAlignment)

        enum Key: String, CaseIterable, SelfIdentifiable {
            case top, leading, bottom, trailing
        }

        var key: Key {
            switch self {
            case .top:      .top
            case .leading:  .leading
            case .bottom:   .bottom
            case .trailing: .trailing
            }
        }

        // TODO: might make more sense to have along the views, also for other textAlignment vars.
        var textAlignment: SwiftUI.TextAlignment {
            switch self {
            case .top(let horizontalAlignment), .bottom(let horizontalAlignment):
                horizontalAlignment.textAlignment
            case .leading: .trailing
            case .trailing: .leading
            }
        }

        // TODO: might make more sense to have along the views.
        // Alignment for the VStack containing the info view.
        var containerHorizontal: HorizontalAlignment {
            switch self {
            case .top(let horizontalAlignment), .bottom(let horizontalAlignment):
                horizontalAlignment
            case .leading: .trailing
            case .trailing: .leading
            }
        }

        // TODO: Dry!
        var frameAlignment: SwiftUI.Alignment {
            switch self {
            case .top(let horizontalAlignment):
                return .init(horizontal: horizontalAlignment.swiftAlignment, vertical: .bottom)
            case .bottom(let horizontalAlignment):
                return .init(horizontal: horizontalAlignment.swiftAlignment, vertical: .top)
            case .leading(let outerVerticalAlignment):
                let vertical: SwiftUI.VerticalAlignment = switch outerVerticalAlignment {
                case .above:
                        .bottom
                case .top:
                        .top
                case .center:
                        .center
                case .bottom:
                        .bottom
                case .below:
                        .top
                }
                return .init(horizontal: .trailing, vertical: vertical)
            case .trailing(let outerVerticalAlignment):
                let vertical: SwiftUI.VerticalAlignment = switch outerVerticalAlignment {
                case .above:
                        .bottom
                case .top:
                        .top
                case .center:
                        .center
                case .bottom:
                        .bottom
                case .below:
                        .top
                }
                return .init(horizontal: .leading, vertical: vertical)
            }
        }

        static var topLeading:     OuterAlignment { .top(.leading) }
        static var topCenter:      OuterAlignment { .top(.center) }
        static var topTrailing:    OuterAlignment { .top(.trailing) }

        static var bottomLeading:  OuterAlignment { .bottom(.leading) }
        static var bottomCenter:   OuterAlignment { .bottom(.center) }
        static var bottomTrailing: OuterAlignment { .bottom(.trailing) }

        static var leadingAbove:   OuterAlignment { .leading(.above) }
        static var leadingTop:     OuterAlignment { .leading(.top) }
        static var leadingCenter:  OuterAlignment { .leading(.center) }
        static var leadingBottom:  OuterAlignment { .leading(.bottom) }
        static var leadingUnder:   OuterAlignment { .leading(.below) }

        static var trailingAbove:  OuterAlignment { .trailing(.above) }
        static var trailingTop:    OuterAlignment { .trailing(.top) }
        static var trailingCenter: OuterAlignment { .trailing(.center) }
        static var trailingBottom: OuterAlignment { .trailing(.bottom) }
        static var trailingBelow:  OuterAlignment { .trailing(.below) }

    }


    enum OuterVerticalAlignment: String, CaseIterable, SelfIdentifiable {
        case above, top, center, bottom, below
    }

}



// MARK: - Previews


#Preview {
    Rectangle()
        .fill(.teal.tertiary)
    .frame(square: 100)
    .overlay {
        AlignedFixedContainer {
            Text("Sphinx of black quartz,")
            Text("judge my vow")
        }
    }
}
