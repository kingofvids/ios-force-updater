import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var updateButton: UIButton!
    
    private let updater = ForceUpdater.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        detectDevice()
    }
    
    private func setupUI() {
        updateButton.setTitle("Force Update to iOS 16", for: .normal)
        updateButton.addTarget(self, action: #selector(initiateUpdate), for: .touchUpInside)
        statusLabel.text = "Ready to update"
        progressView.progress = 0
    }
    
    private func detectDevice() {
        let deviceModel = UIDevice.current.model
        let systemVersion = UIDevice.current.systemVersion
        
        statusLabel.text = "Device: \(deviceModel) - iOS \(systemVersion)"
        
        // Check if device is compatible (iPhone 6s or 7)
        if !isCompatibleDevice() {
            updateButton.isEnabled = false
            statusLabel.text = "Unsupported device"
        }
    }
    
    private func isCompatibleDevice() -> Bool {
        let identifier = UIDevice.modelIdentifier()
        return identifier.contains("iPhone7,1") || identifier.contains("iPhone7,2") || 
               identifier.contains("iPhone8,1") || identifier.contains("iPhone8,2")
    }
    
    @objc private func initiateUpdate() {
        updateButton.isEnabled = false
        statusLabel.text = "Initializing update..."
        progressView.progress = 0.1
        
        DispatchQueue.global().async {
            let result = self.updater.forceUpdateToiOS16()
            
            DispatchQueue.main.async {
                self.progressView.progress = 1.0
                
                switch result {
                case .success(let message):
                    self.statusLabel.text = message
                    self.showAlert(title: "Success", message: message)
                case .failure(let error):
                    self.statusLabel.text = "Update failed: \(error)"
                    self.showAlert(title: "Error", message: "Update failed: \(error)")
                    self.updateButton.isEnabled = true
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension UIDevice {
    static func modelIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
