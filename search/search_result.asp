<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'' 링크를 잘못 건 경우가 있는듯함. search_item 으로 reirect . 인코딩방식 확인요망 2017/09/22 by eastone
'' 아래 IP 넣어서 찍어볼것.
'if (Request.ServerVariables("REMOTE_ADDR")="175.223.18.82") then
'    response.write request("rect")
'    response.end
'end if

dim mQrParam: mQrParam = request.QueryString		'// 유입 전체 파라메터 접수
Response.Redirect "/search/search_item.asp?" & mQrParam
REsponse.End
			
'dim rect : rect = request("rect")
'dim rdsite : rdsite= request("rdsite")
'if (rdsite<>"") then
'    response.redirect "/search/search_item.asp?rect="&rect&"&rdsite="&rdsite
'else
'    response.redirect "/search/search_item.asp?rect="&rect
'end if
%>