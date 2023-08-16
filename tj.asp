
<%

if request("my")<>"" then
	'response.write 	request("my")
	Application("my")=request("my")
end if

if request("my1")<>"" then
	'response.write 	request("my1")
	Application("my1")=request("my1")
end if

response.write Application("my")&"<br><br>"&Application("my1")
%>
<!DOCTYPE html>
 <html lang="zh-Hans">
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="style.css" type="text/css" media="all">
</head>
<body>
<form action="/tj.asp" method="post">

 <textarea style="margin-top:20px;border:0;border-radius:5px;background-color:rgba(241,241,241,.98);width: 655px;height: 150px;padding: 10px;resize: none;" placeholder="询价备注（尺寸、材质等）"></textarea>

  <textarea style="margin-top:20px;border:0;border-radius:5px;background-color:rgba(241,241,241,.98);width: 655px;height: 150px;padding: 10px;resize: none;" placeholder="询价备注（尺寸、材质等）"></textarea>
  <br><br>
<input type="submit" value="Submit" style="margin-top:20px;width:100px;height:60px">

</form>
</body>
</html>
