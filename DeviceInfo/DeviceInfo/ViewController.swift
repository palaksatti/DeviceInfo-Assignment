//
//  ViewController.swift
//  DeviceInfo
//
//  Created by Palak Satti on 01/03/24.
//

import UIKit
import Metal

class ViewController: UIViewController {

    let infoLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemIndigo
        configureUI()
        getDeviceInformation()
        getGPUInfo()
    }

    func configureUI() {
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .left
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.backgroundColor = .systemIndigo
        infoLabel.textColor = .white
        infoLabel.font = UIFont(name: "Verdana", size: 22)
        view.addSubview(infoLabel)

        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            infoLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }

    func getDeviceInformation() {
        var infoText = ""

        let device = UIDevice.current

        // Model Name & Model Number
        infoText += "Model Name: \(device.model)\n"
        infoText += "Model Number: \(device.localizedModel)\n"

        // iOS Version
        infoText += "iOS Version: \(device.systemVersion)\n"

        // Storage
        if let totalSpace = getTotalDiskSpace(), let freeSpace = getFreeDiskSpace() {
            infoText += "Total Space: \(totalSpace) GB\n"
            infoText += "Free Space: \(freeSpace) GB\n"
        }

        // Serial Number (Identifier for Vendor)
        if let serialNumber = getSerialNumber() {
            infoText += "Serial Number: \(serialNumber)"
        }

        infoLabel.text = infoText
    }

    // GPU Information
    func getGPUInfo() {
        let device = MTLCreateSystemDefaultDevice()

        if let device = device {
            var infoText = infoLabel.text ?? ""

            let name = device.name
            infoText += "\nGPU Name: \(name)\n"

            infoLabel.text = infoText
        } else {
            print("Metal is not supported on this device.")
        }
    }

    // Helper functions

    func getSerialNumber() -> String? {
        var serialNumber: String?

        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            serialNumber = uuid
        }
        return serialNumber
    }

    func getTotalDiskSpace() -> Double? {
        if let totalSpace = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())[.systemSize] as? NSNumber {
            let val = totalSpace.doubleValue / (1024 * 1024 * 1024)
            let formattedVal = Double(String(format: "%.2f", val))
            return formattedVal
        }
        return nil
    }

    func getFreeDiskSpace() -> Double? {
        if let freeSpace = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())[.systemFreeSize] as? NSNumber {
            let val = freeSpace.doubleValue / (1024 * 1024 * 1024)
            let formattedVal = Double(String(format: "%.2f", val))
            return formattedVal
        }
        return nil
    }

}
