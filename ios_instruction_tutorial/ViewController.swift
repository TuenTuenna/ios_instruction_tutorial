//
//  ViewController.swift
//  ios_instruction_tutorial
//
//  Created by Jeff Jeong on 2020/10/23.
//

import UIKit
import Instructions

class ViewController: UIViewController {

    
    @IBOutlet var profileImg: UIImageView!
    
    @IBOutlet var profileLabel: UILabel!
    
    
    @IBOutlet var subscribeBtn: UIButton!
    
    @IBOutlet var likeBtn: UIButton!
    
    @IBOutlet var alartmBtn: UIButton!
    
    
    let coachMarksController = CoachMarksController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 데이타 소스를 통해 보여줄 뷰를 지정
        self.coachMarksController.dataSource = self
        
        // 델리겟 설정
        self.coachMarksController.delegate = self
        
        // 애니메이션 델리겟
        self.coachMarksController.animationDelegate = self
        
        // 스킵할 수 있는 뷰를 지정
        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("튜토리얼 스킵하기", for: .normal)

        self.coachMarksController.skipView = skipView

        self.coachMarksController.statusBarVisibility = .hidden
        
        
        self.coachMarksController.overlay.isUserInteractionEnabled = true
        
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.coachMarksController.start(in: .window(over: self))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.coachMarksController.stop(immediately: true)
    }
    

} // ViewController

extension ViewController : CoachMarksControllerDelegate {
    
    // 오버레이설정
    func coachMarksController(_ coachMarksController: CoachMarksController, configureOrnamentsOfOverlay overlay: UIView) {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(label)
        
        label.text = "오버레이 입니다."
        label.alpha = 0.5
        label.font = label.font.withSize(60.0)
        
        label.centerXAnchor.constraint(equalTo: overlay.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: overlay.topAnchor, constant: 100).isActive = true
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, willShow coachMark: inout CoachMark, beforeChanging change: ConfigurationChange, at index: Int) {
        print("willShow() index: \(index)")
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, willHide coachMark: CoachMark, at index: Int) {
        print("willHide() index: \(index)")
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, didEndShowingBySkipping skipped: Bool) {
        print("스킵여부 : ", skipped)
    }

    func shouldHandleOverlayTap(in coachMarksController: CoachMarksController, at index: Int) -> Bool {

        print("tapped")

        return true
    }
    
}


// 보여줄 뷰를 설정
extension ViewController : CoachMarksControllerDataSource {
    
    // 가이드 마커에 대한 설정
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
        
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: true,
            arrowOrientation: coachMark.arrowOrientation
        )
        
        switch index {
        case 0:
            coachViews.bodyView.hintLabel.text = "이것은 당신의 프사입니다!!!"
            coachViews.bodyView.nextLabel.text = "다음"
            coachViews.bodyView.background.innerColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
            coachViews.arrowView?.background.innerColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
            coachViews.bodyView.background.borderColor = .yellow
            coachViews.bodyView.hintLabel.textColor = .white
            coachViews.bodyView.nextLabel.textColor = .yellow
        case 1:
            coachViews.bodyView.hintLabel.text = "이것은 당신의 닉네임입니다"
            coachViews.bodyView.nextLabel.text = "다음!"
        case 2:
            coachViews.bodyView.hintLabel.text = "구독버튼 꼭 눌러주세요!"
            coachViews.bodyView.nextLabel.text = "다음!"
        case 3:
            coachViews.bodyView.hintLabel.text = "좋아요도 눌러주세요!"
            coachViews.bodyView.nextLabel.text = "다음!"
        case 4:
            coachViews.bodyView.hintLabel.text = "알람설정도 잊지 마세요!"
            coachViews.bodyView.nextLabel.text = "다음!"
        default:
            coachViews.bodyView.hintLabel.text = "이건 당신의 프사입니다"
            coachViews.bodyView.nextLabel.text = "다음!"
        }
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    
    
    // 가르키고자 하는 뷰를 지정
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        
        switch index {
        case 0:
            return coachMarksController.helper.makeCoachMark(for: profileImg)
        case 1:
            return coachMarksController.helper.makeCoachMark(for: profileLabel)
        case 2:
            return coachMarksController.helper.makeCoachMark(for: subscribeBtn)
        case 3:
            return coachMarksController.helper.makeCoachMark(for: likeBtn)
        case 4:
            return coachMarksController.helper.makeCoachMark(for: alartmBtn)
        default:
            return coachMarksController.helper.makeCoachMark(for: profileImg)
        }
        
    }
    
    
    // 몇 개의 뷰에 대해 가이드를 제공할거냐
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 5
    }
    
}

extension ViewController: CoachMarksControllerAnimationDelegate {
    
    // 마커가 나타날때
    func coachMarksController(_ coachMarksController: CoachMarksController, fetchAppearanceTransitionOfCoachMark coachMarkView: UIView, at index: Int, using manager: CoachMarkTransitionManager) {
        
        manager.parameters.options = [.beginFromCurrentState]
        manager.animate(.regular) { (CoachMarkAnimationManagementContext) in
            coachMarkView.transform = .identity
            coachMarkView.alpha = 1
        } fromInitialState: {
            // 투명한 상태, 절반 작은 크기에서 시작
            coachMarkView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            coachMarkView.alpha = 0
        } completion: { (Bool) in
            
        }
    }
    
    // 마커가 사라질때
    func coachMarksController(_ coachMarksController: CoachMarksController, fetchDisappearanceTransitionOfCoachMark coachMarkView: UIView, at index: Int, using manager: CoachMarkTransitionManager) {
        manager.animate(.keyframe) { (CoachMarkAnimationManagementContext) in
            
            // 크기를 절반 크기로 쪼그라 들게 함
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 8.0) {
                coachMarkView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }
            
            // 투명하게
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.4) {
                coachMarkView.alpha = 0
            }
            
        }
    }
    
    // 마커가 떠있을때
    func coachMarksController(_ coachMarksController: CoachMarksController, fetchIdleAnimationOfCoachMark coachMarkView: UIView, at index: Int, using manager: CoachMarkAnimationManager) {
        manager.parameters.options = [.repeat, .autoreverse, .allowUserInteraction]
        manager.parameters.duration = 0.7
        manager.animate(.regular) { (context: CoachMarkAnimationManagementContext) in
            let offset: CGFloat = context.coachMark.arrowOrientation == .top ? 10 : -10
            coachMarkView.transform = CGAffineTransform(translationX: 0, y: offset)
        }
    }
}

