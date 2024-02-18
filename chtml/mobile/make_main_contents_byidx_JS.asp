<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
dim flgDevice: flgDevice="W"
%>
<%
'###########################################################
' History : 2007.11.09 한용민 수정
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/mobile/main_contents_managecls.asp" -->
<!-- #INCLUDE File="m_header.htm" -->
<%
'' 관리자 확정시 Data 작성. 
''response.write "수정중.."

dim i
dim poscode, idx
dim savePath, FileName, refip

poscode = requestCheckVar(Request("poscode"),32)
idx = requestCheckVar(Request("idx"),32)

savePath = server.mappath("/chtml/js/") + "\"

'모바일 경로로 변환
IF application("Svr_Info")="Dev" THEN
	'테스트서버
	savePath = Replace(savePath,"2012www","m")
Else
	'실서버
	savePath = Replace(savePath,"2012www","mobile")
End If


refip = request.ServerVariables("HTTP_REFERER")

if (InStr(refip,"10x10.co.kr")<1)  then
	response.write "not valid Referer"
	response.end
end if

if (Len(idx)<1) then
	response.write "not valid cd"
	response.end
end if


dim ocontents
set ocontents = New CMainContents
ocontents.FRectidx= idx
ocontents.GetOneMainContents

if (ocontents.FResultCount<1) then
    response.write "no valid data Exists"
	response.end
end if

FileName = "main_" + CStr(ocontents.FOneItem.Fposcode) + ".js"

dim fso, tFile, BufStr
dim VarName, DoubleQuat, VarTodayStr
VarName = ocontents.FOneItem.FposVarname
DoubleQuat = Chr(34)
VarTodayStr = "V_CURRENTYYYYMM"

If ocontents.FResultCount>0 Then
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set tFile = fso.CreateTextFile(savePath & FileName )
	If ocontents.FOneItem.Fposcode = "1003" Then
		BufStr = ""
		BufStr = "var " + VarName + ";" + VbCrlf
		BufStr = BufStr + VarName + " = " + DoubleQuat + DoubleQuat + ";" + VbCrlf
		BufStr = BufStr + VarName + "+=" + DoubleQuat + "<div class='bnrFull' style='background:" + ocontents.FOneItem.FbackColor + "'>" + DoubleQuat + VbCrlf
		BufStr = BufStr + VarName + "+=" + DoubleQuat + "	<a href='" + ocontents.FOneItem.Flinkurl + "'><img src='" + ocontents.FOneItem.GetImageUrl + "' width='320' height='55'></a>" + DoubleQuat + VbCrlf
		BufStr = BufStr + VarName + "+=" + DoubleQuat + "</div>" + DoubleQuat + VbCrlf
	    BufStr = BufStr + "document.write(" + VarName + ");" + VbCrlf
	Else
	    BufStr = ""
	    BufStr = "var " + VarName + ";" + VbCrlf
	    BufStr = BufStr + VarName + " = " + DoubleQuat + DoubleQuat + ";" + VbCrlf
	    BufStr = BufStr + VarName + "+=" + DoubleQuat + "<table border='0' cellspacing='0' cellpadding='0'>" + DoubleQuat + VbCrlf
	    If ocontents.FOneItem.Flinktype="M" Then 
	        BufStr = BufStr + VarName + "+=" + DoubleQuat + "       <tr><td><img src='" + ocontents.FOneItem.GetImageUrl + "' width='" + ocontents.FOneItem.Fimagewidth + "' " + ocontents.FOneItem.getImageHeightStr + " border='0' usemap='#Map_" + VarName + "'></td></tr>" + DoubleQuat + VbCrlf
	        BufStr = BufStr + VarName + "+=" + DoubleQuat + Replace(Replace(ocontents.FOneItem.Flinkurl,VbCrlf," "),DoubleQuat, "\" & DoubleQuat) + DoubleQuat + VbCrlf
	    Else
	        BufStr = BufStr + VarName + "+=" + DoubleQuat + "       <tr><td><a href='" + ocontents.FOneItem.Flinkurl + "' onFocus='blur()'><img src='" + ocontents.FOneItem.GetImageUrl + "' width='" + ocontents.FOneItem.Fimagewidth + "' " + ocontents.FOneItem.getImageHeightStr + " border='0'></a></td></tr>" + DoubleQuat + VbCrlf
	    End If
	    BufStr = BufStr + VarName + "+=" + DoubleQuat + "</table>" + DoubleQuat + VbCrlf
	    BufStr = BufStr + "document.write(" + VarName + ");" + VbCrlf
	End If
	    tFile.Write BufStr
	    tFile.Close
    
    Set tFile = Nothing
    Set fso = Nothing
End If
%>
<script language='javascript'>
alert("\'<%=FileName%>\'파일 생성 완뇨!");
self.close();
</script>
<%
	set ocontents = Nothing
%>
<!-- #INCLUDE file="m_footer.htm" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->
