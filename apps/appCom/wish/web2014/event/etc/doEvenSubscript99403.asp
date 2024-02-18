<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : MD 기획전 카카오 브랜드 쿠폰
' History : 2019-12-12 원승현
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
	dim mysubsctiptcnt, totalsubsctiptcnt, currenttime, refer, subscriptcount, couponIdxs
	Dim eCode, LoginUserid, mode, sqlStr, device, cnt, videoLink, urlCnt
    Dim i, rvalue, oldrvalue, arridx, couponType

	eCode			= request("eCode")    
	currenttime 	= date()
	LoginUserid		= getencLoginUserid()			
	couponType 		= request("couponType")

    Select Case Trim(couponType)
        Case "cKakaoFriends" '// 카카오 프렌즈 브랜드 쿠폰
            IF application("Svr_Info") = "Dev" THEN
                couponIdxs = "2944"
            Else
                couponIdxs = "1275"
            End If
        Case else
            couponIdxs = ""
    End Select
    
    If isapp="1" Then
        device = "A"
    Else
        device = "M"
    End If
	

	If Not(IsUserLoginOK) Then
		Response.Write "Err|로그인 후 쿠폰을 받으실 수 있습니다."
		response.End
	End If

    If Trim(couponIdxs) = "" Then
		Response.Write "Err|정상적인 경로로 접근해 주세요."
		response.End
	End If

	'//본인 참여 여부
	if LoginUserid<>"" then
		subscriptcount = getevent_subscriptexistscount(eCode, LoginUserid, "", "", couponType)
	end if

	if subscriptcount > 0 then
		Response.write "Err|이미 발급된 쿠폰입니다. 구매 페이지에서 적용 가능합니다."
		dbget.close()	:	response.End
	Else
        arridx = split(couponIdxs,",")
        '// 쿠폰 발급
		For i = 0 To UBound(arridx)
		    rvalue = fnSetSelectCouponDown(LoginUserid,arridx(i))
			if rvalue = 0 then 	'문제 발생시 롤백처리
				exit for
			elseif rvalue = 1 then	'정상처리
                oldrvalue = 1
			elseif (rvalue = 2 or  rvalue = 3) then	'유효하지 않은 쿠폰또는 이미받은 쿠폰 제외하고 다른 쿠폰 다운처리
				if oldrvalue = 1 then 	rvalue = 1
			end if            
        Next
		SELECT CASE  rvalue
			CASE 0
				Response.Write "Err|정상적인 경로가 아닙니다."
				dbget.close() : Response.End
			CASE 1
                Call fncheckcoupondownlog(eCode, device, couponType, LoginUserid)
				Response.Write "OK|OK"
				dbget.close() : Response.End
			CASE 2
				Response.Write "Err|기간이 종료되었거나 유효하지 않은 쿠폰입니다."
				dbget.close() : Response.End
			CASE 3
				Response.Write "Err|이미 쿠폰을 받으셨습니다."
				dbget.close() : Response.End
		END SELECT
	    dbget.close()	:	response.End

	End IF

	Function fnSetSelectCouponDown(ByVal LoginUserid, ByVal idx)
		dim sqlStr
		Dim objCmd
		Set objCmd = Server.CreateObject("ADODB.COMMAND")
		With objCmd
			.ActiveConnection = dbget
			.CommandType = adCmdText
			.CommandText = "{?= call [db_user].[dbo].sp_Ten_eventcoupon_down_selected("&idx&",'"&LoginUserid&"')}"
			.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
			.Execute, , adExecuteNoRecords
			End With
		    fnSetSelectCouponDown = objCmd(0).Value
		Set objCmd = Nothing
	END Function

	Function fncheckcoupondownlog(ByVal evt_code, ByVal device, ByVal couponType, ByVal LoginUserid)
		dim sqlStr
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& evt_code &",'" & LoginUserid & "','"&couponType&"','"& device &"')" + vbcrlf
		dbget.execute sqlstr
	End Function    
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->