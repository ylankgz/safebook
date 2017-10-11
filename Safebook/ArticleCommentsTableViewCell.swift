
import UIKit

class ArticleCommentsCell: UITableViewCell {
    
    @IBOutlet weak var commentsContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentsContent.sizeToFit()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
