package filesystem

import (
	"syscall"

	"golang.org/x/sys/windows"
)

func getFileOwner(fullPath string) string {
	result := ""
	var err error
	var securityDescriptor *windows.SECURITY_DESCRIPTOR
	securityDescriptor, err = windows.GetNamedSecurityInfo(fullPath, windows.SE_FILE_OBJECT, windows.OWNER_SECURITY_INFORMATION)
	if err != nil {
		return ""
	}
	sid, _, err := securityDescriptor.Owner()
	if err != nil {
		return ""
	}

	var accountSize uint32 = 50 // начальный размер буфера для имени аккаунта
	var domainSize uint32 = 50  // начальный размер буфера для имени домена
	var accountBuffer = make([]uint16, accountSize)
	var domainBuffer = make([]uint16, domainSize)
	var sidType uint32 = 0

	for {
		err = windows.LookupAccountSid(nil, sid, &accountBuffer[0], &accountSize, &domainBuffer[0], &domainSize, &sidType)
		if err == nil {
			break
		}
		if err != syscall.ERROR_INSUFFICIENT_BUFFER {
			return ""
		}
		// Размер буфера недостаточен, увеличиваем буферы
		accountBuffer = make([]uint16, accountSize)
		domainBuffer = make([]uint16, domainSize)
	}

	accountName := syscall.UTF16ToString(accountBuffer)
	domainName := syscall.UTF16ToString(domainBuffer)

	result = accountName + "/" + domainName

	return result
}
