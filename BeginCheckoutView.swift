import UIKit

class BeginCheckoutView: UIView {
    let checkoutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Begin Checkout", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: button, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0).isActive = true
        return button
    }()

    let nameLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let selfieImageView: UIImageView = {
        let imageView = CircleImageView(frame: CGRect.zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 1.0, constant: 0.0).isActive = true
        return imageView
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private lazy var portraitStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.selfieImageView, self.nameLabel, self.activityIndicatorView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.portraitStackView, self.checkoutButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.spacing = 20
        return stackView
    }()
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = UIColor.white
        
        addSubview(stackView)
        readableContentGuide.topAnchor.constraint(equalTo: stackView.topAnchor, constant: -60.0).isActive = true
        readableContentGuide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20.0).isActive = true
        readableContentGuide.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -20.0).isActive = true
        readableContentGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 20.0).isActive = true
    }
}
