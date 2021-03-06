//
//  MessagesViewController.swift
//  VoiceBetweenUs Presented By Snatched
//
//  Created by C on 9/10/17.
//  Copyright © 2017 C. All rights reserved.
//

import UIKit
import Messages
import AVFoundation
import AudioToolbox

class MessagesViewController: MSMessagesAppViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    var previousContentOffset:CGFloat = 0.0
    var selectedItemIndex = 9999
    
    var player: AVAudioPlayer?
    
    @IBOutlet weak var mainHeaderView: UIView!
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var stickerCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configCollectionView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }
    
    func configCollectionView() {
        
        let cellNibName = UINib(nibName: "VideoCollectionViewCell", bundle: Bundle.main)
        stickerCollectionView.register(cellNibName, forCellWithReuseIdentifier: "VideoCollectionViewCell")
        
        stickerCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        stickerCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        stickerCollectionView.reloadData()
    }

    func thumbnailForVideoAtURL(_ url: URL) -> UIImage? {
        
        let asset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print("error")
            return nil
        }
    }
    
    func playSound(sender: UIButton) -> Void {
        
        guard let url = Bundle.main.url(forResource: "video\(sender.tag)", withExtension: "mp4") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func sendVideo(sender: UIButton) -> Void {
        
        requestPresentationStyle(.compact)

        let videoUrl = Bundle.main.url(forResource: "video\(sender.tag)", withExtension: "mp4")!
        if let conversation = self.activeConversation {
            conversation.insertAttachment(videoUrl, withAlternateFilename: "", completionHandler: nil)
        }
    }

    
    // MARK: -
    // MARK: - Sticker CollectionView DataSoruce & Delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as! VideoCollectionViewCell
        let videoUrl = Bundle.main.url(forResource: "video\(indexPath.row)", withExtension: "mp4")!
        cell.thumbnailView.image = thumbnailForVideoAtURL(videoUrl)
        cell.buttonContainer.layer.masksToBounds = true
        cell.buttonContainer.layer.cornerRadius = cell.buttonContainer.frame.size.height / 2
        
        if indexPath.row == selectedItemIndex {
            
            cell.opacityView.isHidden = false
            cell.buttonContainer.isHidden = false
            
            cell.buttonPlay.tag = indexPath.row
            cell.buttonUpload.tag = indexPath.row
            cell.buttonPlay.addTarget(self, action: #selector(playSound(sender:)), for: .touchUpInside)
            cell.buttonUpload.addTarget(self, action: #selector(sendVideo(sender:)), for: .touchUpInside)
        } else {
            
            cell.opacityView.isHidden = true
            cell.buttonContainer.isHidden = true
        }
        
        cell.layoutIfNeeded()
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width / 2, height: (collectionView.frame.size.width * 304) / (492 * 2))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        player?.stop()
        selectedItemIndex = indexPath.row
        collectionView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollOffset = scrollView.contentOffset.y
        let scrollDiff = scrollOffset - previousContentOffset
        let scrollHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom
        var headerViewFrame = mainHeaderView.frame
        
        if (scrollOffset <= -scrollView.contentInset.top) {
            headerViewFrame.origin.y = 0
        } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
            headerViewFrame.origin.y = -mainHeaderView.frame.size.height
        } else {
            headerViewFrame.origin.y = min(0, max(-mainHeaderView.frame.size.height, headerViewFrame.origin.y - scrollDiff))
        }
        
        mainHeaderView.frame = headerViewFrame
        
        headerTopConstraint.constant = mainHeaderView.frame.origin.y
        self.view.layoutIfNeeded()
        
        previousContentOffset = scrollView.contentOffset.y
        
    }

}
