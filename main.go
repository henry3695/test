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
var g_url_str string

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

	//sEnc := string(body)
	//log.Println(sEnc)
	//uDec, err := base64.StdEncoding.DecodeString(sEnc)
	//if err != nil {
	//	log.Println("Error:", err)
	//	return ""
	//}
	//fmt.Println(string(uDec))
	return string(body)
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

func filter_node(prefix string,b64 bool) string{
	str_t:=""
	str := g_node_str		
	parts := strings.Split(str, "\n")				
	for _, part := range parts {		
		// 判断字符串是否以指定的前缀开头
		if strings.HasPrefix(part, prefix) {
			fmt.Println(part)
			str_t+=part
			str_t+="\n"
		} 			
	}
	if  b64 {
		str_t= base64.StdEncoding.EncodeToString([]byte(str_t))
	}
	return str_t
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
	if r.URL.Path == "/url.asp" {
		fmt.Fprintf(w, g_url_str)
	} else if r.URL.Path == "/node.asp" {
		//fmt.Fprintf(w, g_node_str) //这个写入到w的是输出到客户端的
		w.Write([]byte(g_node_str));
	} else if r.URL.Path == "/node64.asp" {
		fmt.Fprintf(w, base64.StdEncoding.EncodeToString([]byte(g_node_str))) //这个写入到w的是输出到客户端的
	} else if r.URL.Path == "/node_t.asp" {
		prefix := "trojan://"
		str_t:=filter_node(prefix,false)
		w.Write([]byte(str_t));
	} else if r.URL.Path == "/node_t64.asp" {
		prefix := "trojan://"
		str_t:=filter_node(prefix,true)
		w.Write([]byte(str_t));
	}  else if r.URL.Path == "/node_s.asp" {
		prefix := "ss://"
		str_t:=filter_node(prefix,false)
		w.Write([]byte(str_t));
	} else if r.URL.Path == "/node_s64.asp" {
		prefix := "ss://"
		str_t:=filter_node(prefix,true)
		w.Write([]byte(str_t));
	} else if r.URL.Path == "/abc.asp" {
		for k, v := range r.Form {
			fmt.Println("key:", k)
			fmt.Println("val:", strings.Join(v, ""))
			if k == "url" {
				url := strings.Join(v, "")
				str := get_node_str(url)
				g_node_str = str
				fmt.Fprintf(w, url)
				fmt.Fprintf(w, "\n")
				w.Write([]byte(g_node_str));
				break
			}
		}
	} else {
		w.WriteHeader(404)
	}
}

func get_node_str(targetURL string) string {
	proxyURL := "http://192.168.101.200:9201" // 代理服务器地址和端口
	log.Printf(targetURL)
	str := GetNodeData(proxyURL, targetURL)
	log.Printf(str)

	g_url_str += targetURL
	g_url_str += "\n"
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
