import CoreImage
import SwiftUI
import UIKit

class ContentViewModel: ObservableObject {
    @Published var frame: CGImage?
    @Published var error: Error?
    
    private let cameraManager = CameraManager.shared
    private let frameManager = FrameManager.shared
    
    init() {
        setupSubscriptions()
    }
    
    func setupSubscriptions() {
        frameManager.$current
            .receive(on: RunLoop.main)
            .compactMap { buffer in
                let cgImage = CGImage.create(from: buffer)
                return cgImage
            }
            .assign(to: &$frame)
        
        cameraManager.$error
            .receive(on: RunLoop.main)
            .map { $0 }
            .assign(to: &$error)
    }

    var photo: CGImage? {
        if let frame = frame {
            return frame
        }
//        else if Config.isSimulator {
//            return UIImage(named: "AppIcon")?.cgImage
//        }
        return nil
    }
}
