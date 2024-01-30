package filesystem

import (
	"fmt"
	"os"
	"os/user"
	"syscall"
)

func getFileOwner(fullPath string) string {
	fileInfo, err := os.Stat(fullPath)
	if err == nil {
		uid := fileInfo.Sys().(*syscall.Stat_t).Uid
		u, err := user.LookupId(fmt.Sprint(uid))
		if err == nil {
			return u.Name
		}
	}
	return ""
}
