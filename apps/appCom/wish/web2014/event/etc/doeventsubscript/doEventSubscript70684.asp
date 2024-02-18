<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	History	: 2016.05.12 허진원 생성
'	Description : 오벤져스 응모처리
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
	Dim cnt, couponid
	Dim eCode, sqlstr
	Dim nowdate, refip, refer, renloop
	Dim LoginUserid
	Dim result, mode, md5userid, evtUserCell
	Dim pdName(4), evtItemNm(4), evtItemCode(4), evtCpnCode(4), evtItemCnt(4), IsSold(3), rLo(4), rHi(4)
	Dim device, rstCont
	
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
	evtUserCell = get10x10onlineusercell(LoginUserid) '// 참여한 회원 핸드폰번호

	IF application("Svr_Info") = "Dev" THEN
		eCode = "66128"
	Else
		eCode = "70684"
	End If

	'//응모 확율
	randomize
	renloop=int(Rnd*10000)+1

	md5userid = md5(LoginUserid&"40")


	'당첨 상품 정보
	pdName(1) = "인스탁스 카메라"
	evtItemCode(1) = "1487846"
	evtCpnCode(1) = "11627"
	evtItemCnt(1) = 1				'상품수
	rLo(1) = 0
	rHi(1) = rLo(1) + 1				'0.01 %

	pdName(2) = "스티키몬스터 보틀"
	evtItemCode(2) = "1487924"
	evtCpnCode(2) = "11628"
	evtItemCnt(2) = 2				'상품수
	rLo(2) = rHi(1) + 1
	rHi(2) = rLo(2) + 100			'1.0 %

	pdName(3) = "스파이더맨 선풍기"
	evtItemCode(3) = "1487939"
	evtCpnCode(3) = "11629"
	evtItemCnt(3) = 6				'상품수
	rLo(3) = rHi(2) + 1
	rHi(3) = rLo(3) + 200			'2.0 %

	pdName(4) = "텐바이텐 마일리지"
	evtItemCode(4) = "0"
	evtCpnCode(4) = ""
	evtItemCnt(4) = 0
	rLo(4) = rHi(3) + 1
	rHi(4) = 10000					'나머지

	'// 바로 접속시엔 오류 표시
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다.E01"
		dbget.close: Response.End
	end If

	'// expiredate
	If not(left(nowdate,10)>="2016-05-16" and left(nowdate,10)<="2016-05-22") Then
		Response.Write "Err|이벤트 응모 기간이 아닙니다."
		dbget.close: Response.End
	End If

	'// 로그인 여부 체크
	If Not(IsUserLoginOK) Then
		Response.Write "Err|로그인 후 참여하실 수 있습니다."
		dbget.close: response.End
	End If

	if mode<>"G" then
		Response.Write "Err|잘못된 접속입니다.E04"
		dbget.close: Response.End
	end If

	'// -- APP최초 로그인 여부 확인 --
	'// APP등록 정보에서 확인
	dim lastusercnt, logusercnt, evt_pass
	sqlstr = "select min(convert(varchar(10),regdate,120)) from db_contents.dbo.tbl_app_regInfo where userid = '" & LoginUserid & "' "
	rsget.CursorLocation = adUseClient
	rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly

	IF Not rsget.Eof Then
		lastusercnt = rsget(0) '// 날짜
	Else
		lastusercnt = ""
	End IF
	rsget.close

	If lastusercnt <> "" Then '//어쨌든 값은 있음
		If lastusercnt >= "2016-05-16" Then '// 기준 충족시
			evt_pass = true
		Else
			evt_pass = false
		End If 
	Else '//값 없음 ios라던가 값이 없을 수 있음
		'// APP 기기정보에서 확인
		sqlstr = "select min(convert(varchar(10),regdate,120)) from db_contents.[dbo].[tbl_app_NidInfo] WHERE lastuserid = '"& LoginUserid &"'"
		rsget.CursorLocation = adUseClient
		rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly

		IF Not rsget.Eof Then
			logusercnt = rsget(0) '// 날짜
		Else
			logusercnt = ""
		End IF
		rsget.close

		If logusercnt <> "" Then '//여기엔 있다
			If logusercnt >= "2016-05-16" Then '// 기준 충족시
				evt_pass = true
			Else
				evt_pass = false
			End If
		Else
			evt_pass = false
		End if
	End If
	
	if Not(evt_pass) then
		Response.Write "Err|본 이벤트는 APP에서 로그인 이력이 한번도 없는 고객님을 위한 이벤트입니다.E05"
		dbget.close: response.End
	end if


If mode = "G" Then '//응모하기 버튼 클릭
	'// 기존 응모 정보 확인
	sqlstr = "select count(*) as cnt "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"'"
	rsget.Open sqlstr, dbget, 1
		result = rsget("cnt")
	rsget.close	

	If result>0 Then
		Response.Write "Err|이미 응모하셨습니다."
		dbget.close: response.End
	End If

	'// 당첨상품 남은 수량 계산
	sqlstr = "select "
	sqlstr = sqlstr & " isNull(Sum(Case When sub_opt1='1' Then 1 Else 0 End),0) as Rm1 "
	sqlstr = sqlstr & " ,isNull(Sum(Case When sub_opt1='2' Then 1 Else 0 End),0) as Rm2 "
	sqlstr = sqlstr & " ,isNull(Sum(Case When sub_opt1='3' Then 1 Else 0 End),0) as Rm3 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and sub_opt1 in ('1','2','3')"
	rsget.Open sqlstr, dbget, 1
		IsSold(1) = evtItemCnt(1) <= rsget("Rm1")		'카메라 품절여부
		IsSold(2) = evtItemCnt(2) <= rsget("Rm2")		'보틀 품절여부
		IsSold(3) = evtItemCnt(3) <= rsget("Rm3")		'선풍기 품절여부
	rsget.close	

	'// 당첨 분기 (rLo & rHi 분기)
	If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
		'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 꼴등 처리함
		Call fnAddEvtSubscript(eCode,LoginUserid,"4","0",device)

		'// 마일리지 지급
		Call fnAddUserMileage(LoginUserid)

		'// 참여 로그 로그값 저장
		Call fnCautionEventLog(eCode,LoginUserid,renloop,"log01","전화번호중복",device)

		rstCont = "<p><img src=""http://webimage.10x10.co.kr/eventIMG/2016/70684/m/layer_win04_midge500.png"" alt=""축하합니다. 500 마일리지 당첨"" /></p>" &_
			"<a href=""#"" onclick=""alert('마일리지가 지급되었습니다.');fnClosemask(); return false;"" class=""goBuy"">마일리지 발급받기</a>" &_
			"<span class=""code"">" & md5userid & "</span>"

	ElseIf renloop >= rLo(1) and renloop <= rHi(1) Then '' 인스탁스 카메라
		if IsSold(1) then
			'// 응모정보 저장
			Call fnAddEvtSubscript(eCode,LoginUserid,"4","0",device)
			'// 마일리지 지급
			Call fnAddUserMileage(LoginUserid)
			'// 참여 로그 로그값 저장
			Call fnCautionEventLog(eCode,LoginUserid,renloop,"log08","마일리지 당첨(카메라 품절)",device)

			rstCont = "<p><img src=""http://webimage.10x10.co.kr/eventIMG/2016/70684/m/layer_win04_midge500.png"" alt=""축하합니다. 500 마일리지 당첨"" /></p>" &_
				"<a href=""#"" onclick=""alert('마일리지가 지급되었습니다.');fnClosemask(); return false;"" class=""goBuy"">마일리지 발급받기</a>" &_
				"<span class=""code"">" & md5userid & "</span>"
		else
			'// 응모정보 저장
			Call fnAddEvtSubscript(eCode,LoginUserid,"1",evtItemCode(1),device)
			'// 참여 로그 로그값 저장
			Call fnCautionEventLog(eCode,LoginUserid,renloop,"log05","인스탁스 카메라 당첨",device)
			'// 상품쿠폰 발급
			Call fnSetItemCouponDown(LoginUserid,evtCpnCode(1))

			md5userid = md5(LoginUserid&"10")
			rstCont = "<p><img src=""http://webimage.10x10.co.kr/eventIMG/2016/70684/m/layer_win01_instxcmr.png"" alt=""축하합니다. 인스탁스 카메라 당첨"" /></p>" &_
				"<a href=""#"" onclick=""addshoppingBag(" & evtItemCode(1) & "); return false;"" class=""goBuy"">지금 구매하러 가기</a>" &_
				"<span class=""code"">" & md5userid & "</span>"
		end IF

	ElseIf renloop >= rLo(2) and renloop <= rHi(2) Then '' 스티키몬스터 보틀
		if IsSold(2) then
			'// 응모정보 저장
			Call fnAddEvtSubscript(eCode,LoginUserid,"4","0",device)
			'// 마일리지 지급
			Call fnAddUserMileage(LoginUserid)
			'// 참여 로그 로그값 저장
			Call fnCautionEventLog(eCode,LoginUserid,renloop,"log07","마일리지 당첨(보틀 품절)",device)

			rstCont = "<p><img src=""http://webimage.10x10.co.kr/eventIMG/2016/70684/m/layer_win04_midge500.png"" alt=""축하합니다. 500 마일리지 당첨"" /></p>" &_
				"<a href=""#"" onclick=""alert('마일리지가 지급되었습니다.');fnClosemask(); return false;"" class=""goBuy"">마일리지 발급받기</a>" &_
				"<span class=""code"">" & md5userid & "</span>"
		else
			'// 응모정보 저장
			Call fnAddEvtSubscript(eCode,LoginUserid,"2",evtItemCode(2),device)
			'// 참여 로그 로그값 저장
			Call fnCautionEventLog(eCode,LoginUserid,renloop,"log04","스티키몬스터 보틀 당첨",device)
			'// 상품쿠폰 발급
			Call fnSetItemCouponDown(LoginUserid,evtCpnCode(2))

			md5userid = md5(LoginUserid&"20")
			rstCont = "<p><img src=""http://webimage.10x10.co.kr/eventIMG/2016/70684/m/layer_win02_stkybottl.png"" alt=""축하합니다. 스티키몬스터 보틀 당첨"" /></p>" &_
				"<a href=""#"" onclick=""addshoppingBag(" & evtItemCode(2) & "); return false;"" class=""goBuy"">지금 구매하러 가기</a>" &_
				"<span class=""code"">" & md5userid & "</span>"
		End if

	ElseIf renloop >= rLo(3) and renloop <= rHi(3) Then '' 스파이더맨 선풍기
		if IsSold(3) then
			'// 응모정보 저장
			Call fnAddEvtSubscript(eCode,LoginUserid,"4","0",device)
			'// 마일리지 지급
			Call fnAddUserMileage(LoginUserid)
			'// 참여 로그 로그값 저장
			Call fnCautionEventLog(eCode,LoginUserid,renloop,"log06","마일리지 당첨(선풍기 품절)",device)

			rstCont = "<p><img src=""http://webimage.10x10.co.kr/eventIMG/2016/70684/m/layer_win04_midge500.png"" alt=""축하합니다. 500 마일리지 당첨"" /></p>" &_
				"<a href=""#"" onclick=""alert('마일리지가 지급되었습니다.');fnClosemask(); return false;"" class=""goBuy"">마일리지 발급받기</a>" &_
				"<span class=""code"">" & md5userid & "</span>"
		else
			'// 응모정보 저장
			Call fnAddEvtSubscript(eCode,LoginUserid,"3",evtItemCode(3),device)
			'// 참여 로그 로그값 저장
			Call fnCautionEventLog(eCode,LoginUserid,renloop,"log03","스파이더맨 선풍기 당첨",device)
			'// 상품쿠폰 발급
			Call fnSetItemCouponDown(LoginUserid,evtCpnCode(3))

			md5userid = md5(LoginUserid&"30")
			rstCont = "<p><img src=""http://webimage.10x10.co.kr/eventIMG/2016/70684/m/layer_win03_spdrfan.png"" alt=""축하합니다. 스파이더맨 탁상 선풍기 당첨"" /></p>" &_
				"<a href=""#"" onclick=""addshoppingBag(" & evtItemCode(3) & "); return false;"" class=""goBuy"">지금 구매하러 가기</a>" &_
				"<span class=""code"">" & md5userid & "</span>"
		End if

	ElseIf renloop >= rLo(4) Then '' 꼴등 (500 마일리지)
		'// 응모정보 저장
		Call fnAddEvtSubscript(eCode,LoginUserid,"4","0",device)

		'// 마일리지 지급
		Call fnAddUserMileage(LoginUserid)

		'// 참여 로그 로그값 저장
		Call fnCautionEventLog(eCode,LoginUserid,renloop,"log02","마일리지 당첨",device)

		rstCont = "<p><img src=""http://webimage.10x10.co.kr/eventIMG/2016/70684/m/layer_win04_midge500.png"" alt=""축하합니다. 500 마일리지 당첨"" /></p>" &_
			"<a href=""#"" onclick=""alert('마일리지가 지급되었습니다.');fnClosemask(); return false;"" class=""goBuy"">마일리지 발급받기</a>" &_
			"<span class=""code"">" & md5userid & "</span>"
	End if

	''/// 당첨결과 출력
	Response.write "OK|" &_
			"<div class=""layerCont"">" &_
			"<button class=""btnClose""><img src=""http://webimage.10x10.co.kr/eventIMG/2016/70684/m/btn_layer_close.png"" onclick=""fnClosemask();"" alt=""닫기"" /></button>" &_
			"<div class=""win"">" & rstCont & "</div></div>"
			
End if

'=======================================================

'// 이벤트 응모 저장 처리
Sub fnAddEvtSubscript(ecd,uid,opt1,opt2,dvc)
	dim sqlstr
	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& ecd &", '"& uid &"', '" & opt1 & "', '" & opt2 & "', '"&dvc&"')"
	dbget.execute sqlstr
end Sub

'// 상품 담청 쿠폰 발급
Sub fnSetItemCouponDown(ByVal userid, ByVal idx)
	dim sqlStr, rvalue
	Dim objCmd
	Set objCmd = Server.CreateObject("ADODB.COMMAND")
	With objCmd
		.ActiveConnection = dbget
		.CommandType = adCmdText
		.CommandText = "{?= call [db_item].[dbo].sp_Ten_itemcoupon_down("&idx&",'"&userid&"')}"
		.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
		.Execute, , adExecuteNoRecords
		End With	
		rvalue = objCmd(0).Value	
	Set objCmd = Nothing	

	SELECT CASE  rvalue 
		CASE 0
			Response.Write "Err|데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해주십시오.E07"
			dbget.close()	:	response.End
		CASE 1
			'정상 쿠폰 발급!!
		CASE 2
			'// 기간 종료 또는 없는 쿠폰
			Response.Write "Err|데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해주십시오.E08"
			dbget.close()	:	response.End
		CASE 3
			''Response.Write "Err|이미 쿠폰을 받으셨습니다."
			''dbget.close()	:	response.End
		case else
			Response.Write "Err|데이터 처리에 예외 상황이 발생하였습니다. 관리자에게 문의해주십시오.E09"
			dbget.close()	:	response.End
	END Select
End Sub

'// 마일리지 지급처리
Sub fnAddUserMileage(uid)
	dim sqlStr, isChk
	sqlStr = "Select count(*) cnt from [db_user].[dbo].tbl_mileagelog Where userid='" & uid & "' and jukyocd='" & eCode & "'"
	rsget.Open sqlStr, dbget, 1
		isChk = rsget("cnt")>0
	rsget.Close

	if Not(isChk) then
		sqlStr = "insert into [db_user].[dbo].tbl_mileagelog(userid,mileage,jukyocd,jukyo)" + vbCrlf
		sqlStr = sqlStr + " values('" + CStr(uid) + "',500,'" & eCode & "','오벤져스 이벤트 마일리지')"
		dbget.Execute(sqlStr)
	
		sqlStr = "update [db_user].[dbo].tbl_user_current_mileage" + vbCrlf
		sqlStr = sqlStr + " set bonusmileage=bonusmileage + 500 " + vbCrlf
		sqlStr = sqlStr + " where userid='" + CStr(uid) + "'"
	
		dbget.Execute(sqlStr)
	End if
end Sub
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->