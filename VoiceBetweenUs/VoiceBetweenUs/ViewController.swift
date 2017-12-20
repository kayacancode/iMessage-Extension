//
//  ViewController.swift
//  VoiceBetweenUs
//
//  Created by C on 9/10/17.
//  Copyright © 2017 C. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {
    
    @IBOutlet weak var introduceAnimateView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        introduceAnimateView.image = UIImage.animatedImage(withAnimatedGIFURL: Bundle.main.url(forResource: "introduce", withExtension: "gif"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

