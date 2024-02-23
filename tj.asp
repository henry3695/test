package main

import (
	"encoding/base64"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"net/url"
	"strings"
)

var g_node_str string
var g_chk_ip string

func GetNodeData(proxyURL string, targetURL string) string {
	// 创建代理URL
	proxyURLParsed, err := url.Parse(proxyURL)
	if err != nil {
		fmt.Println("Error:", err)
		return ""
	}

	var response *http.Response
	// 创建代理客户端
	if targetURL != "" {
		proxyClient := &http.Client{
			Transport: &http.Transport{
				Proxy: http.ProxyURL(proxyURLParsed),
			},
		}

		// 发送GET请求通过代理
		response, err = proxyClient.Get(targetURL)
		if err != nil {
			fmt.Println("Error:", err)
			return ""
		}
	} else {
		// 发送GET请求
		response, err = http.Get(targetURL)
		if err != nil {
			fmt.Println("Error:", err)
			return ""
		}
	}

	// 自定义请求头
	//response.Header.Add("User-Agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1")

	defer response.Body.Close()

	// 读取响应内容
	body, err := ioutil.ReadAll(response.Body)
	if err != nil {
		fmt.Println("Error:", err)
		return ""
	}

	sEnc := string(body)
	//log.Println(sEnc)
	uDec, err := base64.StdEncoding.DecodeString(sEnc)
	if err != nil {
		log.Println("Error:", err)
		return ""
	}
	//fmt.Println(string(uDec))
	return string(uDec)
}

// 通过map主键唯一的特性过滤重复元素
func removeDuplicate(arr []string) []string {
	resArr := make([]string, 0)
	tmpMap := make(map[string]interface{})
	for _, val := range arr {
		//判断主键为val的map是否存在
		if _, ok := tmpMap[val]; !ok {
			resArr = append(resArr, val)
			tmpMap[val] = nil
		}
	}

	return resArr
}

func readLinesFromFile(filePath string) ([]string, error) {
	// 读取整个文件内容
	content, err := ioutil.ReadFile(filePath)
	if err != nil {
		fmt.Println("无法读取文件:", err)
		return nil, err
	}

	lines := strings.Split(string(content), "\r\n")
	return lines, nil
}
func sayhelloName(w http.ResponseWriter, r *http.Request) {
	r.ParseForm()       //解析参数，默认是不会解析的
	fmt.Println(r.Form) //这些信息是输出到服务器端的打印信息
	fmt.Println("path", r.URL.Path)
	fmt.Println("scheme", r.URL.Scheme)
	fmt.Println(r.Form["url_long"])
	for k, v := range r.Form {
		fmt.Println("key:", k)
		fmt.Println("val:", strings.Join(v, ""))
	}

	r.ParseForm()
	fmt.Println("path", r.URL.Path)

	ary := strings.Split(r.RemoteAddr, ":")
	ip := ary[0]
	fmt.Println(ip)
	if r.URL.Path == "/node.asp" /*&& ip == g_chk_ip*/ {
		fmt.Fprintf(w, g_node_str) //这个写入到w的是输出到客户端的
	} else if r.URL.Path == "/abc.asp" {
		//g_chk_ip = ary[0]
		//fmt.Fprintf(w, g_chk_ip)

		for k, v := range r.Form {
			fmt.Println("key:", k)
			fmt.Println("val:", strings.Join(v, ""))
			if k == "url" {
				url := strings.Join(v, "")
				str := get_node_str(url)
				g_node_str = base64.StdEncoding.EncodeToString([]byte(str))
				fmt.Fprintf(w, url)
				break
			}
		}
	} else {
		w.WriteHeader(404)
	}
}

func get_node_str(targetURL string) string {
	//proxyURL := ""
	proxyURL := "http://127.0.0.1:9201" // 代理服务器地址和端口
	//targetURL := "https://dlink.host/1drv/aHR0cHM6Ly8xZHJ2Lm1zL3QvcyFBbm5oU0ZGT0NGX05oeVFzOEZvMXp0V25CV3E0P2U9NDFiTDBX.jpg" // 要请求的目标URL
	log.Printf(targetURL)
	str := GetNodeData(proxyURL, targetURL)
	log.Printf(str)
	return str
}

func get_node_str11() string {
	filePath := "url_addr.txt"
	lines, err1 := readLinesFromFile(filePath)
	if err1 != nil {
		fmt.Println("无法读取文件:", err1)
		return ""
	}

	// 输出切片中的每行数据
	var str string
	for _, line := range lines {
		if len(line) > 0 {
			log.Printf(line)

			proxyURL := "http://192.168.101.160:9200" // 代理服务器地址和端口
			targetURL := line                         // 要请求的目标URL
			str1 := GetNodeData(proxyURL, targetURL)
			str += str1
		}
	}

	strArr := strings.Split(str, "\n")
	log.Println(len(strArr))
	arystr := removeDuplicate(strArr)
	log.Println(len(arystr))
	str = ""
	for i := 0; i < len(arystr); i++ {
		str += arystr[i] + "\n"
	}

	//log.Printf(str)
	return str
}
func main() {
	log.Println("start listen:7005")
	http.HandleFunc("/", sayhelloName)       //设置访问的路由
	err := http.ListenAndServe(":7005", nil) //设置监听的端口
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}

}
