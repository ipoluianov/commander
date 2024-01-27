package filesystem

import (
	"encoding/json"
	"os"
)

func Dirs(pb []byte) ([]byte, error) {
	// Parse parameters
	type P struct {
		Path string `json:"path"`
	}
	var p P
	err := json.Unmarshal(pb, &p)
	if err != nil {
		return nil, err
	}

	// Prepare result
	type Item struct {
		Name string `json:"name"`
	}
	type R struct {
		Items []Item `json:"items"`
	}
	var r R

	// Action
	{
		files, err := os.ReadDir(p.Path)
		if err != nil {
			return nil, err
		}

		for _, file := range files {
			r.Items = append(r.Items, Item{Name: file.Name()})
		}
	}

	return json.MarshalIndent(r, "", " ")
}
