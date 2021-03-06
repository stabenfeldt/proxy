package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
)

var (
	ordersURL     = "https://esi.evetech.net/latest/markets/10000002/orders/?datasource=tranquility&order_type=all&page=1"
	lookupNameURL = "https://esi.evetech.net/latest/universe/names/?datasource=tranquility"
)

// The Order object
type Order struct {
	Duration     int     `json:"duration"`
	lsBuyOrder   bool    `json:"Is_buy_order"`
	Issued       string  `json:"Issued"`
	LocationID   int     `json:"Location_id"`
	MinVolume    int     `json:"Min_volume"`
	OrderID      int     `json:"Order_id"`
	Price        float64 `json:"Price"`
	Range        string  `json:"range"`
	Region       string  `json:"region"`
	SystemID     int     `json:"System_id"`
	TypeID       TypeID  `json:"Type_id"`
	VolumeRemain int     `json:"Volume_remain"`
	VolumeTotal  int     `json:"Volume_total"`
	Name         string  `json:"Name"`
	Age          int     `json:"Age"`
}

// Orders contain a list of Orders
type Orders []Order
type TypeIDs []TypeID
type TypeID int

// TypeIDs returns a list of all type_ids found in this list
func (o Orders) TypeIDs() TypeIDs {
	var typeIDs TypeIDs
	for _, order := range o {
		typeIDs = append(typeIDs, order.TypeID)
	}
	return typeIDs
}

func main() {
	fmt.Println("main")
	orders := getOrders()
	// Extract type_ids
	typeIDs := orders.TypeIDs()
	fmt.Println("Printing typeIDs: ", typeIDs)
	fmt.Println("Printing names: ", getNames(typeIDs))
}

func getNames(ids TypeIDs) string {
	//Encode the data
	//   "[11289, 47930, 2400, 20424, 21857, 22112, 43699, 20353, 11859, 14047]"}
	postBody, _ := json.Marshal(ids)
	responseBody := bytes.NewBuffer(postBody)
	//Leverage Go's HTTP Post function to make request
	resp, err := http.Post(lookupNameURL, "application/json", responseBody)
	//Handle Error
	if err != nil {
		log.Fatalf("An Error Occured %v", err)
	}
	defer resp.Body.Close()
	//Read the response body
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatalln(err)
	}
	sb := string(body)
	log.Printf(sb)

	return sb

}

// func extractKey(orders []Order, keyName string) []string {
// 	first := orders[0]
// 	fmt.Println("first: ", first.TypeID)
// 	return []string{"first"}
// }

// func (u Users) NameList() []string {
// 	var list []string
// 	for _, user := range u {
// 		list = append(list, user.UserName)
// 	}
// 	return list
// }

func getOrders() Orders {
	resp, err := http.Get(ordersURL)
	defer resp.Body.Close()

	if err != nil {
		log.Fatal("Failed to fetch orders: ", err)
	}

	response, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatalln(err)
	}

	// fmt.Println(string(response))

	var orders []Order

	if err := json.Unmarshal(response, &orders); err != nil {
		log.Fatal(err)
	}
	// fmt.Printf("Orders: %+v", orders)
	return orders
}
