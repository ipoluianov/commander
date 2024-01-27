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
		Name        string `json:"name"`
		IsDir       bool   `json:"is_dir"`
		Permissions uint32 `json:"premissions"`
		Size        int64  `json:"size"`
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
			var item Item
			item.Name = file.Name()
			item.IsDir = file.IsDir()
			item.Permissions = uint32(file.Type().Perm())
			info, err := file.Info()
			if err != nil {
				item.Size = info.Size()
			}
			r.Items = append(r.Items, item)
		}
	}

	return json.MarshalIndent(r, "", " ")
}
