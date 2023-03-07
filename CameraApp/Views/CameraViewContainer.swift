
import SwiftUI

struct CameraViewContainer: View {
    var body: some View {
        ZStack {
            Image("ic_avatar")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: .infinity, height: .infinity)
                .edgesIgnoringSafeArea(.all)
            camerView
        }
    }
    private var camerView: some View {
        EmptyView()
    }
   
}
struct CameraViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        CameraViewContainer()
    }
}
