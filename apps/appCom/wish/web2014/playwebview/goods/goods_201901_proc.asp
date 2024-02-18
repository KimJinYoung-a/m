<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.Charset="UTF-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'###########################################################
' Description : 플레이 goods 행운의 복덩이
' History : 2018-12-27 이종화
'###########################################################

dim sqlStr, LoginUserid
Dim eCode , mode , snsnum , evtUserCell , refip , refer , md5userid , renloop
Dim device , couponidx
Dim actdate : actdate = Date()
dim grandPrizeDate : grandPrizeDate = "2019-01-07"

'actdate = "2019-01-07" '// 테스트 코드

if isapp then
	device = "A"
else
	device = "M"
end if

IF application("Svr_Info") = "Dev" THEN
	eCode   =  90203
    couponidx = 2895
Else
	eCode   =  91505
    couponidx = 1115
End If

mode		= requestcheckvar(request("mode"),32) '// add
snsnum 		= requestcheckvar(request("snsnum"),10)
LoginUserid	= getLoginUserid()
evtUserCell	= get10x10onlineusercell(LoginUserid) '// 참여한 회원 핸드폰번호
refip 		= Request.ServerVariables("REMOTE_ADDR") '// ip
refer 		= request.ServerVariables("HTTP_REFERER") '// 레퍼러
md5userid 	= md5(LoginUserid&"10") '//회원아이디 + 10 md5 암호화

'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "Err|잘못된 접속입니다."
	Response.End
End If

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "Err|로그인 후 참여하실 수 있습니다."
	response.End
End If

'// 상품명
Function itemprize(winrank)
    if winrank = "gift100" then 
	    itemprize = "100만원 행운의 복덩이"
    else
        itemprize = "행운의 복덩이"
    end if 
End Function

'// 상품코드
Function itemprizecode()
	itemprizecode = "2196912"
End Function

'// 일자별 상품 제한
function itemprizecount(v)
    Select Case CStr(v)
		Case "2019-01-02"
			itemprizecount = 500
		Case "2019-01-03"
			itemprizecount = 300
		Case "2019-01-04"
			itemprizecount = 400
		Case "2019-01-05"
			itemprizecount = 100
		Case "2019-01-06"
			itemprizecount = 119
		Case "2019-01-07"
			itemprizecount = 300
		Case "2019-01-08"
			itemprizecount = 306
		Case "2019-01-09"
			itemprizecount = 420
		Case Else
			itemprizecount = 1
	end Select       
end function

'// 구간 비교 s 랜덤결과 , v 기준값
function compareDice(s , v)
	compareDice = chkiif(s < v ,true,false)
end function 

'// 당첨 타임 구간
function winLoseTimeSection(v,r)
	dim vDefaultPoint : vDefaultPoint = 0
	Select Case CStr(v)
        Case "2019-01-02" , "2019-01-03" , "2019-01-04"
			vDefaultPoint = 75

			winLoseTimeSection = compareDice(r,vDefaultPoint)
		Case "2019-01-05" , "2019-01-09"
			vDefaultPoint = 300

			winLoseTimeSection = compareDice(r,vDefaultPoint)
		Case "2019-01-06" , "2019-01-07" , "2019-01-08"
			vDefaultPoint = 75

			winLoseTimeSection = compareDice(r,vDefaultPoint)
		Case Else
			winLoseTimeSection = false
	end Select
end function

'// 특정일 1등 당첨
function grandprize(d)
    dim winsqlstr , wincnt , grandprizeloop
    randomize
	grandprizeloop=int(Rnd*6)+1

    'grandprizeloop = 1 '// 테스트 코드 

    if DateDiff("d",d,grandPrizeDate) = 0 then
        if grandprizeloop = 1 then
            winsqlstr = "select count(*) as icnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &" and sub_opt3 = 'gift100'"
            rsget.Open winsqlstr, dbget, 1
                wincnt = rsget("icnt")
            rsget.close

            if wincnt = 0 then '// 1등 없을때
                grandprize = "gift100"
            else
                grandprize = "giftetc"
            end if 
        else
            grandprize = "giftetc"    
        end if 
    else
        grandprize = "giftetc"
    end if 
end function

'// 실패 꽝 레이어 이미지 교체
function loserimg()
    dim loserrenloop
    randomize
	loserrenloop=int(Rnd*5)+1

    select case loserrenloop
        case 1
            loserimg = "http://webimage.10x10.co.kr/fixevent/play/goods/674/txt_result_3_1_v2.png"
        case 2
            loserimg = "http://webimage.10x10.co.kr/fixevent/play/goods/674/txt_result_3_2_v2.png"
        case 3
            loserimg = "http://webimage.10x10.co.kr/fixevent/play/goods/674/txt_result_3_3_v2.png"
        case 4
            loserimg = "http://webimage.10x10.co.kr/fixevent/play/goods/674/txt_result_3_4_v2.png"
        case 5
            loserimg = "http://webimage.10x10.co.kr/fixevent/play/goods/674/txt_result_3_5_v2.png"
        Case Else
            loserimg = ""
    end select
end function
'#################################################################################################
'기본 체크 영역
'#################################################################################################
''처리 순서 0
''전화번호 중복당첨 꽝처리
Function duplnum(r)
	Dim dsqlStr
	If event_userCell_Selection_nodate(evtUserCell, eCode) > 0 Then '//전화번호 중복 당첨 꽝처리 - 날짜 없음
		If r = 1 Then 
			dsqlStr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" & vbcrlf
			dsqlStr = dsqlStr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
			dbget.execute dsqlStr
		Else
			dsqlStr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" & vbcrlf
			dsqlStr = dsqlStr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
			dbget.execute dsqlStr
		End If 

		'// 해당 유저의 로그값 집어넣는다.
		dsqlStr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" & vbcrlf
		dsqlStr = dsqlStr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복비당첨처리', '"&device&"')"
		dbget.execute dsqlStr

		Response.write returnvalue2()
		dbget.close()	:	response.End
	End If
End Function 

''처리순서 1
''초기 당첨 여부
Function floor1st()
	Dim winlose
	randomize
	renloop=int(Rnd*1000)+1

    'renloop = 30 '// 테스트 코드

	If winLoseTimeSection(actdate,renloop) Then 
		floor1st = true
	Else
		floor1st = false '// 아님 걍 꽝 // 테스트시엔 ture로 돌리고 테스트
	End If 

	If GetLoginUserLevel = 7 Then '// staff 등급 제외
		floor1st = false '// 걍 꽝
	End If 
End Function

''처리순서 2
''상품 카운트 - 이전당첨 유무
Function prizeproc(v,r)
	Dim isqlStr , icnt
	sqlstr = "select count(*) as icnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &" and sub_opt2 = "& v &" and datediff(day,regdate,getdate()) = 0 "			
	rsget.Open sqlstr, dbget, 1
		icnt = rsget("icnt")
	rsget.close

	If icnt >= itemprizecount(actdate) Then 
		'// 꽝처리 return => false
		prizeproc = lose_proc(r)
	Else
		'// 당첨 입력 처리 return => true
		prizeproc = win_proc(v,r)
	End If 
End Function

''처리순서 2-1-1
''당첨처리
Function win_proc(v,r)
    dim winrank : winrank = grandprize(actdate)
	Dim wsqlStr
	If r = 1 Then '//최초응모
		'// 최초응모자 당첨처리
		wsqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2 , sub_opt3, device)" & vbcrlf
		wsqlstr = wsqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"& v &"', '"&winrank&"' , '"&device&"')"
		dbget.execute wsqlstr
	Else '// 2번째 응모자
		'// SNS 공유자 당첨처리
		wsqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"& v &"'" & vbcrlf
		wsqlstr = wsqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
		dbget.execute wsqlstr
	End If 

	'// 해당 유저의 로그값 집어넣는다.
	wsqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" & vbcrlf
	wsqlstr = wsqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '"& itemprize(winrank) &"', '"&device&"')"
	dbget.execute wsqlstr

	Response.write returnvalue(winrank) '//결과 html vResult 결과
End Function

''처리순서 2-1-2
''꽝처리
Function lose_proc(r)
	Dim lsqlStr
	If r = 1 Then '//최초응모
		'// 최초응모자 꽝처리
		lsqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" & vbcrlf
		lsqlstr = lsqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
		dbget.execute lsqlstr
	Else
		'// 두번째응모자 꽝처리
		lsqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" & vbcrlf
		lsqlstr = lsqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
		dbget.execute lsqlstr
	End If 

	'// 해당 유저의 로그값 집어넣는다.
	lsqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1 , value3, device)" & vbcrlf
	lsqlstr = lsqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '꽝', '"&device&"')"
	dbget.execute lsqlstr

	Response.write returnvalue2() '//결과 html
End Function

''처리순서 3
''메시지 리턴 처리 'html
Function returnvalue(v)
	Select Case CStr(v)
		Case "gift100"
			returnvalue = "OK|<div class='winner'><img src='http://webimage.10x10.co.kr/fixevent/play/goods/674/txt_result_2_v2.png' alt='100만원 복덩이 당첨' /><a href='' class='btn-get' onclick=""goDirOrdItem("& itemprizecode() &");return false;""><img src='http://webimage.10x10.co.kr/fixevent/play/goods/674/btn_buy_1_v2.png' alt='배송비 결제하고 복덩이 데려가기' /></a><a href='' class='share' onclick=""sharesns('winka');return false;""><img src='http://webimage.10x10.co.kr/fixevent/play/goods/674/btn_share_1_v2.png' alt='친구에게 소문내기' /></a><p class='code'>"& md5userid &"</p></div>"
		Case "giftetc"
			returnvalue = "OK|<div class='winner'><img src='http://webimage.10x10.co.kr/fixevent/play/goods/674/txt_result_1_v2.png' alt='복덩이 당첨!' /><a href='' class='btn-get' onclick=""goDirOrdItem("& itemprizecode() &");return false;""><img src='http://webimage.10x10.co.kr/fixevent/play/goods/674/btn_buy_1_v2.png' alt='배송비 결제하고 복덩이 데려가기' /></a><a href='' class='share' onclick=""sharesns('winka');return false;""><img src='http://webimage.10x10.co.kr/fixevent/play/goods/674/btn_share_1_v2.png' alt='친구에게 소문내기' /></a><p class='code'>"& md5userid &"</p></div>"
		Case Else
			returnvalue = "OK|<div class='case1'>응모일이아닙니다.</div>"
	end Select
End Function

'' 꽝메시지
Function returnvalue2()
    returnvalue2 = "OK|<div class='loser'><img src='"& loserimg() &"' alt='아쉽지만..복덩이 대신 복쿠폰 2019년, 당신은 새로운 것을 시도하면 좋은 일이 많이 생길 것 같네요! 오늘부터 새로운 도전을 준비하세요!' /><a href='' class='btn-get' onclick=""coupondown();return false;""><img src='http://webimage.10x10.co.kr/fixevent/play/goods/674/btn_buy_2_v2.png' alt='복쿠폰받기' /></a><a href='' class='share' onclick=""sharesns('ka');return false;""><img src='http://webimage.10x10.co.kr/fixevent/play/goods/674/btn_share_2_v2.png' alt='친구에게 공유 후 한번 더 뽑기!' /></a><script>$(function(){$('.luckbag').css('display', 'none');$('.luckbag span i').css('background-image', 'none');});</script></div>"
End Function

'------------------------------------------------------------------------------------------------------------
'---처리
'------------------------------------------------------------------------------------------------------------
Dim result1 , result2 , result3 , snschk
If mode = "add" Then 		'//응모버튼 클릭
	'// 응모내역 검색
	sqlstr = ""
	sqlstr = sqlstr & " SELECT TOP 1 sub_opt1 , sub_opt2 , sub_opt3 "
	sqlstr = sqlstr & " FROM [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " WHERE evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
	rsget.Open sqlstr, dbget, 1
	If Not(rsget.bof Or rsget.Eof) Then
		'// 기존에 응모 했을때 값
		result1 = rsget(0) '//응모회수 1,2
		result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 경품코드가 들어가 있을경우엔 당첨
		result3 = rsget(2) '//SNS 2차 응모 확인용
	Else
		'// 최초응모
		result1 = ""
		result2 = ""
		result3 = ""
	End IF
	rsget.close

	If result1 = "" Then '//1차 응모
		'//어뷰징 아웃!
		if userBlackListCheck(LoginUserid) Then
			'Response.write "이색히야 넌 영원히 꽝이야"
			lose_proc(1) '//꽝처리
			dbget.close()	:	response.End
		End If 	

		duplnum(1) '//전화번호 걸러내기 통과후 아래로

		If floor1st() Then '//1차 당첨 or 비당첨
			Call prizeproc(1,1) '//당첨후 상품 처리 
			dbget.close()	:	response.End
		Else
			lose_proc(1) '//꽝처리
			dbget.close()	:	response.End
		End If
	ElseIf result1 = 1 Then '//2차 응모
		If result3 <> "" Then '//sns 공유 체크
			'//어뷰징 아웃!
			if userBlackListCheck(LoginUserid) Then
				'Response.write "이색히야 넌 영원히 꽝이야"
				lose_proc(2) '//꽝처리
				dbget.close()	:	response.End
			End If 	
			
			duplnum(2) '//전화번호 걸러내기 통과후 아래로

			If result2 > 0 Then '//1차 당첨이력이 있을경우
				lose_proc(2) '//꽝처리
				dbget.close()	:	response.End
			else
				If floor1st() Then '//2차 당첨 or 비당첨
					Call prizeproc(1,2) '//당첨후 상품 처리 
					dbget.close()	:	response.End
				Else
					lose_proc(2) '//꽝처리
					dbget.close()	:	response.End
				End If 
			End If 
		Else
			Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
			response.End
		End If 
	Else '//금일 모두 응모
		Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
		response.End
	End If 
ElseIf mode = "snschk" Then '//SNS 클릭
	'//응모내역
    if snsnum = "winka" then '// 당첨후 소문내기
        Response.write "OK|ka|ka"
        response.end
    end if 

	sqlStr = ""
	sqlStr = sqlStr & " SELECT TOP 1 sub_opt1, isnull(sub_opt3, '') as sub_opt3 "
	sqlStr = sqlStr & " FROM db_event.dbo.tbl_event_subscript "
	sqlStr = sqlStr & " WHERE evt_code='"& eCode &"'"
	sqlStr = sqlStr & " and userid='"& LoginUserid &"' and datediff(day, regdate, getdate()) = 0 "
	rsget.Open sqlStr, dbget, 1
	If Not rsget.Eof Then
		'//최초 응모
		result1	= rsget(0) '//응모1차 or 2차 응모여부
		snschk	= rsget(1) '//2차 응모 확인용 null , ka , fb , tw
	Else
		'//최초응모
		result1 = ""
		snschk = ""
	End IF
	rsget.close

	If result1 = "" and snschk = "" Then 																	'참여 이력이 없음 - 응모후 이용 하시오
		Response.Write "Err|none"
		dbget.close()	:	response.End
	ElseIf CStr(result1) <> "" And (snschk = "") Then														'1회 참여시 
		sqlStr = ""
		sqlStr = sqlStr & " UPDATE db_event.dbo.tbl_event_subscript SET " & vbcrlf
		sqlStr = sqlStr & " sub_opt3 = '"& snsnum &"'" & vbcrlf
		sqlStr = sqlStr & " WHERE evt_code = "& eCode &" and userid = '"& LoginUserid &"' and datediff(day, regdate, getdate()) = 0 " & vbcrlf
		dbget.execute sqlStr 
		If snsnum = "tw" Then
			Response.write "OK|tw|tw"
		ElseIf snsnum = "fb" Then
			Response.write "OK|fb|fb"
		ElseIf snsnum = "ka" Then
			Response.write "OK|ka|ka"
		Else
			Response.write "error"
		End If
		dbget.close()	:	response.End
	ElseIf CStr(result1) <> "" And (snschk = "ka" or snschk = "tw" or snschk = "fb") Then	'오늘의 응모는 모두 완료!\n내일 또 도전해 주세요!
		Response.Write "Err|end|"
		dbget.close()	:	response.End
	Else
		Response.write "Err|end|"
		dbget.close()	:	response.End
	End If
Elseif mode = "coupondown" then
    dim todaycnt , couponSql

    sqlstr = ""
    sqlstr = sqlstr & " SELECT count(*) as icnt "
	sqlstr = sqlstr & " FROM [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " WHERE evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 and sub_opt2 = 0 "
    rsget.Open sqlStr, dbget, 1
	If Not rsget.Eof Then
		todaycnt = rsget("icnt") '//응모1차 or 2차 응모여부
	end if 

    if todaycnt > 0 then '// 대상자
        '// 쿠폰 발급
		couponSql = "IF NOT EXISTS(select masteridx from [db_user].[dbo].tbl_user_coupon where userid='"& LoginUserid &"' and masteridx="& couponidx &")" & vbcrlf
		couponSql = couponSql & " BEGIN " & vbcrlf
        couponSql = couponSql & " 	INSERT INTO [db_user].[dbo].tbl_user_coupon" & vbcrlf
        couponSql = couponSql & " 	(masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" & vbcrlf
        couponSql = couponSql & " 	SELECT idx, '"& LoginUserid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist, startdate, expiredate,couponmeaipprice,validsitename" & vbcrlf
        couponSql = couponSql & " 	FROM [db_user].[dbo].tbl_user_coupon_master" & vbcrlf
        couponSql = couponSql & " 	WHERE idx="& couponidx &"" & vbcrlf
		couponSql = couponSql & " END "
       
        dbget.execute couponSql

        Response.Write "11||쿠폰이 발급되었습니다."
    else
        Response.Write "Err|end|"
        dbget.close() : response.End
    end if 
Else
	Response.Write "Err|정상적인 경로로 응모해주시기 바랍니다."
	dbget.close() : Response.End
End If	
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->