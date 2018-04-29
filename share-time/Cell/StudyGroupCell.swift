import UIKit

class StudyGroupCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var memberNumLabel: UILabel!
    @IBOutlet weak var professorLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBAction func onEnterGroupButton(_ sender: Any) {
    }
    
    var studyGroup: StudyGroup! {
        didSet {
            self.nameLabel.text = studyGroup.name
            self.memberNumLabel.text = String(studyGroup.members.count)
            self.classLabel.text = studyGroup.course
            self.professorLabel.text = studyGroup.professor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
