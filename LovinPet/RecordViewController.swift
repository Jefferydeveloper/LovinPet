//
//  RecordViewController.swift
//  LovinPet
//
//  Created by 吳孟儒 on 2020/12/8.
//

import UIKit
import Charts
import CoreData

class RecordViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var weightTableView: UITableView!
    
    var data : [WeightData] = []
    
    var weightValue: [ChartDataEntry] = []
    
    let datePicker = UIDatePicker()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.queryFromCoreData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.string(from: self.datePicker.date)
        self.weightTableView.dataSource = self
        self.weightTableView.delegate = self
        
        lineChartView.rightAxis.enabled = false
        
        let yAxis = lineChartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
//        yAxis.setLabelCount(5, force: false)
        yAxis.labelTextColor = .black
        yAxis.axisLineColor = .white
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 50
        yAxis.labelPosition = .outsideChart
        
        lineChartView.xAxis.labelPosition = .bottom

        lineChartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
//        lineChartView.xAxis.setLabelCount(1, force: false)
//        lineChartView.xAxis.labelCount = self.weightValue.count
        lineChartView.xAxis.labelTextColor = .black
        lineChartView.xAxis.axisLineColor = .systemBlue
//        lineChartView.xAxis.spaceMin = 0.5
//        lineChartView.xAxis.spaceMax = 0.5
//        lineChartView.xAxis.granularityEnabled = true
//        lineChartView.xAxis.granularity = 1
//        lineChartView.xAxis.granularity = Double(self.weightValue.count)
        
        let set1 = LineChartDataSet(entries: self.weightValue, label: "Weight")
        let data = LineChartData(dataSet: set1) // Read data
        self.lineChartView.data = data
        
        navigationController?.navigationBar.prefersLargeTitles =  true
        
        self.setData() // Setting line chart
    }
    var alertController : UIAlertController?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UIAlertController(title: nil, message: "請輸入體重與日期", preferredStyle: .alert)
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        controller.addTextField { (textField) in
            textField.delegate = self
            
            textField.placeholder = "日期"
            
            // bar button
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(RecordViewController.didSelectDate))
            
            toolbar.setItems([doneButton], animated: true)
            
            //assign toolbar
            textField.inputAccessoryView = toolbar
            
            // assign date picker to the text field
            textField.inputView = self.datePicker
            
            self.datePicker.preferredDatePickerStyle = .wheels
            self.datePicker.datePickerMode = UIDatePicker.Mode.date
        }
        
        controller.addTextField { (textField) in
            textField.placeholder = "體重"
            textField.isSecureTextEntry = false
            textField.delegate = self
            textField.keyboardType = .decimalPad
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            let weight = controller.textFields![1] as UITextField
            
            self.data[indexPath.row].weightDate = self.datePicker.date
            self.data[indexPath.row].weight = Double(weight.text!) ?? 0.0
            
            CoreDataHelper.shared.saveContext()
            
            self.weightTableView.reloadData()
            
            // Line
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            dateFormatter.string(from: self.datePicker.date)
            
            let dataEntry = ChartDataEntry(x: self.datePicker.date.timeIntervalSince1970, y: self.data[0].weight) // Create data
            self.weightValue.append(dataEntry)
            
            self.alertController = nil
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
            self.alertController = nil
        }
        
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
        self.alertController = controller
    }
    
    @objc func didSelectDate()  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        if let textField = self.alertController?.textFields?[0] {
            textField.text = dateFormatter.string(from: self.datePicker.date)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - target action
    @IBAction func addWeight(_ sender: UIBarButtonItem) {
        let controller = UIAlertController(title: nil, message: "請輸入體重與日期", preferredStyle: .alert)
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        controller.addTextField { (textField) in
            textField.delegate = self
            
            textField.placeholder = "日期"
            
            // bar button
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(RecordViewController.didSelectDate))
            
            toolbar.setItems([doneButton], animated: true)
            
            // assign toolbar
            textField.inputAccessoryView = toolbar
            
            // assign date picker to the text field
            textField.inputView = self.datePicker
            
            self.datePicker.preferredDatePickerStyle = .wheels
            self.datePicker.datePickerMode = UIDatePicker.Mode.date
        }
        
        controller.addTextField { (textField) in
            textField.placeholder = "體重"
            textField.isSecureTextEntry = false
            textField.delegate = self
            textField.keyboardType = .decimalPad
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            let context = CoreDataHelper.shared.managedObjectContext()
            let WeightData = NSEntityDescription.insertNewObject(forEntityName: "WeightData", into: context) as! WeightData
            let weight = controller.textFields![1] as UITextField
            
            WeightData.weightDate = self.datePicker.date
            WeightData.weight = Double(weight.text!) ?? 0
            
            self.data.insert(WeightData, at: 0)
            CoreDataHelper.shared.saveContext()
            
            print("note.weight \(WeightData.weight)")
            
            let indexPath = IndexPath(row: 0, section: 0)
            self.weightTableView.insertRows(at: [indexPath], with: .automatic)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            dateFormatter.string(from: self.datePicker.date)
            
            let dataEntry = ChartDataEntry(x: self.datePicker.date.timeIntervalSince1970, y: self.data[0].weight) // Create data
            self.weightValue.append(dataEntry)
            
            let set1 = LineChartDataSet(entries: self.weightValue, label: "Weight") // Setting data
            set1.mode = .cubicBezier
            set1.lineWidth = 3
            set1.fill = Fill(color: .link)
            set1.fillAlpha = 0.8
            set1.drawFilledEnabled = true
            set1.highlightColor = .systemRed
            
            let data = LineChartData(dataSet: set1) // Read data
            self.lineChartView.xAxis.labelCount = self.weightValue.count - 1
            self.lineChartView.xAxis.spaceMin = 0.5
            self.lineChartView.xAxis.spaceMax = 0.5
            self.lineChartView.xAxis.granularityEnabled = true
            self.lineChartView.xAxis.granularity = 1
            self.lineChartView.xAxis.centerAxisLabelsEnabled = false
            self.lineChartView.xAxis.labelWidth = 1
            self.lineChartView.xAxis.avoidFirstLastClippingEnabled = false
//            self.lineChartView.xAxis.labelFont = .boldSystemFont(ofSize: 5)
//            self.lineChartView.dragEnabled = true
//            self.lineChartView.doubleTapToZoomEnabled = false
            self.lineChartView.data = data
            
            self.alertController = nil
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
            self.alertController = nil
        }
        
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        
        present(controller, animated: true, completion: nil)
        self.alertController = controller
    }
    
    func setData() {
        // Line
        let set1 = LineChartDataSet(entries: self.weightValue, label: "Weight") // Setting data
        set1.mode = .cubicBezier
        set1.lineWidth = 3
        set1.fill = Fill(color: .link)
        set1.fillAlpha = 0.8
        set1.drawFilledEnabled = true
        set1.highlightColor = .systemRed
        
        let data = LineChartData(dataSet: set1) // Read data
        data.setDrawValues(false)
        self.lineChartView.xAxis.valueFormatter = IAxisDateFormatter() // Transfer formate
        self.lineChartView.data = data
        // Line
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let note = data[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
     
        cell.textLabel?.text = dateFormatter.string(from: note.weightDate!)
        cell.detailTextLabel?.text = String(note.weight)
        
        cell.showsReorderControl = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let tableData = self.data.remove(at: indexPath.row)
            let context = CoreDataHelper.shared.managedObjectContext()
            
            context.delete(tableData)
            CoreDataHelper.shared.saveContext()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    //MARK: - CoreData
    func queryFromCoreData() {
        let context = CoreDataHelper.shared.managedObjectContext()
        let request = NSFetchRequest<WeightData>.init(entityName: "WeightData")
        context.performAndWait {
            do{
                let result : [WeightData] = try context.fetch(request)
                self.data = result
            }catch {
                print("error while fetching coredata \(error)")
                self.data = []
            }
        }
    }
    
}

