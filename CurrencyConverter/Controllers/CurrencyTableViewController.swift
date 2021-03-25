//
//  TableViewController.swift
//  CurrencyConverter
//
//  Created by Elmira on 21.03.21.
//

import UIKit


class CurrencyTableViewController: UITableViewController {
    
    let currencyUrl = "http://data.fixer.io/api/latest?access_key=521106e350f34133b6977f5404b1805d"
    let currencyCountriesUrl = "http://data.fixer.io/api/symbols?access_key=521106e350f34133b6977f5404b1805d"
    
    var managerViewController = ManagerViewController()
    
    //var currencyObjects: [CurrencyData] = []
    
    var currencies: [String] = []
    var values: [Double] = []
    var countries: [String] = []
    
    var activeCurrency: Double = 0
    var activeCurrencyLabel: String = ""
    
    //@IBOutlet weak var searchItemsBar: UISearchBar!
    
    public var completion: ((Double, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(named: "DarkBlue")
        performRequest()
        managerViewController.delegate = self
        //searchItemsBar.delegate = self
        managerViewController.fetchCurrency()
    }
    
    
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func performRequest(){
        if  let url = URL(string: currencyUrl) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    return
                }
                if let safeData = data {
                    do {
                        let myJson = try JSONSerialization.jsonObject(with: safeData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        if let results = myJson["rates"] as? NSDictionary {
                            for (key, value) in results {
                                if let currencyKey = key as? String, let currencyValue = value as? Double {
                                    self.currencies.append(currencyKey)
                                    self.values.append(currencyValue)
                                }
                            }
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    } catch {
                        print(error)
                    }
                 
                }
            }
            task.resume()
        }
        
    }
    
//    func parseJson(currencyData: Data) -> CurrencyData? {
//        let decoder = JSONDecoder()
//        do {
//            let decodedData = try decoder.decode(CurrencyData.self, from: currencyData)
//            let rates = decodedData.rates
//            //let symbols = decodedData.symbols
//            let currencyModel = CurrencyData(rates: rates)
//            return currencyModel
//        } catch {
//            print(error)
//            return nil
//        }
//    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        activeCurrency = values[indexPath.row]
        activeCurrencyLabel = currencies[indexPath.row]
        completion?(activeCurrency, activeCurrencyLabel)
    }
}

extension CurrencyTableViewController: ManagerViewControllerDelegate {
    func didUpdateCurrency(_ managerViewController: ManagerViewController, collection: [String]) {
        DispatchQueue.main.async{
            self.countries = collection
            self.tableView.reloadData()
        }
    }
}

//extension CurrencyTableViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        countries = countries.filter({ $0.contains(searchBar.text!) })
//        tableView.reloadData()
//    }
// 
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//    }
//}
