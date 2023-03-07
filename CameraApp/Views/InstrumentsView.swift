
import SwiftUI

struct InstrumentsView: View {
    
    enum Sizing {
        static let rectangleHeight: CGFloat = 184
        static let cornerRadiusSize: CGFloat = 20.0
        static let rectangleHorizontalPadding: CGFloat = 24
        static let labelHeight: CGFloat = 17
        static let verticalPadding: CGFloat = 10
    }
    var body: some View {
            ZStack{
                Rectangle()
                    .fill(Color.white)
                    .frame(height: Sizing.rectangleHeight)
                    .cornerRadius(radius: Sizing.cornerRadiusSize, corners: [.topLeft, .topRight])
                    .padding(.horizontal, Sizing.rectangleHorizontalPadding)
                    
                VStack {
                    Text("OHJE")
                        .frame(height: Sizing.labelHeight)
                        .foregroundColor(.blue)
            
                    Text("• HYVÄ VALAISTUS")
                        .frame(height: Sizing.labelHeight)
                        .padding(.vertical, Sizing.verticalPadding)
                        .foregroundColor(.blue)
                    Text("• VAALEA TAUSTA")
                        .frame(height: Sizing.labelHeight)
                        .padding(.vertical, Sizing.verticalPadding)
                        .foregroundColor(.blue)
                    Text("• TARKENNA KASVOIHIN")
                        .frame(height: Sizing.labelHeight)
                        .foregroundColor(.blue)
                        .padding(.vertical, Sizing.verticalPadding)
                }
            }
        }
}

struct InstrumentsView_Previews: PreviewProvider {
    static var previews: some View {
        InstrumentsView()
    }
}
