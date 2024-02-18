<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 텐x텐 쿠폰 이벤트
' History : 2019-10-11
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
	dim couponname, couponidx, refer, rvalue, loginUserid

    IF application("Svr_Info") = "Dev" THEN
        couponidx = "2910"  
    Else
        couponidx = "1219"
    End If
	couponname = replace(ReplaceRequestSpecialChar(request("couponname"))," ","")
	loginUserid	= getencLoginUserid()			
	
	If Not(IsUserLoginOK) Then
		Response.Write "ERR|로그인 후 쿠폰을 받으실 수 있습니다."
    Else
        Select Case couponname
        Case "호담","럭셜황후","1010쿠폰","텐텐러블","유랑","땡이","하주임","하리미지니","쏘쇼","정자동비버댁","견우네","죵이","이매콤","데이지","로와제이","알로하니모","꾸우미맘","호담","럭셜황후","1010쿠폰","텐텐러블","유랑","땡이","하주임","하리미지니","쏘쇼","정자동비버댁","하얘","까칠한그녀","레이라","보라초","헤일리","순둥작가","꼬비","서아맘","나나킴","민조이","아양","하늘을달리다","용햄","솔솔","달키","봄지","주주맘","지지지혜","액션몽자","위드윤","욜로걸","한방이","수리","레이첼","슈퍼보리","디어루씨","마슝이","꼬꼬마","꽃혜지","율희","보쨘","이반나","다이애나","유부림짱","얌치"
            rvalue = fnSetEventCouponDownPrefixName(loginUserid, couponidx, couponname)
            SELECT CASE  rvalue
            CASE 0
                Response.Write "ERR|쿠폰 발급 처리에 오류가 발생하였습니다."
            CASE 1
                Response.write "OK|OK"
            CASE 2
                Response.Write "ERR|기간이 종료되었거나 유효하지 않은 쿠폰입니다."
            CASE 3
                Response.Write "ERR|이미 등록된 쿠폰이 있습니다. '마이텐바이텐→쿠폰함'을 확인해주세요."
            END SELECT
        Case ""
            Response.Write "ERR|쿠폰명을 입력해주세요!"
        Case Else
            Response.Write "ERR|존재하지 않는 쿠폰입니다. 쿠폰명을 다시 확인해주세요!"
        End Select
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