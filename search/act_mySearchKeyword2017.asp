<%@  codepage="65001" language="VBScript" %>
<%
option Explicit
Response.Buffer = True
Response.CharSet = "UTF-8"
'#######################################################
'	History	:  2013.10.03 허진원 생성
'			   2013.03.25 이종화 모바일 생성
'	Description : 나의 검색어 처리 및 출력
'#######################################################
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
dim mode, keyword, arrMyKwd, arrCKwd, rstKwd, i

mode = requestCheckVar(request("mode"),3)
keyword = requestCheckVar(request("kwd"),100)

Select Case mode
	Case "del"
		arrCKwd = session("myKeyword")
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

'쿠키 재저장
session("myKeyword") = rstKwd


'결과 출력
if rstKwd<>"" then 
	arrMyKwd = split(rstKwd,",")

	for i=0 to ubound(arrMyKwd)
		Response.Write "<li><a href=""/search/search_item.asp?rect=" & server.URLEncode(arrMyKwd(i)) & "&exkw=1"">" & arrMyKwd(i)
		Response.Write "</a><button type=""button"" class=""btn-del"" onclick=""delMyKeyword('" & server.URLEncode(arrMyKwd(i)) & "');return false;"">삭제</button></li>" & vbCrLf
		if i>=4 then Exit For
	next

end if
%>