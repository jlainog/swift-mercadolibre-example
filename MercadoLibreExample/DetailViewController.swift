import UIKit

final class DetailViewController: UIViewController {
    var selected: String
    
    init(_ selected: String) {
        self.selected = selected
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details - change me"
        self.view.backgroundColor = .white
        
        let name = UILabel()
        name.numberOfLines = 0
        name.text = selected
        
        let stack = UIStackView()
        stack.addArrangedSubview(name)
        stack.alignment = .leading
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        self.view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            stack.topAnchor.constraint(equalTo: self.view.topAnchor),
            stack.bottomAnchor.constraint(greaterThanOrEqualTo: self.view.bottomAnchor)
//                .constraint(equalTo: self.view.bottomAnchor),
        ])
    }
}
