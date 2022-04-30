//
//  SceneView+Button.swift
//  CardiacAR
//
//  Created by Alex Yang on 11/16/21.
//

import Foundation
import UIKit
import SceneKit
import ARKit
import Euclid

extension SceneViewController {
    
	
	@objc func enterSlicing(_sender: UIButton) {
		toolbar.currentMode="slicing"
		// remove model view gestures
		sceneView.removeGestureRecognizer(self.modelViewPanGestureRecognizer)
		sceneView.removeGestureRecognizer(self.modelViewPinchGestureRecognizer)
		
		// add slicing gestures
		sceneView.addGestureRecognizer(self.slicingPanGestureRecognizer)
		sceneView.addGestureRecognizer(self.slicingPinchGestureRecognizer)
		
		// show slicing button
		confirmSliceButton.isHidden = false
		revertSliceButton.isHidden = false
		// change slicing button color
//            toggleSlicingButton.setTitleColor(UIColor.systemRed, for: .normal)
		
		// addShaders to heart
		if self.heartNode != nil {
			updatePlaneEquation()
			addSlicingShaders(node: self.heartNode!)
		}
		
		// update current state
		self.currentToolState = ToolState.slicing
		
		// add plane to scene
		if self.heartNode != nil {
			self.planeNode?.opacity = 0.5
			updatePlaneEquation()
		}
	}
	
	@objc func enterPanning(_sender: UIButton) {
		toolbar.currentMode="panning"
		// remove slicing view gestures
		sceneView.removeGestureRecognizer(self.slicingPanGestureRecognizer)
		sceneView.removeGestureRecognizer(self.slicingPinchGestureRecognizer)
		
		// add model view gestures
		sceneView.addGestureRecognizer(self.modelViewPanGestureRecognizer)
		sceneView.addGestureRecognizer(self.modelViewPinchGestureRecognizer)
		
		// hide slicing button
		confirmSliceButton.isHidden = true
		revertSliceButton.isHidden = true
		// change slicing button color
//            toggleSlicingButton.setTitleColor(UIColor.systemBlue, for: .normal)
		
		// remove shaders as model isn't being sliced
		if self.heartNode != nil {
			// reset shaders
			self.heartNode!.geometry?.shaderModifiers!.removeValue(forKey: .surface)
		}
		
		// update current state
		self.currentToolState = ToolState.modelView
		
		// remove plane from sight in scene
		self.planeNode?.opacity = 0
	}
		
	
    
    @objc func resetSliceDown(_sender: UIButton) {
        if self.originalHeartNode != nil {
            replaceHeartNodeWith(node: self.originalHeartNode!)
        }
    }
    
    @objc func confirmSliceDown(_sender: UIButton) {
        if self.heartNode != nil && planeNode != nil {
            
            // convert heart to mesh
            let heart_mesh = Mesh.init(self.heartNode!.geometry!)!

            // inialize Euclid plane to have same rotation as plane equation
            let normal = Vector(Double(self.planeEquation.x), Double(self.planeEquation.y), Double(self.planeEquation.z))
            let point_on_plane = self.planeEquation.xyz * self.planeEquation.w
            let plane = Plane.init(normal: normal, pointOnPlane: Vector(Double(point_on_plane.x), Double(point_on_plane.y), Double(point_on_plane.z)))!
            
            // slice heart mesh according to plane
            let slice_material = SCNMaterial()
            slice_material.diffuse.contents = UIColor(white: 1, alpha: 0)
            slice_material.isDoubleSided = true
            
            let sliced_heart_mesh = heart_mesh.clip(to: plane.inverted(), fill: slice_material)
            
            // convert mesh to an SCNNode and replace the heartnode with the sliced node
            let temp_node = mesh2SCNNode(mesh: sliced_heart_mesh)
            replaceHeartNodeWith(node: temp_node)
        }
    }
	
	//TODO: Thread the objc2SCNNode function, it takes a bit to load object currently
    @objc func addDown(_sender: UIButton) {
        
//        openDocument()

        if heartNode == nil {
            if (SceneViewController.modelPath == nil) {
                openDocument()
            } else {
//                if (urls)
                heartNode = obj2SCNNodeURL(name: SceneViewController.modelPath!)!
                originalHeartNode = heartNode!.copy() as? SCNNode
                
                //create a light node attached to the camera
                sceneView.pointOfView!.addChildNode(self.createLightNode()!)
            }
        } else {
            heartNode?.opacity = 0.7
            heartNode?.position = SCNVector3(0, 0, -0.5)
            sceneView.pointOfView?.addChildNode(heartNode!)
        }
        
    }
        
    @objc func popUp(_sender: UIButton, pos: SCNVector3) {
        var popUpWindow: PopUpWindow!
        let text = "Point located at (\(pos.x), \(pos.y), \(pos.z))"
        popUpWindow = PopUpWindow(title: "Add Information", text: text, buttontext: "Close")
        self.present(popUpWindow, animated: true, completion: nil)
    }
    
    @objc func reAdd() {
        let newNode = obj2SCNNodeURL(name: SceneViewController.modelPath!)!
        
        replaceHeartNodeWith(node: newNode)
        
//        // Can't add material  because the obj doesn't have texture coordinates, need to figure out how to add
//        
//        originalHeartNode = heartNode!.copy() as? SCNNode
//        
//        //create a light node attached to the camera
//        sceneView.pointOfView!.addChildNode(self.createLightNode()!)
//        
//        heartNode?.opacity = 0.7
//        heartNode?.position = SCNVector3(0, 0, -0.5)
//    
//        sceneView.pointOfView?.addChildNode(heartNode!)
        
    }

    @objc func addUp(_sender: UIButton) {
        if heartNode != nil {
            placePlane()
            
            heartNode?.opacity = 1
            heartNode?.removeFromParentNode()
            
            placeNodeInFrontOfCamera(node:heartNode!)
            
            setFragmentShader(node: heartNode!)
               
            if self.currentToolState == ToolState.slicing {
                addSlicingShaders(node: heartNode!)
            }
                        
            sceneView.scene.rootNode.addChildNode(heartNode!)

        }
        
        _sender.setTitle(" Move", for: .normal)
    }
	
	
	
}


