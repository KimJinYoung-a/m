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
' Description : 100원의 기적 - 실시간당첨이벤트
' History : 2018-03-22 이종화 
'###########################################################

dim sqlStr, LoginUserid
Dim eCode , mode , couponidx , snsnum , evtUserCell , refip , refer , md5userid , renloop
Dim device
Dim opendate : opendate = Date()

if isapp then
	device = "A"
else
	device = "M"
end if

eCode 		= "85145" '// 이벤트 번호
couponidx	= "1037" '// 쿠폰번호 무배쿠폰 / 10000원

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
Function itemprize(v)
	Select Case CStr(v)
		Case "2018-04-02"
			itemprize = "LG그램 13인치"
		Case "2018-04-03"
			itemprize = "닌텐도 스위치 본체"
		Case "2018-04-04"
			itemprize = "아이폰X 256GB"
		Case "2018-04-05"
			itemprize = "브리츠 멀티플레이어"
		Case "2018-04-06"
			itemprize = "소니 미러리스 A6000L"
		Case "2018-04-07"
			itemprize = "다이슨 슈퍼소닉"
		Case "2018-04-08"
			itemprize = "발뮤다 공기청정기"
		Case "2018-04-09"
			itemprize = "아이패드 Pro 10.5"
		Case "2018-04-10"
			itemprize = "미스터 마리아 미피램프 S"
		Case "2018-04-11"
			itemprize = "다이슨 V10 앱솔루트"
		Case "2018-04-12"
			itemprize = "드롱기 커피머신"
		Case "2018-04-13"
			itemprize = "발뮤다 더 팟 전기주전자"
		Case "2018-04-14"
			itemprize = "폴라로이드 즉석 카메라"
		Case "2018-04-15"
			itemprize = "포켓 빔프로젝터"
		Case "2018-04-16"
			itemprize = "발뮤다 더 토스터"
		Case Else
			itemprize = "LG그램 13인치"
	end Select
End Function

'// 상품코드
Function itemprizecode(v)
	Select Case CStr(v)
		Case "2018-04-02"
			itemprizecode = "1930624" 'LG그램 13인치
		Case "2018-04-03"
			itemprizecode = "1930622" '닌텐도 스위치 본체
		Case "2018-04-04"
			itemprizecode = "1930621" '아이폰X 256GB
		Case "2018-04-05"
			itemprizecode = "1930738" '브리츠 멀티플레이어
		Case "2018-04-06"
			itemprizecode = "1930623" '소니 미러리스 A6000L
		Case "2018-04-07"
			itemprizecode = "1930733" '다이슨 슈퍼소닉
		Case "2018-04-08"
			itemprizecode = "1930625" '발뮤다 공기청정기
		Case "2018-04-09"
			itemprizecode = "1930742" '아이패드 Pro 10.5
		Case "2018-04-10"
			itemprizecode = "1930740" '미스터 마리아 미피램프 S
		Case "2018-04-11"
			itemprizecode = "1930741" '다이슨 V10 앱솔루트
		Case "2018-04-12"
			itemprizecode = "1930735" '드롱기 커피머신
		Case "2018-04-13"
			itemprizecode = "1930739" '발뮤다 더 팟 전기주전자
		Case "2018-04-14"
			itemprizecode = "1930736" '폴라로이드 즉석 카메라
		Case "2018-04-15"
			itemprizecode = "1930737" '포켓 빔프로젝터
		Case "2018-04-16"
			itemprizecode = "1930734" '발뮤다 더 토스터
		Case Else
			itemprizecode = "1930624" 'LG그램 13인치
	end Select
End Function
														

'// 당첨 타임 테이블
Function winlosetimetable(v)
	Select Case CStr(v)
		Case "2018-04-02"
			winlosetimetable = chkiif(hour(now) < 13,false,true)
		Case "2018-04-03"
			winlosetimetable = chkiif(hour(now) < 17,false,true)
		Case "2018-04-04"
			winlosetimetable = chkiif(hour(now) < 19,false,true)
		Case "2018-04-05"
			winlosetimetable = chkiif(hour(now) < 12,false,true)
		Case "2018-04-06"
			winlosetimetable = chkiif(hour(now) < 10,false,true)
		Case "2018-04-07"
			winlosetimetable = chkiif(hour(now) < 15,false,true)
		Case "2018-04-08"
			winlosetimetable = chkiif(hour(now) < 10,false,true)
		Case "2018-04-09"
			winlosetimetable = chkiif(hour(now) < 17,false,true)
		Case "2018-04-10"
			winlosetimetable = chkiif(hour(now) < 15,false,true)
		Case "2018-04-11"
			winlosetimetable = chkiif(hour(now) < 19,false,true)
		Case "2018-04-12"
			winlosetimetable = chkiif(hour(now) < 16,false,true)
		Case "2018-04-13"
			winlosetimetable = chkiif(hour(now) < 18,false,true)
		Case "2018-04-14"
			winlosetimetable = chkiif(hour(now) < 12,false,true)
		Case "2018-04-15"
			winlosetimetable = chkiif(hour(now) < 15,false,true)
		Case "2018-04-16"
			winlosetimetable = chkiif(hour(now) < 18,false,true)
		Case Else
			winlosetimetable = chkiif(hour(now) < 13,false,true)
	end Select
End Function

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
''초기 당첨 여부 (30% 의 확률 당첨 여부 + 타임테이블 내에 속해야함) 
Function floor1st()
	Dim winlose
	randomize
	renloop=int(Rnd*100)+1

	If winlosetimetable(opendate) And renloop < 50 Then  '// 타임테이블 참 그리고 랜덤 거시기 당첨 일때 당첨 0.1%
		floor1st = true
	Else
		floor1st = false '// 아님 걍 꽝 // 테스트시엔 ture로 돌리고 테스트
	End If 

	If GetLoginUserLevel = 7 Then '// staff
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

	If icnt >= 1 Then 
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
	Dim wsqlStr
	If r = 1 Then '//최초응모
		'// 최초응모자 당첨처리
		wsqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" & vbcrlf
		wsqlstr = wsqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"& v &"', '"&device&"')"
		dbget.execute wsqlstr
	Else '// 2번째 응모자
		'// SNS 공유자 당첨처리
		wsqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"& v &"'" & vbcrlf
		wsqlstr = wsqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
		dbget.execute wsqlstr
	End If 

	'// 해당 유저의 로그값 집어넣는다.
	wsqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" & vbcrlf
	wsqlstr = wsqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '"& itemprize(opendate) &"', '"&device&"')"
	dbget.execute wsqlstr

	Response.write returnvalue(opendate) '//결과 html vResult 결과
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

	'//쿠폰 발급
	sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" & vbcrlf
	sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" & vbcrlf
	sqlstr = sqlstr & " 	SELECT idx, '"& LoginUserid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist, getdate(), dateadd(s, -1,dateadd(dd,datediff(dd,0,getdate()+1),0)),couponmeaipprice,validsitename" & vbcrlf
	sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" & vbcrlf
	sqlstr = sqlstr & " 	where idx in ("& couponidx &")"
	'response.write sqlstr & "<br>"
	dbget.execute sqlstr

	'// 해당 유저의 로그값 집어넣는다.
	lsqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1 , value3, device)" & vbcrlf
	lsqlstr = lsqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '무료배송쿠폰', '"&device&"')"
	dbget.execute lsqlstr

	Response.write returnvalue2() '//결과 html
End Function

''처리순서 3
''메시지 리턴 처리 'html
Function returnvalue(v)
	Select Case CStr(v)
		Case "2018-04-02"
			returnvalue = "OK|<div class='case1'><h3><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/tit_congratulation.png' alt='축하합니다! 100원의 기적에 당첨되셨습니다!' /></h3><a href='' onclick='goDirOrdItem("& itemprizecode(opendate) &"); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/miracle_0402.jpg?v=1' alt='당첨' /><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/btn_buy.png' alt='바로 구매하기' /></a><p class='code'>"& md5userid &"</p></div>"
		Case "2018-04-03"
			returnvalue = "OK|<div class='case1'><h3><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/tit_congratulation.png' alt='축하합니다! 100원의 기적에 당첨되셨습니다!' /></h3><a href='' onclick='goDirOrdItem("& itemprizecode(opendate) &"); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/miracle_0403.jpg?v=1' alt='당첨' /><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/btn_buy.png' alt='바로 구매하기' /></a><p class='code'>"& md5userid &"</p></div>"
		Case "2018-04-04"
			returnvalue = "OK|<div class='case1'><h3><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/tit_congratulation.png' alt='축하합니다! 100원의 기적에 당첨되셨습니다!' /></h3><a href='' onclick='goDirOrdItem("& itemprizecode(opendate) &"); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/miracle_0404.jpg?v=1' alt='당첨' /><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/btn_buy.png' alt='바로 구매하기' /></a><p class='code'>"& md5userid &"</p></div>"
		Case "2018-04-05"
			returnvalue = "OK|<div class='case1'><h3><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/tit_congratulation.png' alt='축하합니다! 100원의 기적에 당첨되셨습니다!' /></h3><a href='' onclick='goDirOrdItem("& itemprizecode(opendate) &"); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/miracle_0405.jpg?v=1' alt='당첨' /><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/btn_buy.png' alt='바로 구매하기' /></a><p class='code'>"& md5userid &"</p></div>"
		Case "2018-04-06"
			returnvalue = "OK|<div class='case1'><h3><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/tit_congratulation.png' alt='축하합니다! 100원의 기적에 당첨되셨습니다!' /></h3><a href='' onclick='goDirOrdItem("& itemprizecode(opendate) &"); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/miracle_0406.jpg?v=1' alt='당첨' /><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/btn_buy.png' alt='바로 구매하기' /></a><p class='code'>"& md5userid &"</p></div>"
		Case "2018-04-07"
			returnvalue = "OK|<div class='case1'><h3><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/tit_congratulation.png' alt='축하합니다! 100원의 기적에 당첨되셨습니다!' /></h3><a href='' onclick='goDirOrdItem("& itemprizecode(opendate) &"); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/miracle_0407.jpg?v=1' alt='당첨' /><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/btn_buy.png' alt='바로 구매하기' /></a><p class='code'>"& md5userid &"</p></div>"
		Case "2018-04-08"
			returnvalue = "OK|<div class='case1'><h3><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/tit_congratulation.png' alt='축하합니다! 100원의 기적에 당첨되셨습니다!' /></h3><a href='' onclick='goDirOrdItem("& itemprizecode(opendate) &"); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/miracle_0408.jpg?v=1' alt='당첨' /><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/btn_buy.png' alt='바로 구매하기' /></a><p class='code'>"& md5userid &"</p></div>"
		Case "2018-04-09"
			returnvalue = "OK|<div class='case1'><h3><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/tit_congratulation.png' alt='축하합니다! 100원의 기적에 당첨되셨습니다!' /></h3><a href='' onclick='goDirOrdItem("& itemprizecode(opendate) &"); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/miracle_0409.jpg?v=1' alt='당첨' /><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/btn_buy.png' alt='바로 구매하기' /></a><p class='code'>"& md5userid &"</p></div>"
		Case "2018-04-10"
			returnvalue = "OK|<div class='case1'><h3><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/tit_congratulation.png' alt='축하합니다! 100원의 기적에 당첨되셨습니다!' /></h3><a href='' onclick='goDirOrdItem("& itemprizecode(opendate) &"); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/miracle_0410.jpg?v=1' alt='당첨' /><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/btn_buy.png' alt='바로 구매하기' /></a><p class='code'>"& md5userid &"</p></div>"
		Case "2018-04-11"
			returnvalue = "OK|<div class='case1'><h3><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/tit_congratulation.png' alt='축하합니다! 100원의 기적에 당첨되셨습니다!' /></h3><a href='' onclick='goDirOrdItem("& itemprizecode(opendate) &"); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/miracle_0411.jpg?v=1' alt='당첨' /><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/btn_buy.png' alt='바로 구매하기' /></a><p class='code'>"& md5userid &"</p></div>"
		Case "2018-04-12"
			returnvalue = "OK|<div class='case1'><h3><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/tit_congratulation.png' alt='축하합니다! 100원의 기적에 당첨되셨습니다!' /></h3><a href='' onclick='goDirOrdItem("& itemprizecode(opendate) &"); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/miracle_0412.jpg?v=1' alt='당첨' /><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/btn_buy.png' alt='바로 구매하기' /></a><p class='code'>"& md5userid &"</p></div>"
		Case "2018-04-13"
			returnvalue = "OK|<div class='case1'><h3><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/tit_congratulation.png' alt='축하합니다! 100원의 기적에 당첨되셨습니다!' /></h3><a href='' onclick='goDirOrdItem("& itemprizecode(opendate) &"); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/miracle_0413.jpg?v=1' alt='당첨' /><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/btn_buy.png' alt='바로 구매하기' /></a><p class='code'>"& md5userid &"</p></div>"
		Case "2018-04-14"
			returnvalue = "OK|<div class='case1'><h3><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/tit_congratulation.png' alt='축하합니다! 100원의 기적에 당첨되셨습니다!' /></h3><a href='' onclick='goDirOrdItem("& itemprizecode(opendate) &"); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/miracle_04142.jpg?v=1' alt='당첨' /><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/btn_buy.png' alt='바로 구매하기' /></a><p class='code'>"& md5userid &"</p></div>"
		Case "2018-04-15"
			returnvalue = "OK|<div class='case1'><h3><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/tit_congratulation.png' alt='축하합니다! 100원의 기적에 당첨되셨습니다!' /></h3><a href='' onclick='goDirOrdItem("& itemprizecode(opendate) &"); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/miracle_0415.jpg?v=1' alt='당첨' /><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/btn_buy.png' alt='바로 구매하기' /></a><p class='code'>"& md5userid &"</p></div>"
		Case "2018-04-16"
			returnvalue = "OK|<div class='case1'><h3><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/tit_congratulation.png' alt='축하합니다! 100원의 기적에 당첨되셨습니다!' /></h3><a href='' onclick='goDirOrdItem("& itemprizecode(opendate) &"); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/miracle_0416.jpg?v=1' alt='당첨' /><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/btn_buy.png' alt='바로 구매하기' /></a><p class='code'>"& md5userid &"</p></div>"
		Case Else
			returnvalue = "OK|<div class='case1'><h3><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/tit_congratulation.png' alt='축하합니다! 100원의 기적에 당첨되셨습니다!' /></h3><a href='' onclick='goDirOrdItem("& itemprizecode(opendate) &"); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/miracle_0402.jpg?v=1' alt='당첨' /><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/btn_buy.png' alt='바로 구매하기' /></a><p class='code'>"& md5userid &"</p></div>"
	end Select
End Function

'' 꽝메시지
Function returnvalue2()
	If isapp Then 
	returnvalue2 = "OK|<div class='case2'><h3><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/tit_fail.png' alt='100원의 기적에 당첨되지 않았어요. 대신, 텐바이텐이 고객님께 배송비를 선물할게요!' /></h3><div><a href='' onclick=""fnAPPpopupCouponBook_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp');return false;""><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/btn_coupon.png' alt='쿠폰함으로 가기' /></a></div><script>$(function(){ $('#moreshare').show(); });</script></div>"
	Else
	returnvalue2 = "OK|<div class='case2'><h3><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/tit_fail.png' alt='100원의 기적에 당첨되지 않았어요. 대신, 텐바이텐이 고객님께 배송비를 선물할게요!' /></h3><div><a href='/my10x10/couponbook.asp'><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/btn_coupon.png' alt='쿠폰함으로 가기' /></a></div><script>$(function(){ $('#moreshare').show(); });</script></div>"
	End If 
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
		Response.write "error"
	End If
Else
	Response.Write "Err|정상적인 경로로 응모해주시기 바랍니다."
	dbget.close() : Response.End
End If	



%>
<!-- #include virtual="/lib/db/dbclose.asp" -->