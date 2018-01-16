//
//  ViewController.swift
//  AR-Dicee
//
//  Created by R. Kukuh on 16/01/18.
//  Copyright © 2018 R. Kukuh. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        //createPlanetObject()
        
        createDiceObject()
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        //sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        print("AR Orientation is supported? \(AROrientationTrackingConfiguration.isSupported)")
        print("AR World Tracking is supported? \(ARWorldTrackingConfiguration.isSupported)")
        print("AR Face Tracking is supported? \(ARFaceTrackingConfiguration.isSupported)")

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func createPlanetObject() {
        
        let sunObject = SCNSphere(radius: 0.5)
        let earthObject = SCNSphere(radius: 0.2)
        let moonObject = SCNSphere(radius: 0.1)
        
        let sunMaterial = SCNMaterial()
        let earthMaterial = SCNMaterial()
        let moonMaterial = SCNMaterial()
        
        sunMaterial.diffuse.contents = UIImage(named: "art.scnassets/planet/sun-texture-2k.jpg")
        earthMaterial.diffuse.contents = UIImage(named: "art.scnassets/planet/earth-texture-2k.jpg")
        moonMaterial.diffuse.contents = UIImage(named: "art.scnassets/planet/moon-texture-2k.jpg")
        
        sunObject.materials = [sunMaterial]
        earthObject.materials = [earthMaterial]
        moonObject.materials = [moonMaterial]
        
        let sunNode = SCNNode()
        let earthNode = SCNNode()
        let moonNode = SCNNode()
        
        sunNode.position = SCNVector3(x: 0, y: 0.5, z: -2)
        earthNode.position = SCNVector3(x: 0.5, y: 0.3, z: -1)
        moonNode.position = SCNVector3(x: 0.7, y: 0.1, z: -0.5)
        
        sunNode.geometry = sunObject
        earthNode.geometry = earthObject
        moonNode.geometry = moonObject
        
        sceneView.scene.rootNode.addChildNode(sunNode)
        sceneView.scene.rootNode.addChildNode(earthNode)
        sceneView.scene.rootNode.addChildNode(moonNode)
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    func createDiceObject() {
        
        let diceScene = SCNScene(named: "art.scnassets/dice/diceCollada.scn")!
        
        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
            
            diceNode.position = SCNVector3(x: 0, y: 0, z: 0.1)
            
            sceneView.scene.rootNode.addChildNode(diceNode)
        }
        
        sceneView.autoenablesDefaultLighting = true
    }
}
