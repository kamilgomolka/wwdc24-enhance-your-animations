import UIKit

class TestFeatureViewController: UIViewController {
    
    // MARK: Properties
    
    private var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Body Label"
        return label
    }()
    
    // MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Test Feature"
        view.backgroundColor = .systemBackground
        
        setupBodyLabel()
    }
    
    // MARK: View setup
    
    private func setupBodyLabel() {
        view.addSubview(bodyLabel)
        bodyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0).isActive = true
        bodyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
