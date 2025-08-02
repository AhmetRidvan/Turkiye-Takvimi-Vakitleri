import WidgetKit
import SwiftUI

// 🔹 Namaz vakti için satır bileşeni (ikon + isim + saat)
struct PrayerTimeRow: View {
    var icon: String
    var name: String
    var time: String

    var body: some View {
        VStack(spacing: 2) {
            Text(icon)
                .font(.caption)
            Text(name)
                .font(.caption2)
            Text(time)
                .font(.caption2)
                .bold()
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
    }
}

// 🔸 Widget görünümünü boyuta göre ayarlayan ana bileşen
struct PrayerTimesEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            Color.red

            switch family {
            case .systemSmall:
                VStack(spacing: 6) {
                    PrayerTimeRow(icon: "🌙", name: "İmsak", time: entry.prayerTimes.imsak)
                    PrayerTimeRow(icon: "☀️", name: "Güneş", time: entry.prayerTimes.gunes)
                }

            case .systemMedium:
                VStack(spacing: 6) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 6) {
                        PrayerTimeRow(icon: "🌙", name: "İmsak", time: entry.prayerTimes.imsak)
                        PrayerTimeRow(icon: "☀️", name: "Güneş", time: entry.prayerTimes.gunes)
                        PrayerTimeRow(icon: "🌤", name: "Öğle", time: entry.prayerTimes.ogle)
                        PrayerTimeRow(icon: "🌇", name: "İkindi", time: entry.prayerTimes.ikindi)
                        PrayerTimeRow(icon: "🌌", name: "Akşam", time: entry.prayerTimes.aksam)
                        PrayerTimeRow(icon: "⏾", name: "Yatsı", time: entry.prayerTimes.yatsi)
                    }

                  
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

            default:
                Text("Bu widget boyutu desteklenmiyor.")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .padding(.vertical, 6)
    }
}

// 🚀 Giriş noktası – tek widget için sadece burada @main kullanılır
@main
struct PrayerTimesWidget: Widget {
    let kind: String = "PrayerTimesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PrayerTimesEntryView(entry: entry)
        }
        .configurationDisplayName("Türkiye Takvimi")
        .description("Namaz vakitlerini ve günlük bilgileri gösteren widget.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
