
import UIKit

internal class MarkingsView: UIView {

    // Margin from the border of the clock.
    internal var borderSpacing: CGFloat = 20 { didSet { setNeedsDisplay() } }
    
    // Length in points of the hour markings.
    internal var hourMarkingLength: CGFloat = 20 { didSet { setNeedsDisplay() } }
    internal var hourMarkingThickness: CGFloat = 1 { didSet { setNeedsDisplay() } }
    internal var hourMarkingColor: UIColor = UIColor.black { didSet { setNeedsDisplay() } }
    
    // Length in points of the minute markings.
    internal var minuteMarkingLength: CGFloat = 10 { didSet { setNeedsDisplay() } }
    internal var minuteMarkingThickness: CGFloat = 1 { didSet { setNeedsDisplay() } }
    internal var minuteMarkingColor: UIColor = UIColor.black { didSet { setNeedsDisplay() } }
    
    internal var shouldDrawHourMarkings: Bool = true { didSet { setNeedsDisplay() } }
    internal var shouldDrawMinuteMarkings: Bool = true { didSet { setNeedsDisplay() } }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }
    
    
    override internal func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context!.clear(rect)
        context!.setAllowsAntialiasing(true)
        context!.setShouldAntialias(true)
        context!.saveGState()
        
        // Get the size of the clock (a square at the center of the rect)
        let size = min(rect.size.width, rect.size.height)
        let lineLength = size/2 - borderSpacing
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        // Draw 12 hour marks
        let hourOffsetAngle: CGFloat = CGFloat(M_PI/6.0)
        let hourPath = CGMutablePath()
        //CGPathMoveToPoint(hourPath, nil, center.x, center.y)
        hourPath.move(to: CGPoint(x: center.x, y: center.y))
        for i in 0..<12 {
            let x = center.x + lineLength * sin(CGFloat(i) * hourOffsetAngle)
            let y = center.y - lineLength * cos(CGFloat(i) * hourOffsetAngle)
//            CGPathAddLineToPoint(hourPath, nil, x, y)
            hourPath.addLine(to: CGPoint(x: x, y: y))
//            CGPathMoveToPoint(hourPath, nil, center.x, center.y)
            hourPath.move(to: CGPoint(x: center.x, y: center.y))
            
        }
        
        // Clip for hours
        let hoursMaskRadius = lineLength - hourMarkingLength
        context!.beginPath()
        context!.addRect(context!.boundingBoxOfClipPath)
        context!.addEllipse(in: CGRect(origin: CGPoint(x: center.x - hoursMaskRadius, y: center.y - hoursMaskRadius), size: CGSize(width: hoursMaskRadius*2, height: hoursMaskRadius*2)))
//        CGContextEOClip(context)
        context?.clip(using: .evenOdd)
        
        // Draw hour markings
        if shouldDrawHourMarkings {
            hourMarkingColor.set()
            context!.setLineWidth(hourMarkingThickness)
            context!.addPath(hourPath)
            context!.strokePath()
        }
        context!.restoreGState()
        
        context!.saveGState()
        
        let minuteOffsetAngle: CGFloat = CGFloat(M_PI/30.0)
        let minutePath = CGMutablePath()
//        CGPathMoveToPoint(minutePath, nil, center.x, center.y)
        minutePath.move(to: CGPoint(x: center.x, y: center.y))
        for i in 0...61 {
            if (i % 5 != 0) { // Minutes markings do not overlap hours markings
                let x = center.x + lineLength * sin(CGFloat(i) * minuteOffsetAngle)
                let y = center.y - lineLength * cos(CGFloat(i) * minuteOffsetAngle)
//                CGPathAddLineToPoint(minutePath, nil, x, y)
                minutePath.addLine(to: CGPoint(x: x, y: y))
//                CGPathMoveToPoint(minutePath, nil, center.x, center.y)
                minutePath.move(to: CGPoint(x: center.x, y: center.y))
            }
        }
        
        
        // Clip for minutes
        let minutesMaskRadius = lineLength - minuteMarkingLength
        context!.beginPath()
        context!.addRect(context!.boundingBoxOfClipPath)
        context!.addEllipse(in: CGRect(origin: CGPoint(x: center.x - minutesMaskRadius, y: center.y - minutesMaskRadius), size: CGSize(width: minutesMaskRadius*2, height: minutesMaskRadius*2)))
//        CGContextEOClip(context)
        context?.clip(using: .evenOdd)

        // Draw minute markings
        if shouldDrawMinuteMarkings {
            minuteMarkingColor.set()
            context!.setLineWidth(minuteMarkingThickness)
            context!.addPath(minutePath)
            context!.strokePath()
        }
        context!.restoreGState()
        // ---------------
    }

}
