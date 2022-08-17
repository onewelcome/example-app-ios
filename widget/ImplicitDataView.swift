//  Copyright © 2022 OneWelcome. All rights reserved.

import SwiftUI
import WidgetKit

struct ImplicitDataView: View {
    @Environment(\.widgetFamily) var family
    private var implicitData: String
    private var logoFamily: String {
        return family == .systemMedium ? "MediumLogo" : "SmallLogo"
    }

    init(_ implicitData: String) {
        self.implicitData = implicitData
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("User identifier")
                .foregroundColor(Color("Text"))
                .lineLimit(1)
                .minimumScaleFactor(0.4)
            Text("")
            Text(implicitData)
                .lineLimit(4)
                .font(.system(size: 10))
                .foregroundColor(Color("Text"))
            Spacer()
            HStack {
                Spacer()
                Image(logoFamily)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 25, alignment: .bottomTrailing)
            }
        }
        .padding()
    }
}

struct ImplicitDataView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ImplicitDataView("User identifier")
                .preferredColorScheme(.dark)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
