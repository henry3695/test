package main

import (
	"fmt"
	"net/http"
	"time"
)

func sendGetRequest(url string) {
	resp, err := http.Get(url)
	if err != nil {
		fmt.Printf("Error sending GET request: %v\n", err)
		return
	}
	defer resp.Body.Close()
	fmt.Printf("GET request sent to %s at %s, Status: %s\n", url, time.Now().Format(time.RFC1123), resp.Status)
}

func scheduleRequests(url string) {
	// 定义目标时间（小时和分钟）
	targetTimes := []struct {
		hour int
		min  int
	}{
		{23, 55}, // 23:55
		{7, 55},  // 7:55
		{15, 55}, // 15:55
	}

	for {
		now := time.Now()
		nextRun := time.Date(now.Year(), now.Month(), now.Day(), 23, 55, 0, 0, now.Location())

		// 如果当前时间已经超过 23:55，则调度到下一天的相同时间
		if now.After(nextRun) {
			nextRun = nextRun.Add(24 * time.Hour)
		}

		// 检查其他目标时间，找到最近的下一个运行时间
		for _, target := range targetTimes {
			checkTime := time.Date(now.Year(), now.Month(), now.Day(), target.hour, target.min, 0, 0, now.Location())
			if now.Before(checkTime) && checkTime.Before(nextRun) {
				nextRun = checkTime
			}
		}

		// 等待直到下一个目标时间
		time.Sleep(time.Until(nextRun))

		// 发送 GET 请求
		sendGetRequest(url)

		// 继续下一次调度
	}
}

func main() {
	url := "https://example.com" // 替换为实际的 URL
	fmt.Printf("Starting scheduler. Requests will be sent at 7:55, 15:55, and 23:55 daily.\n")

	// 启动调度
	go scheduleRequests(url)

	// 保持主 goroutine 运行
	select {}
}
