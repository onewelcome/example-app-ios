//
//  Widget.swift
//  Widget
//
//  Created by Łukasz Łabuński on 16/12/2020.
//  Copyright © 2020 Onegini. All rights reserved.
//

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
            if success {
                guard let profile = sharedUserClient().userProfiles.first else {
                    let entries = [
                        SimpleEntry(date: Date(), implicitData: "User not registered")
                        ]
                    let timeline = Timeline(entries: entries, policy: .atEnd)
                    completion(timeline)
                    return
                }
                ResourceGateway().fetchImplicitResources(profile: profile) { data in
                    let entries = [
                        SimpleEntry(date: Date(), implicitData: data ?? "Data not found")
                        ]
                    let timeline = Timeline(entries: entries, policy: .atEnd)
                    completion(timeline)
                }
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
    
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            Image("light-gray-wallpaper-texture")
                .resizable()
                .scaledToFill()
            switch family {
            case .systemMedium:
                MediumImplicitDataView(entry.implicitData)
                
            default:
                SmallImplicitDataView(entry.implicitData)
            }
        }
    }
}

@main
struct Widget: SwiftUI.Widget {
    let kind: String = "Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget with fetching implicit resources.")
    }
}

struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEntryView(entry: SimpleEntry(date: Date(), implicitData: "Data not found."))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
