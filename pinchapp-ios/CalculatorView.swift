import SwiftUI

// MARK: - Bamboo decorative background

struct BambooBackgroundView: View {
    var body: some View {
        Canvas { ctx, size in
            let stalks: [(x: CGFloat, nodes: Int, width: CGFloat, alpha: Double)] = [
                (size.width * 0.80, 8,  10, 0.07),
                (size.width * 0.88, 10, 7,  0.05),
                (size.width * 0.95, 7,  5,  0.03),
            ]
            for s in stalks {
                let spacing = size.height / CGFloat(s.nodes)
                var stalk = Path()
                stalk.move(to: CGPoint(x: s.x, y: 0))
                stalk.addLine(to: CGPoint(x: s.x, y: size.height))
                ctx.stroke(stalk, with: .color(Color.appAccent.opacity(s.alpha)), lineWidth: s.width)
                for i in 0...s.nodes {
                    let y = CGFloat(i) * spacing
                    var node = Path()
                    node.move(to: CGPoint(x: s.x - s.width, y: y))
                    node.addLine(to: CGPoint(x: s.x + s.width, y: y))
                    ctx.stroke(node, with: .color(Color.appAccent.opacity(s.alpha * 1.6)), lineWidth: 2.5)
                }
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Calculator View

struct CalculatorView: View {
    @State private var volumeMl: Double = 120

    private var minGrams: Double { volumeMl * 5 / 110 }
    private var maxGrams: Double { volumeMl * 7 / 110 }
    private var midGrams: Double { volumeMl * 6 / 110 }

    var body: some View {
        ZStack {
            BambooBackgroundView().ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    header
                    volumeCard
                    resultCard
                    tipCard
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
        }
    }

    // MARK: Header

    private var header: some View {
        VStack(spacing: 4) {
            Text("Калькулятор чая")
                .font(.title2.weight(.semibold))
                .foregroundColor(.appPrimary)
            Text("Стандарт: 5–7 г на 100–120 мл")
                .font(.caption)
                .foregroundColor(.appSecondary)
        }
        .padding(.top, 8)
    }

    // MARK: Volume input

    private var volumeCard: some View {
        VStack(spacing: 16) {
            HStack {
                Label("Объём чайника", systemImage: "drop.fill")
                    .font(.subheadline)
                    .foregroundColor(.appSecondary)
                Spacer()
                Text("\(Int(volumeMl)) мл")
                    .font(.headline.monospacedDigit())
                    .foregroundColor(.appPrimary)
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.3), value: volumeMl)
            }

            Slider(value: $volumeMl, in: 50...400, step: 5)
                .tint(.appAccent)

            HStack {
                Text("50 мл")
                Spacer()
                Text("400 мл")
            }
            .font(.caption2)
            .foregroundColor(.appSecondary.opacity(0.5))
        }
        .padding(20)
        .background(Color.appSurface)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.35), radius: 10, x: 0, y: 4)
    }

    // MARK: Result

    private var resultCard: some View {
        VStack(spacing: 16) {
            Text("Количество листа")
                .font(.subheadline)
                .foregroundColor(.appSecondary)

            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text(String(format: "%.1f", midGrams))
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundColor(.appAccent)
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.4), value: midGrams)
                Text("г")
                    .font(.title)
                    .foregroundColor(.appSecondary)
            }

            Rectangle()
                .fill(Color.appSecondary.opacity(0.15))
                .frame(height: 1)

            HStack {
                rangeLabel(grams: minGrams, title: "минимум", subtitle: "5 г/110мл")
                Spacer()
                Rectangle()
                    .fill(Color.appSecondary.opacity(0.15))
                    .frame(width: 1, height: 40)
                Spacer()
                rangeLabel(grams: maxGrams, title: "максимум", subtitle: "7 г/110мл")
            }
        }
        .padding(20)
        .background(Color.appSurface)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.35), radius: 10, x: 0, y: 4)
    }

    private func rangeLabel(grams: Double, title: String, subtitle: String) -> some View {
        VStack(spacing: 4) {
            Text(String(format: "%.1f г", grams))
                .font(.title3.weight(.semibold).monospacedDigit())
                .foregroundColor(.appPrimary)
                .contentTransition(.numericText())
                .animation(.spring(response: 0.4), value: grams)
            Text(title)
                .font(.caption2.weight(.medium))
                .foregroundColor(.appAccent)
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.appSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: Tip

    private var tipCard: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .foregroundColor(.appAccent)
                .padding(.top, 1)
            Text("Для прессованного чая (пуэр) отламывайте кусок и взвешивайте. Для рассыпного — набирайте горкой, листьев обычно влезает меньше, чем кажется.")
                .font(.caption)
                .foregroundColor(.appSecondary)
        }
        .padding(16)
        .background(Color.appAccent.opacity(0.08))
        .cornerRadius(12)
    }
}

#Preview {
    ZStack {
        Color.appBg.ignoresSafeArea()
        CalculatorView()
    }
}
