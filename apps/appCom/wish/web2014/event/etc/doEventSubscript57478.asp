<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 스타워즈 텐바이텐 참여 이벤트
' History : 2014.12.08 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->


<%
dim eCode, userid, mode, sqlstr, refer, smssubscriptcount, subscriptcount, bonuscouponcount, totalsubscriptcount, totalbonuscouponcount, preveCode, vStarGift, vGiftName, vChkWishSelect, vLinkECode
	userid = getloginuserid()

	IF application("Svr_Info") = "Dev" Then
		eCode = "21396"
		vLinkECode = "21393"
	Else
		eCode = "57275"
		vLinkECode = "57478"
	End If


	vStarGift = requestCheckVar(request("stargift"), 50)



refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/apps/appCom/Wish/web2014/event/eventmain.asp?eventid="&vLinkECode&"'</script>"
	dbget.close() : Response.End
End If

If not(left(Now(),10)>="2014-12-08" and left(Now(),10)<"2014-12-31") Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/apps/appCom/Wish/web2014/event/eventmain.asp?eventid="&vLinkECode&"'</script>"
	dbget.close() : Response.End
End IF

Dim vQuery, vTotalCount, vItemID, vtemp, k, itemcnt
vItemID = requestCheckvar(request("SelChkUsrValue"),400)

If vItemID ="" Then
	vItemID=""
	itemcnt=0
End If


vtemp = Split(vItemID,",")
itemcnt = UBound(vtemp)+1


vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "' And  convert(varchar(10), regdate, 120) = '"&Left(Now(), 10)&"' "
rsget.Open vQuery,dbget,1
IF Not rsget.Eof Then
	vTotalCount = rsget(0)
End IF
rsget.close
If vTotalCount > 0 Then
	response.write "<script language='javascript'>alert('이미 이벤트 응모가 완료되었습니다.\n내일 다시 응모하여 주세요.');parent.location.reload();</script>"
	dbget.close()
	response.end
Else


	'// 위시리스트에 선택한 상품이 있는지 확인한다.
	vQuery = "SELECT count(*) FROM [db_my10x10].[dbo].[tbl_myfavorite] WHERE userid = '" & userid & "' AND itemid = '" & vStarGift & "' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		vChkWishSelect = rsget(0)
	End If
	rsget.close

	If vChkWishSelect < 1 Then
		vQuery = "INSERT INTO [db_my10x10].[dbo].[tbl_myfavorite](userid, itemid, regdate, fidx, viewIsUsing) VALUES('" & userid & "', '" & vStarGift & "',getdate(),0,'Y')"
		dbget.Execute vQuery
'		dbget.close()
	End If 
	

	'// 각 아이템 코드별 상품명
	Select Case Trim(vStarGift)
		Case "932428"
			vGiftName = "요다손목시계"
		Case "926688"
			vGiftName = "다스베이더키체인"
		Case "104109111"
			vGiftName = "스톰트루퍼플래시"
		Case "1060364"
			vGiftName = "R2D2키체인"
		Case Else
			vGiftName = ""
	End Select

	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt2, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "','"&vStarGift&"','"&vGiftName&"', 'M')"
	dbget.Execute vQuery
	
	response.write "<script language='javascript'>alert('응모가 완료되었습니다.');parent.location.reload();</script>"
	dbget.close()
	response.end
End IF

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->