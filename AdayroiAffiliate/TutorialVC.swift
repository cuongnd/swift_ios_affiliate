//
//  TutorialVC.swift
//  WallPaperApp
//
//  Created by iMac on 20/03/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//

import UIKit

class TutorialCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgTutorial: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
}
class TutorialVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var collection_tutorial: UICollectionView!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //MARK: Variables
    var tutorialArr = [
        ["image":"anhside_1","title":"Mạng lưới affiliate hiệu quả và uy tín","description":"Nền tảng Tiếp thị liên kết quy mô và uy tín nhất Việt Nam"],
        ["image":"anhside_2","title":"Hoa hồng chia sẻ hấp dẫn","description":"Hoa hồng lên tới 21%, thanh toán nhanh nhất vào ngày 18 hàng tháng"],
        ["image":"anhside_3","title":"Đa Dạng Chiến Dịch","description":"Hàng nghìn chiến dịch trong các lĩnh vực Thương mại điện tử, Du lịch, Ngân hàng – Bảo hiểm, Làm đẹp…"]
    ]
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnSkip.layer.borderColor = ORENGE_COLOR.cgColor
        self.btnSkip.layer.borderWidth = 1.0
        self.btnSkip.layer.cornerRadius = 8.0
    }
}
//MARK: Actions
extension TutorialVC {
    @IBAction func btnSkip_Clicked(_ sender: UIButton) {
        UserDefaults.standard.set("1", forKey: UD_isTutorial)
        let storyBoard = UIStoryboard(name: "User", bundle: nil)
        let objVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let nav : UINavigationController = UINavigationController(rootViewController: objVC)
        nav.navigationBar.isHidden = true
        UIApplication.shared.windows[0].rootViewController = nav
    }
}
//MARK: Collectionview methods
extension TutorialVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tutorialArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collection_tutorial.dequeueReusableCell(withReuseIdentifier: "TutorialCollectionCell", for: indexPath) as! TutorialCollectionCell
        //        cell.imgTutorial.image = UIImage(systemName: self.tutorialArr[indexPath.item]["image"]!)
        cell.imgTutorial.image = UIImage(named: self.tutorialArr[indexPath.item]["image"]!)
        cell.lblTitle.text = self.tutorialArr[indexPath.item]["title"]
        cell.lblDescription.text = self.tutorialArr[indexPath.item]["description"]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 20.0)
    }
}
//MARK: Functions
extension TutorialVC {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = self.collection_tutorial.contentOffset
        visibleRect.size = self.collection_tutorial.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = self.collection_tutorial.indexPathForItem(at: visiblePoint) else { return }
        self.pageControl.currentPage = indexPath.item
        if indexPath.item == 2 {
            self.btnSkip.setTitle("Bắt đầu", for: .normal)
        }
        else {
            self.btnSkip.setTitle("Bỏ qua", for: .normal)
        }
    }
}
