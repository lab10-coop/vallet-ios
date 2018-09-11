//
//  QRCodeReaderView.swift
//  Vallet
//
//  Created by Matija Kregar on 11/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit
import AVFoundation

protocol QRCodeReaderViewDelegate: class {

	func didReadQRCode(value: String)

}

class QRCodeReaderView: NibLinkedView, AVCaptureMetadataOutputObjectsDelegate {

	var captureSession: AVCaptureSession?
	weak var delegate: QRCodeReaderViewDelegate?

	override func setup() {
		clipsToBounds = true

		captureSession = AVCaptureSession()

		let metadataOutput = AVCaptureMetadataOutput()

		guard let captureSession = captureSession,
			let videoCaptureDevice = AVCaptureDevice.default(for: .video),
			let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
			captureSession.canAddInput(videoInput),
			captureSession.canAddOutput(metadataOutput)
			else {
				return
		}

		captureSession.addInput(videoInput)
		captureSession.addOutput(metadataOutput)

		metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
		metadataOutput.metadataObjectTypes = [.qr]

		let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		previewLayer.frame = layer.bounds
		previewLayer.videoGravity = .resizeAspectFill
		layer.addSublayer(previewLayer)

		captureSession.startRunning()
	}

	func startScanning() {
		captureSession?.startRunning()
	}

	func stopScanning() {
		captureSession?.stopRunning()
	}

	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		guard let metadataObject = metadataObjects.first,
			let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
			let stringValue = readableObject.stringValue
			else {
				return
		}

		captureSession?.stopRunning()

		delegate?.didReadQRCode(value: stringValue)
	}

}
