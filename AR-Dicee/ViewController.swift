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
    
    var dices = [SCNNode]()

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        sceneView.delegate = self
        
        //createPlanets()
        
        sceneView.showsStatistics = true
        
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        //sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        // DEBUG
        //print("AR Orientation is supported? \(AROrientationTrackingConfiguration.isSupported)")
        //print("AR World Tracking is supported? \(ARWorldTrackingConfiguration.isSupported)")
        //print("AR Face Tracking is supported? \(ARFaceTrackingConfiguration.isSupported)")
        
        configuration.planeDetection = .horizontal

        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate Delegate Methods
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        
        let planNode = createPlane(with: planeAnchor)
        
        node.addChildNode(planNode)
    }
    
    // MARK: - Dice Methods
    
    func createDice(atLocation location : ARHitTestResult) {
        
        let diceScene = SCNScene(named: "art.scnassets/dice/diceCollada.scn")!
        
        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
            
            diceNode.position = SCNVector3(
                x: location.worldTransform.columns.3.x,
                y: location.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                z: location.worldTransform.columns.3.z
            )
            
            dices.append(diceNode)
            
            sceneView.scene.rootNode.addChildNode(diceNode)
            
            roll(diceNode)
        }
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResult = results.first {
                
                createDice(atLocation: hitResult)
            }
        }
    }
    
    func roll(_ dice : SCNNode) {
        
        let randomX = Float(arc4random_uniform(4) + 1) * (Float.pi / 2)
        let randomZ = Float(arc4random_uniform(4) + 1) * (Float.pi / 2)
        
        dice.runAction(
            SCNAction.rotateBy(
                x: CGFloat(randomX * 5),
                y: 0,
                z: CGFloat(randomZ * 5),
                duration: 0.5
            )
        )
    }
    
    func rollAll() {
        if !dices.isEmpty {
            for dice in dices {
                roll(dice)
            }
        }
    }
    
    @IBAction func rollDicesAgain(_ sender: UIBarButtonItem) {
        rollAll()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        rollAll()
    }
    
    @IBAction func removeAllDices(_ sender: UIBarButtonItem) {
        
        if !dices.isEmpty {
            for dice in dices {
                dice.removeFromParentNode()
            }
        }
    }
    
    // MARK: - Helpers
    
    func createPlane(with planeAnchor : ARPlaneAnchor) -> SCNNode {
        
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        
        let planNode = SCNNode()
        
        planNode.position  = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
        planNode.transform = SCNMatrix4MakeRotation(-(Float.pi/2), 1, 0, 0)
        
        let gridMaterial = SCNMaterial()
        
        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        
        plane.materials = [gridMaterial]
        
        planNode.geometry = plane
        
        return planNode
    }
    
    // MARK: - Unused Codes
    
    func createPlanets() {
        
        let sunObject = SCNSphere(radius: 0.9)
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
        
        sunNode.position = SCNVector3(x: 0, y: 0, z: -2)
        earthNode.position = SCNVector3(x: 0.5, y: 0.4, z: -1)
        moonNode.position = SCNVector3(x: 0.6, y: 0.3, z: -0.5)
        
        sunNode.geometry = sunObject
        earthNode.geometry = earthObject
        moonNode.geometry = moonObject
        
        sceneView.scene.rootNode.addChildNode(sunNode)
        sceneView.scene.rootNode.addChildNode(earthNode)
        sceneView.scene.rootNode.addChildNode(moonNode)
        
        sceneView.autoenablesDefaultLighting = true
    }
}
