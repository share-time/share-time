import UIKit
import Parse

class StudyGroupCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var memberNumLabel: UILabel!
    @IBOutlet weak var professorLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBAction func onEnterGroupButton(_ sender: Any) {
    }
    
    var nameLabelText: String!
    var members: [PFObject]!
    var classLabelText: String!
    var professorLabelText: String!
    
    var studyGroup: PFObject! {
        didSet {
            self.nameLabel.text = studyGroup.object(forKey: "name") as? String
            let members = studyGroup.object(forKey: "members") as? [PFObject]
            self.memberNumLabel.text = String(describing: members?.count)
            self.classLabel.text = studyGroup.object(forKey: "course") as? String
            self.professorLabel.text = studyGroup.object(forKey: "professor") as? String
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
