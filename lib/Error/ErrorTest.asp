<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%

Dim sentryErrorMsg, oJsonSentry

sentryErrorMsg = "{ ""clientName"" : ""10x10-asp-m"", ""message"" : ""Microsoft VBScript 런타임 오류 (0x800A000D)형식이 일치하지 않습니다.: 'CurrURLQ'"", ""tags"" : { ""file"" : ""/lib/inc/incaside.asp"", ""line"" : "", line 26"", ""remoteIp"" : ""61.252.133.76"", ""server"" : ""staging"" }, ""headers"" : { ""user-agent"" : ""Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36"", ""referer"" : """", ""host"" : ""stgm.10x10.co.kr"" }, ""request"" : { ""url"" : ""/lib/inc/incaside.asp"", ""method"" : ""GET"", ""data"" : """" }, ""user"" : { ""name"" : ""system"", ""ip"" : ""61.252.133.76"" } }"


set oJsonSentry = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")	'xmlHTTP컨퍼넌트 선언
oJsonSentry.open "POST", "http://aspsentry.10x10.co.kr/api/Sentry/CaptureError", False
oJsonSentry.setRequestHeader "Content-Type", "application/json; charset=utf-8"
oJsonSentry.setRequestHeader "key","lkzxljk-fqwo@i3J875qlkzLjdv"
oJsonSentry.setRequestHeader "CharSet", "utf-8" '있어도 되고 없어도 되고
oJsonSentry.setRequestHeader "Accept","application/json"
oJsonSentry.send sentryErrorMsg

response.write sentryErrorMsg


Set oJsonSentry = Nothing
%>