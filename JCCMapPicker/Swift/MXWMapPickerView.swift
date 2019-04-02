//
//  MXWMapPickerView.swift
//  UrawaSwift
//
//  Created by CHARS on 2019/4/1.
//  Copyright © 2019 chars. All rights reserved.
//

import UIKit

protocol MXWMapPickerViewCallBack: AnyObject {
    func mapPickerDidTapSubmit(result: MXWLocationModel)
    func mapPickerDidTapCancel()
}

let columnCount = 3 // 列数
let pickerViewLabelHeight: CGFloat = 30.0

class MXWMapPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    public static let height: CGFloat = 200.0

    public weak var delegate: MXWMapPickerViewCallBack?

    private var cancelButton: UIButton!
    private var submitButton: UIButton!
    private var pickerView: UIPickerView!

    private var provinces: [MXWProvince]!
    private var cities: [MXWCity]!
    private var districts: [MXWDistrict]!

    private var location: MXWLocationModel = MXWLocationModel()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        initSubviews()
        loadMapData()
    }

    // MARK: - Private

    private func initSubviews() {
        backgroundColor = UIColor.white
        let size = bounds.size
        let buttonH: CGFloat = 40.0

        cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: buttonH))
        cancelButton.setTitle(cancelTitle, for: UIControl.State.normal)
        cancelButton.setTitleColor(UIColor(rgb: 0x515151), for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        cancelButton.addTarget(self, action: #selector(MXWMapPickerView.cancelButtonAction), for: .touchUpInside)
        addSubview(cancelButton)

        submitButton = UIButton(frame: CGRect(x: size.width - 60, y: 0, width: 60, height: buttonH))
        submitButton.setTitle(confirmTitle, for: UIControl.State.normal)
        submitButton.setTitleColor(UIColor(rgb: 0x1296DB), for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        submitButton.addTarget(self, action: #selector(MXWMapPickerView.submitButtonAction), for: .touchUpInside)
        addSubview(submitButton)

        pickerView = UIPickerView(frame: CGRect(x: 10.0, y: buttonH, width: size.width - 10.0 * 2, height: 160.0))
        pickerView.clipsToBounds = true
        pickerView.delegate = self
        pickerView.dataSource = self
        addSubview(pickerView)
    }

    @objc func cancelButtonAction() {
        delegate?.mapPickerDidTapCancel()
    }

    @objc func submitButtonAction() {
        delegate?.mapPickerDidTapSubmit(result: location)
    }

    // MARK: - Data

    private func loadMapData() {
        let path = Bundle.main.path(forResource: "china_cities_v3", ofType: "json") ?? ""
        let url = URL(fileURLWithPath: path)
        do {
            /*
             * try 和 try! 的区别
             * try 发生异常会跳到catch代码中
             * try! 发生异常程序会直接crash
             */
            let data = try Data(contentsOf: url)
            let provinces: [MXWProvince] = try JSONDecoder().decode([MXWProvince].self, from: data)
            self.provinces = provinces
            let province: MXWProvince = provinces.first!
            cities = province.cities
            let city: MXWCity = province.cities.first!
            districts = city.districts
            let district: MXWDistrict = districts.first!

            let location: MXWLocationModel = MXWLocationModel()
            location.province = province.name
            location.city = city.name
            location.district = district.name
            self.location = location
        } catch let error {
            print("读取本地数据文件出错！", error)
        }
    }

    private func object(objects: [Any], index: Int) -> Any? {
        if objects.count > index && index >= 0 {
            return objects[index]
        }
        return nil
    }

    private func setModel(row: Int, component: Int) {
        if 0 == component, let p = self.provinces {
            let province: MXWProvince = object(objects: p, index: row) as! MXWProvince
            location.province = province.name

            if let cities: [MXWCity] = province.cities {
                let city: MXWCity = cities.first!
                location.city = city.name

                if let districts: [MXWDistrict] = city.districts {
                    let district: MXWDistrict = districts.first!
                    location.district = district.name
                } else {
                    location.district = ""
                }
            }
        } else if 1 == component, let c = self.cities {
            let city: MXWCity = object(objects: c, index: row) as! MXWCity
            location.city = city.name
            if let districts: [MXWDistrict] = city.districts {
                let d: MXWDistrict = districts.first!
                location.district = d.name
            } else {
                location.district = ""
            }
        } else if 2 == component, let d = self.districts {
            let district: MXWDistrict = object(objects: d, index: row) as! MXWDistrict
            location.district = district.name
        }
    }

    public func setSelected(location: MXWLocationModel) {
        self.location = location

        var pIndex: Int = 0
        for cur: MXWProvince in provinces {
            if cur.name == location.province {
                break
            }
            pIndex = pIndex + 1
        }

        let p: MXWProvince = object(objects: provinces, index: pIndex) as! MXWProvince
        var cIndex: Int = 0
        var dIndex: Int = 0
        if let cities: [MXWCity] = p.cities {
            for cur: MXWCity in cities {
                if cur.name == location.city {
                    break
                }
                cIndex = cIndex + 1
            }

            let c: MXWCity = object(objects: cities, index: cIndex) as! MXWCity
            if let districts: [MXWDistrict] = c.districts {
                for cur: MXWDistrict in districts {
                    if cur.name == location.district {
                        break
                    }
                    dIndex = dIndex + 1
                }

                self.districts = districts
            } else {
                self.districts = nil
            }

            self.cities = cities
        } else {
            self.cities = nil
        }

        pickerView.reloadAllComponents()

        pickerView.selectRow(pIndex, inComponent: 0, animated: false)
        pickerView.selectRow(cIndex, inComponent: 1, animated: false)
        pickerView.selectRow(dIndex, inComponent: 2, animated: false)
    }

    // MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if 0 == component, let p = self.provinces {
            let province: MXWProvince = object(objects: p, index: row) as! MXWProvince
            return province.name
        } else if 1 == component, let c = self.cities {
            let city: MXWCity = object(objects: c, index: row) as! MXWCity
            return city.name
        } else if 2 == component, let d = self.districts {
            let district: MXWDistrict = object(objects: d, index: row) as! MXWDistrict
            return district.name
        } else {
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width / CGFloat(columnCount), height: pickerViewLabelHeight))
        label.font = UIFont(name: "Avenir-Light", size: 14.0)
        label.textColor = UIColor(rgb: 0x333333)
        label.textAlignment = .center
        label.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if 0 == component, let p = self.provinces {
            let province: MXWProvince = object(objects: p, index: row) as! MXWProvince
            cities = province.cities
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)

            let city: MXWCity = object(objects: cities, index: 0) as! MXWCity
            districts = city.districts
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        } else if 1 == component, let c = self.cities {
            let city: MXWCity = object(objects: c, index: row) as! MXWCity
            districts = city.districts
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        }
        setModel(row: row, component: component)
    }

    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return columnCount
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count = 0
        if 0 == component, let p = provinces {
            count = p.count
        } else if 1 == component, let c = cities {
            count = c.count
        } else if 2 == component, let d = districts {
            count = d.count
        } else {
            count = 0
        }
        return count
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(0.5)
        context?.setStrokeColor(UIColor(rgb: 0xBFBFBF).cgColor)
        context?.move(to: CGPoint(x: 0, y: 0))
        context?.addLine(to: CGPoint(x: bounds.width, y: 0))
        context?.strokePath()
    }
}
