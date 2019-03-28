//
//  DetailNewsViewController.swift
//  NewsTest
//
//  Created by Алексей Ермолаев on 18.03.2019.
//  Copyright © 2019 Алексей Ермолаев. All rights reserved.
//

import UIKit

class DetailNewsViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var newsImageView: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var pollView: UIView!
    @IBOutlet var pollLabel: UILabel!
    @IBOutlet var chooseFirstButton: UIButton!
    @IBOutlet var chooseSecondButton: UIButton!
    
    
    var newsTitle: String?
    var newsImageUrl: String?
    var newsTimePublished: String?
    var newsDatePublished: String?
    var newsDesription: String?
    
    var fakePoll: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildNewsView()
        if (self.randomBool()) {
            buildPoolView()
        } else {
            pollView.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    func buildNewsView() {
        self.titleLabel.text = newsTitle
        self.timeLabel.text = newsTimePublished
        self.dateLabel.text = newsDatePublished
        self.descriptionLabel.text = newsDesription
        self.newsImageView?.imageFromServerURL(urlString: newsImageUrl!, placeHolder: nil)
        self.newsImageView.contentMode = .scaleAspectFit
        self.descriptionLabel.sizeToFit()
    }
    
    func buildPoolView() {
        fakePoll = self.generateValueFrom1to100()
        self.pollLabel.text = Constants.pollTextLabel
        self.chooseFirstButton.setTitle(Constants.buttonTitleYes, for: .normal)
        self.chooseSecondButton.setTitle(Constants.buttonTitleNo, for: .normal)
    }
    
    @IBAction func actionYes(_ sender: Any) {
        self.buildAlertController(stringYesOrNo: "Да")
    }
    
    @IBAction func actionNo(_ sender: Any) {
        self.buildAlertController(stringYesOrNo: "")
    }
    
    func buildAlertController(stringYesOrNo: String) {
        let alertController = UIAlertController(title: "Внимание", message: "Подтверждаете свой выбор?", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Да", style: .default) { (action:UIAlertAction) in
            self.chooseFirstButton.isEnabled = false
            self.chooseSecondButton.isEnabled = false
            self.chooseFirstButton.setTitle(String(self.fakePoll!), for: .normal)
            self.chooseSecondButton.setTitle(String(100 - self.fakePoll!), for: .normal)
            if (stringYesOrNo == "Да") {
                self.chooseFirstButton.backgroundColor = UIColor.gray
                self.chooseFirstButton.setTitleColor(UIColor.white, for: .normal)
            } else {
                self.chooseSecondButton.backgroundColor = UIColor.gray
                self.chooseSecondButton.setTitleColor(UIColor.white, for: .normal)
            }
        }
        
        let action2 = UIAlertAction(title: "Нет", style: .cancel) { (action:UIAlertAction) in
            print("You've pressed cancel");
        }
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func generateValueFrom1to100() -> Int {
        return Int(arc4random_uniform(100));
    }
    
    func randomBool() -> Bool {
        return arc4random_uniform(2) == 0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
