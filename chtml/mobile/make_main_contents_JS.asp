<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
dim flgDevice: flgDevice="W"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/mobile/main_contents_managecls.asp" -->
<!-- #INCLUDE File="m_header.htm" -->
<%
'' 관리자 확정시 Data 작성. 

dim i
dim poscode
dim savePath, FileName, refip

poscode = requestCheckVar(Request("poscode"),32)

'// 생성파일 경로 및 파일명 선언
savePath = server.mappath("/chtml/js/") + "\"
FileName = "main_" + CStr(poscode) + ".js"

'모바일 경로로 변환
IF application("Svr_Info")="Dev" THEN
	'테스트서버
	savePath = Replace(savePath,"2012www","m")
Else
	'실서버
	savePath = Replace(savePath,"2012www","mobile")
End If


'// 유입경로 확인
refip = request.ServerVariables("HTTP_REFERER")

if (InStr(refip,"10x10.co.kr")<1) then
	response.write "not valid Referer"
    response.end
end if

if (Len(poscode)<1) then
	response.write "not valid cd"
	response.end
end if


dim ocontents, ocontentsCode

'// 적용코드 확인
set ocontentsCode = new CMainContentsCode
ocontentsCode.FRectPoscode = poscode
ocontentsCode.GetOneContentsCode

if (ocontentsCode.FResultCount<1) then
    response.write "not valid cd value"
	response.end
end if

'// 메인 데이터 접수
set ocontents = New CMainContents
ocontents.FRectPoscode= poscode
ocontents.FPageSize=7
ocontents.GetMainContentsValidList

if (ocontents.FResultCount<1) then
    response.write "no valid data Exists"
	response.end
end if



dim fso, tFile, BufStr
dim VarName, DoubleQuat, VarTodayStr
VarName = ocontentsCode.FOneItem.FposVarname
DoubleQuat = Chr(34)
VarTodayStr = "V_CURRENTYYYYMM"


if ocontents.FResultCount>0 then
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set tFile = fso.CreateTextFile(savePath & FileName )
    BufStr = ""
    
    	    
    BufStr = "var " + VarName + ";" + VbCrlf
    BufStr = BufStr + VarName + " = " + DoubleQuat + DoubleQuat + ";" + VbCrlf
    	   
    BufStr = BufStr + VarName + "+=" + DoubleQuat + "<table border='0' cellspacing='0' cellpadding='0'>" + DoubleQuat + VbCrlf
    
    if  ocontents.FResultCount=1 then
        if ocontents.FItemList(i).Flinktype="M" then 
            BufStr = BufStr + VarName + "+=" + DoubleQuat + "       <tr><td><img src='" + ocontents.FItemList(i).GetImageUrl + "' width='" + ocontents.FItemList(i).Fimagewidth + "' " + ocontents.FItemList(i).getImageHeightStr + " border='0' usemap='#Map_" + VarName + "'></td></tr>" + DoubleQuat + VbCrlf
            BufStr = BufStr + VarName + "+=" + DoubleQuat + Replace(Replace(ocontents.FItemList(i).Flinkurl,VbCrlf," "),DoubleQuat, "\" & DoubleQuat) + DoubleQuat + VbCrlf
        else
            BufStr = BufStr + VarName + "+=" + DoubleQuat + "       <tr><td><a href='" + ocontents.FItemList(i).Flinkurl + "' onFocus='blur()'><img src='" + ocontents.FItemList(i).GetImageUrl + "' width='" + ocontents.FItemList(i).Fimagewidth + "' " + ocontents.FItemList(i).getImageHeightStr + " border='0'></a></td></tr>" + DoubleQuat + VbCrlf
        end if
    else
        BufStr = BufStr + " switch(true){"+ VbCrlf
        for i=0 to ocontents.FResultCount-1 
            BufStr = BufStr + "     case(" + VarTodayStr + ">='" + Left(CStr(ocontents.FItemList(i).FStartdate),10) + "'):"+ VbCrlf
            if ocontents.FItemList(i).Flinktype="M" then 
                BufStr = BufStr + VarName + "+=" + DoubleQuat + "       <tr><td><img src='" + ocontents.FItemList(i).GetImageUrl + "' width='" + ocontents.FItemList(i).Fimagewidth + "' " + ocontents.FItemList(i).getImageHeightStr + " border='0' usemap='#Map_" + VarName + "'></td></tr>" + DoubleQuat + VbCrlf
                BufStr = BufStr + VarName + "+=" + DoubleQuat + Replace(Replace(ocontents.FItemList(i).Flinkurl,VbCrlf," "),DoubleQuat, "\" & DoubleQuat) + DoubleQuat + VbCrlf
            else
                BufStr = BufStr + VarName + "+=" + DoubleQuat + "       <tr><td><a href='" + ocontents.FItemList(i).Flinkurl + "' onFocus='blur()'><img src='" + ocontents.FItemList(i).GetImageUrl + "' width='" + ocontents.FItemList(i).Fimagewidth + "' " + ocontents.FItemList(i).getImageHeightStr + " border='0'></a></td></tr>" + DoubleQuat + VbCrlf
            end if
            BufStr = BufStr + "     break;"+ VbCrlf
        next
        BufStr = BufStr + "     default:"+ VbCrlf
        
        if ocontents.FItemList(0).Flinktype="M" then 
            BufStr = BufStr + VarName + "+=" + DoubleQuat + "       <tr><td><img src='" + ocontents.FItemList(0).GetImageUrl + "' width='" + ocontents.FItemList(0).Fimagewidth + "' " + ocontents.FItemList(0).getImageHeightStr + " border='0' usemap='#Map_" + VarName + "'></td></tr>" + DoubleQuat + VbCrlf
            BufStr = BufStr + VarName + "+=" + DoubleQuat + Replace(Replace(ocontents.FItemList(0).Flinkurl,VbCrlf," "),DoubleQuat, "\" & DoubleQuat) + DoubleQuat + VbCrlf
        else
            BufStr = BufStr + VarName + "+=" + DoubleQuat + "       <tr><td><a href='" + ocontents.FItemList(0).Flinkurl + "' onFocus='blur()'><img src='" + ocontents.FItemList(0).GetImageUrl + "' width='" + ocontents.FItemList(0).Fimagewidth + "' " + ocontents.FItemList(0).getImageHeightStr + " border='0'></a></td></tr>" + DoubleQuat + VbCrlf
        end if
        
        BufStr = BufStr + "     break;"+ VbCrlf
        BufStr = BufStr + " }"+ VbCrlf
    end if
    
    BufStr = BufStr + VarName + "+=" + DoubleQuat + "</table>" + DoubleQuat + VbCrlf
    
    BufStr = BufStr + "document.write(" + VarName + ");" + VbCrlf
    
    tFile.Write BufStr
    tFile.Close
    
    Set tFile = Nothing
    Set fso = Nothing

end if
%>
<script language='javascript'>
alert("[<%=ocontentsCode.FOneItem.Fposname%>]에 사용될 \n\n\'<%=FileName%>\'파일 생성 완뇨!");
self.close();
</script>
<%
	set ocontentsCode = Nothing
	set ocontents = Nothing
%>
<!-- #INCLUDE file="m_footer.htm" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->
