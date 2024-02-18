<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
	Dim cnt, couponid
	Dim eCode, sqlstr
	Dim nowdate, refip, refer, renloop, vImg, vAlt
	Dim LoginUserid
	Dim result, mode, md5userid, evtUserCell
	Dim pdName(4), evtItemNm(4), evtItemCode(4), evtCpnCode(4), evtItemCnt(4), IsSold(3), rLo(4), rHi(4)
	Dim device, rstCont

	If Now() > #07/27/2016 23:59:57# Then
		Response.Write "Err|이벤트가 종료되었습니다."
		dbget.close: Response.End
	End If

	If isapp then
		device = "A"
	else
		device = "M"
	end if

	nowdate = now()

	LoginUserid = getLoginUserid()
	refip = Request.ServerVariables("REMOTE_ADDR")
	refer = request.ServerVariables("HTTP_REFERER")
	mode = requestcheckvar(request("mode"),1)

	IF application("Svr_Info") = "Dev" THEN
		eCode = "66173"
	Else
		eCode = "72088"
	End If
	
	
	'// 바로 접속시엔 오류 표시
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다.E01"
		dbget.close: Response.End
	end If

	'// 로그인 여부 체크
	If Not(IsUserLoginOK) Then
		Response.Write "Err|로그인 후 참여하실 수 있습니다."
		dbget.close: response.End
	End If
	
	if mode<>"G" then
		Response.Write "Err|잘못된 접속입니다.E04"
		dbget.close: Response.End
	end If
	

	'//응모 확율
	randomize
	renloop=int(Rnd*10000)+1
	'renloop=1

	'당첨 상품 정보
	evtCpnCode(1) = "885"			'10만 쿠폰
	rLo(1) = 0
	rHi(1) = rLo(1) + 1				'0.01 %
	'rLo(1) = 0						'0%

	evtCpnCode(2) = "886"			'3만 쿠폰
	rLo(2) = rHi(1) + 1
	rHi(2) = rLo(2) + 999			'9.99 %

	evtCpnCode(3) = "888"			'5천 쿠폰
	rLo(3) = rHi(2) + 1
	rHi(3) = rLo(3) + 3500			'35.0 %

	evtCpnCode(4) = "887"			'1만 쿠폰
	rLo(4) = rHi(3) + 1
	rHi(4) = 10000					'55.0 %


	'// 기존 응모 확인
	result = fnExistTodaySave(eCode,LoginUserid)
	'result = False

	If result = True Then
		Response.Write "Err|이미 응모하셨습니다."
		dbget.close: response.End
	End If


	'// 당첨 분기 (rLo & rHi 분기)
	If renloop >= rLo(1) and renloop <= rHi(1) Then '' 10만 쿠폰 885
		
			'// 쿠폰 저장
			Call fnBonusCouponProc(LoginUserid,"885")
			'// 응모정보 저장
			Call fnAddEvtSubscript(eCode,LoginUserid,"","885",renloop,device)
			'// 참여 로그 로그값 저장
			Call fnCautionEventLog(eCode,LoginUserid,renloop,"log01","10만 쿠폰 885",device)

			vImg = "http://webimage.10x10.co.kr/eventIMG/2016/72088/m/txt_win_01.png"
			vAlt = "대박! 십만원 쿠폰이라니! 오십만원 이상 구매시 사용하실 수 있는 십만원 할인쿠폰 오늘 가정까지 사용하실 수 있습니다."
			
	ElseIf renloop >= rLo(2) and renloop <= rHi(2) Then '' 3만 쿠폰 886

			'// 쿠폰 저장
			Call fnBonusCouponProc(LoginUserid,"886")
			'// 응모정보 저장
			Call fnAddEvtSubscript(eCode,LoginUserid,"","886",renloop,device)
			'// 참여 로그 로그값 저장
			Call fnCautionEventLog(eCode,LoginUserid,renloop,"log02","3만 쿠폰 886",device)

			vImg = "http://webimage.10x10.co.kr/eventIMG/2016/72088/m/txt_win_02.png"
			vAlt = "아니 그거슨 삼만원 쿠폰! 이십만원 이상 구매시 사용하실 수 있는 삼만원 할인쿠폰 오늘 가정까지 사용하실 수 있습니다."

	ElseIf renloop >= rLo(3) and renloop <= rHi(3) Then '' 5천 쿠폰 888

			'// 쿠폰 저장
			Call fnBonusCouponProc(LoginUserid,"888")
			'// 응모정보 저장
			Call fnAddEvtSubscript(eCode,LoginUserid,"","888",renloop,device)
			'// 참여 로그 로그값 저장
			Call fnCautionEventLog(eCode,LoginUserid,renloop,"log03","5천 쿠폰 888",device)

			vImg = "http://webimage.10x10.co.kr/eventIMG/2016/72088/m/txt_win_04.png"
			vAlt = "오천원 주는건 안비밀! 삼만원 이상 구매시 사용하실 수 있는 오천원 할인쿠폰 오늘 가정까지 사용하실 수 있습니다."

	ElseIf renloop >= rLo(4) Then '' 1만 쿠폰 887
		
					'// 쿠폰 저장
			Call fnBonusCouponProc(LoginUserid,"887")
			'// 응모정보 저장
			Call fnAddEvtSubscript(eCode,LoginUserid,"","887",renloop,device)
			'// 참여 로그 로그값 저장
			Call fnCautionEventLog(eCode,LoginUserid,renloop,"log04","1만 쿠폰 887",device)

			vImg = "http://webimage.10x10.co.kr/eventIMG/2016/72088/m/txt_win_03.png"
			vAlt = "만원 쿠폰 넘나 좋은 것! 육만원 이상 구매시 사용하실 수 있는 만원 할인쿠폰 오늘 가정까지 사용하실 수 있습니다."

	End if

	''/// 당첨결과 출력
	Response.write "OK|<p><img src=""" & vImg & """ alt=""" & vAlt & """ /></p><button type=""button"" class=""btnConfirm"" onClick=""fnCloseLayer();"">확인</button><button type=""button"" class=""btnClose"" onClick=""fnCloseLayer();"">닫기</button>"
			

'=======================================================
'// 당일 중복참여 체크
Function fnExistTodaySave(ecd,uid)
	dim sqlstr, r
	r = False
	sqlstr = "SELECT count(sub_idx) from [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & ecd & "' and sub_opt1 = convert(varchar(10),getdate(),120) and userid = '" & uid & "'"
	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
	if not rsget.eof then
		if rsget(0) > 0 then
			r = True
		end if
	end if
	rsget.close
	fnExistTodaySave = r
end Function

'// 이벤트 응모 저장 처리
Sub fnAddEvtSubscript(ecd,uid,opt1,opt2,opt3,dvc)
	dim sqlstr
	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, device)"
	sqlstr = sqlstr & " VALUES("& ecd &", '"& uid &"', convert(varchar(10),getdate(),120), '" & opt2 & "', '" & opt3 & "', '"&dvc&"')"
	dbget.execute sqlstr
end Sub

'// 쿠폰 저장 처리
Sub fnBonusCouponProc(uid,cidx)
	dim sqlstr
	sqlStr = sqlStr & "insert into [db_user].[dbo].tbl_user_coupon " & vbCrLf
	sqlStr = sqlStr & "(masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename) " & vbCrLf
	sqlStr = sqlStr & "SELECT m.idx, '" & uid & "', m.coupontype, m.couponvalue, m.couponname, m.minbuyprice, m.targetitemlist " & vbCrLf
	sqlStr = sqlStr & ", convert(varchar(10),getdate(),120), convert(datetime,convert(varchar(10),getdate(),120) + ' 23:59:59'), m.couponmeaipprice, m.validsitename " & vbCrLf
	sqlStr = sqlStr & "from [db_user].[dbo].tbl_user_coupon_master as m " & vbCrLf
	sqlStr = sqlStr & "where m.isusing='Y' and m.idx='" & cidx & "' "
	dbget.execute sqlstr
end Sub
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->