package filesystem

import (
	"encoding/json"
	"fmt"
	"os"
	"strings"
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
		Permissions uint32 `json:"permissions"`
		Size        int64  `json:"size"`
		Owner       string `json:"owner"`
		IsLink      bool   `json:"is_link"`
		LinkTarget  string `json:"link_target"`
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

			fullPath := p.Path + "/" + file.Name()

			lsinfo, err := os.Lstat(fullPath)
			if err == nil {
				item.Permissions = uint32(lsinfo.Mode())
				item.Size = lsinfo.Size()
			}

			item.Owner = getFileOwner(fullPath)

			if lsinfo.Mode()&os.ModeSymlink != 0 {
				item.IsLink = true
				fmt.Println("link detected: ", fullPath)
				resolvedPath, err := os.Readlink(fullPath)
				if !strings.HasPrefix(resolvedPath, "/") {
					resolvedPath = "/" + resolvedPath
				}
				item.LinkTarget = resolvedPath
				if err == nil {
					fmt.Println("link path: ", resolvedPath)
					resolvedFileInfo, err := os.Stat(resolvedPath)
					if err == nil {
						fmt.Println("link resolve result:", resolvedFileInfo)
						if resolvedFileInfo.IsDir() {
							fmt.Println("link resolve result (ISDIR):", resolvedFileInfo)
							item.IsDir = true
						}
					} else {
						fmt.Println("link resolve error", err)
					}
				} else {
					fmt.Println("link path error", err)
				}
			}

			r.Items = append(r.Items, item)
		}
	}

	return json.MarshalIndent(r, "", " ")
}
