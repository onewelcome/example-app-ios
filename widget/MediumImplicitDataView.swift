//  Copyright © 2020 OneWelcome. All rights reserved.

import SwiftUI
import WidgetKit

struct MediumImplicitDataView: View {
    var implicitData: String
    
    private let fontColor = Color(UIColor(named: "Text") ?? .black)
    
    init(_ implicitData: String) {
        self.implicitData = implicitData
    }

    var body: some View {
        HStack {
            Image("OnewelcomeLogo")
                .resizable()
                .frame(width: 41, height: 41, alignment: .leading)
                .aspectRatio(contentMode: .fit)
            VStack(alignment: .leading) {
                Text("User identifier")
                    .font(.headline)
                    .foregroundColor(fontColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
                Text(implicitData)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(fontColor)
            }.padding()
        }.padding()
    }
}

struct MediumImplicitDataView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MediumImplicitDataView("User identifier")
                .previewLayout(.fixed(width: 160, height: 160))
        }
    }
}
