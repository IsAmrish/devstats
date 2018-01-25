package devstats

import (
	"fmt"
	"os"
	"time"

	"github.com/lib/pq"
)

// FatalOnError displays error message (if error present) and exits program
func FatalOnError(err error) string {
	if err != nil {
		tm := time.Now()
		Printf("Error(time=%+v):\n%v\nError: '%s'\nStacktrace:\n", tm, err, err.Error())
		fmt.Fprintf(os.Stderr, "Error(time=%+v):\n%v\nError: '%s'\nStacktrace:\n", tm, err, err.Error())
		switch e := err.(type) {
		case *pq.Error:
			errName := e.Code.Name()
			if errName == "too_many_connections" {
				return Retry
			}
		}
		panic("stacktrace")
	}
	return "ok"
}
