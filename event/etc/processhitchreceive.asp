<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/enjoy/hitchhikerCls.asp" -->
<% If isApp = 1 Then %>
<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/common.js?v=2.05"></script>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js?v=2.43"></script>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/jquery.swiper-3.1.2.min.js"></script>
<% End If %>
<%
Dim chkid, chklevel
chkid 	= requestCheckVar(request.Form("chkid"),32)

Dim hitch
Set hitch = new Hitchhiker
hitch.FUserId = GetLoginUserID
hitch.fnGetHitchCont
chklevel = hitch.FUserlevel

dim evtID, iHVol, startdate, enddate, delidate
rsget.open "select top 1 * from db_event.dbo.tbl_vip_hitchhiker where isusing= 'Y' and getdate()>startdate and getdate() <= enddate",dbget,1
If not rsget.eof Then
'	evtID = rsget("mevt_code")
	iHVol = rsget("Hvol")
	startdate =  rsget("startdate")	'시작일
	enddate =  rsget("enddate")		'종료일
	delidate =  rsget("delidate")	'배송일
Else
	evtID = ""
	iHVol = ""
End If
rsget.close

Dim alertDate, aVol
If date() >= startdate and date() <= enddate Then
	aVol = "1"											'### 차수
	alertDate = Month(delidate)&"월 "& Day(delidate)&"일"			'"07월 21일"								'### 발송일			
'ElseIf date >= "2016-09-12" and date <= "2016-09-18" Then
'	aVol = "2"
'	alertDate = "09월 29일"
End If

'// 아이디 확인  //
IF chkid <> getEncLoginUserID THEN
	If isApp = 1 Then
%>
	<script>$(function(){alert('아이디 정보가 일치하지 않습니다.');callmain();return false;});</script>
<%
	response.end
	Else
		response.write "<script>alert('아이디 정보가 일치하지 않습니다.');top.location.href='"&wwwURL&"';</script>"
		response.end
	End If
END IF

'// vip 회원이상만 신청가능 //
IF (chklevel <> 3 and chklevel <> 4 and chklevel <> 6 and chkid <> "kjy8517" and chkid <> "kobula" and chkid <> "dream1103" and chkid <> "star088" and chkid <> "okkang77" and chkid <> "tozzinet" and chkid <> "baboytw") THEN
	If isApp = 1 Then
%>
	<script>$(function(){alert('마이텐바이텐의 회원등급을 확인해주세요!');callmain();return false;});</script>
<%
	response.end
	Else
		response.write "<script>alert('마이텐바이텐의 회원등급을 확인해주세요!');top.location.href='"&wwwURL&"';</script>"
		response.end
	End If
END IF

Dim zipcode, addr1, addr2, userphone, usercell
Dim strSql,strQuery
Dim username

'zipcode = requestCheckVar(request.Form("txZip1"),3) + "-" + requestCheckVar(request.Form("txZip2"),3)
zipcode = requestCheckVar(request.Form("txZip"),8)
addr1 = html2db(request.Form("txAddr1"))
addr2 = html2db(request.Form("txAddr2"))

userphone = requestCheckVar(request.Form("userphone1"),3) + "-" + requestCheckVar(request.Form("userphone2"),4) + "-" + requestCheckVar(request.Form("userphone3"),4)
usercell = requestCheckVar(request.Form("usercell1"),3)+ "-" + requestCheckVar(request.Form("usercell2"),4) + "-" +requestCheckVar(request.Form("usercell3"),4)
iHVol = requestCheckVar(request.Form("iHVol"),10)
username = requestCheckVar(request.Form("reqname"),32)

If requestCheckVar(request.Form("txZip"),8) = "" OR addr1 = "" OR addr2 = "" OR requestCheckVar(request.Form("usercell1"),3) = "" OR requestCheckVar(request.Form("usercell2"),3) = "" OR requestCheckVar(request.Form("usercell3"),3) = "" OR iHvol = "" OR username = "" Then
	If isApp = 1 Then
%>
	<script>$(function(){alert('주소 입력이 잘 못 되었습니다.');callmain();return false;});</script>
<%
	response.end
	Else
		response.write "<script>alert('주소 입력이 잘 못 되었습니다.');top.location.href='"&wwwURL&"';</script>"
		response.end
	End If
End If

dbget.beginTrans

'	strSql = " UPDATE [db_user].[dbo].tbl_user_n" & VbCrlf
'	strSql = strSql & " SET " & VbCrlf
'	strSql = strSql & " zipcode='" + zipcode + "'" & VbCrlf
'	strSql = strSql & " ,useraddr='" + addr2 + "'" & VbCrlf
'	strSql = strSql & " ,userphone='" + userphone + "'" & VbCrlf
'	strSql = strSql & " ,usercell='" + usercell + "'"  & VbCrlf
'	strSql = strSql & " where userid='" + chkid + "'"
'	dbget.execute strSql

	strQuery =" SELECT userid FROM [db_user].[dbo].[tbl_user_hitchhiker] WHERE HVol = "&iHVol&" and userid ='"&chkid&"'"
	rsget.Open strQuery, dbget
	IF NOT (rsget.EOF OR rsget.BOF) THEN
		strSql = "UPDATE [db_user].[dbo].[tbl_user_hitchhiker] "	& VbCrlf
		strSql = strSql & " SET ApplyDate =getdate(), recevieName='"& username&"', zipcode='"&zipcode&"', useraddr='"& addr2&"', userphone='"& userphone&"', usercell='"& usercell&"',zipaddr='"& addr1&"' " & VbCrlf
		strSql = strSql & " WHERE HVol = "& iHVol & VbCrlf
		strSql = strSql & " and userid='"&chkid&"'"
	ELSE
		strSql = "INSERT INTO [db_user].[dbo].[tbl_user_hitchhiker] "	& VbCrlf
		strSql = strSql & " (HVol, userid, ApplyVol,recevieName, zipcode, useraddr, userphone, usercell, zipaddr)" & VbCrlf
		strSql = strSql & " VALUES " & VbCrlf
		strSql = strSql & " ("&iHVol&",'"&chkid&"','"&aVol&"','"&username&"','"&zipcode&"','"&addr2&"','"&userphone&"','"&usercell&"','"&addr1&"')"
	END IF
		dbget.execute strSql
	rsget.Close

IF Err.Number = 0 THEN
	dbget.CommitTrans
		response.Cookies("hitchVIP").domain = "10x10.co.kr"
		response.Cookies("hitchVIP")("mode") = "x"
		response.cookies("hitchVIP").Expires = Date + 30
	If isApp = 1 Then
%>
	<script>$(function(){alert('고맙습니다. <%=alertDate%> 일괄 우편 발송됩니다.');callmain();return false;});</script>
<%
	response.end
	Else
		response.write "<script>alert('고맙습니다. "&alertDate&" 일괄 우편 발송됩니다.');top.location.href='"&wwwURL&"';</script>"
		response.end
	End If
Else
   	dbget.RollBackTrans
	If isApp = 1 Then
%>
	<script>$(function(){alert('데이터 처리에 실패하였습니다. 다시 시도해 주세요.\n\n 지속적으로 문제 발생시 고객센터로 연락주세요.');callmain();return false;});</script>
<%
	response.end
	Else
		response.write "<script>alert('데이터 처리에 실패하였습니다. 다시 시도해 주세요.\n\n 지속적으로 문제 발생시 고객센터로 연락주세요.');top.location.href='"&wwwURL&"';</script>"
		response.end
	End If
End IF
%>
<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->