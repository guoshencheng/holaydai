import SwiftUI

struct ContentView: View {
    @State private var eventName: String = "XXXX"
    @State private var targetDate: Date = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
    @State private var includeToday: Bool = true
    @State private var referenceDate: Date = Date()

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }

    private var countdownResult: CountdownResult {
        CountdownCalculator.calculateDays(from: referenceDate, to: targetDate, includeToday: includeToday)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            header
            Divider()
            form
            Divider()
            resultView
            Spacer()
        }
        .padding(32)
        .frame(minWidth: 420, minHeight: 320)
        .background(.regularMaterial)
        .onAppear {
            referenceDate = Date()
        }
        .onReceive(Timer.publish(every: 60, on: .main, in: .common).autoconnect()) { _ in
            referenceDate = Date()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("距离 XXXX 还有多少天")
                .font(.largeTitle.bold())
            Text("输入一个事件名称和目标日期，应用会自动计算距离现在还有多少天或者已经过去了多少天。")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
    }

    private var form: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("事件名称，例如：考试、旅行", text: $eventName)
                .textFieldStyle(.roundedBorder)

            DatePicker("目标日期", selection: $targetDate, displayedComponents: [.date])
                .datePickerStyle(.graphical)

            Toggle("计算时包含今天", isOn: $includeToday)
                .toggleStyle(.switch)
        }
    }

    private var resultView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(countdownResult.localizedSummary(for: eventName))
                .font(.title2.weight(.semibold))
                .foregroundStyle(countdownResult.isFuture ? .blue : .pink)
                .animation(.easeInOut, value: countdownResult)

            Label {
                Text("目标日期：\(dateFormatter.string(from: targetDate))")
            } icon: {
                Image(systemName: "calendar")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            if includeToday {
                Text("提示：勾选“计算时包含今天”会在计算差值时额外加上一天，方便用于倒计时。")
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct CountdownResult: Equatable {
    let dayOffset: Int

    var isFuture: Bool { dayOffset >= 0 }

    func localizedSummary(for eventName: String) -> String {
        let sanitizedName = eventName.trimmingCharacters(in: .whitespacesAndNewlines)
        let displayName = sanitizedName.isEmpty ? "XXXX" : sanitizedName
        switch dayOffset {
        case 0:
            return "今天就是\(displayName)！"
        case 1:
            return "距离\(displayName)还有 1 天。"
        case let offset where offset > 1:
            return "距离\(displayName)还有 \(offset) 天。"
        case -1:
            return "\(displayName)已经过去 1 天。"
        default:
            return "\(displayName)已经过去 \(-dayOffset) 天。"
        }
    }
}

enum CountdownCalculator {
    private static let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        return calendar
    }()

    static func calculateDays(from referenceDate: Date, to targetDate: Date, includeToday: Bool) -> CountdownResult {
        let start = calendar.startOfDay(for: referenceDate)
        let end = calendar.startOfDay(for: targetDate)
        var components = calendar.dateComponents([.day], from: start, to: end)
        if includeToday, let currentValue = components.day {
            components.day = currentValue >= 0 ? currentValue + 1 : currentValue - 1
        }

        let dayOffset = components.day ?? 0
        return CountdownResult(dayOffset: dayOffset)
    }
}

#Preview {
    ContentView()
}
