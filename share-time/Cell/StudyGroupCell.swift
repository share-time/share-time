import UIKit
import Parse

class StudyGroupCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var memberNumLabel: UILabel!
    @IBOutlet weak var professorLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    
    var studyGroup: PFObject! {
        didSet {
            self.nameLabel.text = studyGroup.object(forKey: "name") as? String
            //let members = studyGroup.object(forKey: "members") as? [PFObject]
            let memberNum = 10 //members!.count
            var memberNumString = String(describing: memberNum)
            memberNumString += (memberNum == 1) ? " Member" : " Members"
            self.memberNumLabel.text = memberNumString
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
