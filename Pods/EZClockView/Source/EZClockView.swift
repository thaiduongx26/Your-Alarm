

import UIKit

@IBDesignable
public class EZClockView: UIView {
    
    // MARK: - Properties
    private var faceView: UIView = UIView()
    private var centerView: UIView = UIView()
    private var handHours: UIView = UIView()
    private var handMinutes: UIView = UIView()
    private var handSeconds: UIView = UIView()
    private var markingsView: MarkingsView = MarkingsView(frame: CGRect.zero)
    
    
    
    private var hourProperty: Int = 0
    private var minuteProperty: Int = 0
    private var secondProperty: Int = 0

    // MARK: animation
    /// Set the animation duration (the view is animated when calling the setTime methods)
    public var animationDuration: TimeInterval = 0.3
    
    // MARK: Time
    /// Set this property to change the hour hand position.
    @IBInspectable public var hours: Int {
        get {
            return hourProperty
        }
        set {
            hourProperty = newValue
            updateHands()
        }
    }
    /// Set this property to change the minutes hand position.
    @IBInspectable public var minutes: Int {
        get {
            return minuteProperty
        }
        set {
            minuteProperty = newValue
            updateHands()
        }
    }
    /// Set this property to change the seconds hand position.
    @IBInspectable public var seconds: Int {
        get {
            return secondProperty
        }
        set {
            secondProperty = newValue
            updateHands()
        }
    }
    
    // MARK: Face
    /// Defines the background color of the face. Defaults to white.
    @IBInspectable public var faceBackgroundColor: UIColor = UIColor.white { didSet { faceView.backgroundColor = faceBackgroundColor } }
    /// Defines the border color of the face. Defaults to black.
    @IBInspectable public var faceBorderColor: UIColor = UIColor.black
    /// Defines the border width of the face. Defaults to 2.
    @IBInspectable public var faceBorderWidth: CGFloat = 2.0
    
    // MARK: Center disc
    /// Defines the color of the rounded part in the middle of the face, over the needles. Default is red.
    @IBInspectable public var centerColor: UIColor = UIColor.red { didSet { centerView.backgroundColor = centerColor } }
    /// Desfines the width of the center circle. Default is 3.0.
    @IBInspectable public var centerRadius: CGFloat = 3.0 { didSet { setupCenterView() } }
    /// Defines the width for the border of this center part. Default is 1.0.
    @IBInspectable public var centerBorderWidth: CGFloat = 1.0 { didSet { centerView.layer.borderWidth = centerBorderWidth } }
    /// Defines the color for the border of this center part. Default is red.
    @IBInspectable public var centerBorderColor: UIColor = UIColor.red { didSet { centerView.layer.borderColor = centerBorderColor.cgColor } }
    
    // MARK: Hour hand
    /// Defines the color for the hours hand. Default to black.
    @IBInspectable public var hoursColor: UIColor = UIColor.black { didSet { handHours.backgroundColor = hoursColor } }
    /// Defines the length of the hours hand. It is represented as a ratio of the radius of the face. Default to 0.5.
    @IBInspectable public var hoursLength: CGFloat = 0.5 {
        didSet { setupHand(hand: handHours, lengthRatio: hoursLength, thickness: hoursThickness, offset: hoursOffset) }
    }
    /// Defines the thickness of the hours hand. Default is 4.
    @IBInspectable public var hoursThickness: CGFloat = 4 {
        didSet { setupHand(hand: handHours, lengthRatio: hoursLength, thickness: hoursThickness, offset: hoursOffset) }
    }
    /// Defines the distance by which the hours hand will overlap over the center of the face. Default is 2.
    @IBInspectable public var hoursOffset: CGFloat = 2 {
        didSet { setupHand(hand: handHours, lengthRatio: hoursLength, thickness: hoursThickness, offset: hoursOffset) }
    }
    
    // MARK: Minute hand
    /// Defines the color for the minutes hand. Default to black.
    @IBInspectable public var minutesColor: UIColor = UIColor.black { didSet { handMinutes.backgroundColor = minutesColor } }
    /// Defines the length of the minutes hand. It is represented as a ratio of the radius of the face. Default to 0.7.
    @IBInspectable public var minutesLength: CGFloat = 0.7 {
        didSet { setupHand(hand: handMinutes, lengthRatio: minutesLength, thickness: minutesThickness, offset: minutesOffset) }
    }
    /// Defines the thickness of the minutes hand. Default is 2.
    @IBInspectable public var minutesThickness: CGFloat = 2 {
        didSet { setupHand(hand: handMinutes, lengthRatio: minutesLength, thickness: minutesThickness, offset: minutesOffset) }
    }
    /// Defines the distance by which the minutes hand will overlap over the center of the face. Default is 2.
    @IBInspectable public var minutesOffset: CGFloat = 2 {
        didSet { setupHand(hand: handMinutes, lengthRatio: minutesLength, thickness: minutesThickness, offset: minutesOffset) }
    }
    
    // MARK: Second hand
    /// Defines the color for the seconds hand. Default to red.
    @IBInspectable public var secondsColor: UIColor = UIColor.red { didSet { handSeconds.backgroundColor = secondsColor } }
    /// Defines the length of the seconds hand. It is represented as a ratio of the radius of the face. Default to 0.8.
    @IBInspectable public var secondsLength: CGFloat = 0.8 {
        didSet { setupHand(hand: handSeconds, lengthRatio: secondsLength, thickness: secondsThickness, offset: secondsOffset) }
    }
    /// Defines the thickness of the seconds hand. Default is 1.
    @IBInspectable public var secondsThickness: CGFloat = 1 {
        didSet { setupHand(hand: handSeconds, lengthRatio: secondsLength, thickness: secondsThickness, offset: secondsOffset) }
    }
    /// Defines the distance by which the seconds hand will overlap over the center of the face. Default is 2.
    @IBInspectable public var secondsOffset: CGFloat = 2 {
        didSet { setupHand(hand: handSeconds, lengthRatio: secondsLength, thickness: secondsThickness, offset: secondsOffset) }
    }
    
    // MARK: Markings
    // Margin from the border of the clock.
    @IBInspectable public var markingBorderSpacing: CGFloat = 20 { didSet { markingsView.borderSpacing = markingBorderSpacing } }
    
    // Length in points of the hour markings.
    @IBInspectable public var markingHourLength: CGFloat = 20 { didSet { markingsView.hourMarkingLength = markingHourLength } }
    @IBInspectable public var markingHourThickness: CGFloat = 1 { didSet { markingsView.hourMarkingThickness = markingHourThickness } }
    @IBInspectable public var markingHourColor: UIColor = UIColor.black { didSet { markingsView.hourMarkingColor = markingHourColor } }
    
    // Length in points of the minute markings.
    @IBInspectable public var markingMinuteLength: CGFloat = 10 { didSet { markingsView.minuteMarkingLength = markingMinuteLength } }
    @IBInspectable public var markingMinuteThickness: CGFloat = 1 { didSet { markingsView.minuteMarkingThickness = markingMinuteThickness } }
    @IBInspectable public var markingMinuteColor: UIColor = UIColor.black { didSet { markingsView.minuteMarkingColor = markingMinuteColor } }
    
    @IBInspectable public var shouldDrawHourMarkings: Bool = true { didSet { markingsView.shouldDrawHourMarkings = shouldDrawHourMarkings } }
    @IBInspectable public var shouldDrawMinuteMarkings: Bool = true { didSet { markingsView.shouldDrawMinuteMarkings = shouldDrawMinuteMarkings } }
    
    // MARK: - Public methods
    /**
    Set the time the clock will display. You can animate it or not.
    
    - parameter h: The hour to set
    - parameter m: The minute to set
    - parameter s: The second to set
    - parameter animated: Whether or not the change should be animated (default to false).
    */
    public func setTime(h h: Int, m: Int, s: Int, animated: Bool = false) {
        hourProperty = h
        minuteProperty = m
        secondProperty = s
        updateHands(animated: animated)
    }
    
    /**
    Set the time the clock will display directly by using an NSDate instance.
    
    - parameter date: The date to display. Only hours, minutes, and seconds, will be taken into account.
    - parameter animated: Whether or not the change should be animated (default to false).
    */
    public func setTime(date: Date, animated: Bool = false) {
        var calendar = Calendar.current
        print(calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date as Date))
        let unitFlags = Set<Calendar.Component>([.hour, .year, .minute])
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let components = calendar.dateComponents(unitFlags, from: date as Date)
        hourProperty = calendar.component(.hour, from: date)
        minuteProperty = calendar.component(.minute, from: date)
        secondProperty = calendar.component(.second, from: date)
        print("\(hourProperty):\(minuteProperty):\(secondProperty)")
        updateHands(animated: animated)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let clockRadius = min(self.bounds.size.width, self.bounds.size.height)
        
        // Reset all transforms
        setupHand(hand: handHours, lengthRatio: hoursLength, thickness: hoursThickness, offset: hoursOffset)
        setupHand(hand: handMinutes, lengthRatio: minutesLength, thickness: minutesThickness, offset: minutesOffset)
        setupHand(hand: handSeconds, lengthRatio: secondsLength, thickness: secondsThickness, offset: secondsOffset)
        
        setupCenterView()
        
        handHours.backgroundColor = hoursColor
        handMinutes.backgroundColor = minutesColor
        handSeconds.backgroundColor = secondsColor
        
        faceView.frame.size = CGSize(width: clockRadius, height: clockRadius)
        faceView.center = CGPoint(x:self.bounds.midX, y:self.bounds.midY)
        faceView.layer.cornerRadius = clockRadius/2.0
        faceView.backgroundColor = faceBackgroundColor
        faceView.layer.borderWidth = faceBorderWidth
        faceView.layer.borderColor = faceBorderColor.cgColor
        
        markingsView.frame = faceView.frame
        let date = Date()
        setTime(h: hours, m: minutes, s: seconds)
//        setTime(date: date, animated: true)
        
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        if (faceView.superview == nil) {
            self.backgroundColor = UIColor.clear
            self.addSubview(faceView)
            self.addSubview(handHours)
            self.addSubview(handMinutes)
            self.addSubview(handSeconds)
            self.addSubview(centerView)
            
            self.addSubview(markingsView)
        }
    }
    
    // MARK: - Private methods
    private func setupHand(hand: UIView, lengthRatio: CGFloat, thickness: CGFloat, offset: CGFloat) {
        hand.transform = CGAffineTransform.identity
        hand.layer.allowsEdgeAntialiasing = true
        
        let clockRadius = min(self.bounds.size.width, self.bounds.size.height)
        let handLength = (clockRadius/2.0) * CGFloat(lengthRatio)
        
        let anchorX: CGFloat = 0.5
        let anchorY: CGFloat = 1.0 - (offset/handLength)
        hand.layer.anchorPoint = CGPoint(x: anchorX, y: anchorY)
        
        let centerInParent = CGPoint(x:self.bounds.midX,y: self.bounds.midY)
        hand.frame = CGRect(x:centerInParent.x-(thickness/2), y:centerInParent.y - handLength + offset, width:thickness, height :handLength)

        // Replace the hand at appropriate position
        updateHands()
    }
    
    private func setupCenterView() {
        centerView.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: centerRadius*2, height: centerRadius*2))
        centerView.center = CGPoint(x:self.bounds.midX, y:self.bounds.midY)
        centerView.layer.cornerRadius = centerRadius
        centerView.backgroundColor = centerColor
        centerView.layer.borderColor = centerBorderColor.cgColor
        centerView.layer.borderWidth = centerBorderWidth
    }
    
    private func updateHands(animated: Bool = false) {
        // Put everything in seconds to have ratios
        let hoursInSeconds = (hours%12)*3600
        let minutesInSeconds = (minutes%60)*60
        let secondsInSeconds = (seconds%60)
        let hoursRatio = CGFloat(hoursInSeconds + minutesInSeconds + secondsInSeconds) / 43200.0
        let minutesRatio = CGFloat(minutesInSeconds + secondsInSeconds) / 3600.0
        let secondsRatio = CGFloat(secondsInSeconds) / 60.0
        
        if (animated) {
            UIView.animate(withDuration: animationDuration) {
                self.handSeconds.transform = CGAffineTransform(rotationAngle: CGFloat(2*M_PI)*secondsRatio)
                self.handMinutes.transform = CGAffineTransform(rotationAngle: CGFloat(2*M_PI)*minutesRatio)
                self.handHours.transform = CGAffineTransform(rotationAngle: CGFloat(2*M_PI)*hoursRatio)
            }
        } else {
            handSeconds.transform = CGAffineTransform(rotationAngle: CGFloat(2*M_PI)*secondsRatio)
            handMinutes.transform = CGAffineTransform(rotationAngle: CGFloat(2*M_PI)*minutesRatio)
            handHours.transform = CGAffineTransform(rotationAngle: CGFloat(2*M_PI)*hoursRatio)
        }
    }
}
