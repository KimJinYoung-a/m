<%
'' APP 리다이렉션. push 메세지 길이 제한. ios app는 LCASE로 변환 되므로 http://bit.ly 사용하지 말것.
dim eventid : eventid=request("eventid")
response.redirect "http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&eventid
%>