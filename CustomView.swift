//
//  Pindropped
//
//  
//

import UIKit

@IBDesignable
class CustomView: UIView {
	
	var layers : Dictionary<String, AnyObject> = [:]
	var completionBlocks : Dictionary<CAAnimation, (Bool) -> Void> = [:]
	var updateLayerValueForCompletedAnimation : Bool = false
	
	var color : UIColor!
	
	//MARK: - Life Cycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupProperties()
		setupLayers()
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
		setupProperties()
		setupLayers()
	}
	
	
	
	func setupProperties(){
		self.color = UIColor(red:0.0192, green: 0.711, blue:0.426, alpha:1)
	}
	
	func setupLayers(){
		let shadow = CAShapeLayer()
		shadow.frame = CGRectMake(143, 290, 34, 13)
		shadow.path = shadowPath().CGPath;
		self.layer.addSublayer(shadow)
		layers["shadow"] = shadow
		
		let Trash = CAShapeLayer()
		Trash.frame = CGRectMake(139, 221, 41, 41)
		Trash.path = TrashPath().CGPath;
		self.layer.addSublayer(Trash)
		layers["Trash"] = Trash
		
		let Share = CAShapeLayer()
		Share.frame = CGRectMake(139, 221, 41, 41)
		Share.path = SharePath().CGPath;
		self.layer.addSublayer(Share)
		layers["Share"] = Share
		
		let Edit = CAShapeLayer()
		Edit.frame = CGRectMake(139, 223, 41, 41)
		Edit.path = EditPath().CGPath;
		self.layer.addSublayer(Edit)
		layers["Edit"] = Edit
		
		let Pin = CAShapeLayer()
		Pin.frame = CGRectMake(139, 223, 41, 41)
		Pin.path = PinPath().CGPath;
		self.layer.addSublayer(Pin)
		layers["Pin"] = Pin
		
		let Group = CALayer()
		Group.frame = CGRectMake(137, -89, 46, 77)
		self.layer.addSublayer(Group)
		layers["Group"] = Group
		let oval = CAShapeLayer()
		oval.frame = CGRectMake(0, 0, 46, 46)
		oval.path = ovalPath().CGPath;
		Group.addSublayer(oval)
		layers["oval"] = oval
		let polygon = CAShapeLayer()
		polygon.frame = CGRectMake(1, 31, 43, 47)
		polygon.path = polygonPath().CGPath;
		Group.addSublayer(polygon)
		layers["polygon"] = polygon
		
		resetLayerPropertiesForLayerIdentifiers(nil)
	}
	
	func resetLayerPropertiesForLayerIdentifiers(layerIds: [String]!){
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		if layerIds == nil || layerIds.contains("shadow"){
			let shadow = layers["shadow"] as! CAShapeLayer
			shadow.fillColor = UIColor(red:0, green: 0, blue:0, alpha:0.1).CGColor
			shadow.lineWidth = 0
		}
		if layerIds == nil || layerIds.contains("Trash"){
			let Trash = layers["Trash"] as! CAShapeLayer
			Trash.fillColor = UIColor(red:0.791, green: 0.791, blue:0.791, alpha:1).CGColor
			Trash.lineWidth = 0
		}
		if layerIds == nil || layerIds.contains("Share"){
			let Share = layers["Share"] as! CAShapeLayer
			Share.fillColor = UIColor(red:0.0192, green: 0.711, blue:0.426, alpha:1).CGColor
			Share.lineWidth = 0
		}
		if layerIds == nil || layerIds.contains("Edit"){
			let Edit = layers["Edit"] as! CAShapeLayer
			Edit.fillColor = UIColor(red:0, green: 0.817, blue:0.995, alpha:1).CGColor
			Edit.lineWidth = 0
		}
		if layerIds == nil || layerIds.contains("Pin"){
			let Pin = layers["Pin"] as! CAShapeLayer
			Pin.fillColor = UIColor(red:0.0192, green: 0.711, blue:0.426, alpha:1).CGColor
			Pin.lineWidth = 0
		}
		if layerIds == nil || layerIds.contains("oval"){
			let oval = layers["oval"] as! CAShapeLayer
			oval.fillColor = self.color.CGColor
			oval.lineWidth = 0
		}
		if layerIds == nil || layerIds.contains("polygon"){
			let polygon = layers["polygon"] as! CAShapeLayer
			polygon.setValue(-180 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
			polygon.fillColor = UIColor(red:0.0192, green: 0.711, blue:0.426, alpha:1).CGColor
			polygon.lineWidth = 0
		}
		
		CATransaction.commit()
	}
	
	//MARK: - Animation Setup
	
	func addPinDroppedAnimation(){
		addPinDroppedAnimationCompletionBlock(nil)
	}
	
	func addPinDroppedAnimationCompletionBlock(completionBlock: ((finished: Bool) -> Void)?){
		if completionBlock != nil{
			let completionAnim = CABasicAnimation(keyPath:"completionAnim")
			completionAnim.duration = 2.061
			completionAnim.delegate = self
			completionAnim.setValue("PinDropped", forKey:"animId")
			completionAnim.setValue(false, forKey:"needEndAnim")
			layer.addAnimation(completionAnim, forKey:"PinDropped")
			if let anim = layer.animationForKey("PinDropped"){
				completionBlocks[anim] = completionBlock
			}
		}
		
		let fillMode : String = kCAFillModeForwards
		
		////Shadow animation
		let shadowOpacityAnim      = CAKeyframeAnimation(keyPath:"opacity")
		shadowOpacityAnim.values   = [0, 0, 0.75, 1, 0, 1]
		shadowOpacityAnim.keyTimes = [0, 0.78, 0.849, 0.85, 0.91, 1]
		shadowOpacityAnim.duration = 1.27
		
		let shadowTransformAnim       = CAKeyframeAnimation(keyPath:"transform")
		shadowTransformAnim.values    = [NSValue(CATransform3D: CATransform3DIdentity), 
			 NSValue(CATransform3D: CATransform3DIdentity)]
		shadowTransformAnim.keyTimes  = [0, 1]
		shadowTransformAnim.duration  = 0.1
		shadowTransformAnim.beginTime = 0.994
		
		let shadowPinDroppedAnim : CAAnimationGroup = QCMethod.groupAnimations([shadowOpacityAnim, shadowTransformAnim], fillMode:fillMode)
		layers["shadow"]?.addAnimation(shadowPinDroppedAnim, forKey:"shadowPinDroppedAnim")
		
		////Trash animation
		let TrashPositionAnim            = CAKeyframeAnimation(keyPath:"position")
		TrashPositionAnim.values         = [NSValue(CGPoint: CGPointMake(160, 244.027)), NSValue(CGPoint: CGPointMake(160.504, 321))]
		TrashPositionAnim.keyTimes       = [0, 1]
		TrashPositionAnim.duration       = 0.266
		TrashPositionAnim.beginTime      = 1.79
		TrashPositionAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
		
		let TrashOpacityAnim      = CAKeyframeAnimation(keyPath:"opacity")
		TrashOpacityAnim.values   = [0, 0, 1]
		TrashOpacityAnim.keyTimes = [0, 0.87, 1]
		TrashOpacityAnim.duration = 1.79
		
		let TrashTransformAnim       = CAKeyframeAnimation(keyPath:"transform")
		TrashTransformAnim.values    = [NSValue(CATransform3D: CATransform3DIdentity), 
			 NSValue(CATransform3D: CATransform3DMakeScale(0.5, 0.5, 1))]
		TrashTransformAnim.keyTimes  = [0, 1]
		TrashTransformAnim.duration  = 0.266
		TrashTransformAnim.beginTime = 1.79
		
		let TrashPinDroppedAnim : CAAnimationGroup = QCMethod.groupAnimations([TrashPositionAnim, TrashOpacityAnim, TrashTransformAnim], fillMode:fillMode)
		layers["Trash"]?.addAnimation(TrashPinDroppedAnim, forKey:"TrashPinDroppedAnim")
		
		////Share animation
		let SharePositionAnim            = CAKeyframeAnimation(keyPath:"position")
		SharePositionAnim.values         = [NSValue(CGPoint: CGPointMake(160, 244.027)), NSValue(CGPoint: CGPointMake(160.504, 185.361))]
		SharePositionAnim.keyTimes       = [0, 1]
		SharePositionAnim.duration       = 0.266
		SharePositionAnim.beginTime      = 1.79
		SharePositionAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
		
		let ShareOpacityAnim      = CAKeyframeAnimation(keyPath:"opacity")
		ShareOpacityAnim.values   = [0, 0, 1]
		ShareOpacityAnim.keyTimes = [0, 0.87, 1]
		ShareOpacityAnim.duration = 1.79
		
		let SharePinDroppedAnim : CAAnimationGroup = QCMethod.groupAnimations([SharePositionAnim, ShareOpacityAnim], fillMode:fillMode)
		layers["Share"]?.addAnimation(SharePinDroppedAnim, forKey:"SharePinDroppedAnim")
		
		////Edit animation
		let EditPositionAnim            = CAKeyframeAnimation(keyPath:"position")
		EditPositionAnim.values         = [NSValue(CGPoint: CGPointMake(160, 244.027)), NSValue(CGPoint: CGPointMake(105, 215.361))]
		EditPositionAnim.keyTimes       = [0, 1]
		EditPositionAnim.duration       = 0.266
		EditPositionAnim.beginTime      = 1.79
		EditPositionAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
		
		let EditOpacityAnim      = CAKeyframeAnimation(keyPath:"opacity")
		EditOpacityAnim.values   = [0, 0, 1]
		EditOpacityAnim.keyTimes = [0, 0.87, 1]
		EditOpacityAnim.duration = 1.79
		
		let EditPinDroppedAnim : CAAnimationGroup = QCMethod.groupAnimations([EditPositionAnim, EditOpacityAnim], fillMode:fillMode)
		layers["Edit"]?.addAnimation(EditPinDroppedAnim, forKey:"EditPinDroppedAnim")
		
		////Pin animation
		let PinPositionAnim            = CAKeyframeAnimation(keyPath:"position")
		PinPositionAnim.values         = [NSValue(CGPoint: CGPointMake(160, 244.027)), NSValue(CGPoint: CGPointMake(213.667, 215.361))]
		PinPositionAnim.keyTimes       = [0, 1]
		PinPositionAnim.duration       = 0.266
		PinPositionAnim.beginTime      = 1.79
		PinPositionAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
		
		let PinOpacityAnim      = CAKeyframeAnimation(keyPath:"opacity")
		PinOpacityAnim.values   = [0, 0, 1]
		PinOpacityAnim.keyTimes = [0, 0.87, 1]
		PinOpacityAnim.duration = 1.79
		
		let PinPinDroppedAnim : CAAnimationGroup = QCMethod.groupAnimations([PinPositionAnim, PinOpacityAnim], fillMode:fillMode)
		layers["Pin"]?.addAnimation(PinPinDroppedAnim, forKey:"PinPinDroppedAnim")
		
		////Group animation
		let GroupPositionAnim            = CAKeyframeAnimation(keyPath:"position")
		GroupPositionAnim.values         = [NSValue(CGPoint: CGPointMake(160, -50.28)), NSValue(CGPoint: CGPointMake(160, 259.72)), NSValue(CGPoint: CGPointMake(160, 230)), NSValue(CGPoint: CGPointMake(160, 260)), NSValue(CGPoint: CGPointMake(160, 250)), NSValue(CGPoint: CGPointMake(160, 260))]
		GroupPositionAnim.keyTimes       = [0, 0.616, 0.78, 0.871, 0.956, 1]
		GroupPositionAnim.duration       = 1.14
		GroupPositionAnim.beginTime      = 0.458
		GroupPositionAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
		
		let GroupTransformAnim            = CAKeyframeAnimation(keyPath:"transform")
		GroupTransformAnim.values         = [NSValue(CATransform3D: CATransform3DMakeScale(1, 0.75, 1)), 
			 NSValue(CATransform3D: CATransform3DIdentity), 
			 NSValue(CATransform3D: CATransform3DIdentity), 
			 NSValue(CATransform3D: CATransform3DMakeScale(1, 0.75, 1)), 
			 NSValue(CATransform3D: CATransform3DIdentity), 
			 NSValue(CATransform3D: CATransform3DIdentity)]
		GroupTransformAnim.keyTimes       = [0, 0.115, 0.401, 0.449, 0.524, 1]
		GroupTransformAnim.duration       = 0.491
		GroupTransformAnim.beginTime      = 1.11
		GroupTransformAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
		
		let GroupPinDroppedAnim : CAAnimationGroup = QCMethod.groupAnimations([GroupPositionAnim, GroupTransformAnim], fillMode:fillMode)
		layers["Group"]?.addAnimation(GroupPinDroppedAnim, forKey:"GroupPinDroppedAnim")
	}
	
	//MARK: - Animation Cleanup
	
	override func animationDidStop(anim: CAAnimation, finished flag: Bool){
		if let completionBlock = completionBlocks[anim]{
			completionBlocks.removeValueForKey(anim)
			if (flag && updateLayerValueForCompletedAnimation) || anim.valueForKey("needEndAnim") as! Bool{
				updateLayerValuesForAnimationId(anim.valueForKey("animId") as! String)
				removeAnimationsForAnimationId(anim.valueForKey("animId") as! String)
			}
			completionBlock(flag)
		}
	}
	
	func updateLayerValuesForAnimationId(identifier: String){
		if identifier == "PinDropped"{
			QCMethod.updateValueFromPresentationLayerForAnimation((layers["shadow"] as! CALayer).animationForKey("shadowPinDroppedAnim"), theLayer:(layers["shadow"] as! CALayer))
			QCMethod.updateValueFromPresentationLayerForAnimation((layers["Trash"] as! CALayer).animationForKey("TrashPinDroppedAnim"), theLayer:(layers["Trash"] as! CALayer))
			QCMethod.updateValueFromPresentationLayerForAnimation((layers["Share"] as! CALayer).animationForKey("SharePinDroppedAnim"), theLayer:(layers["Share"] as! CALayer))
			QCMethod.updateValueFromPresentationLayerForAnimation((layers["Edit"] as! CALayer).animationForKey("EditPinDroppedAnim"), theLayer:(layers["Edit"] as! CALayer))
			QCMethod.updateValueFromPresentationLayerForAnimation((layers["Pin"] as! CALayer).animationForKey("PinPinDroppedAnim"), theLayer:(layers["Pin"] as! CALayer))
			QCMethod.updateValueFromPresentationLayerForAnimation((layers["Group"] as! CALayer).animationForKey("GroupPinDroppedAnim"), theLayer:(layers["Group"] as! CALayer))
		}
	}
	
	func removeAnimationsForAnimationId(identifier: String){
		if identifier == "PinDropped"{
			(layers["shadow"] as! CALayer).removeAnimationForKey("shadowPinDroppedAnim")
			(layers["Trash"] as! CALayer).removeAnimationForKey("TrashPinDroppedAnim")
			(layers["Share"] as! CALayer).removeAnimationForKey("SharePinDroppedAnim")
			(layers["Edit"] as! CALayer).removeAnimationForKey("EditPinDroppedAnim")
			(layers["Pin"] as! CALayer).removeAnimationForKey("PinPinDroppedAnim")
			(layers["Group"] as! CALayer).removeAnimationForKey("GroupPinDroppedAnim")
		}
	}
	
	func removeAllAnimations(){
		for layer in layers.values{
			(layer as! CALayer).removeAllAnimations()
		}
	}
	
	//MARK: - Bezier Path
	
	func shadowPath() -> UIBezierPath{
		let shadowPath = UIBezierPath(ovalInRect:CGRectMake(0, 0, 34, 13))
		return shadowPath;
	}
	
	func TrashPath() -> UIBezierPath{
		let TrashPath = UIBezierPath(ovalInRect:CGRectMake(0, 0, 41, 41))
		return TrashPath;
	}
	
	func SharePath() -> UIBezierPath{
		let SharePath = UIBezierPath(ovalInRect:CGRectMake(0, 0, 41, 41))
		return SharePath;
	}
	
	func EditPath() -> UIBezierPath{
		let EditPath = UIBezierPath(ovalInRect:CGRectMake(0, 0, 41, 41))
		return EditPath;
	}
	
	func PinPath() -> UIBezierPath{
		let PinPath = UIBezierPath(ovalInRect:CGRectMake(0, 0, 41, 41))
		return PinPath;
	}
	
	func ovalPath() -> UIBezierPath{
		let ovalPath = UIBezierPath(ovalInRect:CGRectMake(0, 0, 46, 46))
		return ovalPath;
	}
	
	func polygonPath() -> UIBezierPath{
		let polygonPath = UIBezierPath()
		polygonPath.moveToPoint(CGPointMake(21.385, 0.094))
		polygonPath.addLineToPoint(CGPointMake(0, 47))
		polygonPath.addLineToPoint(CGPointMake(42.769, 47))
		polygonPath.closePath()
		polygonPath.moveToPoint(CGPointMake(21.385, 0.094))
		
		return polygonPath;
	}
	
	
}
