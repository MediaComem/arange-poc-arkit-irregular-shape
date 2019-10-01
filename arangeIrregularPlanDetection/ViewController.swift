//
//  ViewController.swift
//  arangeIrregularPlanDetection
//
//  Created by Adrien Bigler on 10.07.18.
//  Copyright © 2018 Adrien Bigler. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    private var planeGeometry: ARSCNPlaneGeometry!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let device = MTLCreateSystemDefaultDevice()!
        planeGeometry = ARSCNPlaneGeometry(device: device)!
        
        sceneView.delegate = self
        sceneView.scene = SCNScene()
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, SCNDebugOptions.showWireframe]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.vertical, .horizontal]
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("\(self.classForCoder)/" + #function + ", anchor id: \(anchor.identifier)")
        guard let planeAnchor = anchor as? ARPlaneAnchor else {fatalError()}
        planeGeometry.update(from: planeAnchor.geometry)
        planeGeometry.materials.first?.diffuse.contents = UIColor.green.withAlphaComponent(0.3)
        let planeNode = SCNNode(geometry: planeGeometry)
        node.addChildNode(planeNode)
        //        planeAnchor.addPlaneNode(on: node, geometry: planeGeometry, contents: UIColor.green.withAlphaComponent(0.3))
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {fatalError()}
        planeGeometry.update(from: planeAnchor.geometry)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        print("\(self.classForCoder)/" + #function)
    }
}
