import UIKit
import Parse

class StudyGroupCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var memberNumLabel: UILabel!
    @IBOutlet weak var professorLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    var memberNum = 0
    
    var studyGroup: PFObject! {
        didSet {
            self.nameLabel.text = studyGroup.object(forKey: "name") as? String
            
            // code to get number of members
            studyGroup.relation(forKey: "members").query().findObjectsInBackground{
                (studyGroups: [PFObject]?, error: Error?) -> Void in
                if error != nil {
                    print("please dont print")
                } else {
                    self.memberNum = (studyGroups?.count)!
                    var memberNumString = String(describing: self.memberNum)
                    memberNumString += (self.memberNum == 1) ? " Member" : " Members"
                    self.memberNumLabel.text = memberNumString
                }
            }
            
            self.classLabel.text = studyGroup.object(forKey: "course") as? String
            self.professorLabel.text = studyGroup.object(forKey: "professor") as? String
            print("setting stuff")
        }
    }    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.lightGray
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
