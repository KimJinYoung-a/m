<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 10초의 기적
' History : 2015-02-05 원승현
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/wishCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<%
dim eCode, userid, mode, sqlstr, refer , renloop , couponid
Dim result1 , result2 , result3, vToday
Dim vMiracleGiftItemId, dateitemlimitcnt

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  21466
		couponid = 388
	Else
		eCode   =  59261
		couponid = 699
	End If
	userid = getloginuserid()
	mode = requestcheckvar(request("mode"),32)
	vMiracleGiftItemId = requestcheckvar(request("vMiracleGiftItemId"),128)
	vToday = requestcheckvar(request("vToday"),128)

	'// 상품 제한수량 체크
	dateitemlimitcnt=getitemlimitcnt(vMiracleGiftItemId)
'	dateitemlimitcnt = 1 '// 테스트용

	refer = request.ServerVariables("HTTP_REFERER")
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "잘못된 접속입니다."
		dbget.close() : Response.End
	end If
	
	'// expiredate
	If not(left(now(),10)>="2015-02-06" and left(now(),10)<"2015-02-18") Then
		Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End If


	'// 상품 제한수량이 없을경우엔 응모 자체가 안됨
	If dateitemlimitcnt < 1 Then

		If Trim(mode)="kakao2" Then
			'// 로그 넣음
			sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", 'kakao')" + vbcrlf
			dbget.execute sqlstr '// 응모 기회 한번 더줌

			Response.write "SUCCESS"
			dbget.close()	:	response.End
		ElseIf Trim(mode)="app_main" Then
			'//앱실행 메인배너 클릭 카운트
			sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& mode &"')" + vbcrlf
			dbget.execute sqlstr

			Response.write "OK"
			dbget.close()	:	response.end
		Else
			response.write "soldout"
			response.End
		End If

	Else

		Select Case Trim(mode)

			'// start 버튼 누르면 바로 값 넣음
			Case "start"
				'// 응모내역 검색
				sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
				sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
				sqlstr = sqlstr & " where evt_code="& eCode &""
				sqlstr = sqlstr & " and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& Date() &"' "

				rsget.Open sqlstr, dbget, 1
				If Not(rsget.bof Or rsget.Eof) Then
					'// 기존에 응모 했을때 값
					result1 = rsget(0) '//응모회수 1,2
					result2 = rsget(1) '//당첨여부 0,1 
					result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
				Else
					'// 최초응모
					result1 = ""
					result2 = ""
					result3 = ""
				End IF
				rsget.close

				'// start 버튼을 눌렀을시엔 기존에 응모했냐 여부와 2차 응모인지 여부 파악만 하면 됨
				'// 일단 무조건 비당첨 값으로 넣음
				'// 최초 응모자인지
				If result1="" And result2="" And result3="" Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '0', 'A')"
					dbget.execute sqlstr
					Response.write "SUCCESS"
					dbget.close()	:	response.End				
				'// 응모를 1회 했을경우
				ElseIf Trim(result1) = "1" Then

					'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
					If Trim(result3)="kakao" Then

						'// 카카오 초대를 했다손 치더라도 기존에 응모가 당첨일 경우엔 더 이상 응모 안됨.
						If Trim(result2)="1" Then
							response.write "complete"
							response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& Date() &"' "
							dbget.execute sqlstr
							Response.write "SUCCESS"
							dbget.close()	:	response.End				
						End If
					Else
						response.write "kakao" '// 카카오 친구초대 안내문구 쏴줌
						response.End
					End If
				'// 총 2번 이상 응모를 했을경우
				ElseIf result1 >= 2 Then
					response.write "END" '// 응모횟수초과
					dbget.close()	:	response.End				
				End If

			'// 당첨
			Case "winner"

				'// 응모내역 검색
				sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
				sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
				sqlstr = sqlstr & " where evt_code="& eCode &""
				sqlstr = sqlstr & " and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& Date() &"' "

				rsget.Open sqlstr, dbget, 1
				If Not(rsget.bof Or rsget.Eof) Then
					result1 = rsget(0) '//응모회수 1,2
					result2 = rsget(1) '//당첨여부 0,1 
					result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao					
				Else
					
					'// 여기선 값이 없으면 안됨 그러므로 error
					response.write "error"
					dbget.close()	:	response.End				

				End IF
				rsget.close
				If result1 > 2 Then
					response.write "END" '// 응모횟수초과
					dbget.close()	:	response.End

				'// 응모횟수가 두번째일경우
				ElseIf  Trim(result1) = "2" Then

					'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
					If Trim(result3)="kakao" Then
						'// 카카오 초대를 했다손 치더라도 기존에 응모가 당첨일 경우엔 더 이상 응모 안됨.
						If Trim(result2)="1" Then
							response.write "complete"
							response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '1'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& Date() &"' "
							dbget.execute sqlstr

							sqlstr = " insert into db_my10x10.dbo.tbl_my_baguni "
							sqlstr = sqlstr & " (userKey , isLoginUser , itemid , itemoption , itemea , chkorder) "
							sqlstr = sqlstr & " values ('"&userid&"','Y','"&vMiracleGiftItemId&"','0000','1','N') "
							dbget.execute sqlstr

							Response.write "SUCCESS"
							dbget.close()	:	response.End				
						End If
					Else
						response.write "kakao" '// 카카오 친구초대 안내문구 쏴줌
						response.End
					End If

				'// 첫번째 응모일 경우
				ElseIf  Trim(result1) = "1" Then
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '1' , sub_opt2 = '1'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& Date() &"' "
					dbget.execute sqlstr

					sqlstr = " insert into db_my10x10.dbo.tbl_my_baguni "
					sqlstr = sqlstr & " (userKey , isLoginUser , itemid , itemoption , itemea , chkorder) "
					sqlstr = sqlstr & " values ('"&userid&"','Y','"&vMiracleGiftItemId&"','0000','1','N') "
					dbget.execute sqlstr

					Response.write "SUCCESS"
					dbget.close()	:	response.End

				'// 당첨쪽 프로세스 이지만 혹 기존에 당첨된 값이 들어가 있을경우..
				ElseIf Trim(result2)>=1 Then
					response.write "complete"
					response.End
				End If

			'// 카카오 친구초대(재도전용)
			Case "kakao"

				'// 로그 넣음
				sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& mode &"')" + vbcrlf
				dbget.execute sqlstr '// 응모 기회 한번 더줌

				'//카카오초대 클릭 카운트 
				'// 응모내역 검색
				sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
				sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
				sqlstr = sqlstr & " where evt_code="& eCode &""
				sqlstr = sqlstr & " and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& Date()&"'"
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
					Response.End
				ElseIf result1 = "1" And (result3 = "" Or isnull(result3) Or result3 <> "kakao" or result3 = "NULL") And result2<>"1" Then '//1회 참여시
					sqlstr = " update [db_event].[dbo].[tbl_event_subscript] set sub_opt3 = 'kakao'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& Date()&"'" + vbcrlf
					dbget.execute sqlstr '// 응모 기회 한번 더줌

					Response.write "SUCCESS"
					dbget.close()	:	response.End
				ElseIf result1 = "1" And result3 = "kakao" Then
					Response.write "NOT2"
					Response.end
				ElseIf (result1 = "1" And result3 = "kakao") Or result1 = "2" Then 
					Response.write "END" '//오늘 참여 끝
					Response.End
				ElseIf Trim(result2) = 1 Then
					Response.write "complete" '//이미 당첨된 인원은 안됨.
					Response.End
				End If 


			'// 카카오 친구초대(걍초대용)
			Case "kakao2"

				'// 로그 넣음
				sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", 'kakao')" + vbcrlf
				dbget.execute sqlstr '// 응모 기회 한번 더줌

				Response.write "SUCCESS"
				dbget.close()	:	response.End

			'// 이벤트 페이지 배너 클릭시(도전하기)
			Case "banner1", "banner2"
				'//기획전배너 1 , 2
				sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& mode &"')" + vbcrlf
				dbget.execute sqlstr

				Response.write "OK"
				dbget.close()	:	response.end


			'// 앱 메인 배너 클릭시
			Case  "app_main"
				'//앱실행 메인배너 클릭 카운트
				sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& mode &"')" + vbcrlf
				dbget.execute sqlstr

				Response.write "OK"
				dbget.close()	:	response.end
			'// 쿠폰발급
			Case "coupon"

				'//쿠폰 발급
				sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
				sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid)" + vbcrlf
				sqlstr = sqlstr & " values('" &couponid &"','"& userid &"','3','2000','10초의 기적 <기적의 무료배송권>','10000','"& Date() &" 00:00:00','"& Date() &" 23:59:59','',0,'system')"
				dbget.execute sqlstr
				Response.write "SUCCESS"
				dbget.close()	:	response.end

			Case Else
				Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/apps/appCom/wish/web2014/event/eventmain.asp?eventid="& eCode &"'</script>"
				Response.End
		End Select
	End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->