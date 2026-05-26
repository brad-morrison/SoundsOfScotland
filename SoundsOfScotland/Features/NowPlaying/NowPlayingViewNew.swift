import SwiftUI

extension Soundscape {
    fileprivate var displayName: String { title }
    fileprivate var displayLocation: String { subtitle }
    fileprivate var tagline: String { description }

    fileprivate var sceneStyle: SceneStyle {
        switch category {
        case .beach:
            return id.contains("storm") ? .coastalStormy : .lochMorning
        case .forest:
            return .pineForest
        case .city:
            return .highlandsDusk
        case .mountain:
            return id.contains("glencoe") ? .glencoe : .highlandsDay
        case .island:
            return .lochMorning
        case .meadow:
            return .highlandsDay
        }
    }
}

private enum SceneStyle: Equatable {
    case highlandsDay
    case highlandsDusk
    case lochMorning
    case coastalStormy
    case pineForest
    case glencoe

    var bgGradient: [Color] {
        switch self {
        case .highlandsDay: return [c(0.22, 0.45, 0.72), c(0.06, 0.26, 0.16)]
        case .highlandsDusk: return [c(0.68, 0.24, 0.14), c(0.22, 0.06, 0.30)]
        case .lochMorning: return [c(0.50, 0.68, 0.82), c(0.12, 0.28, 0.40)]
        case .coastalStormy: return [c(0.14, 0.18, 0.30), c(0.08, 0.10, 0.18)]
        case .pineForest: return [c(0.06, 0.18, 0.14), c(0.02, 0.08, 0.06)]
        case .glencoe: return [c(0.22, 0.28, 0.44), c(0.08, 0.12, 0.20)]
        }
    }

    var accent: Color {
        switch self {
        case .highlandsDay: return c(0.38, 0.65, 0.90)
        case .highlandsDusk: return c(0.92, 0.50, 0.25)
        case .lochMorning: return c(0.70, 0.84, 0.95)
        case .coastalStormy: return c(0.40, 0.48, 0.72)
        case .pineForest: return c(0.30, 0.60, 0.38)
        case .glencoe: return c(0.50, 0.60, 0.82)
        }
    }

    var skyTop: Color {
        switch self {
        case .highlandsDay: return c(0.35, 0.62, 0.90)
        case .highlandsDusk: return c(0.88, 0.40, 0.18)
        case .lochMorning: return c(0.70, 0.82, 0.92)
        case .coastalStormy: return c(0.22, 0.26, 0.40)
        case .pineForest: return c(0.20, 0.35, 0.55)
        case .glencoe: return c(0.44, 0.54, 0.70)
        }
    }

    var skyBottom: Color {
        switch self {
        case .highlandsDay: return c(0.65, 0.82, 0.96)
        case .highlandsDusk: return c(0.60, 0.22, 0.55)
        case .lochMorning: return c(0.84, 0.90, 0.96)
        case .coastalStormy: return c(0.30, 0.34, 0.50)
        case .pineForest: return c(0.30, 0.45, 0.58)
        case .glencoe: return c(0.56, 0.64, 0.80)
        }
    }

    var farMountain: Color {
        switch self {
        case .highlandsDay: return c(0.48, 0.63, 0.76)
        case .highlandsDusk: return c(0.55, 0.28, 0.46)
        case .lochMorning: return c(0.58, 0.70, 0.80)
        case .coastalStormy: return c(0.28, 0.32, 0.46)
        case .pineForest: return c(0.18, 0.32, 0.28)
        case .glencoe: return c(0.38, 0.46, 0.62)
        }
    }

    var midMountain: Color {
        switch self {
        case .highlandsDay: return c(0.20, 0.40, 0.26)
        case .highlandsDusk: return c(0.36, 0.16, 0.34)
        case .lochMorning: return c(0.28, 0.44, 0.40)
        case .coastalStormy: return c(0.16, 0.20, 0.30)
        case .pineForest: return c(0.08, 0.20, 0.16)
        case .glencoe: return c(0.22, 0.30, 0.42)
        }
    }

    var nearMountain: Color {
        switch self {
        case .highlandsDay: return c(0.10, 0.26, 0.16)
        case .highlandsDusk: return c(0.20, 0.08, 0.20)
        case .lochMorning: return c(0.16, 0.28, 0.26)
        case .coastalStormy: return c(0.08, 0.10, 0.18)
        case .pineForest: return c(0.04, 0.12, 0.08)
        case .glencoe: return c(0.12, 0.18, 0.28)
        }
    }

    var water: Color {
        switch self {
        case .highlandsDay: return c(0.16, 0.40, 0.64)
        case .highlandsDusk: return c(0.44, 0.18, 0.28)
        case .lochMorning: return c(0.32, 0.54, 0.72)
        case .coastalStormy: return c(0.10, 0.16, 0.32)
        case .pineForest: return c(0.08, 0.22, 0.26)
        case .glencoe: return c(0.18, 0.28, 0.44)
        }
    }

    var hasMist: Bool { self == .lochMorning || self == .glencoe || self == .pineForest }
    var hasSun: Bool { self == .highlandsDay || self == .highlandsDusk || self == .lochMorning }
    var hasTrees: Bool { self == .pineForest || self == .highlandsDay || self == .glencoe }
    var hasClouds: Bool { self == .highlandsDay || self == .lochMorning }

    private func c(_ r: Double, _ g: Double, _ b: Double) -> Color {
        Color(red: r, green: g, blue: b)
    }
}

private struct SceneCanvasView: View {
    let style: SceneStyle
    let time: TimeInterval

    var body: some View {
        Canvas { context, size in
            let width = size.width
            let height = size.height

            context.fill(
                Path(CGRect(origin: .zero, size: size)),
                with: .linearGradient(
                    Gradient(colors: [style.skyTop, style.skyBottom]),
                    startPoint: .zero,
                    endPoint: CGPoint(x: 0, y: height * 0.68)
                )
            )

            if style.hasSun {
                let isDusk = style == .highlandsDusk
                let centerX = width * 0.66 + CGFloat(sin(time * 0.22) * 3)
                let centerY = height * (isDusk ? 0.50 : 0.20)
                let radius: CGFloat = isDusk ? 26 : 18

                context.fill(
                    Path(ellipseIn: CGRect(
                        x: centerX - radius * 4,
                        y: centerY - radius * 4,
                        width: radius * 8,
                        height: radius * 8
                    )),
                    with: .radialGradient(
                        Gradient(colors: [style.accent.opacity(0.45), .clear]),
                        center: CGPoint(x: centerX, y: centerY),
                        startRadius: 0,
                        endRadius: radius * 4
                    )
                )

                context.fill(
                    Path(ellipseIn: CGRect(
                        x: centerX - radius,
                        y: centerY - radius,
                        width: radius * 2,
                        height: radius * 2
                    )),
                    with: .color(.white.opacity(0.92))
                )
            }

            if style.hasClouds {
                drawClouds(context: context, width: width, height: height, time: time)
            }

            let movement = sin(time * 0.28)
            let farOffset = CGFloat(movement * 7)
            let midOffset = CGFloat(movement * 13)
            let nearOffset = CGFloat(movement * 20)

            mountainFill(
                context: context,
                width: width,
                height: height,
                points: [(0.00, 0.38), (0.18, 0.27), (0.38, 0.34), (0.58, 0.24), (0.76, 0.31), (0.92, 0.26), (1.08, 0.37)],
                baseY: 0.70,
                color: style.farMountain,
                dx: farOffset
            )

            if style.hasMist {
                context.fill(
                    Path(CGRect(origin: .zero, size: size)),
                    with: .linearGradient(
                        Gradient(stops: [
                            .init(color: .clear, location: 0.36),
                            .init(color: .white.opacity(0.22), location: 0.50),
                            .init(color: .clear, location: 0.60)
                        ]),
                        startPoint: .zero,
                        endPoint: CGPoint(x: 0, y: height)
                    )
                )
            }

            if style.hasTrees {
                drawTrees(context: context, width: width, groundY: height * 0.71, dx: farOffset * 0.8, count: 24, treeHeight: height * 0.07, color: style.midMountain.opacity(0.80))
            }

            mountainFill(
                context: context,
                width: width,
                height: height,
                points: [(0.00, 0.50), (0.14, 0.42), (0.32, 0.48), (0.50, 0.38), (0.68, 0.46), (0.85, 0.41), (1.05, 0.52)],
                baseY: 0.80,
                color: style.midMountain,
                dx: midOffset
            )

            if style.hasTrees {
                drawTrees(context: context, width: width, groundY: height * 0.80, dx: midOffset * 0.9, count: 18, treeHeight: height * 0.09, color: style.nearMountain.opacity(0.82))
            }

            mountainFill(
                context: context,
                width: width,
                height: height,
                points: [(0.00, 0.63), (0.10, 0.56), (0.28, 0.61), (0.48, 0.52), (0.68, 0.58), (0.88, 0.54), (1.10, 0.63)],
                baseY: 0.90,
                color: style.nearMountain,
                dx: nearOffset
            )

            if style.hasTrees {
                drawTrees(context: context, width: width, groundY: height * 0.84, dx: nearOffset * 1.2, count: 14, treeHeight: height * 0.12, color: style.nearMountain.opacity(0.95))
            }

            let waterY = height * 0.84
            context.fill(
                Path(CGRect(x: 0, y: waterY, width: width, height: height - waterY)),
                with: .linearGradient(
                    Gradient(colors: [style.water.opacity(0.90), style.water]),
                    startPoint: CGPoint(x: 0, y: waterY),
                    endPoint: CGPoint(x: 0, y: height)
                )
            )

            for index in 0..<5 {
                let shimmerY = waterY + 9 + CGFloat(index) * 8 + CGFloat(sin(time * 1.8 + Double(index) * 0.8) * 2.5)
                var path = Path()
                path.move(to: CGPoint(x: width * 0.08, y: shimmerY))
                path.addLine(to: CGPoint(x: width * 0.92, y: shimmerY))
                context.stroke(path, with: .color(.white.opacity(0.19 - Double(index) * 0.02)), lineWidth: 1)
            }

            context.fill(
                Path(CGRect(origin: .zero, size: size)),
                with: .linearGradient(
                    Gradient(stops: [
                        .init(color: .white.opacity(0.13), location: 0.00),
                        .init(color: .clear, location: 0.26)
                    ]),
                    startPoint: .zero,
                    endPoint: CGPoint(x: 0, y: height)
                )
            )
        }
    }

    private func mountainFill(
        context: GraphicsContext,
        width: CGFloat,
        height: CGFloat,
        points rawPoints: [(Double, Double)],
        baseY: Double,
        color: Color,
        dx: CGFloat
    ) {
        let points = rawPoints.map { CGPoint(x: width * $0.0 + dx, y: height * $0.1) }
        guard points.count >= 2 else { return }

        var path = Path()
        path.move(to: CGPoint(x: -50, y: height))
        path.addLine(to: CGPoint(x: points[0].x, y: height * baseY))

        for index in 0..<(points.count - 1) {
            let start = points[index]
            let end = points[index + 1]
            path.addCurve(
                to: end,
                control1: CGPoint(x: start.x + (end.x - start.x) * 0.40, y: start.y),
                control2: CGPoint(x: start.x + (end.x - start.x) * 0.60, y: end.y)
            )
        }

        path.addLine(to: CGPoint(x: width + 50, y: height * baseY))
        path.addLine(to: CGPoint(x: width + 50, y: height))
        path.closeSubpath()
        context.fill(path, with: .color(color))
    }

    private func drawTrees(
        context: GraphicsContext,
        width: CGFloat,
        groundY: CGFloat,
        dx: CGFloat,
        count: Int,
        treeHeight: CGFloat,
        color: Color
    ) {
        let spacing = width / CGFloat(count)

        for index in 0..<count {
            let baseX = spacing * (CGFloat(index) + 0.5) + dx
            let height = treeHeight * (0.82 + CGFloat(index % 4) * 0.09)
            let treeWidth = height * 0.45
            var path = Path()
            path.move(to: CGPoint(x: baseX, y: groundY - height))
            path.addLine(to: CGPoint(x: baseX - treeWidth / 2, y: groundY))
            path.addLine(to: CGPoint(x: baseX + treeWidth / 2, y: groundY))
            path.closeSubpath()
            context.fill(path, with: .color(color))
        }
    }

    private func drawClouds(
        context: GraphicsContext,
        width: CGFloat,
        height: CGFloat,
        time: TimeInterval
    ) {
        struct Bubble {
            var dx: CGFloat
            var dy: CGFloat
            var scale: CGFloat
        }

        let bubbles: [Bubble] = [
            .init(dx: 0, dy: 0, scale: 1.00),
            .init(dx: 20, dy: -8, scale: 0.75),
            .init(dx: -20, dy: -7, scale: 0.70),
            .init(dx: 38, dy: 3, scale: 0.65)
        ]
        let configs: [(x: Double, y: Double, radius: Double, speed: Double)] = [
            (0.14, 0.13, 26, 0.040),
            (0.48, 0.08, 20, 0.025),
            (0.78, 0.16, 23, 0.032)
        ]

        for config in configs {
            let drift = CGFloat(time * config.speed).truncatingRemainder(dividingBy: width)
            let centerX = width * CGFloat(config.x) + drift
            let centerY = height * CGFloat(config.y)
            let radius = CGFloat(config.radius)

            for bubble in bubbles {
                let bubbleRadius = radius * bubble.scale
                context.fill(
                    Path(ellipseIn: CGRect(
                        x: centerX + bubble.dx - bubbleRadius,
                        y: centerY + bubble.dy - bubbleRadius,
                        width: bubbleRadius * 2,
                        height: bubbleRadius * 2
                    )),
                    with: .color(.white.opacity(0.22))
                )
            }
        }
    }
}

private struct AudioVisualiserView: View {
    let phases: [Double]
    let isPlaying: Bool
    private let count = 24

    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate

            Canvas { context, size in
                let gap: CGFloat = 2.5
                let barWidth = (size.width - gap * CGFloat(count - 1)) / CGFloat(count)

                for index in 0..<count {
                    let baseAmplitude = isPlaying
                        ? 0.20 + 0.80 * abs(sin(time * (1.3 + Double(index) * 0.06) + phases[index]))
                        : 0.22
                    let barHeight = size.height * CGFloat(baseAmplitude)
                    let x = CGFloat(index) * (barWidth + gap)
                    let y = (size.height - barHeight) / 2

                    context.fill(
                        Path(roundedRect: CGRect(x: x, y: y, width: barWidth, height: barHeight), cornerRadius: barWidth / 2),
                        with: .color(.white.opacity(isPlaying ? 0.48 : 0.20))
                    )
                }
            }
        }
    }
}

struct NowPlayingViewNew: View {
    @EnvironmentObject private var appState: AppState
    @State private var isPulsing = false
    @State private var visualPhases: [Double] = (0..<24).map { _ in Double.random(in: 0..<(.pi * 2)) }

    private let circleDiameter: CGFloat = 290

    var body: some View {
        ZStack {
            if let soundscape = appState.selectedSoundscape ?? appState.audioPlayer.currentSoundscape {
                nowPlayingContent(for: soundscape)
            } else {
                emptyState
            }
        }
        .gesture(
            DragGesture(minimumDistance: 20)
                .onEnded { value in
                    if value.translation.height > 80 && abs(value.translation.width) < 100 {
                        appState.closeNowPlaying()
                    }
                }
        )
        .onAppear {
            withAnimation(.easeIn(duration: 0.8)) {
                isPulsing = true
            }
        }
    }

    private func nowPlayingContent(for soundscape: Soundscape) -> some View {
        ZStack {
            background(for: soundscape)

            VStack(spacing: 0) {
                topBar(for: soundscape)
                    .padding(.top, 58)
                    .padding(.horizontal, 24)

                Spacer()

                sceneArea(for: soundscape)

                Spacer()

                controlsArea(for: soundscape)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 54)
            }
        }
    }

    private func background(for soundscape: Soundscape) -> some View {
        ZStack {
            LinearGradient(colors: soundscape.sceneStyle.bgGradient, startPoint: .top, endPoint: .bottom)
            RadialGradient(colors: [.clear, .black.opacity(0.50)], center: .center, startRadius: 150, endRadius: 450)
        }
        .ignoresSafeArea()
    }

    private func topBar(for soundscape: Soundscape) -> some View {
        HStack {
            iconButton("chevron.down") {
                appState.closeNowPlaying()
            }

            Spacer()

            VStack(spacing: 4) {
                Text(soundscape.displayName)
                    .font(.system(size: 18, weight: .semibold, design: .serif))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text(soundscape.displayLocation.uppercased())
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.50))
                    .tracking(1.6)
                    .lineLimit(1)
            }

            Spacer()

            iconButton(
                appState.isFavourite(soundscape) ? "heart.fill" : "heart",
                tint: appState.isFavourite(soundscape) ? .pink : .white.opacity(0.80)
            ) {
                withAnimation(.spring(response: 0.28, dampingFraction: 0.5)) {
                    appState.toggleFavourite(soundscape)
                }
            }
        }
    }

    private func sceneArea(for soundscape: Soundscape) -> some View {
        VStack(spacing: 22) {
            Text(soundscape.tagline)
                .font(.system(size: 15, weight: .light, design: .serif))
                .italic()
                .foregroundStyle(.white.opacity(0.68))
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .padding(.horizontal, 28)

            ZStack {
                Circle()
                    .fill(soundscape.sceneStyle.accent.opacity(0.20))
                    .frame(width: circleDiameter + 90, height: circleDiameter + 90)
                    .blur(radius: 34)

                if isCurrentSoundscapePlaying(soundscape) {
                    Circle()
                        .stroke(soundscape.sceneStyle.accent.opacity(0.30), lineWidth: 7)
                        .frame(width: circleDiameter + 24, height: circleDiameter + 24)
                        .scaleEffect(isPulsing ? 1.045 : 0.975)
                        .opacity(isPulsing ? 1.0 : 0.3)
                        .animation(.easeInOut(duration: 2.1).repeatForever(autoreverses: true), value: isPulsing)
                        .transition(.opacity.animation(.easeOut(duration: 0.35)))
                }

                TimelineView(.animation) { timeline in
                    SceneCanvasView(
                        style: soundscape.sceneStyle,
                        time: timeline.date.timeIntervalSinceReferenceDate
                    )
                }
                .frame(width: circleDiameter, height: circleDiameter)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.45), radius: 24, x: 0, y: 10)

                Circle()
                    .strokeBorder(
                        AngularGradient(
                            colors: [
                                .white.opacity(0.06),
                                .white.opacity(0.45),
                                .white.opacity(0.06),
                                .white.opacity(0.28),
                                .white.opacity(0.06)
                            ],
                            center: .center
                        ),
                        lineWidth: 1.5
                    )
                    .frame(width: circleDiameter, height: circleDiameter)
            }
        }
    }

    private func controlsArea(for soundscape: Soundscape) -> some View {
        VStack(spacing: 28) {
            AudioVisualiserView(
                phases: visualPhases,
                isPlaying: isCurrentSoundscapePlaying(soundscape)
            )
            .frame(height: 28)

            HStack(spacing: 52) {
                Button { } label: {
                    Image(systemName: "backward.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.white.opacity(0.38))
                }
                .buttonStyle(.plain)
                .disabled(true)

                Button {
                    withAnimation(.spring(response: 0.30, dampingFraction: 0.60)) {
                        appState.audioPlayer.togglePlayback(for: soundscape)
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 76, height: 76)
                            .shadow(color: soundscape.sceneStyle.accent.opacity(0.60), radius: 18, x: 0, y: 6)

                        Image(systemName: isCurrentSoundscapePlaying(soundscape) ? "pause.fill" : "play.fill")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundStyle(soundscape.sceneStyle.bgGradient.first ?? .blue)
                            .offset(x: isCurrentSoundscapePlaying(soundscape) ? 0 : 2)
                    }
                }
                .buttonStyle(.plain)
                .scaleEffect(isCurrentSoundscapePlaying(soundscape) ? 1.0 : 0.93)

                Button { } label: {
                    Image(systemName: "forward.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.white.opacity(0.38))
                }
                .buttonStyle(.plain)
                .disabled(true)
            }
        }
    }

    private func isCurrentSoundscapePlaying(_ soundscape: Soundscape) -> Bool {
        appState.audioPlayer.currentSoundscape?.id == soundscape.id && appState.audioPlayer.isPlaying
    }

    @ViewBuilder
    private func iconButton(
        _ icon: String,
        tint: Color = .white.opacity(0.80),
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(tint)
                .frame(width: 44, height: 44)
                .background(.white.opacity(0.11), in: Circle())
        }
        .buttonStyle(.plain)
    }

    private var emptyState: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.22, green: 0.28, blue: 0.44), Color(red: 0.08, green: 0.12, blue: 0.20)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                Image(systemName: "waveform")
                    .font(.largeTitle)

                Text("Nothing playing yet")
                    .font(.headline)

                Text("Choose a soundscape from Home to begin.")
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.70))
            }
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .padding()
        }
    }
}

#Preview {
    let state = AppState()
    state.selectedSoundscape = MockSoundscapes.all[0]
    state.audioPlayer.play(MockSoundscapes.all[0])

    return NowPlayingViewNew()
        .environmentObject(state)
}
