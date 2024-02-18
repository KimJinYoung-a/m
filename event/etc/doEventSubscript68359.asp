<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 1월 신규고객 이벤트 찰칵!
' History : 2016.01.04 원승현
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim eCode, userid, sqlstr, mode, vLinkECode , vTotalCount, md5userid, eCouponID, RvchrNum, LoginUserid, deviceGubun, snsGubun
Dim vQuery, strsql
Dim result1, result2, result3
Dim evtUserCell, refer, refip
Dim vHiterSt, vHiterEd, vGlassBottleSt, vGlassBottleEd, vTumblr1St, vTumblr1Ed, vTumblr2St, vTumblr2Ed, vQueryCheck, imgLoop, imgLoopVal
Dim vInstaxSt, vInstaxEd, chkProductCntToday, RvConNum

	
	refip = Request.ServerVariables("REMOTE_ADDR")
	refer = request.ServerVariables("HTTP_REFERER")
	mode = requestcheckvar(request("mode"),32)
	snsGubun = requestcheckvar(request("snsGubun"),32)
	userid = GetEncLoginUserID


	'// 디바이스 구분
	If isApp = "1" Then
		deviceGubun = "A"
	Else
		deviceGubun = "M"
	End If

	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "65998"
	Else
		eCode 		= "68359"
	End If



	'// 바로 접속시엔 오류 표시
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If

	'// expiredate
	If not(left(Now(),10)>="2016-01-01" and left(Now(),10)<"2016-02-01") Then
		Response.Write "Err|이벤트 응모 기간이 아닙니다."
		Response.End
	End If

	'// 로그인 여부 체크
	If Not(IsUserLoginOK) Then
		Response.Write "Err|로그인 후 참여하실 수 있습니다."
		response.End
	End If

	'// 1월 신규가입자인지 확인
	sqlstr = " Select count(userid) From db_user.dbo.tbl_user_n Where regdate >= '2016-01-01' And regdate < '2016-02-01' And userid='"&userid&"' "
	rsget.Open sqlStr,dbget,1
	If rsget(0) < 1 Then
		Response.Write "Err|1월에 신규가입한 회원만 참여하실 수 있습니다."
		response.End
	End If
	rsget.close

	'// 참여여부 확인
	sqlstr = "Select count(sub_idx) as cnt" &_
			" From db_event.dbo.tbl_event_subscript" &_
			" WHERE evt_code='" & eCode & "' and userid='" & userid & "'"
	rsget.Open sqlStr,dbget,1
	If rsget(0) > 0 Then
		Response.Write "Err|1월 신규고객 이벤트 참여는 1회만 가능합니다."
		response.End
	End If
	rsget.Close	


	'// 당첨확률 셋팅
	vInstaxSt = 1
	vInstaxEd = 51


	'// 응모내역 검색
	sqlstr = "select top 1 sub_opt1 , sub_opt2, sub_opt3 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' "
	rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
	If Not(rsget.bof Or rsget.Eof) Then
		'// 기존에 응모 했을때 값
		result1 = rsget(0) '// 응모횟수
		result2 = rsget(1) '// 당첨여부 0일 경우엔 비당첨, 1-당첨(인스탁스 카메라)
		result3 = rsget(2) '// 사용안함
	Else
		'// 최초응모
		result1 = ""
		result2 = ""
		result3 = ""
	End IF
	rsget.close

	If result1 = "" Then
		'// 블랙 리스트에 등재되어 있는 회원일시 무조건 비당첨 처리
		If userBlackListCheck(userid) Then
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '0', getdate(), '"&deviceGubun&"')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '블랙리스트아이디비당첨처리', '"&deviceGubun&"')"
			dbget.execute sqlstr

			If isApp="1" Then
				Response.write "OK|<div class='result02'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/68359/m/layer_coupon.png' alt='당첨이 안됐어요. 아쉽지만 1월 신규회원님을 위한 3종 쿠폰패키지를 발급해드렸어요!' /></div><a href='' onclick=""fnAPPpopupBrowserURL('쿠폰북','"&wwwUrl&"/apps/appCom/wish/web2014/my10x10/couponbook.asp'); return false;"" class='lyrBtn'>MY TENBYTEN &gt; 쿠폰/보너스쿠폰</a></div>"
			Else
				Response.write "OK|<div class='result02'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/68359/m/layer_coupon.png' alt='당첨이 안됐어요. 아쉽지만 1월 신규회원님을 위한 3종 쿠폰패키지를 발급해드렸어요!' /></div><a href='/my10x10/couponbook.asp' class='lyrBtn'>MY TENBYTEN &gt; 쿠폰/보너스쿠폰</a></div>"
			End If
			dbget.close()	:	response.End
		End If


		'// 해당일 재고파악(1일 1개)
		sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' And sub_opt2='1' "			
		rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
			chkProductCntToday = rsget(0)
		rsget.close	

		If chkProductCntToday > 0 Then
			'// 이미 오늘 하루 물량 나갔기 때문에 비당첨처리
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '0', getdate(), '"&deviceGubun&"')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '수량초과비당첨처리', '"&deviceGubun&"')"
			dbget.execute sqlstr

			If isApp="1" Then
				Response.write "OK|<div class='result02'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/68359/m/layer_coupon.png' alt='당첨이 안됐어요. 아쉽지만 1월 신규회원님을 위한 3종 쿠폰패키지를 발급해드렸어요!' /></div><a href='' onclick=""fnAPPpopupBrowserURL('쿠폰북','"&wwwUrl&"/apps/appCom/wish/web2014/my10x10/couponbook.asp'); return false;"" class='lyrBtn'>MY TENBYTEN &gt; 쿠폰/보너스쿠폰</a></div>"
			Else
				Response.write "OK|<div class='result02'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/68359/m/layer_coupon.png' alt='당첨이 안됐어요. 아쉽지만 1월 신규회원님을 위한 3종 쿠폰패키지를 발급해드렸어요!' /></div><a href='/my10x10/couponbook.asp' class='lyrBtn'>MY TENBYTEN &gt; 쿠폰/보너스쿠폰</a></div>"
			End If
			dbget.close()	:	response.End
		Else
			'// 당첨확률 1%
			randomize
			RvConNum=int(Rnd*1000)+1 '100%

			If RvConNum >= vInstaxSt And RvConNum < vInstaxEd Then
				'// 당첨
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '1', getdate(), '"&deviceGubun&"')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '인스탁스카메라당첨', '"&deviceGubun&"')"
				dbget.execute sqlstr

				Response.write "OK|<div class='result01'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/68359/m/layer_win.png' alt='인스탁스 카메라 당첨' /></div><button class='lyrBtn btnConfirm' onclick='fnlayerClose();return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/68359/btn_confirm.png' alt='확인' /></button></div>"
				dbget.close()	:	response.End
			Else
				'// 비당첨
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '0', getdate(), '"&deviceGubun&"')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '인스탁스카메라비당첨', '"&deviceGubun&"')"
				dbget.execute sqlstr

				If isApp="1" Then
					Response.write "OK|<div class='result02'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/68359/m/layer_coupon.png' alt='당첨이 안됐어요. 아쉽지만 1월 신규회원님을 위한 3종 쿠폰패키지를 발급해드렸어요!' /></div><a href='' onclick=""fnAPPpopupBrowserURL('쿠폰북','"&wwwUrl&"/apps/appCom/wish/web2014/my10x10/couponbook.asp'); return false;"" class='lyrBtn'>MY TENBYTEN &gt; 쿠폰/보너스쿠폰</a></div>"
				Else
					Response.write "OK|<div class='result02'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/68359/m/layer_coupon.png' alt='당첨이 안됐어요. 아쉽지만 1월 신규회원님을 위한 3종 쿠폰패키지를 발급해드렸어요!' /></div><a href='/my10x10/couponbook.asp' class='lyrBtn'>MY TENBYTEN &gt; 쿠폰/보너스쿠폰</a></div>"
				End If
				dbget.close()	:	response.End
			End If
		End If
	Else
		Response.Write "Err|1월 신규고객 이벤트 참여는 1회만 가능합니다."
		response.End
	End If

%>

<!-- #include virtual="/lib/db/dbclose.asp" -->