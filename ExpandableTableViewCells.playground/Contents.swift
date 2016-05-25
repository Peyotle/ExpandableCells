import UIKit
import XCPlayground

struct User {
    let name: String
    let details: String
    let image: UIImage
    
    var expanded: Bool
}

let users = [User(name: "First One", details: "First person \nlonger details", image: [#Image(imageLiteral: "user_1.png")#], expanded: false),
             User(name: "Second", details: "Second person details", image: [#Image(imageLiteral: "user_2.png")#], expanded: false),
             User(name: "Third", details: "Second person details", image: [#Image(imageLiteral: "user_3.png")#], expanded: false),
             User(name: "First One", details: "First person \nlonger details", image: [#Image(imageLiteral: "user_1.png")#], expanded: false),
             User(name: "Second", details: "Second person details", image: [#Image(imageLiteral: "user_2.png")#], expanded: false),
             User(name: "Third", details: "Second person details", image: [#Image(imageLiteral: "user_3.png")#], expanded: false),
             User(name: "First One", details: "First person \nlonger details", image: [#Image(imageLiteral: "user_1.png")#], expanded: false),
             User(name: "Second", details: "Second person details", image: [#Image(imageLiteral: "user_2.png")#], expanded: false),
             User(name: "Third", details: "Second person details", image: [#Image(imageLiteral: "user_3.png")#], expanded: false)]


protocol UserCell{
    var user: User { get }
}


extension UserCell{
    func setupUserImage(image:UIImage) -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 15, y: 10, width: 20, height: 20))
        imageView.backgroundColor = UIColor.blueColor()
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        imageView.image = image
        imageView.clipsToBounds = true
        return imageView
    }
    
    func setupNameLabel() -> UILabel {
        let nameLabel = UILabel(frame: CGRect(x: 45, y: 10, width: 100, height: 20))
        return nameLabel
    }
}

class MinimizedCell: UITableViewCell, UserCell {
    let user: User
    
    init(user: User) {
        self.user = user
        
        super.init(style: .Default, reuseIdentifier: nil)
        
        let nameLabel = setupNameLabel()
        nameLabel.text = user.name
        
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(self.setupUserImage(user.image))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ExpandedCell: UITableViewCell, UserCell {
    let user: User
    
    init(user: User) {
        self.user = user
        
        let detailsText = UITextView(frame: CGRect(x: 70 + 20, y: 35, width: 200, height: 50))
        detailsText.userInteractionEnabled = false
        detailsText.text = user.details
        
        super.init(style: .Default, reuseIdentifier: nil)

        let nameLabel = setupNameLabel()
        nameLabel.text = user.name

        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(detailsText)
        
        let imageView = self.setupUserImage(user.image)
        self.contentView.addSubview(imageView)
        self.animateUserImageView(imageView)
    }
    
    func animateUserImageView(view: UIView) {
        let imageEdgeLength = 70
        
        let animation = CABasicAnimation.init(keyPath: "cornerRadius")
        animation.duration = 0.3
        animation.fromValue = view.layer.cornerRadius
        animation.toValue = imageEdgeLength / 2
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = false
        view.layer.addAnimation(animation, forKey: "cornerRadius")
        
        UIView.animateWithDuration(0.4, delay: 0,
                                   options: UIViewAnimationOptions.CurveEaseOut,
                                   animations: {
                                    view.frame = CGRect(x: 15, y: 35, width: imageEdgeLength, height: imageEdgeLength)
                                    
            },
                                   completion: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MyTableViewController: UITableViewController {
    var items: [User]
    
    init(style:UITableViewStyle, items:[User]) {
        self.items = items
        
        super.init(style: style)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.view.backgroundColor = UIColor(white: 0.9, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if items[indexPath.row].expanded {
            return ExpandedCell(user:items[indexPath.row])
        }else {
            return MinimizedCell(user:items[indexPath.row])
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let user = items[indexPath.row]
        
        items[indexPath.row] = User(name: user.name, details: user.details, image: user.image, expanded: !user.expanded)
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if items[indexPath.row].expanded {
            return 120.0
        }
        return 40.0
    }
}

let tebleViewController = MyTableViewController(style: .Plain, items: users)
XCPlaygroundPage.currentPage.liveView = tebleViewController
