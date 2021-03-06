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

// The Name object
type Name struct {
	Category      string `json:"category"`
	InventoryType string `json:"inventory_type"`
	ID            int    `json:"id"`
	Name          string `json:"name"`
}

// Orders contain a list of Orders
type Orders []Order

// TypeIDs is a list of TypeID
type TypeIDs []TypeID

// TypeID is an int which represents a type
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
	orders := getOrders()
	typeIDs := orders.TypeIDs()
	names := getNames(typeIDs)

	// Print all names
	for _, n := range names {
		fmt.Println(n.Name)
	}

}

func getNames(ids TypeIDs) []Name {
	// Extract the 10 first elements from the list
	// We don´t need the entire list for this POC
	ids = ids[1:10]

	postBody, _ := json.Marshal(ids)
	responseBody := bytes.NewBuffer(postBody)

	// Make a POST request to fetch the names
	resp, err := http.Post(lookupNameURL, "application/json", responseBody)
	if err != nil {
		log.Fatalf("An Error Occured %v", err)
	}
	defer resp.Body.Close()
	response, err := ioutil.ReadAll(resp.Body)

	// Prepare to extract the names from the response
	var names []Name
	if err := json.Unmarshal(response, &names); err != nil {
		log.Fatal(err)
	}

	return names
}

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

	var orders []Order
	if err := json.Unmarshal(response, &orders); err != nil {
		log.Fatal(err)
	}
	return orders
}
