//
//  ViewController.swift
//  AnyQuizz
//
//  Created by Илья Валито on 27.09.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    var appLogic = AppLogic()
    
    @IBOutlet private weak var categoryPicker: UIPickerView!
    @IBOutlet private weak var numberOfQuestionsLabel: UILabel!
    @IBOutlet private weak var numberOfQuestionsSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        
        categoryPicker.selectRow(18, inComponent: 0, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startQuiz" {
            DispatchQueue.main.async {
                let destinationVC = segue.destination as! QuizQuestionsViewController
                let questionsNumber =  self.numberOfQuestionsLabel.text ?? ""
                if self.categoryPicker.selectedRow(inComponent: 0) == 18 {
                    DispatchQueue.main.async {
                        destinationVC.questionManager.performRequest(numberOfQuestions: questionsNumber)
                    }
                } else {
                    let title = self.pickerView(self.categoryPicker, titleForRow: self.categoryPicker.selectedRow(inComponent: 0), forComponent: 0) ?? "Random"
                    let questionsCategory = self.appLogic.categoriesDictionary[title]
                    DispatchQueue.main.async {
                        destinationVC.questionManager.performRequest(category: questionsCategory ?? 0, numberOfQuestions: questionsNumber)
                        
                    }
                }
            }
        } else if segue.identifier == "showResults" {
            appLogic.loadItems()
            let destinationVC = segue.destination as! ResultsViewController
            destinationVC.appLogic = appLogic
        }
    }
    
    @IBAction private func sliderValueChanged() {
        numberOfQuestionsLabel.text = "\(Int(numberOfQuestionsSlider.value))"
    }
    
    @IBAction func unwindToFirstScreen(_ segue: UIStoryboardSegue) {
    }
}

extension MainViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        appLogic.categoriesArray.count
    }
}
extension MainViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        appLogic.categoriesArray[row]
    }
    
    // autoresize the text to fit in row
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        label.text =  appLogic.categoriesArray[row]
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        let color = #colorLiteral(red: 0.3240146041, green: 0.4451152086, blue: 0.4160501361, alpha: 1)
        label.textColor = color
        return label
    }
}

