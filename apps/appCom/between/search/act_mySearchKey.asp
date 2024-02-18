<%@  codepage="65001" language="VBScript" %>
<%
option Explicit
Response.Buffer = True
Response.CharSet = "UTF-8"
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
dim mode, keyword, arrMyKwd, arrCKwd, rstKwd, i

mode = requestCheckVar(request("mode"),3)
keyword = requestCheckVar(request("kwd"),100)

Select Case mode
	Case "del"
		arrCKwd = session("mySearchKey")
		arrCKwd = split(arrCKwd,",")

		rstKwd = ""
		if ubound(arrCKwd)>-1 then
			for i=0 to ubound(arrCKwd)
				if trim(arrCKwd(i))<>trim(keyword) then
					rstKwd = rstKwd & chkIIF(rstKwd="","",",") & arrCKwd(i)
				end if
				if i>9 then Exit For
			next
		end if

	Case else
		rstKwd = ""
End Select
session("mySearchKey") = rstKwd

'결과 출력
if rstKwd<>"" then 
	Response.Write "<strong class=""txtTopGry"">나의 검색어</strong>" & vbCrLf
	Response.Write "<ul>" & vbCrLf
	arrMyKwd = split(rstKwd,",")

	for i=0 to ubound(arrMyKwd)
		Response.Write "<li><a href=""/apps/appCom/between/search/result.asp?rect=" & server.URLEncode(arrMyKwd(i)) & "&exkw=1"">" & arrMyKwd(i) & "</a> <button type=""button"" class=""btnDel"" onclick=""delMyKeyword('"&server.URLEncode(arrMyKwd(i))&"');return false;"">삭제</button></li>" & vbCrLf
		if i>=9 then Exit For
	next

	Response.Write "</ul>" & vbCrLf
	Response.Write "<button type=""button"" class=""btnAll"" onclick=""delMyKeywordAll();return false;"">나의 검색어 전체삭제</button>" & vbCrLf
else
	Response.Write "<strong class=""txtTopGry"">나의 검색어</strong>" & vbCrLf
	Response.Write "<p class=""noKeyword"">최근 검색내역이 없습니다</p>" & vbCrLf
end if
%>