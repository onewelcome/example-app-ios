//  Copyright © 2020 Onegini. All rights reserved.

import SwiftUI
import WidgetKit

struct SmallImplicitDataView: View {
    var implicitData: String

    init(_ implicitData: String) {
        self.implicitData = implicitData
    }

    var body: some View {
        VStack {
            Image("OnewelcomeLogo")
                .resizable()
                .frame(width: 41, height: 41, alignment: .leading)
                .aspectRatio(contentMode: .fit)
            Text("Implicit data")
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.4)
            Text(implicitData)
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }.padding()
    }
}

struct SmallImplicitDataView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SmallImplicitDataView("Implicit data")
                .previewLayout(.fixed(width: 160, height: 160))
        }
    }
}
