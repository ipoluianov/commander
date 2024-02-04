package main

import "C"
import (
	"commander_go/filesystem"
	"encoding/json"
	"fmt"
	"sync"
)

// go build -o mylib.dylib -buildmode=c-shared

type Transaction struct {
	Id      int64
	Input   []byte
	Started bool
	Ready   bool
	Output  []byte
}

var nextTransactionId int64
var transactions map[int64]*Transaction
var mtx sync.Mutex

func init() {
	transactions = make(map[int64]*Transaction)
	nextTransactionId = 1
}

func exec(tr *Transaction) {
	type Func struct {
		FuncName string `json:"f"`
	}
	var a Func
	json.Unmarshal(tr.Input, &a)
	if a.FuncName == "filesystem_dirs" {
		res, err := filesystem.Dirs(tr.Input)
		if err != nil {
			fmt.Println("Go Error:", err)
			type Error struct {
				Error string `json:"err"`
			}
			var e Error
			e.Error = err.Error()
			bsError, _ := json.MarshalIndent(e, "", " ")
			tr.Output = append(tr.Output, bsError...)
			tr.Ready = true
		} else {
			fmt.Println("Go Success:", string(res))
			tr.Output = append(tr.Output, res...)
			tr.Ready = true
		}
	}
}

//export Begin
func Begin() int64 {
	mtx.Lock()
	trId := nextTransactionId
	nextTransactionId++
	var tr Transaction
	tr.Id = trId
	tr.Input = make([]byte, 0)
	tr.Output = make([]byte, 0)
	tr.Ready = false
	tr.Started = false
	transactions[trId] = &tr
	mtx.Unlock()
	return trId
}

//export Commit
func Commit(tId int64) int64 {
	mtx.Lock()
	delete(transactions, tId)
	mtx.Unlock()
	return 0
}

//export IsReady
func IsReady(tId int64) int64 {
	result := int64(0)
	mtx.Lock()
	if tr, trExists := transactions[tId]; trExists {
		if tr.Ready {
			result = 1
		}
	}
	mtx.Unlock()
	return result
}

//export In
func In(tId int64, a int64) uint64 {
	if (a & 0xFFFFFF00) == 0 {
		mtx.Lock()
		if tr, trExists := transactions[tId]; trExists {
			if !tr.Started {
				tr.Input = append(tr.Input, byte(a&0xFF))
			}
		}
		mtx.Unlock()
	} else {
		var tr *Transaction
		var trExists bool
		mtx.Lock()
		if tr, trExists = transactions[tId]; trExists {
			go exec(tr)
		}
		mtx.Unlock()
	}
	return 0
}

//export Out
func Out(tId int64) int64 {
	var result int64
	result = 0xFFFFFFFF
	mtx.Lock()
	if tr, trExists := transactions[tId]; trExists {
		if len(tr.Output) > 0 {
			result = int64(tr.Output[0])
			tr.Output = tr.Output[1:]
		}
	}
	mtx.Unlock()
	return result
}

func main() {
	filesystem.Dirs([]byte(`{"path":"/var/db"}`))

}
