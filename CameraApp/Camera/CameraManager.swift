import Foundation
import AVFoundation
import VideoToolbox
import CoreGraphics

class CameraManager: ObservableObject {
    enum Status {
        case unconfigured
        case configured
        case unauthorized
        case failed
    }
    
    static let shared = CameraManager()
    
    private init() {
        if checkPermissions() {
            configure()
        }
    }
    
    @Published var error: CameraError?
    let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "co.humanz.opy2.cam")
    private let videoOutput = AVCaptureVideoDataOutput()
    private var status = Status.unconfigured {
        didSet {
            print("status = \(status)")
        }
    }
    
    var device: AVCaptureDevice? = nil
    
    private func set(error: CameraError?) {
        DispatchQueue.main.async {
            self.error = error
        }
    }
    
    func configure() {
        status = .unconfigured
        sessionQueue.async {
            self.configureCaptureSession()
            self.session.startRunning()
        }
    }
    
    func requestAccess(_ completion: @escaping ((Bool) -> Void)) {
        sessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: .video) {[weak self] authorized in
            guard let self = self else { return }
            if !authorized {
                self.status = .unauthorized
                self.set(error: .deniedAuthorization)
                completion(false)
            } else {
                self.configure()
                completion(true)
            }
            self.sessionQueue.resume()
        }
    }
    
    func checkPermissions() -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            self.status = .unauthorized
        case .restricted:
            status = .unauthorized
            set(error: .restrictedAuthorization)
        case .denied:
            status = .unauthorized
            set(error: .deniedAuthorization)
        case .authorized:
            return true
        @unknown default:
            status = .unauthorized
            set(error: .unknownAuthorization)
        }
        return false
    }
    
    private func configureCaptureSession() {
        guard status == .unconfigured else {
            return
        }
        session.beginConfiguration()
        defer {
            session.commitConfiguration()
        }
        let device = AVCaptureDevice.default(
            .builtInTripleCamera,
            for: .video,
            position: .back)
        guard let camera = device else {
            self.device = device
            set(error: .cameraUnavailable)
            status = .failed
            return
            
        }
        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            
            if session.canAddInput(cameraInput) {
                session.addInput(cameraInput)
            } else {
                
                set(error: .cannotAddInput)
                status = .failed
                return
            }
        } catch {
            
            set(error: .createCaptureInput(error))
            status = .failed
            return
        }
        
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
            videoOutput.videoSettings =
            [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            let videoConnection = videoOutput.connection(with: .video)
            videoConnection?.videoOrientation = .portrait
            
        } else {
            set(error: .cannotAddOutput)
            status = .failed
            return
        }
                
        status = .configured
    }
    
    func set(
        _ delegate: AVCaptureVideoDataOutputSampleBufferDelegate,
        queue: DispatchQueue
    ) {
        sessionQueue.async {
            self.videoOutput.setSampleBufferDelegate(delegate, queue: queue)
        }
    }
    
}

enum CameraError: Error {
    case cameraUnavailable
    case cannotAddInput
    case cannotAddOutput
    case createCaptureInput(Error)
    case deniedAuthorization
    case restrictedAuthorization
    case unknownAuthorization
}

extension CameraError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .cameraUnavailable:
            return "Camera unavailable"
        case .cannotAddInput:
            return "Cannot add capture input to session"
        case .cannotAddOutput:
            return "Cannot add video output to session"
        case .createCaptureInput(let error):
            return "Creating capture input for camera: \(error.localizedDescription)"
        case .deniedAuthorization:
            return "Camera access denied"
        case .restrictedAuthorization:
            return "Attempting to access a restricted capture device"
        case .unknownAuthorization:
            return "Unknown authorization status for capture device"
        }
    }
}

extension CGImage {
    static func create(from cvPixelBuffer: CVPixelBuffer?) -> CGImage? {
        guard let pixelBuffer = cvPixelBuffer else {
            return nil
        }
        
        var image: CGImage?
        VTCreateCGImageFromCVPixelBuffer(
            pixelBuffer,
            options: nil,
            imageOut: &image)
        return image
    }
}
