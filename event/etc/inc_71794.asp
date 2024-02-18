<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Dim vEventDay, vDay, i, vTemp
	'vEventDay = CDate("2016-11-17")
	vEventDay = CDate("2016-11-17")
	vDay = DateDiff("d",date(),vEventDay)
	
	For i=0 To Len(vDay)-1
		vTemp = vTemp & "<i><img src=""http://webimage.10x10.co.kr/eventIMG/2016/71794/m/img_no_0" & Mid(vDay,(i+1),1) & ".png"" alt=""" & Mid(vDay,(i+1),1) & """></i>"
	Next
	
	Response.Write vTemp
%>