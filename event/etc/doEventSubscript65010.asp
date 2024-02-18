<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'#######################################################
'	History	: 2015.07.23 유태욱 생성
'	Description : 냉동실을 부탁해
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
	Dim LoginUserid
	Dim eCode, sqlstr
	Dim nowdate, refip, refer
	Dim pdName1, pdName2, pdName3
	Dim renloop1, renloop2, renloop3
	Dim	DayName1, DayName2, DayName3, imgmon
	Dim renloop1min, renloop2min, renloop3min
	Dim renloop1max, renloop2max, renloop3max
	Dim evtItemCnt1, evtItemCnt2, evtItemCnt3
	Dim evtItemCode1, evtItemCode2, evtItemCode3
	Dim cnt, evtimagenum, couponid, fselchef, device
	Dim result1, result2, result3, mode, md5userid, evtUserCell

	If isapp then
		device = "A"
	else
		device = "M"
	end if

	nowdate = now()
'						nowdate = "2015-07-27 10:10:00"

	LoginUserid = getLoginUserid()
	refip = Request.ServerVariables("REMOTE_ADDR")
	refer = request.ServerVariables("HTTP_REFERER")
	mode = requestcheckvar(request("mode"),32)
	fselchef = requestcheckvar(request("fselchef"),1)
	evtUserCell = get10x10onlineusercell(LoginUserid) '// 참여한 회원 핸드폰번호

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  64837
		couponid = 2727
	Else
		eCode   =  65010
		couponid = 758
	End If

	'//응모 확율
	randomize
	renloop1=int(Rnd*10000)+1
	renloop2=int(Rnd*10000)+1
	renloop3=int(Rnd*10000)+1

If left(nowdate,10)="2015-08-07" Then		'''동적확율
	''확율조정
	''1번쉐프
	renloop1min = 10000		''0
	renloop1max = 10002
	
	''2번쉐프
	renloop2min = 10000		''0
	renloop2max = 10002

	''3번쉐프
	renloop3min = 4999		''10
	renloop3max = 6001

else							'''
	''1번쉐프
	renloop1min = 10000		''0
	renloop1max = 10002
	
	''2번쉐프
	renloop2min = 10000		''0
	renloop2max = 10002

	''3번쉐프
	renloop3min = 10000		''0
	renloop3max = 10002
end if

	'// 당첨시 확실히 판단하기 위해 userid에 "10"스트링으로 더해 md5값 만들어 보여줌
	md5userid = md5(LoginUserid&"10")

	''1주차,2주차 구분
	If left(nowdate,10)<"2015-08-03" Then
		imgmon	=	"01"
	else
		imgmon	=	"02"
	end if

	''당첨레이어 구분
	If left(nowdate,10)<"2015-07-28" or left(nowdate,10)="2015-08-03" Then
		DayName1 = "01"
		DayName2 = "02"
		DayName3 = "03"
	elseif left(nowdate,10)="2015-07-28" or left(nowdate,10)="2015-08-04" Then
		DayName1 = "04"
		DayName2 = "05"
		DayName3 = "06"
	elseif left(nowdate,10)="2015-07-29" or left(nowdate,10)="2015-08-05" Then
		DayName1 = "07"
		DayName2 = "08"
		DayName3 = "09"
	elseif left(nowdate,10)="2015-07-30" or left(nowdate,10)="2015-08-06" Then
		DayName1 = "10"
		DayName2 = "11"
		DayName3 = "12"
	elseif left(nowdate,10)="2015-07-31" or left(nowdate,10)>="2015-08-07" Then
		DayName1 = "13"
		DayName2 = "14"
		DayName3 = "15"
	end if

	If left(nowdate,10)<"2015-07-28" or left(nowdate,10)="2015-08-03" Then
		evtimagenum	=	"0727"

		pdName1 = "베스킨베리"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 5

		pdName2 = "설레임밀크"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 485

		pdName3 = "파리팥빙수"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 10

	elseif left(nowdate,10)="2015-07-28" or left(nowdate,10)="2015-08-04" Then
		evtimagenum	=	"0728"

		pdName1 = "던킨아이스"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 10

		pdName2 = "우유속모카"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 480

		pdName3 = "스타아이스"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 10

	elseif left(nowdate,10)="2015-07-29" Then
		evtimagenum	=	"0729"

		pdName1 = "스무디베리"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 10

		pdName2 = "메로나"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 480

		pdName3 = "베스킨사과"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 10

	elseif left(nowdate,10)="2015-08-05" Then
		evtimagenum	=	"0805"

		pdName1 = "스무디베리"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 12

		pdName2 = "메로나"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 580

		pdName3 = "베스킨사과"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 13

	elseif left(nowdate,10)="2015-07-30" or left(nowdate,10)="2015-08-06" Then
		evtimagenum	=	"0730"

		pdName1 = "베스킨엄마"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 10

		pdName2 = "베스킨롤"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 470

		pdName3 = "스타초콜릿"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 20

	elseif left(nowdate,10)="2015-07-31" or left(nowdate,10)>="2015-08-07" Then
		evtimagenum	=	"0731"

		pdName1 = "베스킨감사"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 5

		pdName2 = "베스킨마카롱"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 10

		pdName3 = "베스킨싱글"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 485
	end if

	'// 나간 수량
	sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2<>0"
	rsget.Open sqlstr, dbget, 1
		cnt = rsget(0)
	rsget.close

	'// 바로 접속시엔 오류 표시
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If

	'// 솔드아웃
	if left(nowdate,10)="2015-08-05" then
		If cnt > 604 Then
			Response.Write "Err|오늘은 마감되었습니다.!"
			Response.End
		End If
	else
		If cnt > 499 Then
			Response.Write "Err|오늘은 마감되었습니다.!"
			Response.End
		End If
	end if

	'// expiredate
	If not(left(nowdate,10)>="2015-07-27" and left(nowdate,10)<"2015-08-08") Then
		Response.Write "Err|이벤트 응모 기간이 아닙니다."
		Response.End
	End If

	''// 주말 제외
	If left(nowdate,10)="2015-08-01" or left(nowdate,10)="2015-08-02" Then
		Response.Write "Err|주말엔 쉽니다."
		Response.End
	End If

	'// 오전10시부터 응모 가능함, 그 이전에는 응모불가
		If Not(TimeSerial(Hour(nowdate), minute(nowdate), second(nowdate)) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(nowdate), minute(nowdate), second(nowdate)) < TimeSerial(23, 59, 59)) Then
			Response.Write "Err|오전 10시부터 응모하실 수 있습니다."
			Response.End
		End If

	'// 로그인 여부 체크
	If Not(IsUserLoginOK) Then
		Response.Write "Err|로그인 후 참여하실 수 있습니다."
		response.End
	End If

If mode = "add" Then '//응모하기 버튼 클릭
	if fselchef = 1 then	'//1번쉐프 선택시
		If renloop1 > renloop1min and renloop1 < renloop1max Then ''1번 쉐프 선택인데 당첨
			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
			rsget.Open sqlstr, dbget, 1
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모회수 1,2
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(1번쉐프)
			sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2='"&evtItemCode1&"' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget(0)
			rsget.close
		
			'// 최초 응모자면
			If result1="" And result2="" And result3="" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop1,"log01","전화번호중복비당첨",device)

					If left(nowdate,10)<"2015-07-29" then
						Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p></div>"
					else
						if isapp then
							Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='' onclick='fnAPPpopupEvent(65026); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
						else
							Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='/event/eventmain.asp?eventid=65026'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
						end if
					end if
					dbget.close()	:	response.End
				End If
		
				If cnt < evtItemCnt1 then
					'// 최초응모자이고, 1번쉐프 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode1&"', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop1,"log02",pdName1,device)
					
					If isapp then
						Response.write "OK|<div class='freezerCont win'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_win_"&DayName1&".png' alt='허셰프 당첨' /></div><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/txt_win.png' alt='당첨을 축하합니다! 개인정보에 있는 휴대폰 번호로 상품권이 발송됩니다. 휴대폰 번호를 확인해주세요' /></p><div class='myNumber'><p><input type='tel' value="&evtUserCell&" /></p><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp""); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_modify.gif' alt='수정' /></a></div></div>"
					else
						Response.write "OK|<div class='freezerCont win'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_win_"&DayName1&".png' alt='허셰프 당첨' /></div><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/txt_win.png' alt='당첨을 축하합니다! 개인정보에 있는 휴대폰 번호로 상품권이 발송됩니다. 휴대폰 번호를 확인해주세요' /></p><div class='myNumber'><p><input type='tel' value="&evtUserCell&" /></p><a href='http://m.10x10.co.kr/my10x10/userinfo/confirmuser.asp' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_modify.gif' alt='수정' /></a></div></div>"
					end if
					dbget.close()	:	response.End
				Else
					'// 1번쉐프 남은게 없으면 걍 비당첨
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop1,"log03","비당첨",device)
		
					If left(nowdate,10)<"2015-07-29" then
						Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p></div>"
					else
						if isapp then
							Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='' onclick='fnAPPpopupEvent(65026); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
						else
							Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='/event/eventmain.asp?eventid=65026'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
						end if
					end if
					dbget.close()	:	response.End
				end if
			'// 응모를 1회 했을경우
			ElseIf Trim(result1) = "1" Then
				'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
				If Trim(result3)="kakao" Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함--------------
					If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
		
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop1,"log04","전화번호중복비당첨(2번째 도전)",device)
		
						If left(nowdate,10)<"2015-07-29" then
							Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p></div>"
						else
							if isapp then
								Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='' onclick='fnAPPpopupEvent(65026); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
							else
								Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='/event/eventmain.asp?eventid=65026'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
							end if
						end if
						dbget.close()	:	response.End
					End If
		
					If cnt < evtItemCnt1 then
					'// kakao에 값이 있고 기존 당첨자도 아니고, 기존에 당첨 안됐는데 1번쉐프 난수걸리면 당첨 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"&evtItemCode1&"'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
		
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop1,"log05","2번째도전1번쉐프당첨",device)
		
						If isapp then
							Response.write "OK|<div class='freezerCont win'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_win_"&DayName1&".png' alt='허셰프 당첨' /></div><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/txt_win.png' alt='당첨을 축하합니다! 개인정보에 있는 휴대폰 번호로 상품권이 발송됩니다. 휴대폰 번호를 확인해주세요' /></p><div class='myNumber'><p><input type='tel' value="&evtUserCell&" /></p><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp""); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_modify.gif' alt='수정' /></a></div></div>"
						else
							Response.write "OK|<div class='freezerCont win'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_win_"&DayName1&".png' alt='허셰프 당첨' /></div><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/txt_win.png' alt='당첨을 축하합니다! 개인정보에 있는 휴대폰 번호로 상품권이 발송됩니다. 휴대폰 번호를 확인해주세요' /></p><div class='myNumber'><p><input type='tel' value="&evtUserCell&" /></p><a href='http://m.10x10.co.kr/my10x10/userinfo/confirmuser.asp' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_modify.gif' alt='수정' /></a></div></div>"
						end if
						dbget.close()	:	response.End
					else
						'// 1번쉐프 남은게 없으면 걍 비당첨
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
		
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop1,"log06","비당첨(2번째 도전)",device)
		
						If left(nowdate,10)<"2015-07-29" then
							Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p></div>"
						else
							if isapp then
								Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='' onclick='fnAPPpopupEvent(65026); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
							else
								Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='/event/eventmain.asp?eventid=65026'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
							end if
						end if
						dbget.close()	:	response.End
					end if
				Else
					Response.Write "Err|카카오톡으로 친구에게 이벤트 알려주면,>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			'// 2번째 응모까지 다 했을경우(그이외의 경우에도 여기에 걸림)
			Else
				Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
				response.End
			End If
		else
			''//비당첨
			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
			rsget.Open sqlstr, dbget, 1
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모회수 1,2
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close
		
			''// 최초 응모자면
			If result1="" And result2="" And result3="" Then
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
				dbget.execute sqlstr
		 
				'// 해당 유저의 로그값 집어넣는다.
				Call fnCautionEventLog(eCode,LoginUserid,renloop1,"log7","비당첨",device)
		
				If left(nowdate,10)<"2015-07-29" then
					Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p></div>"
				else
					if isapp then
						Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='' onclick='fnAPPpopupEvent(65026); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
					else
						Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='/event/eventmain.asp?eventid=65026'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
					end if
				end if
				dbget.close()	:	response.End
			'// 응모를 1회 했을경우
			ElseIf Trim(result1) = "1" Then
				'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
				If Trim(result3)="kakao" Then
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop1,"log8","비당첨(2번째도전)",device)
		
					If left(nowdate,10)<"2015-07-29" then
						Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p></div>"
					else
						if isapp then
							Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='' onclick='fnAPPpopupEvent(65026); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
						else
							Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='/event/eventmain.asp?eventid=65026'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
						end if
					end if
					dbget.close()	:	response.End
				Else
					Response.Write "Err|카카오톡으로 친구에게 이벤트 알려주면,>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			'// 2번째 응모까지 다 했을경우(그이외의 경우에도 여기에 걸림)
			Else
				Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
				response.End
			End If
		end if
	elseif fselchef = 2 then	'//2번쉐프 선택시
		If renloop2 > renloop2min and renloop2 < renloop2max Then ''2번 쉐프 선택인데 당첨
			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
			rsget.Open sqlstr, dbget, 1
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모회수 1,2
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close
		
			'// 현재 재고 파악(2번쉐프)
			sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2='"&evtItemCode2&"' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget(0)
			rsget.close
		
			'// 최초 응모자면
			If result1="" And result2="" And result3="" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop2,"log9","전화번호중복비당첨",device)
		
					If left(nowdate,10)<"2015-07-29" then
						Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p></div>"
					else
						if isapp then
							Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='' onclick='fnAPPpopupEvent(65026); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
						else
							Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='/event/eventmain.asp?eventid=65026'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
						end if
					end if
					dbget.close()	:	response.End
				End If
		
				If cnt < evtItemCnt2 then
					'// 최초응모자이고, 2번쉐프 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode2&"', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop2,"log10",pdName2,device)
					
					If isapp then
						Response.write "OK|<div class='freezerCont win'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_win_"&DayName2&".png' alt='풍셰프 당첨' /></div><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/txt_win.png' alt='당첨을 축하합니다! 개인정보에 있는 휴대폰 번호로 상품권이 발송됩니다. 휴대폰 번호를 확인해주세요' /></p><div class='myNumber'><p><input type='tel' value="&evtUserCell&" /></p><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp""); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_modify.gif' alt='수정' /></a></div></div>"
					else
						Response.write "OK|<div class='freezerCont win'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_win_"&DayName2&".png' alt='풍셰프 당첨' /></div><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/txt_win.png' alt='당첨을 축하합니다! 개인정보에 있는 휴대폰 번호로 상품권이 발송됩니다. 휴대폰 번호를 확인해주세요' /></p><div class='myNumber'><p><input type='tel' value="&evtUserCell&" /></p><a href='http://m.10x10.co.kr/my10x10/userinfo/confirmuser.asp' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_modify.gif' alt='수정' /></a></div></div>"
					end if
					dbget.close()	:	response.End
				Else
					'// 1번쉐프 남은게 없으면 걍 비당첨
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop2,"log11","비당첨",device)
		
					If left(nowdate,10)<"2015-07-29" then
						Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p></div>"
					else
						if isapp then
							Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='' onclick='fnAPPpopupEvent(65026); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
						else
							Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='/event/eventmain.asp?eventid=65026'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
						end if
					end if
					dbget.close()	:	response.End
				end if
			'// 응모를 1회 했을경우
			ElseIf Trim(result1) = "1" Then
				'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
				If Trim(result3)="kakao" Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함--------------
					If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
		
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop2,"log12","전화번호중복비당첨(2번째 도전)",device)
		
						If left(nowdate,10)<"2015-07-29" then
							Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p></div>"
						else
							if isapp then
								Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='' onclick='fnAPPpopupEvent(65026); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
							else
								Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='/event/eventmain.asp?eventid=65026'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
							end if
						end if
						dbget.close()	:	response.End
					End If
		
					If cnt < evtItemCnt2 then
					'// kakao에 값이 있고 기존 당첨자도 아니고, 기존에 당첨 안됐는데 2번쉐프 난수걸리면 당첨 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"&evtItemCode2&"'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
		
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop2,"log13","2번째도전2번쉐프당첨",device)
		
						If isapp then
							Response.write "OK|<div class='freezerCont win'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_win_"&DayName2&".png' alt='풍셰프 당첨' /></div><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/txt_win.png' alt='당첨을 축하합니다! 개인정보에 있는 휴대폰 번호로 상품권이 발송됩니다. 휴대폰 번호를 확인해주세요' /></p><div class='myNumber'><p><input type='tel' value="&evtUserCell&" /></p><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp""); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_modify.gif' alt='수정' /></a></div></div>"
						else
							Response.write "OK|<div class='freezerCont win'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_win_"&DayName2&".png' alt='풍셰프 당첨' /></div><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/txt_win.png' alt='당첨을 축하합니다! 개인정보에 있는 휴대폰 번호로 상품권이 발송됩니다. 휴대폰 번호를 확인해주세요' /></p><div class='myNumber'><p><input type='tel' value="&evtUserCell&" /></p><a href='http://m.10x10.co.kr/my10x10/userinfo/confirmuser.asp' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_modify.gif' alt='수정' /></a></div></div>"
						end if
						dbget.close()	:	response.End
					else
						'// 2번쉐프 남은게 없으면 걍 비당첨
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
		
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop2,"log14","비당첨(2번째 도전)",device)
		
						If left(nowdate,10)<"2015-07-29" then
							Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p></div>"
						else
							if isapp then
								Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='' onclick='fnAPPpopupEvent(65026); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
							else
								Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='/event/eventmain.asp?eventid=65026'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
							end if
						end if
						dbget.close()	:	response.End
					end if
				Else
					Response.Write "Err|카카오톡으로 친구에게 이벤트 알려주면,>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			'// 2번째 응모까지 다 했을경우(그이외의 경우에도 여기에 걸림)
			Else
				Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
				response.End
			End If
		else
			''//비당첨
			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
			rsget.Open sqlstr, dbget, 1
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모회수 1,2
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close
		
			''// 최초 응모자면
			If result1="" And result2="" And result3="" Then
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
				dbget.execute sqlstr
		 
				'// 해당 유저의 로그값 집어넣는다.
				Call fnCautionEventLog(eCode,LoginUserid,renloop2,"log15","비당첨",device)
		
				If left(nowdate,10)<"2015-07-29" then
					Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p></div>"
				else
					if isapp then
						Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='' onclick='fnAPPpopupEvent(65026); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
					else
						Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='/event/eventmain.asp?eventid=65026'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
					end if
				end if
				dbget.close()	:	response.End
			'// 응모를 1회 했을경우
			ElseIf Trim(result1) = "1" Then
				'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
				If Trim(result3)="kakao" Then
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop2,"log16","비당첨(2번째도전)",device)
		
					If left(nowdate,10)<"2015-07-29" then
						Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p></div>"
					else
						if isapp then
							Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='' onclick='fnAPPpopupEvent(65026); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
						else
							Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='/event/eventmain.asp?eventid=65026'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
						end if
					end if
					dbget.close()	:	response.End
				Else
					Response.Write "Err|카카오톡으로 친구에게 이벤트 알려주면,>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			'// 2번째 응모까지 다 했을경우(그이외의 경우에도 여기에 걸림)
			Else
				Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
				response.End
			End If
		end if
	elseif fselchef = 3 then	'//3번쉐프 선택시
		If renloop3 > renloop3min and renloop3 < renloop3max Then ''3번 쉐프 선택인데 당첨
			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
			rsget.Open sqlstr, dbget, 1
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모회수 1,2
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close
		
			'// 현재 재고 파악(3번쉐프)
			sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2='"&evtItemCode3&"' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget(0)
			rsget.close
		
			'// 최초 응모자면
			If result1="" And result2="" And result3="" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop3,"log17","전화번호중복비당첨",device)
		
					If left(nowdate,10)<"2015-07-29" then
						Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p></div>"
					else
						if isapp then
							Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='' onclick='fnAPPpopupEvent(65026); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
						else
							Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='/event/eventmain.asp?eventid=65026'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
						end if
					end if
					dbget.close()	:	response.End
				End If
		
				If cnt < evtItemCnt3 then
					'// 최초응모자이고, 3번쉐프 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode3&"', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop3,"log18",pdName3,device)
					
					If isapp then
						Response.write "OK|<div class='freezerCont win'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_win_"&DayName3&".png' alt='홍셰프 당첨' /></div><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/txt_win.png' alt='당첨을 축하합니다! 개인정보에 있는 휴대폰 번호로 상품권이 발송됩니다. 휴대폰 번호를 확인해주세요' /></p><div class='myNumber'><p><input type='tel' value="&evtUserCell&" /></p><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp""); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_modify.gif' alt='수정' /></a></div></div>"
					else
						Response.write "OK|<div class='freezerCont win'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_win_"&DayName3&".png' alt='홍셰프 당첨' /></div><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/txt_win.png' alt='당첨을 축하합니다! 개인정보에 있는 휴대폰 번호로 상품권이 발송됩니다. 휴대폰 번호를 확인해주세요' /></p><div class='myNumber'><p><input type='tel' value="&evtUserCell&" /></p><a href='http://m.10x10.co.kr/my10x10/userinfo/confirmuser.asp' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_modify.gif' alt='수정' /></a></div></div>"
					end if
					dbget.close()	:	response.End
				Else
					'// 3번쉐프 남은게 없으면 걍 비당첨
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop3,"log19","비당첨",device)
		
					If left(nowdate,10)<"2015-07-29" then
						Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p></div>"
					else
						if isapp then
							Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='' onclick='fnAPPpopupEvent(65026); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
						else
							Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='/event/eventmain.asp?eventid=65026'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
						end if
					end if
					dbget.close()	:	response.End
				end if
			'// 응모를 1회 했을경우
			ElseIf Trim(result1) = "1" Then
				'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
				If Trim(result3)="kakao" Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함--------------
					If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
		
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop3,"log20","전화번호중복비당첨(2번째 도전)",device)
		
						If left(nowdate,10)<"2015-07-29" then
							Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p></div>"
						else
							if isapp then
								Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='' onclick='fnAPPpopupEvent(65026); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
							else
								Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='/event/eventmain.asp?eventid=65026'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
							end if
						end if
						dbget.close()	:	response.End
					End If
		
					If cnt < evtItemCnt3 then
					'// kakao에 값이 있고 기존 당첨자도 아니고, 기존에 당첨 안됐는데 3번쉐프 난수걸리면 당첨 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"&evtItemCode3&"'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
		
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop3,"log21","2번째도전3번쉐프당첨",device)
		
						If isapp then
							Response.write "OK|<div class='freezerCont win'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_win_"&DayName3&".png' alt='홍셰프 당첨' /></div><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/txt_win.png' alt='당첨을 축하합니다! 개인정보에 있는 휴대폰 번호로 상품권이 발송됩니다. 휴대폰 번호를 확인해주세요' /></p><div class='myNumber'><p><input type='tel' value="&evtUserCell&" /></p><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp""); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_modify.gif' alt='수정' /></a></div></div>"
						else
							Response.write "OK|<div class='freezerCont win'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_win_"&DayName3&".png' alt='홍셰프 당첨' /></div><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/txt_win.png' alt='당첨을 축하합니다! 개인정보에 있는 휴대폰 번호로 상품권이 발송됩니다. 휴대폰 번호를 확인해주세요' /></p><div class='myNumber'><p><input type='tel' value="&evtUserCell&" /></p><a href='http://m.10x10.co.kr/my10x10/userinfo/confirmuser.asp' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_modify.gif' alt='수정' /></a></div></div>"
						end if
						dbget.close()	:	response.End
					else
						'// 3번쉐프 남은게 없으면 걍 비당첨
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
		
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop3,"log22","비당첨(2번째 도전)",device)
		
						If left(nowdate,10)<"2015-07-29" then
							Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p></div>"
						else
							if isapp then
								Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='' onclick='fnAPPpopupEvent(65026); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
							else
								Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='/event/eventmain.asp?eventid=65026'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
							end if
						end if
						dbget.close()	:	response.End
					end if
				Else
					Response.Write "Err|카카오톡으로 친구에게 이벤트 알려주면,>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			'// 2번째 응모까지 다 했을경우(그이외의 경우에도 여기에 걸림)
			Else
				Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
				response.End
			End If
		else
			''//비당첨
			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
			rsget.Open sqlstr, dbget, 1
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모회수 1,2
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close
		
			''// 최초 응모자면
			If result1="" And result2="" And result3="" Then
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
				dbget.execute sqlstr
		 
				'// 해당 유저의 로그값 집어넣는다.
				Call fnCautionEventLog(eCode,LoginUserid,renloop3,"log23","비당첨",device)
		
				If left(nowdate,10)<"2015-07-29" then
					Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p></div>"
				else
					if isapp then
						Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='' onclick='fnAPPpopupEvent(65026); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
					else
						Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='/event/eventmain.asp?eventid=65026'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
					end if
				end if
				dbget.close()	:	response.End
			'// 응모를 1회 했을경우
			ElseIf Trim(result1) = "1" Then
				'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
				If Trim(result3)="kakao" Then
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop3,"log24","비당첨(2번째도전)",device)
		
					If left(nowdate,10)<"2015-07-29" then
						Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p></div>"
					else
						if isapp then
							Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='' onclick='fnAPPpopupEvent(65026); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
						else
							Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='/event/eventmain.asp?eventid=65026'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
						end if
					end if
					dbget.close()	:	response.End
				Else
					Response.Write "Err|카카오톡으로 친구에게 이벤트 알려주면,>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			'// 2번째 응모까지 다 했을경우(그이외의 경우에도 여기에 걸림)
			Else
				Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
				response.End
			End If
		end if
	else	''//쉐프값 없으면 꽝
		''//비당첨
		'// 응모내역 검색
		sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
		sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
		sqlstr = sqlstr & " where evt_code="& eCode &""
		sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
		rsget.Open sqlstr, dbget, 1
		If Not(rsget.bof Or rsget.Eof) Then
			'// 기존에 응모 했을때 값
			result1 = rsget(0) '//응모회수 1,2
			result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
			result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
		Else
			'// 최초응모
			result1 = ""
			result2 = ""
			result3 = ""
		End IF
		rsget.close
	
		''// 최초 응모자면
		If result1="" And result2="" And result3="" Then
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
			dbget.execute sqlstr
	 
			'// 해당 유저의 로그값 집어넣는다.
			Call fnCautionEventLog(eCode,LoginUserid,"","log25","비당첨",device)
	
			If left(nowdate,10)<"2015-07-29" then
				Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p></div>"
			else
				if isapp then
					Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='' onclick='fnAPPpopupEvent(65026); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
				else
					Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='/event/eventmain.asp?eventid=65026'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
				end if
			end if
			dbget.close()	:	response.End
		'// 응모를 1회 했을경우
		ElseIf Trim(result1) = "1" Then
			'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
			If Trim(result3)="kakao" Then
				sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
				sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
				dbget.execute sqlstr
	
				'// 해당 유저의 로그값 집어넣는다.
				Call fnCautionEventLog(eCode,LoginUserid,"","log26","비당첨(2번째도전)",device)
	
				If left(nowdate,10)<"2015-07-29" then
					Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p></div>"
				else
					if isapp then
						Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='' onclick='fnAPPpopupEvent(65026); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
					else
						Response.write "OK|<div class='freezerCont lose'><p class='btnClose lyrClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png' onclick=""fnClosemask();"" alt='닫기' /></p><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_free_coupon.png' alt='무료배송 쿠폰 당첨' /></div><p class='btnCopon'><a href='' onclick='get_coupon(); return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_coupon.png' alt='쿠폰받기' /></a></p><div class='anotherEvt'><a href='/event/eventmain.asp?eventid=65026'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_relate_evt.png' alt='실망하지 마세요! 또 다른 이벤트가 당신을 기다립니다.' /></a></div></div>"
					end if
				end if
				dbget.close()	:	response.End
			Else
				Response.Write "Err|카카오톡으로 친구에게 이벤트 알려주면,>?n도전기회가 한 번 더 생깁니다!"
				response.End
			End If
		'// 2번째 응모까지 다 했을경우(그이외의 경우에도 여기에 걸림)
		Else
			Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
			response.End
		End If
	end if
'// 카카오톡 초대시
elseIf mode = "kakao" Then '//응모하기 버튼 클릭
	'// 로그 넣음
	Call fnCautionEventLog(eCode,LoginUserid,"kakao","log27","카카오 초대 클릭",device)

	'//카카오초대 클릭 카운트 
	'// 응모내역 검색
	sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0"
	rsget.Open sqlstr, dbget, 1
	If Not rsget.Eof Then
		'//최초 응모
		result1 = rsget(0) '//응모회수 1,2
		result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
		result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
	Else
		'// 최초응모
		result1 = ""
		result2 = ""
		result3 = ""
	End IF
	rsget.close

	If result1 = "" Or isnull(result1) Then
		Response.write "NOT1" '//참여 이력이 없음 - 응모후 이용 하시오
		Response.End
	ElseIf result1 = "1" And (result3 = "" Or isnull(result3) Or result3 <> "kakao" or result3 = "NULL") Then '//1회 참여시 
		sqlstr = " update [db_event].[dbo].[tbl_event_subscript] set sub_opt3 = 'kakao'" + vbcrlf
		sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0" + vbcrlf
		dbget.execute sqlstr '// 응모 기회 한번 더줌

		Response.write "SUCCESS"
		dbget.close()	:	response.End
	ElseIf result1 = "1" And result3 = "kakao" Then		'오늘의 초대는 모두 완료!\n내일 또 도전해 주세요!
		Response.write "NOT2"
		Response.end
	ElseIf (result1 = "1" And result3 = "kakao") Or result1 = "2" Then		'오늘의 초대는 모두 완료!\n내일 또 도전해 주세요!
		Response.write "END" '//오늘 참여 끝
		Response.End
	End If
ElseIf mode="coupon" Then
	'//쿠폰 발급
	sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
	sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid)" + vbcrlf
	sqlstr = sqlstr & " values('" &couponid &"','"& LoginUserid &"','3','2000','냉동실을 부탁해<무료배송권>','10000','"& left(nowdate,10) &" 00:00:00','"& left(nowdate,10) &" 23:59:59','',0,'system')"
	dbget.execute sqlstr

	'// 해당 유저의 로그값 집어넣는다.
	Call fnCautionEventLog(eCode,LoginUserid,"coupon","log28","무배쿠폰발급",device)

	Response.write "SUCCESS"
	dbget.close()	:	response.end

else
		Response.Write "Err|잘못된 접속입니다."
		Response.End
End if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->