import SwiftUI

struct SoundscapeCard: View {
    let soundscape: Soundscape
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                ZStack(alignment: .topTrailing) {
                    Image(soundscape.imageName)
                        .resizable()
                        .aspectRatio(16/9, contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .clipped()

                    if soundscape.isPremium {
                        Image(systemName: "lock.fill")
                            .font(.caption)
                            .foregroundStyle(.white)
                            .padding(8)
                            .background(.black.opacity(0.45))
                            .clipShape(Circle())
                            .padding(12)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(soundscape.subtitle.uppercased())
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white.opacity(0.7))
                        .tracking(1)

                    Text(soundscape.title)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .lineLimit(2)
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 14)
            }
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(.white.opacity(0.08), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SoundscapeCard(soundscape: MockSoundscapes.all[0]) {}
        .padding()
        .background(Color(red: 0.05, green: 0.07, blue: 0.13))
}

