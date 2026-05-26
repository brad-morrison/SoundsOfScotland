//
//  NowPlayingView.swift
//  Sounds of Scotland
//
//  A self-contained Now Playing screen.
//  Requires iOS 15+ / Xcode 15+.
//  Drop this file into your project — no other files needed for the UI.
//

import SwiftUI

// MARK: – Soundscape Model ────────────────────────────────────────────────────

struct Soundscape: Identifiable {
    let id: UUID
    let name: String
    let location: String
    let tagline: String
    let style: SceneStyle

    init(id: UUID = UUID(), name: String, location: String,
         tagline: String, style: SceneStyle) {
        self.id = id; self.name = name
        self.location = location; self.tagline = tagline
        self.style = style
    }

    /// Sample data — replace / extend with your real soundscapes.
    static let samples: [Soundscape] = [
        .init(name: "Highland Rain",
              location: "Cairngorms National Park",
              tagline: "Let the rain carry you away",
              style: .highlandsDay),
        .init(name: "Loch at Dawn",
              location: "Loch Lomond",
              tagline: "Still waters, still mind",
              style: .lochMorning),
        .init(name: "Coastal Storm",
              location: "Isle of Skye",
              tagline: "Power of the wild Atlantic",
              style: .coastalStormy),
        .init(name: "Glencoe Dusk",
              location: "Glen Coe, Highlands",
              tagline: "Ancient valleys at rest",
              style: .highlandsDusk),
        .init(name: "Pine Cathedral",
              location: "Rothiemurchus Forest",
              tagline: "Green silence, deep roots",
              style: .pineForest),
        .init(name: "Valley Mist",
              location: "Glen Etive",
              tagline: "Drift with the morning haze",
              style: .glencoe),
    ]

    // ── Scene styles ──────────────────────────────────────────────────────
    enum SceneStyle: Equatable {
        case highlandsDay, highlandsDusk, lochMorning,
             coastalStormy, pineForest, glencoe

        // Full-screen background
        var bgGradient: [Color] { switch self {
            case .highlandsDay:  return [c(0.22,0.45,0.72), c(0.06,0.26,0.16)]
            case .highlandsDusk: return [c(0.68,0.24,0.14), c(0.22,0.06,0.30)]
            case .lochMorning:   return [c(0.50,0.68,0.82), c(0.12,0.28,0.40)]
            case .coastalStormy: return [c(0.14,0.18,0.30), c(0.08,0.10,0.18)]
            case .pineForest:    return [c(0.06,0.18,0.14), c(0.02,0.08,0.06)]
            case .glencoe:       return [c(0.22,0.28,0.44), c(0.08,0.12,0.20)]
        }}

        // Glow / accent tint
        var accent: Color { switch self {
            case .highlandsDay:  return c(0.38,0.65,0.90)
            case .highlandsDusk: return c(0.92,0.50,0.25)
            case .lochMorning:   return c(0.70,0.84,0.95)
            case .coastalStormy: return c(0.40,0.48,0.72)
            case .pineForest:    return c(0.30,0.60,0.38)
            case .glencoe:       return c(0.50,0.60,0.82)
        }}

        // Sky colours (top → bottom)
        var skyTop: Color { switch self {
            case .highlandsDay:  return c(0.35,0.62,0.90)
            case .highlandsDusk: return c(0.88,0.40,0.18)
            case .lochMorning:   return c(0.70,0.82,0.92)
            case .coastalStormy: return c(0.22,0.26,0.40)
            case .pineForest:    return c(0.20,0.35,0.55)
            case .glencoe:       return c(0.44,0.54,0.70)
        }}
        var skyBot: Color { switch self {
            case .highlandsDay:  return c(0.65,0.82,0.96)
            case .highlandsDusk: return c(0.60,0.22,0.55)
            case .lochMorning:   return c(0.84,0.90,0.96)
            case .coastalStormy: return c(0.30,0.34,0.50)
            case .pineForest:    return c(0.30,0.45,0.58)
            case .glencoe:       return c(0.56,0.64,0.80)
        }}

        // Mountain layers (far → near)
        var farMtn: Color { switch self {
            case .highlandsDay:  return c(0.48,0.63,0.76)
            case .highlandsDusk: return c(0.55,0.28,0.46)
            case .lochMorning:   return c(0.58,0.70,0.80)
            case .coastalStormy: return c(0.28,0.32,0.46)
            case .pineForest:    return c(0.18,0.32,0.28)
            case .glencoe:       return c(0.38,0.46,0.62)
        }}
        var midMtn: Color { switch self {
            case .highlandsDay:  return c(0.20,0.40,0.26)
            case .highlandsDusk: return c(0.36,0.16,0.34)
            case .lochMorning:   return c(0.28,0.44,0.40)
            case .coastalStormy: return c(0.16,0.20,0.30)
            case .pineForest:    return c(0.08,0.20,0.16)
            case .glencoe:       return c(0.22,0.30,0.42)
        }}
        var nearMtn: Color { switch self {
            case .highlandsDay:  return c(0.10,0.26,0.16)
            case .highlandsDusk: return c(0.20,0.08,0.20)
            case .lochMorning:   return c(0.16,0.28,0.26)
            case .coastalStormy: return c(0.08,0.10,0.18)
            case .pineForest:    return c(0.04,0.12,0.08)
            case .glencoe:       return c(0.12,0.18,0.28)
        }}
        var water: Color { switch self {
            case .highlandsDay:  return c(0.16,0.40,0.64)
            case .highlandsDusk: return c(0.44,0.18,0.28)
            case .lochMorning:   return c(0.32,0.54,0.72)
            case .coastalStormy: return c(0.10,0.16,0.32)
            case .pineForest:    return c(0.08,0.22,0.26)
            case .glencoe:       return c(0.18,0.28,0.44)
        }}

        var hasMist:  Bool { self == .lochMorning || self == .glencoe  || self == .pineForest }
        var hasSun:   Bool { self == .highlandsDay || self == .highlandsDusk || self == .lochMorning }
        var hasTrees: Bool { self == .pineForest   || self == .highlandsDay  || self == .glencoe }
        var hasClouds:Bool { self == .highlandsDay || self == .lochMorning }

        private func c(_ r: Double, _ g: Double, _ b: Double) -> Color {
            Color(red: r, green: g, blue: b)
        }
    }
}

// MARK: – Scene Canvas ────────────────────────────────────────────────────────
//
// Draws a layered Scottish landscape using SwiftUI Canvas.
// Three parallax mountain layers + optional mist, sun, clouds, trees, water.

struct SceneCanvasView: View {
    let style: Soundscape.SceneStyle
    let time: TimeInterval          // drives all animations

    var body: some View {
        Canvas { ctx, size in
            let w = size.width, h = size.height

            // 1 ── Sky
            ctx.fill(
                Path(CGRect(origin: .zero, size: size)),
                with: .linearGradient(
                    Gradient(colors: [style.skyTop, style.skyBot]),
                    startPoint: .zero,
                    endPoint:   CGPoint(x: 0, y: h * 0.68)))

            // 2 ── Sun / low dusk sun
            if style.hasSun {
                let isDusk = style == .highlandsDusk
                let cx: CGFloat = w * 0.66 + CGFloat(sin(time * 0.22) * 3)
                let cy: CGFloat = h * (isDusk ? 0.50 : 0.20)
                let r:  CGFloat = isDusk ? 26 : 18
                // Glow halo
                ctx.fill(
                    Path(ellipseIn: CGRect(x: cx-r*4, y: cy-r*4, width: r*8, height: r*8)),
                    with: .radialGradient(
                        Gradient(colors: [style.accent.opacity(0.45), .clear]),
                        center: CGPoint(x: cx, y: cy),
                        startRadius: 0, endRadius: r * 4))
                // Disc
                ctx.fill(
                    Path(ellipseIn: CGRect(x: cx-r, y: cy-r, width: r*2, height: r*2)),
                    with: .color(.white.opacity(0.92)))
            }

            // 3 ── Clouds
            if style.hasClouds { drawClouds(ctx: ctx, w: w, h: h, time: time) }

            // Parallax offsets — gentle sine drift
            let s = sin(time * 0.28)
            let farOff:  CGFloat = CGFloat(s *  7)
            let midOff:  CGFloat = CGFloat(s * 13)
            let nearOff: CGFloat = CGFloat(s * 20)

            // 4 ── Far mountains
            mountainFill(ctx: ctx, w: w, h: h,
                pts: [(0.00,0.38),(0.18,0.27),(0.38,0.34),(0.58,0.24),
                      (0.76,0.31),(0.92,0.26),(1.08,0.37)],
                baseY: 0.70, color: style.farMtn, dx: farOff)

            // 5 ── Mist band
            if style.hasMist {
                ctx.fill(Path(CGRect(origin: .zero, size: size)),
                    with: .linearGradient(
                        Gradient(stops: [
                            .init(color: .clear,               location: 0.36),
                            .init(color: .white.opacity(0.22), location: 0.50),
                            .init(color: .clear,               location: 0.60)]),
                        startPoint: .zero, endPoint: CGPoint(x: 0, y: h)))
            }

            // 6 ── Trees behind mid-mountains
            if style.hasTrees {
                drawTrees(ctx: ctx, w: w, h: h,
                    groundY: h * 0.71, dx: farOff * 0.8,
                    count: 24, treeH: h * 0.07,
                    color: style.midMtn.opacity(0.80))
            }

            // 7 ── Mid mountains
            mountainFill(ctx: ctx, w: w, h: h,
                pts: [(0.00,0.50),(0.14,0.42),(0.32,0.48),(0.50,0.38),
                      (0.68,0.46),(0.85,0.41),(1.05,0.52)],
                baseY: 0.80, color: style.midMtn, dx: midOff)

            // 8 ── Trees behind near-mountains
            if style.hasTrees {
                drawTrees(ctx: ctx, w: w, h: h,
                    groundY: h * 0.80, dx: midOff * 0.9,
                    count: 18, treeH: h * 0.09,
                    color: style.nearMtn.opacity(0.82))
            }

            // 9 ── Near mountains (foreground hills)
            mountainFill(ctx: ctx, w: w, h: h,
                pts: [(0.00,0.63),(0.10,0.56),(0.28,0.61),(0.48,0.52),
                      (0.68,0.58),(0.88,0.54),(1.10,0.63)],
                baseY: 0.90, color: style.nearMtn, dx: nearOff)

            // 10 ── Foreground trees
            if style.hasTrees {
                drawTrees(ctx: ctx, w: w, h: h,
                    groundY: h * 0.84, dx: nearOff * 1.2,
                    count: 14, treeH: h * 0.12,
                    color: style.nearMtn.opacity(0.95))
            }

            // 11 ── Loch / water
            let wy = h * 0.84
            ctx.fill(
                Path(CGRect(x: 0, y: wy, width: w, height: h - wy)),
                with: .linearGradient(
                    Gradient(colors: [style.water.opacity(0.90), style.water]),
                    startPoint: CGPoint(x: 0, y: wy),
                    endPoint:   CGPoint(x: 0, y: h)))

            // 12 ── Water shimmer lines
            for i in 0..<5 {
                let sy = wy + 9 + CGFloat(i) * 8
                          + CGFloat(sin(time * 1.8 + Double(i) * 0.8) * 2.5)
                var p = Path()
                p.move(to:    CGPoint(x: w * 0.08, y: sy))
                p.addLine(to: CGPoint(x: w * 0.92, y: sy))
                ctx.stroke(p, with: .color(.white.opacity(0.19 - Double(i) * 0.02)),
                           lineWidth: 1)
            }

            // 13 ── Top glass-dome gloss
            ctx.fill(Path(CGRect(origin: .zero, size: size)),
                with: .linearGradient(
                    Gradient(stops: [
                        .init(color: .white.opacity(0.13), location: 0.00),
                        .init(color: .clear,               location: 0.26)]),
                    startPoint: .zero, endPoint: CGPoint(x: 0, y: h)))
        }
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    /// Smooth Bézier mountain silhouette.
    private func mountainFill(ctx: GraphicsContext, w: CGFloat, h: CGFloat,
                               pts raw: [(Double, Double)],
                               baseY: Double, color: Color, dx: CGFloat) {
        let pts = raw.map { CGPoint(x: w * $0.0 + dx, y: h * $0.1) }
        guard pts.count >= 2 else { return }
        var path = Path()
        path.move(to: CGPoint(x: -50, y: h))
        path.addLine(to: CGPoint(x: pts[0].x, y: h * baseY))
        for i in 0 ..< pts.count - 1 {
            let a = pts[i], b = pts[i + 1]
            path.addCurve(to: b,
                control1: CGPoint(x: a.x + (b.x - a.x) * 0.40, y: a.y),
                control2: CGPoint(x: a.x + (b.x - a.x) * 0.60, y: b.y))
        }
        path.addLine(to: CGPoint(x: w + 50, y: h * baseY))
        path.addLine(to: CGPoint(x: w + 50, y: h))
        path.closeSubpath()
        ctx.fill(path, with: .color(color))
    }

    /// Simple triangle pine trees.
    private func drawTrees(ctx: GraphicsContext, w: CGFloat, h: CGFloat,
                           groundY: CGFloat, dx: CGFloat,
                           count: Int, treeH: CGFloat, color: Color) {
        let spacing = w / CGFloat(count)
        for i in 0 ..< count {
            let bx = spacing * (CGFloat(i) + 0.5) + dx
            let th = treeH * (0.82 + CGFloat(i % 4) * 0.09)
            let tw = th * 0.45
            var t = Path()
            t.move(to:    CGPoint(x: bx,        y: groundY - th))
            t.addLine(to: CGPoint(x: bx - tw/2, y: groundY))
            t.addLine(to: CGPoint(x: bx + tw/2, y: groundY))
            t.closeSubpath()
            ctx.fill(t, with: .color(color))
        }
    }

    /// Softly drifting cloud puffs.
    private func drawClouds(ctx: GraphicsContext, w: CGFloat, h: CGFloat,
                            time: TimeInterval) {
        struct Bubble { var dx: CGFloat; var dy: CGFloat; var scale: CGFloat }
        let bubbles: [Bubble] = [
            .init(dx:  0,  dy:  0,   scale: 1.00),
            .init(dx:  20, dy: -8,   scale: 0.75),
            .init(dx: -20, dy: -7,   scale: 0.70),
            .init(dx:  38, dy:  3,   scale: 0.65),
        ]
        let configs: [(x: Double, y: Double, r: Double, speed: Double)] = [
            (0.14, 0.13, 26, 0.040),
            (0.48, 0.08, 20, 0.025),
            (0.78, 0.16, 23, 0.032),
        ]
        for cfg in configs {
            let drift = CGFloat(time * cfg.speed).truncatingRemainder(dividingBy: w)
            let cx = w * CGFloat(cfg.x) + drift
            let cy = h * CGFloat(cfg.y)
            let r  = CGFloat(cfg.r)
            for b in bubbles {
                let br = r * b.scale
                ctx.fill(
                    Path(ellipseIn: CGRect(x: cx + b.dx - br,
                                          y: cy + b.dy - br,
                                          width: br * 2, height: br * 2)),
                    with: .color(.white.opacity(0.22)))
            }
        }
    }
}

// MARK: – Audio Visualiser ────────────────────────────────────────────────────

struct AudioVisualiserView: View {
    /// Pre-computed random phase offsets so bars are always out of sync.
    let phases: [Double]
    private let count = 24

    var body: some View {
        TimelineView(.animation) { tl in
            let t = tl.date.timeIntervalSinceReferenceDate
            Canvas { ctx, size in
                let gap: CGFloat = 2.5
                let bw = (size.width - gap * CGFloat(count - 1)) / CGFloat(count)
                for i in 0 ..< count {
                    let amp = 0.20 + 0.80 * abs(sin(t * (1.3 + Double(i) * 0.06) + phases[i]))
                    let bh  = size.height * CGFloat(amp)
                    let x   = CGFloat(i) * (bw + gap)
                    let y   = (size.height - bh) / 2
                    ctx.fill(
                        Path(roundedRect: CGRect(x: x, y: y, width: bw, height: bh),
                             cornerRadius: bw / 2),
                        with: .color(.white.opacity(0.48)))
                }
            }
        }
    }
}

// MARK: – Now Playing View ────────────────────────────────────────────────────

struct NowPlayingView: View {

    let soundscape: Soundscape

    @Environment(\.dismiss) private var dismiss
    @State private var isPlaying   = true
    @State private var isFavourite = false
    @State private var isPulsing   = false

    // Persist random bar phases for the lifetime of this view
    @State private var visualPhases: [Double] =
        (0 ..< 24).map { _ in Double.random(in: 0 ..< .pi * 2) }

    private let circleD: CGFloat = 290

    // ── Body ─────────────────────────────────────────────────────────────────

    var body: some View {
        ZStack {
            background
            VStack(spacing: 0) {
                topBar
                    .padding(.top, 58)
                    .padding(.horizontal, 24)
                Spacer()
                sceneArea
                Spacer()
                controlsArea
                    .padding(.horizontal, 32)
                    .padding(.bottom, 54)
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.8)) { isPulsing = true }
        }
    }

    // ── Background ───────────────────────────────────────────────────────────

    private var background: some View {
        ZStack {
            LinearGradient(colors: soundscape.style.bgGradient,
                           startPoint: .top, endPoint: .bottom)
            RadialGradient(colors: [.clear, .black.opacity(0.50)],
                           center: .center, startRadius: 150, endRadius: 450)
        }
        .ignoresSafeArea()
    }

    // ── Top Bar ──────────────────────────────────────────────────────────────

    private var topBar: some View {
        HStack {
            // Dismiss
            iconButton("chevron.down") { dismiss() }

            Spacer()

            // Soundscape name + location
            VStack(spacing: 4) {
                Text(soundscape.name)
                    .font(.system(size: 18, weight: .semibold, design: .serif))
                    .foregroundStyle(.white)
                Text(soundscape.location.uppercased())
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.50))
                    .tracking(1.6)
            }

            Spacer()

            // Favourite
            iconButton(isFavourite ? "heart.fill" : "heart",
                       tint: isFavourite ? .pink : .white.opacity(0.80)) {
                withAnimation(.spring(response: 0.28, dampingFraction: 0.5)) {
                    isFavourite.toggle()
                }
            }
        }
    }

    // ── Scene Circle ─────────────────────────────────────────────────────────

    private var sceneArea: some View {
        VStack(spacing: 22) {
            // Tagline
            Text(soundscape.tagline)
                .font(.system(size: 15, weight: .light, design: .serif))
                .italic()
                .foregroundStyle(.white.opacity(0.68))
                .multilineTextAlignment(.center)

            ZStack {
                // Ambient halo glow
                Circle()
                    .fill(soundscape.style.accent.opacity(0.20))
                    .frame(width: circleD + 90, height: circleD + 90)
                    .blur(radius: 34)

                // Breathing pulse ring (only while playing)
                if isPlaying {
                    Circle()
                        .stroke(soundscape.style.accent.opacity(0.30), lineWidth: 7)
                        .frame(width: circleD + 24, height: circleD + 24)
                        .scaleEffect(isPulsing ? 1.045 : 0.975)
                        .opacity(isPulsing ? 1.0 : 0.3)
                        .animation(
                            .easeInOut(duration: 2.1).repeatForever(autoreverses: true),
                            value: isPulsing)
                        .transition(.opacity.animation(.easeOut(duration: 0.35)))
                }

                // Landscape scene
                TimelineView(.animation) { tl in
                    SceneCanvasView(
                        style: soundscape.style,
                        time:  tl.date.timeIntervalSinceReferenceDate)
                }
                .frame(width: circleD, height: circleD)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.45), radius: 24, x: 0, y: 10)

                // Iridescent rim highlight
                Circle()
                    .strokeBorder(
                        AngularGradient(
                            colors: [.white.opacity(0.06), .white.opacity(0.45),
                                     .white.opacity(0.06), .white.opacity(0.28),
                                     .white.opacity(0.06)],
                            center: .center),
                        lineWidth: 1.5)
                    .frame(width: circleD, height: circleD)
            }
        }
    }

    // ── Controls ─────────────────────────────────────────────────────────────

    private var controlsArea: some View {
        VStack(spacing: 28) {
            // Audio visualiser (shown only while playing)
            Group {
                if isPlaying {
                    AudioVisualiserView(phases: visualPhases)
                        .frame(height: 28)
                        .transition(.opacity.animation(.easeInOut(duration: 0.4)))
                } else {
                    Color.clear.frame(height: 28)
                }
            }

            // Playback row
            HStack(spacing: 52) {
                Button { /* hook up previous track */ } label: {
                    Image(systemName: "backward.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.white.opacity(0.78))
                }

                // Play / Pause
                Button {
                    withAnimation(.spring(response: 0.30, dampingFraction: 0.60)) {
                        isPlaying.toggle()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 76, height: 76)
                            .shadow(color: soundscape.style.accent.opacity(0.60),
                                    radius: 18, x: 0, y: 6)
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundStyle(soundscape.style.bgGradient.first ?? .blue)
                            .offset(x: isPlaying ? 0 : 2) // optical centre for play icon
                    }
                }
                .scaleEffect(isPlaying ? 1.0 : 0.93)

                Button { /* hook up next track */ } label: {
                    Image(systemName: "forward.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.white.opacity(0.78))
                }
            }
        }
    }

    // ── Shared icon-button helper ─────────────────────────────────────────────

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
    }
}

// MARK: – Previews ────────────────────────────────────────────────────────────

#Preview("Highlands Day")  { NowPlayingView(soundscape: Soundscape.samples[0]) }
#Preview("Loch Morning")   { NowPlayingView(soundscape: Soundscape.samples[1]) }
#Preview("Coastal Storm")  { NowPlayingView(soundscape: Soundscape.samples[2]) }
#Preview("Glencoe Dusk")   { NowPlayingView(soundscape: Soundscape.samples[3]) }
#Preview("Pine Forest")    { NowPlayingView(soundscape: Soundscape.samples[4]) }
#Preview("Valley Mist")    { NowPlayingView(soundscape: Soundscape.samples[5]) }
