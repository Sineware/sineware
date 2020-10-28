package main

import (
	"fmt"
	"net/http"
	"net"
	"strings"
)

func main() {
	// Print Status Screen Box
	fmt.Print("\033[2J \u001B[1;1H")
	for i := 0; i < 80; i++ {
        fmt.Print("-")
    }
	fmt.Print("\u001B[24;1H")
	for i := 0; i < 80; i++ {
		fmt.Print("-")
	}
	for i := 2; i < 24; i++ {
		fmt.Printf("\033[%d;1H|", i)
       	fmt.Printf("\033[%d;80H|", i)
    }
    // Status Text (temp)
	fmt.Print("\u001B[4;4H Welcome to \u001b[35mSineware\u001b[0m!")
	fmt.Print("\u001B[6;4H System Status: \u001b[33mUnknown\u001B[0m")

	fmt.Printf("\u001B[10;4H IP Address: \u001b[32m%s\u001B[0m", findIPAddress())
	fmt.Print("\u001B[11;4H The Web Interface is available on port 8086.")
	fmt.Print("\u001B[12;4H Press Ctrl+Alt+F2 to access the command line.")

	// HTTP Server (JSON API)
	http.HandleFunc("/", HelloServer)
    http.ListenAndServe(":8086", nil)
}

// https://stackoverflow.com/a/22951591
func findIPAddress() string {
	if interfaces, err := net.Interfaces(); err == nil {
		for _, interfac := range interfaces {
			if interfac.HardwareAddr.String() != "" {
				if strings.Index(interfac.Name, "en") == 0 ||
					strings.Index(interfac.Name, "eth") == 0 {
					if addrs, err := interfac.Addrs(); err == nil {
						for _, addr := range addrs {
							if addr.Network() == "ip+net" {
								pr := strings.Split(addr.String(), "/")
								if len(pr) == 2 && len(strings.Split(pr[0], ".")) == 4 {
									return pr[0]
								}
							}
						}
					}
				}
			}
		}
	}
	return ""
}

func HelloServer(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello, %s!", r.URL.Path[1:])
}