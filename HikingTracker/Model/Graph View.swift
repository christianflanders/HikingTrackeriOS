//
//  Graph View.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/19/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import Foundation
import UIKit

//func drawGraphLines(view: UIView){


//drawGraphLines(view: graphBackroundView)



class GraphView: UIView {
    
    let graphBackgroundColor = UIColor(red: 10/255, green: 42/255, blue: 53/255, alpha: 1)
    let graphGridColor = UIColor(red: 248/255, green: 238/255, blue: 180/255, alpha: 0.7)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        self.backgroundColor = graphBackgroundColor
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = drawLinesForGrid().cgPath
        shapeLayer.strokeColor = graphGridColor.cgColor
        shapeLayer.lineWidth = 0.5
        shapeLayer.position = CGPoint(x: 0, y: 0)
        self.layer.addSublayer(shapeLayer)
        
    }
    
    
    func drawLinesForGrid() -> UIBezierPath {
        let width = self.frame.width
        let height = self.frame.height
        let distanceToDrawLinesVertical: CGFloat = 100
        let distanceToDrawLinesHorizontal: CGFloat = 50
        
        let line = UIBezierPath()
        //Vertical Lines
        for i in stride(from: 0, to: width, by: distanceToDrawLinesVertical){
            line.move(to: CGPoint(x: i, y: 0))
            line.addLine(to: CGPoint(x: i, y: height))
            let label = UILabel()
            label.text = String(describing: i)
            label.frame = CGRect(x: i + 5, y: height - 20, width: 20, height: 15)
            label.font = UIFont.boldSystemFont(ofSize: 8)
            label.textColor = UIColor.white
            label.backgroundColor = UIColor.clear
            self.addSubview(label)
            
        }
        //Create labels for horizontal lines because iOS is dumb and draws from the top left. 🙃
        
        // Horizontal Lines
        for i in stride(from: 0, to: height, by: distanceToDrawLinesHorizontal){
            line.move(to: CGPoint(x: 0, y: i))
            line.addLine(to: CGPoint(x: width, y: i))
            let label = UILabel()
            label.text = String(describing: i)
            label.frame = CGRect(x: 20, y: i, width: 20, height: 15)
            label.font = UIFont.boldSystemFont(ofSize: 8)
            label.textColor = UIColor.white
            label.backgroundColor = UIColor.clear
            self.addSubview(label)
        }
        return line
        
    }
    
    
    
    func graphData(_ dataToGraph: [Double]) {
        
        let path = UIBezierPath()
        let adjustedY = self.frame.height
        let graphPointDistance: CGFloat = self.frame.width / CGFloat(dataToGraph.count)
        var currentPointYLocation: CGFloat = 0
        //move to our start point
        path.move(to: CGPoint(x: 0, y: adjustedY))
        //Draw the plots
        for point in dataToGraph {
            //Gotta subtract the Y cause ios draws from the top left
            let pointToCGFloat = CGFloat(point)
            path.addLine(to: CGPoint(x: currentPointYLocation, y: adjustedY - pointToCGFloat))
            currentPointYLocation += graphPointDistance
        }
        path.addLine(to: CGPoint(x: self.frame.width, y: 0 ))
        let lineLayer = CAShapeLayer()
        lineLayer.path = path.cgPath
        lineLayer.strokeColor = UIColor.green.cgColor
        lineLayer.fillColor = UIColor.clear.cgColor
        
        lineLayer.lineWidth = 1
        lineLayer.position = CGPoint(x: 0, y: 0)
        self.layer.addSublayer(lineLayer)
    }
    
}




