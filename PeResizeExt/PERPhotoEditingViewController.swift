//
//  PERPhotoEditingViewController.swift
//  PeResizeExt
//
//  Created by temoki on 2015/03/06.
//  Copyright (c) 2015年 temoki. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class PERPhotoEditingViewController: UIViewController, PHContentEditingController {

    var input: PHContentEditingInput?

    @IBOutlet var imageView: UIImageView?
    @IBOutlet var bottomBar: UIView?
    @IBOutlet var scaleLabel: UILabel?
    @IBOutlet var upButton: UIButton?
    @IBOutlet var downButton: UIButton?

    let scaleValueArray: [Float] = [1/1, 1/2, 1/4, 1/8, 1/16];
    let scaleStringArray: [String] = ["1 / 1", "1 / 2", "1 / 4", "1 / 8", "1 / 16"];
    var scaleArrayIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomBar?.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
        scaleArrayIndex = 0
        self.scaleLabel?.text = scaleStringArray[scaleArrayIndex]
        self.upButton?.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onUpButtonTapped(sender: UIButton) {
        if (0 < scaleArrayIndex && scaleArrayIndex <= scaleStringArray.count - 1) {
            scaleArrayIndex--
            scaleLabel?.text = scaleStringArray[scaleArrayIndex]
            upButton?.enabled = scaleArrayIndex == 0 ? false : true
            downButton?.enabled = true
        }
    }

    @IBAction func onDownButtonTapped(sender: UIButton) {
        if (0 <= scaleArrayIndex && scaleArrayIndex < (scaleStringArray.count - 1)) {
            scaleArrayIndex++
            scaleLabel?.text = scaleStringArray[scaleArrayIndex]
            downButton?.enabled = scaleArrayIndex == (scaleStringArray.count - 1) ? false : true
            upButton?.enabled = true
        }
    }

    // MARK: - PHContentEditingController

    func canHandleAdjustmentData(adjustmentData: PHAdjustmentData?) -> Bool {
        // Inspect the adjustmentData to determine whether your extension can work with past edits.
        // (Typically, you use its formatIdentifier and formatVersion properties to do this.)
        return false
    }

    func startContentEditingWithInput(contentEditingInput: PHContentEditingInput?, placeholderImage: UIImage) {
        // Present content for editing, and keep the contentEditingInput for use when closing the edit session.
        // If you returned YES from canHandleAdjustmentData:, contentEditingInput has the original image and adjustment data.
        // If you returned NO, the contentEditingInput has past edits "baked in".
        input = contentEditingInput
        self.imageView?.image = input?.displaySizeImage
    }

    func finishContentEditingWithCompletionHandler(completionHandler: ((PHContentEditingOutput!) -> Void)!) {
        // Update UI to reflect that editing has finished and output is being rendered.
        
        // Render and provide output on a background queue.
        dispatch_async(dispatch_get_global_queue(CLong(DISPATCH_QUEUE_PRIORITY_DEFAULT), 0)) {
            // Create editing output from the editing input.
            let output = PHContentEditingOutput(contentEditingInput: self.input)
            
            // Provide new adjustments and render output to given location.
            // output.adjustmentData = <#new adjustment data#>
            // let renderedJPEGData = <#output JPEG#>
            // renderedJPEGData.writeToURL(output.renderedContentURL, atomically: true)
            
            // Call completion handler to commit edit to Photos.
            completionHandler?(output)
            
            // Clean up temporary files, etc.
        }
    }

    var shouldShowCancelConfirmation: Bool {
        // Determines whether a confirmation to discard changes should be shown to the user on cancel.
        // (Typically, this should be "true" if there are any unsaved changes.)
        return false
    }

    func cancelContentEditing() {
        // Clean up temporary files, etc.
        // May be called after finishContentEditingWithCompletionHandler: while you prepare output.
    }

}
