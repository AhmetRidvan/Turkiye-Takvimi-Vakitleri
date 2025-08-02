import WidgetKit
import SwiftUI

// Namaz vakitleri için veri modeli
struct PrayerTimes {
    let imsak: String
    let sabah: String
    let gunes: String
    let ogle: String
    let ikindi: String
    let aksam: String
    let yatsi: String
  

    // App Group üzerinden UserDefaults’tan veri alma
    static func fromUserDefaults() -> PrayerTimes {
        let defaults = UserDefaults(suiteName: "group.turkiyeTakvimiWidget")
        return PrayerTimes(
            imsak: defaults?.string(forKey: "_imsak") ?? "—",
            sabah: defaults?.string(forKey: "_sabah") ?? "—",
            gunes: defaults?.string(forKey: "_gunes") ?? "—",
            ogle: defaults?.string(forKey: "_ogle") ?? "—",
            ikindi: defaults?.string(forKey: "_ikindi") ?? "—",
            aksam: defaults?.string(forKey: "_aksam") ?? "—",
            yatsi: defaults?.string(forKey: "_yatsi") ?? "—",
         
        )
    }
}

// Widget için zamanlamalı veri girişi
struct SimpleEntry: TimelineEntry {
    let date: Date
    let prayerTimes: PrayerTimes
}

// Widget’ın veri sağlayıcısı
struct Provider: TimelineProvider {
    typealias Entry = SimpleEntry

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), prayerTimes: PrayerTimes.fromUserDefaults())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), prayerTimes: PrayerTimes.fromUserDefaults())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        let prayerTimes = PrayerTimes.fromUserDefaults()

        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, prayerTimes: prayerTimes)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// Widget arayüzü
struct TurkiyeWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("🇹🇷 Türkiye Takvimi")
                .font(.headline)
                .bold()
                .foregroundColor(.red)

            VStack(alignment: .leading, spacing: 4) {
                Text("İmsak: \(entry.prayerTimes.imsak)")
                Text("Sabah: \(entry.prayerTimes.sabah)")
                Text("Güneş: \(entry.prayerTimes.gunes)")
                Text("Öğle: \(entry.prayerTimes.ogle)")
                Text("İkindi: \(entry.prayerTimes.ikindi)")
                Text("Akşam: \(entry.prayerTimes.aksam)")
                Text("Yatsı: \(entry.prayerTimes.yatsi)")
             
            }
            .font(.caption2)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

