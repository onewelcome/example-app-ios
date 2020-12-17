//  Copyright © 2020 Onegini. All rights reserved.

import SwiftUI
import WidgetKit

struct MediumImplicitDataView: View {
    var implicitData: String

    init(_ implicitData: String) {
        self.implicitData = implicitData
    }

    var body: some View {
        HStack {
            Image("Image 1")
                .resizable()
                .frame(width: 60, height: 41, alignment: .leading)
                .aspectRatio(contentMode: .fit)
            VStack(alignment: .leading) {
                Text("Implicit data")
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
                Text(implicitData)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }.padding()
        }.padding()
    }
}

struct MediumImplicitDataView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MediumImplicitDataView("Implicit data")
                .previewLayout(.fixed(width: 160, height: 160))
        }
    }
}
