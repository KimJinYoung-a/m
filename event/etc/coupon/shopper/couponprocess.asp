<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 텐x텐 쿠폰 이벤트
' History : 2020-02-17 이종화
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/etc/coupon/shopper/keywordCheck.asp" -->
<%
	dim couponname, couponidx, refer, rvalue, loginUserid , eventid

	couponname = replace(ReplaceRequestSpecialChar(request("couponname"))," ","")
	eventid = requestcheckvar(request("eventid"),10)
	loginUserid	= getencLoginUserid()
	
	If Not(IsUserLoginOK) Then
		Response.Write "ERR|로그인 후 쿠폰을 받으실 수 있습니다."
    Else
        IF couponname = "" THEN 
            Response.Write "ERR|쿠폰코드를 입력해주세요!"
            Response.end
        END IF

        '// 쿠폰 번호 셋팅
        CALL shopperKeyword(eventid , couponname , couponidx)

        IF couponidx = "" THEN
            Response.Write "ERR|존재하지 않는 쿠폰입니다. 쿠폰코드를 다시 확인해주세요!"
            Response.end
        END IF

        rvalue = fnSetEventCouponDownPrefixName(loginUserid, couponidx, couponname)
        SELECT CASE rvalue
            CASE 0
                Response.Write "ERR|쿠폰 발급 처리에 오류가 발생하였습니다."
                Response.end
            CASE 1
                Response.write "OK|OK"
                Response.end
            CASE 2
                Response.Write "ERR|기간이 종료되었거나 유효하지 않은 쿠폰입니다."
                Response.end
            CASE 3
                Response.Write "ERR|이미 등록된 쿠폰이 있습니다. '마이텐바이텐→쿠폰함'을 확인해주세요."
                Response.end
        END SELECT
    End If

	'## 보너스쿠폰 다운 함수 - 쿠폰명 프리픽스 추가
	Function fnSetEventCouponDownPrefixName(ByVal userid, ByVal idx, ByVal nameprefix)
		dim sqlStr
		Dim objCmd
		Set objCmd = Server.CreateObject("ADODB.COMMAND")
		With objCmd
			.ActiveConnection = dbget
			.CommandType = adCmdText
			.CommandText = "{?= call [db_user].[dbo].sp_Ten_eventcoupon_down_couponname_prefix_add("&idx&",'"&userid&"','"&nameprefix&"')}"
			.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
			.Execute, , adExecuteNoRecords
			End With
			fnSetEventCouponDownPrefixName = objCmd(0).Value
		Set objCmd = Nothing
	END Function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->