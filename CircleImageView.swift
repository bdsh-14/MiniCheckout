import UIKit

class CircleImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        layer.borderWidth = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        layer.cornerRadius = CGFloat(bounds.size.width * 0.5)
    }
}
