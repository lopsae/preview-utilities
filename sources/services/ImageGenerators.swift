//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import CryptoKit
import SwiftUI


// MARK: - Protocols


/// Protocol for all image generators.
public protocol ImageGeneratorProtocol: Sendable, Identifiable {

    typealias GenerationTuple = (image: Image, threadInfo: ThreadInfo)

    /// Unique identifier of the generator.
    var id: UUID { get }

    /// Size of the generated images.
    var size: CGSize { get }

    /// Generates an image with a given string, returns the image and the ``ThreadInfo`` where the
    /// image was generated.
    ///
    /// This function MUST be defined in the protocol as `nonisolated` for the different
    /// implementations to work as expected. Removing `nonisolated` will change the behavior of
    /// ``NonisolatedImageGenerator`` since protocol boxing (even when using generics) seems to
    /// override the callers isolation context to the package's default.
    ///
    /// - SeeAlso: [The Swift Programing Language - Protocols as Types][protocols-as-types]
    /// - SeeAlso: [The Swift Programing Language - Boxed Protocol Types][boxed-protocol-types]
    ///
    /// [protocols-as-types]:   https://docs.swift.org/swift-book/documentation/the-swift-programming-language/protocols/#Protocols-as-Types
    /// [boxed-protocol-types]: https://docs.swift.org/swift-book/documentation/the-swift-programming-language/opaquetypes/#Boxed-Protocol-Types
    nonisolated
    func generateImage(with text: String)
    async throws(ImageGeneratorError)
    -> GenerationTuple

    /// Creates a copy of the generator with the same settings and a new ``id``.
    func makeCopy() -> Self

}


nonisolated
public enum ImageGeneratorDefaults {

    public static let sleepRange: ClosedRange<Duration> = .seconds(2) ... .seconds(5)
    public static let zero: ClosedRange<Duration> = .seconds(0) ... .seconds(0)

}


public enum ImageGeneratorError: Error {
    case cancelled(ThreadInfo)
    var threadInfo: ThreadInfo {
        switch self {
        case .cancelled(let threadInfo): threadInfo
        }
    }
}


/// This is a copy of ``ImageGeneratorProtocol`` with one difference: `generateImage` is specified
/// WITHOUT `nonisolated`.
///
/// In this protocol `generateImage` uses the package default isolation: MainActor. When this
/// protocol is used (both as a generic or an existential type) with the ``NonisolatedImageGenerator``
/// implementation, the `generateImage` function will behave diferently.
///
/// This issue seems to arise from *existential types* when storing the generator as an
/// `any protocol` or using a generic. The protocol boxing of the generator implementation seems to
/// change the isolation context where `generateImage` is called, hence modifying the isolation that
/// is inherited by ``NonisolatedImageGenerator``.
///
/// The protocol boxing for this type will use the package default isolation, which then will be
/// inherited by ``NonisolatedImageGenerator/generateImage(with:)``, making the image generation
/// to always happen on `MainActor`.
///
///  See the `Nonisolated/Isolated` preview for an example of this issue.
private protocol IsolatedImageGeneratorProtocol: Sendable, Identifiable {
    var id: UUID { get }
    var size: CGSize { get }

    func generateImage(with text: String)
    async throws(ImageGeneratorError)
    -> (image: Image, threadInfo: ThreadInfo)

    func makeCopy() -> Self
}


// TODO: add some tests for the following cases:
// + nonisolated class with async function running in inherited main and background threads
// + default isolated class with async function running in default main and concurrent threads, called from main and background threads


// MARK: - ConcurrentImageGenerator


/// Nonisolated ImageGenerator with a `@concurrent generateImage` function that will always be
/// called in the cooperative thread pool.
nonisolated
public final class ConcurrentImageGenerator: ImageGeneratorProtocol, Sendable {

    public let id: UUID = UUID()

    public let size: CGSize
    let sleepRange: ClosedRange<Duration>?

    public init(size: CGSize, sleepRange: ClosedRange<Duration>? = ImageGeneratorDefaults.sleepRange) {
        self.size = size
        self.sleepRange = sleepRange
    }


    public func makeCopy() -> Self {
        Self(size: size, sleepRange: sleepRange)
    }


    /// Generates an image concurrently, this function always runs in the cooperative thread pool.
    ///
    /// This function must use `@concurrent` to use the cooperative thread pool.
    ///
    /// Replacing `@concurrent` with `nonisolated` will cause this function to inherit the isolation
    /// context of the caller, since the package uses the `NonisolatedNonsendingByDefault` upcoming
    /// feature.
    @concurrent
    public func generateImage(with text: String)
        async throws(ImageGeneratorError)
        -> GenerationTuple
    {
        return try await ImageGeneratorUtils.generateImage(text: text, size: size, sleepRange: sleepRange)
    }

}


// MARK: - NonisolatedImageGenerator


/// Nonisolated ImageGenerator with a `nonisolated generateImage` function that will inherit the
/// isolation context of the caller.
nonisolated
public final class NonisolatedImageGenerator:
    ImageGeneratorProtocol, IsolatedImageGeneratorProtocol, Sendable
{

    public let id: UUID = UUID()

    public let size: CGSize
    let sleepRange: ClosedRange<Duration>?

    public init(size: CGSize, sleepRange: ClosedRange<Duration>? = ImageGeneratorDefaults.sleepRange) {
        self.size = size
        self.sleepRange = sleepRange
    }


    public func makeCopy() -> Self {
        Self(size: size, sleepRange: sleepRange)
    }


    /// Generates an image asyncronously, this function inherits the isolation context of the
    /// caller.
    ///
    /// See notes in `IsolatedImageGeneratorProtocol` about how existential types and protocol
    /// boxing can change the behaviour of this implementation.
    nonisolated
    public func generateImage(with text: String)
        async throws(ImageGeneratorError)
        -> GenerationTuple
    {
        return try await ImageGeneratorUtils.generateImage(text: text, size: size, sleepRange: sleepRange)
    }

}


// MARK: - MainActorImageGenerator


/// Nonisolated ImageGenerator with a `generateImage` isolated to MainActor.
nonisolated
public final class MainActorImageGenerator: ImageGeneratorProtocol, Sendable {

    public let id: UUID = UUID()

    public let size: CGSize
    let sleepRange: ClosedRange<Duration>?

    public init(size: CGSize, sleepRange: ClosedRange<Duration>? = ImageGeneratorDefaults.sleepRange) {
        self.size = size
        self.sleepRange = sleepRange
    }


    public func makeCopy() -> Self {
        Self(size: size, sleepRange: sleepRange)
    }


    /// Generates an image asyncronously, this function is isolated to MainActor.
    @MainActor
    public func generateImage(with text: String)
        async throws(ImageGeneratorError)
        -> GenerationTuple
    {
            return try await ImageGeneratorUtils.generateImage(text: text, size: size, sleepRange: sleepRange)
    }

}


// MARK: - ImageGeneratorUtils


/// Collection of static non-isolated-non-sending functions to be used by image generators from any
/// isolation context. 
nonisolated
final class ImageGeneratorUtils {

    /// Generates an image using the callers isolation context, optionally sleeps for a random
    /// duration within the given duration range.
    ///
    /// - Note:
    /// The package settings enable `NonisolatedNonsendingByDefault`, irregardless this function is
    /// marked `nonisolated(nonsending)` for explicitness.
    nonisolated(nonsending)
    static func generateImage(text: String, size: CGSize, sleepRange: ClosedRange<Duration>?)
    async throws(ImageGeneratorError)
    -> ImageGeneratorProtocol.GenerationTuple {
        // Simulate async work.
        if let sleepRange {
            let sleepDuration = sleepRange.randomDuration()
            do {
                try await Task.sleep(for: sleepDuration)
            } catch is CancellationError {
                throw .cancelled(ThreadInfo())
            } catch {
                print("Unexpected error during image generation: \(error.localizedDescription)")
                throw .cancelled(ThreadInfo())
            }
        }

        let threadInfo = ThreadInfo()

        let image = SyncImageGenerator.generateImage(
            with: text,
            caption: threadInfo.displayName,
            size: size,
            border: true)

        return (image: image, threadInfo: threadInfo)
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - GenericGeneratorPreview


extension PreviewContent {

    /// View that stores the image generator using a generic of ``ImageGeneratorProtocol``.
    struct GenericGeneratorPreview<Generator: ImageGeneratorProtocol>: View {

        @State var usesMainActor: Bool = true
        @State var images: [Int: Image] = [:]
        @State var generator: Generator

        let strings: [String]

        init(strings: [String], generator: Generator) {
            self.strings = strings
            self.generator = generator
        }

        var body: some View {
            VStack {
                ForEach(strings.enumerated(), id: \.offset) { index, string in
                    Group {
                        if let image = images[index] {
                            image.resizable()
                        } else {
                            Rectangle().fill(.secondary)
                        }
                    }
                    .frame(size: generator.size)
                    .roundedRectangleClip(cornerRadius: 8)
                    .task {
                        let imageTask = if usesMainActor {
                            // Call from inherited MainActor isolation.
                            Task {
                                print("In Task: Generating from: \(ThreadInfo().displayName)")
                                return try? await generator.generateImage(with: string)
                            }
                        } else {
                            // Call using cooperative thread pool.
                            Task.detached {
                                print("In Detached: start from: \(ThreadInfo().displayName)")
                                return try? await generator.generateImage(with: string)
                            }
                        }
                        let image = await imageTask.value?.image
                        images[index] = image
                    }
                    .id(generator.id.hash(with: index))
                }
            } // VStack
            .onChange(of: usesMainActor) {
                // Reset image generator and stored images.
                print("Resetting Generator")
                generator = generator.makeCopy()
                images = [:]
            }

            Toggle("Call from Main Actor", isOn: $usesMainActor)
        }
    }

}


// MARK: - Generic Previews


#Preview("Concurrent", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var printOnce = PrintOnce("✴️ Concurrent preview started")

    PreviewCaption("""
        Generation always happens in the cooperative thread pool, since `@concurrent` does not 
        depend on isolation context inheritance.
        """)

    printOnce.print()
    PreviewContent.GenericGeneratorPreview(
        strings: ["One", "Two", "Three", "Four"],
        generator: ConcurrentImageGenerator(
            size: .square(of: 100),
            sleepRange: .seconds(0.5) ... .seconds(1)
        )
    )
}

#Preview("Nonisolated", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var printOnce = PrintOnce("✴️ Nonisolated preview started")

    PreviewCaption("""
        Generation happens in the inherited isolation context of he caller.
        """)

    printOnce.print()
    PreviewContent.GenericGeneratorPreview(
        strings: ["Uno", "Dos", "Tres", "Cuatro"],
        generator: NonisolatedImageGenerator(
            size: .square(of: 100),
            sleepRange: .seconds(0.5) ... .seconds(1)
        )
    )
}


#Preview("MainActor", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var printOnce = PrintOnce("✴️ MainActor preview started")

    PreviewCaption("""
        Image generation is isolated to `MainActor`, irregardless of calling isolation context.
        """)

    printOnce.print()
    PreviewContent.GenericGeneratorPreview(
        strings: ["Un", "Deux", "Trois", "Quatre"],
        generator: MainActorImageGenerator(
            size: .square(of: 100),
            sleepRange: .seconds(0.5) ... .seconds(1)
        )
    )
}


// MARK: - ProtocolComparisonPreview


extension PreviewContent {

    ///
    struct ProtocolComparisonPreview<
        Generator: ImageGeneratorProtocol,
        IsolatedGenerator: IsolatedImageGeneratorProtocol
    >: View
    {

        @State var usesMainActor: Bool = false
        @State var nonisolatedGenerator: Generator
        @State var isolatedGenerator: IsolatedGenerator
        @State var nonisolatedImage: Image?
        @State var isolatedImage: Image?

        let nonisolatedString: String
        let isolatedString: String

        init(
            nonisolatedString: String,
            isolatedString: String,
            nonisolatedGenerator: Generator,
            isolatedGenerator: IsolatedGenerator
        ) {
            self.nonisolatedString = nonisolatedString
            self.isolatedString = isolatedString
            self.nonisolatedGenerator = nonisolatedGenerator
            self.isolatedGenerator = isolatedGenerator
        }

        var body: some View {
            VStack {
                HStack {
                    // NonIsolated Image
                    Group {
                        if let nonisolatedImage {
                            nonisolatedImage.resizable()
                        } else {
                            Rectangle().fill(.secondary)
                        }
                    }
                    .frame(size: nonisolatedGenerator.size)
                    .roundedRectangleClip(cornerRadius: 8)
                    .task {
                        let imageTask = if usesMainActor {
                            // Call from inherited MainActor isolation.
                            Task {
                                print("Nonisolated: In Task: Generating from: \(ThreadInfo().displayName)")
                                return try? await nonisolatedGenerator.generateImage(with: nonisolatedString)
                            }
                        } else {
                            // Call using cooperative thread pool.
                            Task.detached {
                                print("Nonisolated: In Detached: start from: \(ThreadInfo().displayName)")
                                return try? await nonisolatedGenerator.generateImage(with: nonisolatedString)
                            }
                        }
                        let image = await imageTask.value?.image
                        nonisolatedImage = image
                    }
                    .id(nonisolatedGenerator.id.hash(with: nonisolatedString))

                    // Isolated Image
                    Group {
                        if let isolatedImage {
                            isolatedImage.resizable()
                        } else {
                            Rectangle().fill(.secondary)
                        }
                    }
                    .frame(size: isolatedGenerator.size)
                    .roundedRectangleClip(cornerRadius: 8)
                    .task {
                        let imageTask = if usesMainActor {
                            // Call from inherited MainActor isolation.
                            Task {
                                print("Isolated: In Task: Generating from: \(ThreadInfo().displayName)")
                                return try? await isolatedGenerator.generateImage(with: isolatedString)
                            }
                        } else {
                            // Call using cooperative thread pool.
                            Task.detached {
                                print("Isolated: In Detached: start from: \(ThreadInfo().displayName)")
                                return try? await isolatedGenerator.generateImage(with: isolatedString)
                            }
                        }
                        let image = await imageTask.value?.image
                        isolatedImage = image
                    }
                    .id(isolatedGenerator.id.hash(with: isolatedString))

                }

            } // VStack
            .onChange(of: usesMainActor) {
                // Reset image generator and stored images.
                print("Resetting Generator")
                nonisolatedGenerator = nonisolatedGenerator.makeCopy()
                isolatedGenerator = isolatedGenerator.makeCopy()
                nonisolatedImage = nil
                isolatedImage = nil
            }

            Toggle("Call from Main Actor", isOn: $usesMainActor)
                .padding()
        }
    }

}


// MARK: - Comparison Preview


#Preview("Nonisolated/Isolated", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var printOnce = PrintOnce("✴️ Comparison preview started")

    PreviewCaption("""
        The same implementation of `NonisolatedImageGenerator` behaves differently depending on the
        protocol used to box it.
        """)
    .paragraph("""
        The isolated protocol always is called in `MainActor`, which is the package default isolation.
        """)

    printOnce.print()
    let size: CGSize = .square(of: 100)
    let sleepRange: ClosedRange<Duration> = .seconds(0.5) ... .seconds(1)
    PreviewContent.ProtocolComparisonPreview(
        nonisolatedString: "Nonisolated",
        isolatedString: "Default\nIsolation",
        nonisolatedGenerator: NonisolatedImageGenerator(size: size, sleepRange: sleepRange),
        isolatedGenerator: NonisolatedImageGenerator(size: size, sleepRange: sleepRange))
}


// MARK: - TypeErasedPreview


extension PreviewContent {

    /// Preview that stores the image generator in a type erased `any ImageGeneratorProtocol`
    /// property.
    ///
    /// This was the initial implementation where the issues with existential types and protocol
    /// boxing where first found. After implementing the generic implementation it was found that
    /// the boxing issues happens with generics too.
    ///
    /// This implementation shows the same behaviour as `GenericGeneratorPreview`, but it is left
    /// for completeness.
    ///
    /// To see an example of the issues found see the `Nonisolated/Isolated` preview for a working
    /// example.
    ///
    /// Previously ``ImageGeneratorProtocol`` did not specify a `nonisolated generateImage`, which
    /// surfaced the protocol boxing issues.
    struct TypeErasedPreview: View {
        @State var usesMainActor: Bool = true
        @State var image: Image? = nil
        @State var generator: any ImageGeneratorProtocol

        let string: String

        init(string: String, generator: any ImageGeneratorProtocol) {
            self.string = string
            self.generator = generator
        }

        var body: some View {
            Group {
                if let image {
                    image.resizable()
                } else {
                    Rectangle().fill(.secondary)
                }
            }
            .frame(size: generator.size)
            .roundedRectangleClip(cornerRadius: 8)
            .task {
                let imageTask = if usesMainActor {
                    // Call from inherited the MainActor isolation.
                    Task {
                        print("In Task: Generating from: \(ThreadInfo().displayName)")
                        return try? await generator.generateImage(with: string)
                    }
                } else {
                    // Call using cooperative thread pool.
                    Task.detached {
                        print("In Detached: Generating from: \(ThreadInfo().displayName)")
                        return try? await generator.generateImage(with: string)
                    }
                }
                let generatedImage = await imageTask.value?.image
                image = generatedImage
            }
            .id(generator.id.hash(with: string))

            Toggle("Call from Main Actor", isOn: $usesMainActor)
            .onChange(of: usesMainActor) {
                // Reset image generator and stored images.
                print("Resetting Generator")
                generator = generator.makeCopy()
                image = nil
            }
        }
    }

}


// MARK: - TypeErased Previews


#Preview("ConcurrentErasure", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var printOnce = PrintOnce("✴️ ConcurrentErasure preview started")

    PreviewCaption("""
        Generation always happens in the cooperative thread pool, since `@concurrent` does not 
        depend on isolation context inheritance.
        """)
    .paragraph("""
        This has he same behaviour as its preview counterpart using generics.
        """)

    printOnce.print()
    PreviewContent.TypeErasedPreview(
        string: "Concurrent",
        generator: ConcurrentImageGenerator(
            size: .square(of: 100),
            sleepRange: .seconds(0.5) ... .seconds(1)
        )
    )
}


#Preview("NonisolatedErasure", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var printOnce = PrintOnce("✴️ NonisoltedErasure preview started")

    PreviewCaption("""
        Generation happens in the inherited isolation context of he caller.
        """)
    .paragraph("""
        This has he same behaviour as its preview counterpart using generics.
        """)

    printOnce.print()
    PreviewContent.TypeErasedPreview(
        string: "NonIsolated",
        generator: NonisolatedImageGenerator(
            size: .square(of: 100),
            sleepRange: .seconds(0.5) ... .seconds(1)
        )
    )
}


#Preview("MainActorErasure", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var printOnce = PrintOnce("✴️ ConcurrentErasure preview started")

    PreviewCaption("""
        Image generation is isolated to `MainActor`, irregardless of calling isolation context.
        """)
    .paragraph("""
        This has he same behaviour as its preview counterpart using generics.
        """)

    printOnce.print()
    PreviewContent.TypeErasedPreview(
        string: "MainActor",
        generator: MainActorImageGenerator(
            size: .square(of: 100),
            sleepRange: .seconds(0.5) ... .seconds(1)
        )
    )
}
