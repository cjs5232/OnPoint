//
//  CalendarViewController.swift
//  Mom
//
//  Created by Connor Stange (student LM) on 1/28/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
//

import UIKit

var dateString = ""

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var Calendar: UICollectionView!
    @IBOutlet weak var MonthLabel: UILabel!
    
    let Months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let DaysOfMonth = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var DaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonth = String()
    var NumberOfEmptyBox = Int()        // The number of "empty boxes" at the start of the month
    var NextNumberOfEmptyBox = Int()    // The number of "empty boxes" at the start of the next month
    var PreviousNumberOfEmptyBox = 0    // The number of "empty boxes" at the start of the previous month
    var Direction = 0                   // 0 = Current month | 1+ = Future month | -1- = Past month
    var PositionIndex = 0               // Stores the above vars of the "empty boxes"
    var LeapYearCounter = 3
    var dayCounter = 0
    var cellsArray: [UICollectionViewCell] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        currentMonth = Months[month]
        MonthLabel.text = "\(currentMonth) \(year)"
        if weekday == 0 {
            weekday = 7
        }
        GetStartDateDayPosition()
    }
    
    @IBAction func Next(_ sender: Any) {
        switch currentMonth {
        case "December":
            month = 0
            year += 1
            Direction = 1
            if LeapYearCounter < 5{
                LeapYearCounter += 1
            }
            if LeapYearCounter == 4{
                DaysInMonth[1] = 29
            }
            if LeapYearCounter == 5{
                LeapYearCounter = 1
                DaysInMonth[1] = 28
            }
            GetStartDateDayPosition()
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            MoveAnimationNext(Label: MonthLabel)
            Calendar.reloadData()
        default:
            Direction = 1
            GetStartDateDayPosition()
            month += 1
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            MoveAnimationNext(Label: MonthLabel)
            Calendar.reloadData()
        }
    }
    @IBAction func Back(_ sender: Any) {
        switch currentMonth {
        case "January":
            month = 11
            year -= 1
            Direction = -1
            if LeapYearCounter > 0{
                LeapYearCounter -= 1
            }
            if LeapYearCounter == 0{
                DaysInMonth[1] = 29
                LeapYearCounter = 4
            } else {
                DaysInMonth[1] = 28
            }
            GetStartDateDayPosition()
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            MoveAnimationBack(Label: MonthLabel)
            Calendar.reloadData()
        default:
            month -= 1
            Direction = -1
            GetStartDateDayPosition()
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            MoveAnimationBack(Label: MonthLabel)
            Calendar.reloadData()
        }
    }
    
    func GetStartDateDayPosition(){                                                 // Gives us number of "empty boxes"
        switch Direction {
        case 0:                                                                     // Current Month
            NumberOfEmptyBox = weekday
            dayCounter = day
            while dayCounter > 0{
                NumberOfEmptyBox = NumberOfEmptyBox - 1
                dayCounter = dayCounter - 1
                if NumberOfEmptyBox == 0 {
                    NumberOfEmptyBox = 7
                }
            }
            PositionIndex = NumberOfEmptyBox
        case 1...:                                                                  // Future Month
            NextNumberOfEmptyBox = (PositionIndex + DaysInMonth[month])%7
            PositionIndex = NextNumberOfEmptyBox
        case -1:                                                                    // Past Month
            PreviousNumberOfEmptyBox = (7 - (DaysInMonth[month] - PositionIndex)%7)
            if PreviousNumberOfEmptyBox == 7 {
                PreviousNumberOfEmptyBox = 0
            }
            PositionIndex = PreviousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Direction {      // returns number of days in month and number of "empty boxes" based on direction
        case 0:
            return DaysInMonth[month] + NumberOfEmptyBox
        case 1...:
            return DaysInMonth[month] + NextNumberOfEmptyBox
        case -1:
            return DaysInMonth[month] + PreviousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionViewCell
        cell.backgroundColor = UIColor.clear
        cell.DateLabel.textColor = UIColor.black
        cell.Circle.isHidden = true
        if cell.isHidden{
            cell.isHidden = false
        }
        switch Direction {
        case 0:
            cell.DateLabel.text = "\(indexPath.row + 1 - NumberOfEmptyBox)"
        case 1...:
            cell.DateLabel.text = "\(indexPath.row + 1 - NextNumberOfEmptyBox)"
        case -1:
            cell.DateLabel.text = "\(indexPath.row + 1 - PreviousNumberOfEmptyBox)"
        default:
            fatalError()
        }
        if Int(cell.DateLabel.text!)! < 1{      // Hides cells less than 1
            cell.isHidden = true
        }
        switch indexPath.row {                  // Makes weekends lightgray color
        case 0,6,7,13,14,20,21,27,28,34,35:       // Weekends
            if Int(cell.DateLabel.text!)! > 0 {
                cell.DateLabel.textColor = UIColor.lightGray
            }
        default:
            break
        }
        if currentMonth == Months[calendar.component(.month, from: date)-1] && year == calendar.component(.year, from: date) && indexPath.row + 1 - NumberOfEmptyBox == day {        // Makes the current date red
            cell.Circle.isHidden = false
            cell.DrawCircle()
        }
        cellsArray.append(cell)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dateString = "\(indexPath.row - PositionIndex + 1) \(currentMonth) \(year)"
        performSegue(withIdentifier: "NextView", sender: self)
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        cell.alpha = 0
        cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
        for x in cellsArray{
            let cell: UICollectionViewCell = x
            UIView.animate(withDuration: 1, delay: 0.01*Double(indexPath.row), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                cell.alpha = 1
                cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
            })
        }
    }
    func setDirection(Direction: Int){
        self.Direction = Direction
    }
}
