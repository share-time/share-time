//
//  QRScannerViewController.swift
//  share-time
//
//  Created by Godwin Pang on 5/15/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import AVFoundation
import Parse

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    let currentUser = PFUser.current()
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            searchStudyGroup(studyGroupName: stringValue)
        }
    }
    
    func searchStudyGroup(studyGroupName: String){
        
        var studyGroupToAdd: PFObject!
        
        let query = PFQuery(className: "StudyGroup")
        query.whereKey("name", equalTo: studyGroupName)
        query.findObjectsInBackground{ (findStudyGroup: [PFObject]?, error: Error?) -> Void in
            if findStudyGroup!.count > 0 {
                studyGroupToAdd = findStudyGroup![0]
                self.addStudyGroup(studyGroupToAdd: studyGroupToAdd)
            }
        }
    }
    
    func addStudyGroup(studyGroupToAdd: PFObject) {
        
        let studyGroupRelation = studyGroupToAdd.relation(forKey: "members")
        studyGroupRelation.add(currentUser!)
        
        let userRelation = currentUser?.relation(forKey: "studyGroups")
        userRelation?.add(studyGroupToAdd)
        
        studyGroupToAdd.saveInBackground{ (success: Bool, error: Error?) -> Void in
            if (success){
                self.currentUser?.saveInBackground{ (success: Bool, error: Error?) -> Void in
                    if (success){
                        if let navController = self.navigationController {
                            navController.popViewController(animated: true)
                            navController.popViewController(animated: true)
                            navController.parentPageboy?.scrollToPage(.at(index: 0), animated: true)
                        }
                    } else {
                        self.captureSession.startRunning()
                    }
                }
            } else {
                self.captureSession.startRunning()
            }
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
