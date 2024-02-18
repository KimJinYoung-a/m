<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 지구를 멈춰라 처리 WWW
' History : 2016.06.16 유태욱
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
Dim RvConNum, couponidx, RvSelNum
dim totalsubsctiptcnt, bonuscouponexistscount,  currenttime, renloop, winlose, vdaytotalNum
Dim eCode, LoginUserid, mode, sqlStr, result1, result2, result3, device, snsnum, snschk, evtUserCell, refip, refer, md5userid, cnt
dim vPstNum1,vPstNum2,vPstNum3,vPstNum4,vPstNum5,vPstNum6,vPstNum7,vPstNum8,vPstNum9,vPstNum10,vPstNum11,vPstNum12,vPstNum13,vPstNum14,vPstNum15,vPstNum16,vPstNum17,vPstNum18,vPstNum19,vPstNum20,vPstNum21,vPstNum22
dim vPstNum23,vPstNum24,vPstNum25,vPstNum26,vPstNum27,vPstNum28,vPstNum29,vPstNum30,vPstNum31,vPstNum32,vPstNum33,vPstNum34,vPstNum35,vPstNum36,vPstNum37,vPstNum38,vPstNum39,vPstNum40,vPstNum41,vPstNum42,vPstNum43,vPstNum44
		
IF application("Svr_Info") = "Dev" THEN
	eCode 		= "66153"
	couponidx = "2779"
Else
	eCode 		= "71239"
	couponidx = "872"
End If

currenttime = date()
'															currenttime = "2016-06-20"

mode			= requestcheckvar(request("mode"),32)
snsnum 		= requestcheckvar(request("snsnum"),10)
LoginUserid	= getLoginUserid()
evtUserCell	= get10x10onlineusercell(LoginUserid) '// 참여한 회원 핸드폰번호
refip 			= Request.ServerVariables("REMOTE_ADDR")
refer 			= request.ServerVariables("HTTP_REFERER")
md5userid 		= md5(LoginUserid&"10")

'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "Err|잘못된 접속입니다."
	Response.End
End If

'// expiredate
If not(currenttime >= "2016-06-20" and currenttime < "2016-06-25") Then
	Response.Write "Err|이벤트 응모 기간이 아닙니다."
	Response.End
End If

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "Err|로그인 후 참여하실 수 있습니다."
	response.End
End If

	vPstNum1	= 2		''스티키몬스터보틀한국
	vPstNum2	= 0		''마이뷰티마스크팩한국
	vPstNum3	= 100	''피크닉매트한국
	vPstNum4	= 30	''오야스미양쿨팩한국
	vPstNum5	= 8		''커피메이커오븐파리
	vPstNum6	= 196	''토드라팡네일파리
	vPstNum7	= 89	''키티버니포니 파우치_파리
	vPstNum8	= 18	''델리삭스 양말 세트_파리
	vPstNum9	= 50	''요거트 메이커_덴마크
	vPstNum10	= 5		''스파이더맨 탁상 선풍기_미국
	vPstNum11	= 300	''미니마우스 얼굴 물총_미국
	vPstNum12	= 73	''디즈니 앨리스 플레잉 카드_미국
	vPstNum13	= 43	''아이코닉 코인월렛_오사카
	vPstNum14	= 29	''아이코닉 코인월렛_다낭
	vPstNum15	= 3		''슈퍼 피플 선글라스_다낭
	vPstNum16	= 70	''여행노트+클립펜_세부
	vPstNum17	= 8		''여행노트+클립펜_괌
	vPstNum18	= 67	''여행노트+클립펜_홍콩
	vPstNum19	= 37	''여행노트+클립펜_호놀룰루
	vPstNum20	= 43	''여행노트+클립펜_오사카
	vPstNum21	= 61	''여행노트+클립펜_타이페이
	vPstNum22	= 18	''여행노트+클립펜_다낭
	vPstNum23	= 61	''모노폴리 파우치_세부
	vPstNum24	= 8		''모노폴리 파우치_괌
	vPstNum25	= 58	''모노폴리 파우치_홍콩
	vPstNum26	= 37	''모노폴리 파우치_호놀룰루
	vPstNum27	= 43	''모노폴리 파우치_오사카
	vPstNum28	= 82	''모노폴리 파우치_타이페이
	vPstNum29	= 18	''모노폴리 파우치_다낭
	vPstNum30	= 43	''멀티플러그 십일자형_오사카
	vPstNum31	= 67	''아이코닉 행키_홍콩
	vPstNum32	= 91	''아이코닉 행키_타이페이
	vPstNum33	= 67	''아이코닉 사이드백_홍콩
	vPstNum34	= 91	''아이코닉 사이드백_타이베이
	vPstNum35	= 60	''서커스보이밴드 타투스티커_세부
	vPstNum36	= 8		''서커스보이밴드 타투스티커_괌
	vPstNum37	= 37	''서커스보이밴드 타투스티커_호놀룰루
	vPstNum38	= 62	''방수팩_세부
	vPstNum39	= 8		''방수팩_괌
	vPstNum40	= 37	''방수팩_호놀룰루
	vPstNum41	= 8		''아이리뷰 USB선풍기_한국
	vPstNum42	= 22	''Girl & ball - MOBILE_한국
	vPstNum43	= 1		''여행상품권 100만원
	vPstNum44	= 55	''보냉백_한국
	
'response.write vPstNum(1)
'response.end

If isapp = "1" Then device = "A" Else device = "M" End If 

'// 일 총 나간 수량 체크
sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2 <> '0' "
rsget.Open sqlstr, dbget, 1
	totalsubsctiptcnt = rsget("cnt")
rsget.close

''초기 당첨 확율
randomize

if currenttime <= "2016-06-23" then
	renloop=int(Rnd*225)+1
else
	renloop=int(Rnd*50)+1
end if

'renloop = 6


if renloop < 45 then
	winlose = "win"
else
	winlose = "lose"
end if

''랜덤 버그때문에 RvSelNum 사용안하고 renloop로 사용
if currenttime <= "2016-06-24" then	'이벤트 기간동안만
  Randomize
  ''상품 랜덤으로 고르기
  RvSelNum=int(Rnd*44)+1
'	  RvSelNum = Int(Rnd*dayarrcnt)
'	  Response.write arrnum(RvSelNum)
else
	RvSelNum=99
end if

'// 일자별 최대 한정갯수 셋팅
Select Case currenttime
	Case "2016-06-16" '// 이건 테스트 날짜용 셋팅임
		vdaytotalNum = 700

	Case "2016-06-20"
		vdaytotalNum = 700
	Case "2016-06-21"
		vdaytotalNum = 700
	Case "2016-06-22"
		vdaytotalNum = 490	
	Case "2016-06-23"
		vdaytotalNum = 698
	Case "2016-06-24"
		vdaytotalNum = 430
	Case Else
		vdaytotalNum = 0
End Select


''일일 제한수량 다 나가면 꽝
if totalsubsctiptcnt >= vdaytotalNum then
	winlose = "lose"
end if

If mode = "add" Then 		'//응모버튼 클릭
	'// 당첨 상품 랜덤 셀렉트
	dim tmpnum, dayarrcnt, arrnum



	Select Case Trim(renloop)
		Case "1" '//  스티키몬스터보틀한국
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(1번 스티키몬스터보틀한국
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '01' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복비당첨처리', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum1 Then
					'// 정해진 수량이 넘었을 경우 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1 ,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '스티키몬스터보틀한국 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 1번상품 재고가 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '01', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '스티키몬스터보틀한국 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world02'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_02.png' alt='한국' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_01.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else	''일일수량 재고 없으면 꽝
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '스티키몬스터보틀한국 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr

						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr

						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum1 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr

						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '스티키몬스터보틀한국 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 스티키몬스터보틀 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '01'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '스티키몬스터보틀한국 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world02'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_02.png' alt='한국' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_01.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '스티키몬스터보틀한국 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If
		Case "2" '// 마이뷰티다이어리마스크팩한국
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(2번..마이뷰티다이어리마스크팩한국 )
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '02' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum2 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '마이뷰티다이어리마스크팩한국 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 미니어쳐 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '02', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '마이뷰티다이어리마스크팩한국 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world02'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_02.png' alt='한국' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_02.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '마이뷰티다이어리마스크팩한국 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum2 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '마이뷰티다이어리마스크팩한국 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 미니어쳐 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '02'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '마이뷰티다이어리마스크팩한국 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world02'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_02.png' alt='한국' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_02.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '마이뷰티다이어리마스크팩한국 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If
		Case "3" '// 피크닉매트한국
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(3번..피크닉매트)
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '03' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum3 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '피크닉매트한국 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 피크닉매트 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '03', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '피크닉매트한국 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world02'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_02.png' alt='한국' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_03.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '피크닉매트한국 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum3 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '피크닉매트한국 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 피크닉매트 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '03'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '피크닉매트한국 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world02'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_02.png' alt='한국' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_03.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '피크닉매트한국 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If
		Case "4" '// 오야스미양쿨팩한국
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(4번..오야스미양쿨팩)
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '04' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum4 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '오야스미양쿨팩한국 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 오야스미양쿨팩 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '04', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '오야스미양쿨팩한국 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world02'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_02.png' alt='한국' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_04.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '오야스미양쿨팩한국 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If

					If cnt >= vPstNum4 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '오야스미양쿨팩한국 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 오야스미양쿨팩한국 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '04'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '오야스미양쿨팩 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world02'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_02.png' alt='한국' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_04.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '오야스미양쿨팩한국 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If
		Case "5" '// 커피메이커오븐파리
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(5번..커피메이커오븐파리)
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '05' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum5 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '커피메이커오븐파리 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 커피메이커오븐 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '05', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '커피메이커오븐파리 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world03'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_03.png' alt='파리' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_05.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '커피메이커오븐파리 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum5 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '커피메이커오븐파리 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 커피메이커오븐 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '05'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '커피메이커오븐파리 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world03'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_03.png' alt='파리' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_05.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '커피메이커오븐파리 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If
		Case "6" '// 토드라팡네일파리
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(6번..토드라팡네일폴리쉬)
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '06' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum6 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '토드라팡네일파리 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 토드라팡네일파리 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '06', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '토드라팡네일파리 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world03'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_03.png' alt='파리' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_06.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '토드라팡네일파리 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum6 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '토드라팡네일파리 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 토드라팡네일폴리쉬 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '06'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '토드라팡네일파리 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world03'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_03.png' alt='파리' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_06.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '토드라팡네일파리 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "7" '// 키티버니포니파우치파리
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(6번..키티버니포니파우치
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '07' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum7 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '키티버니포니파우치파리 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 키티버니포니파우치 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '07', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '키티버니포니파우치파리 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world03'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_03.png' alt='파리' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_07.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '키티버니포니파우치파리 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum7 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '키티버니포니파우치 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 키티버니포니파우치파리 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '07'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '키티버니포니파우치파리 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world03'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_03.png' alt='파리' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_07.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '키티버니포니파우치파리 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "8" '// 델리삭스양말세트파리
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(8번..델리삭스양말세트파리
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '08' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum8 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '델리삭스양말세트파리 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 키티버니포니파우치 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '08', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '델리삭스양말세트파리 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world03'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_03.png' alt='파리' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_08.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '델리삭스양말세트파리 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum8 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '델리삭스양말세트파리 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 키티버니포니파우치 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '08'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '델리삭스양말세트파리 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world03'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_03.png' alt='파리' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_08.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '델리삭스양말세트파리 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "9" '// 요거트메이커덴마크
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(9번..요거트메이커덴마크
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '09' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum9 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '요거트메이커덴마크 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 요거트메이커덴마크 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '09', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '요거트메이커덴마크 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world04'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_04.png' alt='덴마크' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_09.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '요거트메이커덴마크 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum9 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '요거트메이커덴마크 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 키티버니포니파우치 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '09'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '요거트메이커덴마크 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world04'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_04.png' alt='덴마크' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_09.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '요거트메이커덴마크 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "10" '// 10 스파이더맨선풍기미국
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(10번..스파이더맨선풍기미국
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '10' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum10 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '스파이더맨선풍기미국 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 스파이더맨선풍기미국 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '10', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '스파이더맨선풍기미국 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world05'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_05.png' alt='미국' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_10.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '스파이더맨선풍기미국 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum10 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '스파이더맨선풍기미국 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 스파이더맨선풍기미국 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '10'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '스파이더맨선풍기미국 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world05'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_05.png' alt='미국' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_10.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '스파이더맨선풍기미국 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "11" '// 미니마우스물총 미국
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(11번..미니마우스물총 미국
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '11' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum11 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '미니마우스물총 미국 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 미니마우스물총 미국 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '11', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '미니마우스물총 미국 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world05'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_05.png' alt='미국' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_11.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '미니마우스물총 미국 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum11 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '미니마우스물총 미국 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 미니마우스물총 미국 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '11'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '미니마우스물총 미국 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world05'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_05.png' alt='미국' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_11.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '미니마우스물총 미국 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "12" '// 디즈니플레잉카드미국
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(12번..디즈니플레잉카드미국
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '12' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum12 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '디즈니플레잉카드미국 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 디즈니플레잉카드미국 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '12', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '디즈니플레잉카드미국 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world05'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_05.png' alt='미국' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_12.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '디즈니플레잉카드미국 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum12 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '디즈니플레잉카드미국 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 디즈니플레잉카드미국 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '12'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '디즈니플레잉카드미국 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world05'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_05.png' alt='미국' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_12.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '디즈니플레잉카드미국 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "13" '// 아이코닉코인월렛오사카
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(13번..아이코닉코인월렛오사카
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '13' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum13 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉코인월렛오사카 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 아이코닉코인월렛오사카 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '13', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉코인월렛오사카 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world07'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_07.png' alt='오사카' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_13.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉코인월렛오사카 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum13 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉코인월렛오사카 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 아이코닉코인월렛오사카 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '13'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉코인월렛오사카 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world07'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_07.png' alt='오사카' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_13.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉코인월렛오사카 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "14" '// 아이코닉코인월렛다낭
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(14번..아이코닉코인월렛다낭
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '14' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum14 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉코인월렛다낭 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 아이코닉코인월렛다낭 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '14', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉코인월렛다낭 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world06'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_06.png' alt='다낭' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_13.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉코인월렛다낭 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum14 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉코인월렛다낭 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 아이코닉코인월렛다낭 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '14'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉코인월렛다낭 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world06'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_06.png' alt='다낭' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_13.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉코인월렛다낭 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "15" '// 슈퍼피플선글라스다낭
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(15번..슈퍼피플선글라스다낭
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '15' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum15 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '슈퍼피플선글라스다낭 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 슈퍼피플선글라스다낭 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '15', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '슈퍼피플선글라스다낭 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world06'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_06.png' alt='다낭' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_14.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '슈퍼피플선글라스다낭 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum15 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '슈퍼피플선글라스다낭 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 슈퍼피플선글라스다낭 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '15'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '슈퍼피플선글라스다낭 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world06'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_06.png' alt='다낭' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_14.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '슈퍼피플선글라스다낭 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "16" '// 여행노트클립펜세부
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(16번..여행노트클립펜세부
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '16' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum16 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜세부 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 여행노트클립펜세부 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '16', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜세부 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world12'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_12.png' alt='세부' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_15.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜세부 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum16 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜세부 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 여행노트클립펜세부 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '16'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜세부 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world12'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_12.png' alt='세부' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_15.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜세부 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "17" '// 여행노트클립펜괌
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(17번..여행노트클립펜괌
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '17' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum17 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜괌 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 여행노트클립펜괌 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '17', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜괌 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world10'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_10.png' alt='괌' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_15.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜괌 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum17 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜괌 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 여행노트클립펜괌 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '17'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜괌 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world10'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_10.png' alt='괌' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_15.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜괌 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "18" '// 여행노트클립펜홍콩
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(18번..여행노트클립펜홍콩
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '18' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum18 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜홍콩 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 여행노트클립펜홍콩 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '18', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜홍콩 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world09'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_09.png' alt='오사카' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_15.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜홍콩 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum18 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜홍콩 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 여행노트클립펜홍콩 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '18'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜홍콩 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world09'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_09.png' alt='오사카' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_15.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜홍콩 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "19" '// 여행노트클립펜호놀룰루
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(19번..여행노트클립펜호놀룰루
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '19' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum19 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜호놀룰루 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 여행노트클립펜호놀룰루 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '19', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜호놀룰루 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world11'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_11.png' alt='호놀룰루' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_15.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜호놀룰루 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum19 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜호놀룰루 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 여행노트클립펜호놀룰루 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '19'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜호놀룰루 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world11'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_11.png' alt='호놀룰루' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_15.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜호놀룰루 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "20" '// 여행노트클립펜오사카
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(6번..여행노트클립펜오사카
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '20' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum20 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜오사카 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 여행노트클립펜오사카 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '20', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜오사카 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world07'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_07.png' alt='타이페이' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_15.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜오사카 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum20 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜오사카 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 여행노트클립펜오사카 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '20'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜오사카 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world07'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_07.png' alt='타이페이' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_15.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜오사카 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "21" '// 여행노트클립펜타이페이
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(21번..여행노트클립펜타이페이
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '21' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum21 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜타이페이 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 여행노트클립펜타이페이 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '21', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜타이페이 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world08'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_08.png' alt='오사카' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_15.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜타이페이 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum21 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜타이페이 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 여행노트클립펜타이페이 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '21'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜타이페이 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world08'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_08.png' alt='오사카' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_15.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜타이페이 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "22" '// 여행노트클립펜다낭
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(22번..여행노트클립펜다낭
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '22' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum22 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜다낭 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 여행노트클립펜다낭 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '22', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜다낭 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world06'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_06.png' alt='다낭' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_15.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜다낭 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum22 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜다낭 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 여행노트클립펜다낭 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '22'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜다낭 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world06'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_06.png' alt='다낭' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_15.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행노트클립펜다낭 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "23" '// 모노폴리파우치세부
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(23번..모노폴리파우치세부
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '23' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum23 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치세부 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 모노폴리파우치세부 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '23', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치세부 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world12'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_12.png' alt='세부' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_16.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치세부 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum23 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치세부 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 모노폴리파우치세부 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '23'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치세부 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world12'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_12.png' alt='세부' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_16.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치세부 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "24" '// 모노폴리파우치괌
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(24번..모노폴리파우치괌
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '24' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum24 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치괌 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 모노폴리파우치괌 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '24', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치괌 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world10'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_10.png' alt='괌' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_16.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치괌 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum24 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치괌 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 모노폴리파우치괌 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '24'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치괌 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world10'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_10.png' alt='괌' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_16.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치괌 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "25" '// 모노폴리파우치홍콩
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(25번..모노폴리파우치홍콩
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '25' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum25 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치홍콩 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 모노폴리파우치홍콩 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '25', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치홍콩 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world09'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_09.png' alt='홍콩' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_16.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치홍콩 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum25 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치홍콩 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 모노폴리파우치홍콩 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '25'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치홍콩 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world09'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_09.png' alt='홍콩' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_16.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치홍콩 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "26" '// 모노폴리파우치호놀룰루
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(26번..모노폴리파우치호놀룰루
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '26' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum26 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치호놀룰루 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 모노폴리파우치호놀룰루 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '26', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치호놀룰루 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world11'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_11.png' alt='호놀룰루' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_16.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치호놀룰루 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum26 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치호놀룰루 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 모노폴리파우치호놀룰루 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '26'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치호놀룰루 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world11'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_11.png' alt='호놀룰루' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_16.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치호놀룰루 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "27" '// 모노폴리파우치오사카
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(27번..모노폴리파우치오사카
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '27' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum27 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치오사카 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 모노폴리파우치오사카 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '27', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치오사카 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world07'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_07.png' alt='오사카' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_16.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치오사카 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum27 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치오사카 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 모노폴리파우치오사카 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '27'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치오사카 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world07'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_07.png' alt='오사카' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_16.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치오사카 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "28" '// 모노폴리파우치타이페이
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(28번..모노폴리파우치타이페이
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '28' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum28 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치타이페이 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 모노폴리파우치타이페이 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '28', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치타이페이 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world08'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_08.png' alt='타이페이' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_16.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치타이페이 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum28 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치타이페이 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 모노폴리파우치타이페이 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '28'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치타이페이 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world08'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_08.png' alt='타이페이' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_16.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치타이페이 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "29" '// 모노폴리파우치다낭
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(6번..모노폴리파우치다낭
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '29' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum29 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치다낭 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 모노폴리파우치다낭 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '29', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치다낭 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world06'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_06.png' alt='다낭' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_16.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치다낭 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum29 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치다낭 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 모노폴리파우치다낭 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '29'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치다낭 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world06'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_06.png' alt='다낭' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_16.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '모노폴리파우치다낭 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "30" '// 멀티플러그십일자형오사카
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(30번..멀티플러그십일자형오사카
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '30' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum30 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '멀티플러그십일자형오사카 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 멀티플러그십일자형오사카 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '30', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '멀티플러그십일자형오사카 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world07'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_07.png' alt='오사카' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_17.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '멀티플러그십일자형오사카 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum30 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '멀티플러그십일자형오사카 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 멀티플러그십일자형오사카 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '30'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '멀티플러그십일자형오사카 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world07'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_07.png' alt='오사카' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_17.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '멀티플러그십일자형오사카 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "31" '// 아이코닉행키홍콩
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(31번..아이코닉행키홍콩)
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '31' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum31 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉행키홍콩 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 아이코닉행키홍콩 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '31', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉행키홍콩 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world09'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_09.png' alt='홍콩' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_18.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉행키홍콩 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum31 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉행키홍콩 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 아이코닉행키홍콩 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '31'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉행키홍콩 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world09'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_09.png' alt='홍콩' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_18.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉행키홍콩 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "32" '// 아이코닉행키타이페이
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(32번..아이코닉행키타이페이)
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '32' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum32 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉행키타이페이 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 아이코닉행키타이페이 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '32', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉행키타이페이 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world08'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_08.png' alt='타이페이' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_18.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉행키타이페이 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum32 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉행키타이페이 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 아이코닉행키타이페이 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '32'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉행키타이페이 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world08'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_08.png' alt='타이페이' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_18.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉행키타이페이 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If
			
		Case "33" '// 아이코닉사이드백홍콩
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(33번..아이코닉사이드백홍콩)
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '33' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum33 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉사이드백홍콩 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 아이코닉사이드백홍콩 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '33', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉사이드백홍콩 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world09'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_09.png' alt='홍콩' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_19.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉사이드백홍콩 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum33 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉사이드백홍콩 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 아이코닉사이드백홍콩 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '33'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉사이드백홍콩 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world09'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_09.png' alt='홍콩' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_19.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉사이드백홍콩 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If
			
		Case "34" '// 아이코닉사이드백타이페이
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(34..아이코닉사이드백타이페이)
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '34' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum34 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉사이드백타이페이 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 아이코닉사이드백타이페이 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '34', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉사이드백타이페이 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world08'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_08.png' alt='타이베이' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_19.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉사이드백타이페이 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum34 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉사이드백타이페이 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 아이코닉사이드백타이페이 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '34'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉사이드백타이페이 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world08'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_08.png' alt='타이베이' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_19.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이코닉사이드백타이페이 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "35" '// 서커스타투세부
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(35번..서커스타투세부
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '35' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum35 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '서커스타투세부 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 서커스타투세부 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '35', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '서커스타투세부 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world12'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_12.png' alt='세부' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_20.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '서커스타투세부 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum35 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '서커스타투세부 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 서커스타투세부 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '35'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '서커스타투세부 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world12'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_12.png' alt='세부' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_20.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '서커스타투세부 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "36" '// 서커스타투괌
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(6번..서커스타투괌
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '36' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum36 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '서커스타투괌 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 서커스타투괌 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '36', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '서커스타투괌 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world10'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_10.png' alt='괌' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_20.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '서커스타투괌 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum36 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '서커스타투괌 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 서커스타투괌 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '36'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '서커스타투괌 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world10'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_10.png' alt='괌' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_20.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '서커스타투괌 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "37" '// 서커스타투호놀룰루
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(6번..서커스타투호놀룰루
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '37' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum37 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '서커스타투호놀룰루 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 서커스타투호놀룰루 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '37', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '서커스타투호놀룰루 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world11'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_11.png' alt='호놀룰루' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_20.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '서커스타투호놀룰루 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum37 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '서커스타투호놀룰루 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 서커스타투호놀룰루 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '37'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '서커스타투호놀룰루 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world11'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_11.png' alt='호놀룰루' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_20.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '서커스타투호놀룰루 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "38" '// 방수팩세부
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(38번..방수팩세부
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '38' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum38 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '방수팩세부 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 방수팩세부 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '38', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '방수팩세부 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world12'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_12.png' alt='세부' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_21.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '방수팩세부 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum38 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '방수팩세부 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 방수팩세부 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '38'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '방수팩세부 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world12'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_12.png' alt='세부' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_21.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '방수팩세부 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "39" '// 방수팩괌
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(39번..방수팩괌
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '39' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum39 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '방수팩괌 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 방수팩괌 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '39', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '방수팩괌 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world10'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_10.png' alt='괌' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_21.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '방수팩괌 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum39 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '방수팩괌 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 방수팩괌 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '39'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '방수팩괌 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world10'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_10.png' alt='괌' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_21.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '방수팩괌 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "40" '// 방수팩호놀룰루
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(40번..방수팩호놀룰루
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '40' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum40 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '방수팩호놀룰루 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 방수팩호놀룰루 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '40', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '방수팩호놀룰루 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world11'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_11.png' alt='호놀룰루' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_21.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '방수팩호놀룰루 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum40 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '방수팩호놀룰루 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 방수팩호놀룰루 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '40'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '방수팩호놀룰루 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world11'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_11.png' alt='호놀룰루' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_21.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '방수팩호놀룰루 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "41" '// 아이리뷰선풍기한국
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(41번..아이리뷰선풍기한국
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '41' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum41 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이리뷰선풍기한국 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 아이리뷰선풍기한국 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '41', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이리뷰선풍기한국 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world02'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_02.png' alt='한국' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_22.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이리뷰선풍기한국 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum41 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이리뷰선풍기한국 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 아이리뷰선풍기한국 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '41'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이리뷰선풍기한국 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world02'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_02.png' alt='한국' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_22.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '아이리뷰선풍기한국 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "42" '// 걸볼모바일한국
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(42번..걸볼모바일한국
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '42' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum42 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '걸볼모바일한국 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 걸볼모바일한국 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '42', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '걸볼모바일한국 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world02'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_02.png' alt='한국' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_23.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '걸볼모바일한국 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum42 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '걸볼모바일한국 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 걸볼모바일한국 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '42'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '걸볼모바일한국 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world02'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_02.png' alt='한국' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_23.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '걸볼모바일한국 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "43" '// 여행상품권100만원
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(43번..여행상품권100만원
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '43' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum43 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행상품권100만원 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 여행상품권100만원 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '43', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행상품권100만원 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world01'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_01.png' alt='월드투어' /><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행상품권100만원 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum43 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행상품권100만원 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 여행상품권100만원 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '43'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행상품권100만원 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world01'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_01.png' alt='월드투어' /><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '여행상품권100만원 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "44" '// 보냉백한국
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(44번..보냉백한국
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &"  And sub_opt2 = '44' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum44 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '보냉백한국 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				Else
					if winlose = "win" then	'' 일일 수량 남으면 당첨
						'// 최초응모자이고, 보냉백한국 잔량이 있고, 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '44', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '보냉백한국 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world02'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_02.png' alt='한국' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_24.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '보냉백한국 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum44 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '보냉백한국 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					Else
						if winlose = "win" then	'' 일일 수량 남으면 당첨
							'// SNS 공유자이고, 보냉백한국 잔량이 있고, 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '44'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '보냉백한국 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world02'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_02.png' alt='한국' /><p class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_item_24.png' alt='' /></p><span class='code'>"&md5userid&"</span><a href='#' onclick=""jsmyten(); return false;"" class='btnGo'>기본 배송지 확인하러 가기</a></div></div></div>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '보냉백한국 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If



		Case Else
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
				End If
					
				'무조건 꽝 처리
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', 'caseelse 비당첨', '"&device&"')"
				dbget.execute sqlstr

				Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
				dbget.close()	:	response.End

			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
						dbget.close()	:	response.End
					End If

					'//  무조건 꽝 처리
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', 'caseelse 비당첨(2번째 도전)', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<div class='layerCont'><button type='button' onclick=""fnClosemask();""  class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png' alt='닫기' /></button><div class='worldTravel' id='reresultLayer'><div class='world00'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71239/img_pop_world_00.png' alt='또! 오세영(feat.꽝)' /><a href='#' onclick=""get_coupon(); return false;"" class='btnGo'>쿠폰 받기</a></div></div></div>"
					dbget.close()	:	response.End
					
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If
	End Select

ElseIf mode="coupon" Then

	if not( currenttime >= "2016-06-20" and currenttime < "2016-06-25" ) then
		Response.Write "DATENOT"
		dbget.close() : Response.End
	End If

	if LoginUserid="" then
		Response.Write "USERNOT"
		dbget.close() : Response.End
	End If

	bonuscouponexistscount=getbonuscouponexistscount(LoginUserid, couponidx, "", "", left(currenttime,10))
	if bonuscouponexistscount>2 then
		Response.write "MAXCOUPON"
		dbget.close() : Response.End
	end if

	'// 응모내역 검색
	sqlstr = "select top 1 sub_opt1 , sub_opt2 , isnull(sub_opt3,'') as sub_opt3 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "

	'response.write sqlstr & "<br>"
	rsget.Open sqlstr, dbget, 1
	If Not rsget.Eof Then
		'//최초 응모
		result1 = rsget(0) '//응모회수 1,2
		result2 = rsget(1) '//당첨여부 0,1 
		result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
	End IF
	rsget.close

	If result1 = "" Or isnull(result1) Then
		Response.write "NOT1" '//참여 이력이 없음 - 응모후 이용 하시오
		dbget.close()	:	response.End
	else
		'//쿠폰 발급
		sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
		sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
		sqlstr = sqlstr & " 	SELECT idx, '"& LoginUserid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,'2016-06-20 00:00:00','2016-06-24 23:59:59',couponmeaipprice,validsitename" + vbcrlf
		sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
		sqlstr = sqlstr & " 	where idx in ("& couponidx &")"
		'response.write sqlstr & "<br>"
		dbget.execute sqlstr

		''로그저장
		sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log](evt_code, userid, refip, value1, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '"& Left(request.ServerVariables("REMOTE_ADDR"),32) & "', 'coupon', '"& device &"')"
	
		'response.write sqlstr & "<br>"
		dbget.execute sqlstr

		Response.write "SUCCESS"
		dbget.close()	:	response.end
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

	If result1 = "" and snschk = "" Then	'참여 이력이 없음 - 응모후 이용 하시오
		Response.Write "Err|none"
		dbget.close()	:	response.End
	ElseIf CStr(result1) <> "" And (snschk = "") Then	'1회 참여시 
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
	ElseIf CStr(result1) <> "" And (snschk = "ka" or snschk = "tw" or snschk = "fb") Then	'오늘의 초대는 모두 완료!\n내일 또 도전해 주세요!
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