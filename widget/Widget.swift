//  Copyright © 2022 OneWelcome. All rights reserved.

import WidgetKit
import SwiftUI
import OneginiSDKiOS

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), implicitData: "Data not found.")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), implicitData: "Data not found.")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Startup().oneginiSDKStartup { success in
            guard success else {
                let entries = [SimpleEntry(date: Date(), implicitData: "Error")]
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
                return
            }
            guard let profile = SharedUserClient.instance.userProfiles.first else {
                let entries = [SimpleEntry(date: Date(), implicitData: "User not registered")]
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
                return
            }
            
            let errorMapper: (_ error: Error) -> AppError = { error in
                AppError(errorDescription: error.localizedDescription)
            }
            FetchImplicitDataInteractor(errorMapper: errorMapper).fetchImplicitResources(profile: profile) { userIdDecoded, error in
                var implicitData = "Data not found"
                if error == nil, let userIdDecoded = userIdDecoded {
                    implicitData = userIdDecoded
                }
                let entries = [SimpleEntry(date: Date(), implicitData: implicitData)]
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let implicitData: String
}

struct WidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            ImplicitDataView(entry.implicitData)
        }
    }
}

@main
struct Widget: SwiftUI.Widget {
    let kind = "Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget with fetching implicit resources.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEntryView(entry: SimpleEntry(date: Date(), implicitData: "Data not found"))
            .preferredColorScheme(.dark)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
