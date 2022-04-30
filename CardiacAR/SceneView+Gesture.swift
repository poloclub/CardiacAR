//
//  SceneView+Gesture.swift
//  CardiacAR
//
//  Created by Alex Yang on 11/16/21.
//

import Foundation
import UIKit
import SceneKit

extension SceneViewController {
    
    @objc func modelViewPinchGesture(sender: UIPinchGestureRecognizer) {
        if heartNode != nil && self.planeNode != nil && sender.state == .changed {
            
            heartNode!.simdScale *= Float(sender.scale)
            planeNode!.simdScale *= Float(sender.scale)
            sender.scale = 1
        }
    }
    
    @objc func slicingPinchGesture(sender: UIPinchGestureRecognizer) {
        if self.planeNode != nil && sender.state == .changed {
            let pinchConstant:Float = 0.2
            
            self.planeNode!.simdWorldPosition += self.planeNormal * Float(sender.scale - 1) * pinchConstant
            sender.scale = 1
            
            self.updatePlaneEquation()
        }
    }
    
    @objc func modelViewPanGesture(sender: UIPanGestureRecognizer) {
        if heartNode != nil {
            if let currentFrame = sceneView.session.currentFrame {
                if sender.state == .began {
                    self.camera_rotation_pan_start = simd_quatf(currentFrame.camera.transform)
                    self.object_rotation_pan_start = heartNode!.simdOrientation
                }
                                    
                let translation = sender.translation(in: sender.view!)
                                
                let newAngleX = (Float)(translation.x)*(Float)(Double.pi)/180.0
                let newAngleY = (Float)(translation.y)*(Float)(Double.pi)/180.0
                
                // transform rotations into quaterions and multiply together
                let x_quat = simd_quatf(angle: newAngleX, axis: self.camera_rotation_pan_start.act(simd_float3(-1, 0, 0)))
                let y_quat = simd_quatf(angle: newAngleY, axis: self.camera_rotation_pan_start.act(simd_float3(0, 1, 0)))
                
                let rot = x_quat * y_quat
                
                heartNode!.simdOrientation = (rot * self.object_rotation_pan_start).normalized
            }
        }
    }
    
    @objc func slicingPanGesture(sender: UIPanGestureRecognizer) {
        if planeNode != nil {
            if let currentFrame = sceneView.session.currentFrame {
                if sender.state == .began {
                    self.camera_rotation_pan_start = simd_quatf(currentFrame.camera.transform)
                    self.object_rotation_pan_start = planeNode!.simdOrientation
                }
                                    
                let translation = sender.translation(in: sender.view!)
                                
                let newAngleX = (Float)(translation.x)*(Float)(Double.pi)/180.0
                let newAngleY = (Float)(translation.y)*(Float)(Double.pi)/180.0
                
                // transform rotations into quaterions and multiply together
                let x_quat = simd_quatf(angle: newAngleX, axis: self.camera_rotation_pan_start.act(simd_float3(-1, 0, 0)))
                let y_quat = simd_quatf(angle: newAngleY, axis: self.camera_rotation_pan_start.act(simd_float3(0, 1, 0)))
                
                let rot = x_quat * y_quat
                
                planeNode!.simdOrientation = (rot * self.object_rotation_pan_start).normalized
                
                self.updatePlaneEquation()
            }
        }
    }

	@objc func tapGesture(sender: UITapGestureRecognizer) {
		let tapPosition = sender.location(in: self.sceneView)
		let hitTestResults = self.sceneView.hitTest(tapPosition, options:nil)
        if (hitTestResults.count > 0) {
            for hitTestResult in Array(hitTestResults[0...0]){
                if (self.heartNode != nil && hitTestResult.node == self.heartNode) {
                    // retrieve LOCAL coordinates so spherePos is relative to hit node
                    let retHitPosition = hitTestResult.localCoordinates
//                    print("Touched Heart")
//                    print("Projected Location on heart: ", retHitPosition)
                    drawSphere(spherePos:retHitPosition, radius:1)
                    addedNodes.append(retHitPosition)
                    print(addedNodes)
                }
                
            }
        }
        
	}
	
	fileprivate func drawSphere(spherePos: SCNVector3, radius: CGFloat) {
		let sphere = SCNSphere(radius: radius)
		let sphereNode = SCNNode(geometry: sphere)
        
        
        let note = SCNText(string: "Text", extrusionDepth: 0.0)
        note.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        let noteNode = SCNNode(geometry: note)
		
		sphereNode.position = spherePos
		sphereNode.geometry?.firstMaterial?.specular.contents = UIColor.orange
		sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        
        noteNode.position = spherePos
        noteNode.geometry?.firstMaterial?.specular.contents = UIColor.yellow
        noteNode.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
        
        
		// sphereNode.geometry?.firstMaterial?.isDoubleSided = true
		self.heartNode?.addChildNode(sphereNode)
        // self.heartNode?.addChildNode(noteNode)
        
        let pseudo:UIButton = {
            let button = UIButton(type:.system)
            return button
        }()
        
        popUp(_sender: pseudo, pos: spherePos)

        
	}
}
