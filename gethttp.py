import requests
import base64
headers = {
'User-Agent':'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.87 Safari/537.36',
}
url = 'https://ghproxy.com/https://raw.githubusercontent.com/Pawdroid/Free-servers/main/sub'
#等价下面的
response = requests.get(url, headers=headers).text
response = str(base64.b64decode(response))
response_split = response.split("\n")
#print(response_split)
for url in response_split:
    print(url)
