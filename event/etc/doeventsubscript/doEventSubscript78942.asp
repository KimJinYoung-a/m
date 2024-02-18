<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 	쿨링을 부탁해
' History : 2017.07.10 유태욱
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim mysubsctiptcnt, totalsubsctiptcnt, currenttime, refer
Dim eCode, LoginUserid, mode, sqlStr, device, cnt, couponnum, realcouponidx
		
IF application("Svr_Info") = "Dev" THEN
	eCode = "66384"
	realcouponidx = 11149
Else
	eCode = "78942"
	realcouponidx = 12706
End If

currenttime = date()
mode			= requestcheckvar(request("mode"),32)
couponnum			= trim(requestcheckvar(request("couponnum"),32))
LoginUserid		= getencLoginUserid()
refer 			= request.ServerVariables("HTTP_REFERER")


'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "Err||Error06:잘못된 접속입니다."
	Response.End
End If

'// expiredate
If not(currenttime >= "2017-07-12") Then
	Response.Write "Err||Error07:이벤트 기간이 아닙니다."
	Response.End
End If

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "Err||Error08:로그인 후 참여하실 수 있습니다."
	response.End
End If

if isapp then
	device = "A"
Else
	device = "M"
end if

'## 상품쿠폰 다운 함수
Function fnSetItemCouponDown(ByVal LoginUserid, ByVal realcouponidx)
	dim sqlStr
	Dim objCmd
	Set objCmd = Server.CreateObject("ADODB.COMMAND")
	With objCmd
		.ActiveConnection = dbget
		.CommandType = adCmdText
		.CommandText = "{?= call [db_item].[dbo].sp_Ten_itemcoupon_down("&realcouponidx&",'"&LoginUserid&"')}"
		.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
		.Execute, , adExecuteNoRecords
		End With	
	    fnSetItemCouponDown = objCmd(0).Value	
	Set objCmd = Nothing	
END Function	
	
If mode = "down" Then
	'유효한 쿠폰인지 체크 
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_temp].[dbo].[tbl_event_78942] WHERE isusing= 'N' and couponnum='"&couponnum&"' "
	rsget.Open sqlstr, dbget, 1
		cnt = rsget("cnt")
	rsget.close

	If cnt > 0 Then
		dim rvalue, oldrvalue
		dbget.beginTrans
			rvalue = fnSetItemCouponDown(LoginUserid,realcouponidx)

			if rvalue = 0 then 	'문제 발생시 롤백처리
			elseif rvalue = 1 then	'정상처리
				sqlStr = ""
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , device)" & vbCrlf
				sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '"&couponnum&"', '"&device&"')"
				dbget.execute sqlstr

				sqlstr = "update [db_temp].[dbo].[tbl_event_78942] set isusing = 'Y' , userid='"& LoginUserid &"' where couponnum= '"&couponnum&"' "
				dbget.execute sqlstr

				oldrvalue = 1
			elseif (rvalue = 2 or  rvalue = 3) then	'유효하지 않은 쿠폰또는 이미받은 쿠폰 제외하고 다른 쿠폰 다운처리
				if oldrvalue = 1 then 	rvalue = 1
			end if

			SELECT CASE  rvalue
				CASE 0
					dbget.RollBackTrans
					Response.Write "00||Error01:정상적인 경로가 아닙니다."
					dbget.close() : Response.End
				CASE 1
					dbget.CommitTrans
					Response.Write "11||쿠폰이 발급되었습니다."
					dbget.close() : Response.End
				CASE 2
					dbget.RollBackTrans
					Response.Write "12||Error02:기간이 종료되었거나 유효하지 않은 쿠폰입니다."
					dbget.close() : Response.End
				CASE 3
					dbget.RollBackTrans
					Response.Write "13||이미 쿠폰을 받으셨습니다."
					dbget.close() : Response.End
			END SELECT
		dbget.close()	:	response.End

	Else
		Response.write "Err||Error03:쿠폰 번호를 확인해주세요."
		dbget.close()	:	response.End
	End If
Else
	Response.Write "Err||Error04:정상적인 경로로 참여해주시기 바랍니다."
	dbget.close() : Response.End
End If	
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->