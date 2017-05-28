//
//  StatsViewController.swift
//  AngryMob
//
//  Created by Radoslaw Halski on 27/05/2017.
//  Copyright © 2017 AngryMobTeam. All rights reserved.
//

import Foundation
import UIKit
import Charts
import RxSwift
import RxCocoa
import DatePickerDialog
import PieCharts


public class StatsViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    

    @IBOutlet weak var genderChart: PieChart!
    @IBOutlet weak var endDateButton: UIButton!
    @IBOutlet weak var startDateButton: UIButton!
    
    @IBOutlet weak var ageButton: UIButton!
    @IBOutlet weak var hoursButton: UIButton!
    @IBOutlet weak var emotionsButton: UIButton!
    
    @IBOutlet weak var leadingConst: NSLayoutConstraint!
    @IBOutlet weak var widthConst: NSLayoutConstraint!
    
    let pinkColor = UIColor(red:0.94, green:0.45, blue:0.45, alpha:1.0)
    let blueColor = UIColor(red:0.24, green:0.67, blue:0.90, alpha:1.0)
    
    let active = UIColor(red:0.21, green:0.04, blue:0.23, alpha:1.0)
    let inactive = UIColor(red:0.64, green:0.56, blue:0.65, alpha:1.0)
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var ageContainer: UIView!
    @IBOutlet weak var hoursContainer: UIView!
    @IBOutlet weak var emotionsContainer: UIView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Statistics"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red:0.21, green:0.04, blue:0.23, alpha:1.0), NSFontAttributeName: UIFont(name: "Exo2-Bold", size: 20)!]
        
        topView.layer.cornerRadius = 8
        submitButton.layer.cornerRadius = 8
        
        startDateButton.setTitle(Date().date, for: .normal)
        startDateButton.layer.cornerRadius = 8
        startDateButton.layer.borderColor = UIColor(red:0.21, green:0.04, blue:0.23, alpha:1.0).cgColor
        startDateButton.layer.borderWidth = 2
        
        startDateButton.rx.tap.subscribe(onNext:{ [weak self] in
            DatePickerDialog().show(title: "Select start date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) { date in
                guard let date = date else { return }
                self?.startDateButton.setTitle(date.date, for: .normal)
            }
        }).addDisposableTo(disposeBag)
        
        // end
        
        endDateButton.setTitle(Date().date, for: .normal)
        endDateButton.layer.cornerRadius = 8
        endDateButton.layer.borderColor = UIColor(red:0.21, green:0.04, blue:0.23, alpha:1.0).cgColor
        endDateButton.layer.borderWidth = 2
        
        endDateButton.rx.tap.subscribe(onNext:{ [weak self] in
            DatePickerDialog().show(title: "Select end date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) { date in
                guard let date = date else { return }
                self?.endDateButton.setTitle(date.date, for: .normal)
            }
        }).addDisposableTo(disposeBag)
        
        genderChart.models = [
            PieSliceModel(value: 60, color: blueColor),
            PieSliceModel(value: 40, color: pinkColor)
        ]
        
        self.ageButton.setTitleColor(active, for: .normal)
        self.hoursButton.setTitleColor(inactive, for: .normal)
        self.emotionsButton.setTitleColor(inactive, for: .normal)
        
        setupButtons()
        
        self.ageContainer.alpha = 1
        self.hoursContainer.alpha = 0
        self.emotionsContainer.alpha = 0
    }
    
    
    func setupButtons() {
        ageButton.rx.tap.subscribe(onNext:{ [weak self] in
            guard let `self` = self else { return }
            self.configureButtons(button: self.ageButton)
        }).addDisposableTo(disposeBag)
        
        hoursButton.rx.tap.subscribe(onNext:{ [weak self] in
            guard let `self` = self else { return }
            self.configureButtons(button: self.hoursButton)
        }).addDisposableTo(disposeBag)
        
        emotionsButton.rx.tap.subscribe(onNext:{ [weak self] in
            guard let `self` = self else { return }
            self.configureButtons(button: self.emotionsButton)
        }).addDisposableTo(disposeBag)
    }
    
    func configureButtons(button: UIButton) {
        self.ageButton.setTitleColor(inactive, for: .normal)
        self.hoursButton.setTitleColor(inactive, for: .normal)
        self.emotionsButton.setTitleColor(inactive, for: .normal)
        
        button.setTitleColor(active, for: .normal)
        
        leadingConst.constant = button.frame.origin.x
        widthConst.constant = button.frame.size.width
        
        view.setNeedsLayout()
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: { [weak self] in
            self?.view.layoutIfNeeded()
            }, completion: nil)
        
        presentContainer(index: button.tag)
    }
    
    func presentContainer(index: Int) {
        switch index {
        case 1:
            UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: { [weak self] in
                self?.ageContainer.alpha = 1
                self?.hoursContainer.alpha = 0
                self?.emotionsContainer.alpha = 0
                }, completion: nil)
        case 2:
            UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: { [weak self] in
                self?.ageContainer.alpha = 0
                self?.hoursContainer.alpha = 1
                self?.emotionsContainer.alpha = 0
                }, completion: nil)
        case 3:
            UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: { [weak self] in
                self?.ageContainer.alpha = 0
                self?.hoursContainer.alpha = 0
                self?.emotionsContainer.alpha = 1
                }, completion: nil)
        default:
            break
        }
    }
    
}