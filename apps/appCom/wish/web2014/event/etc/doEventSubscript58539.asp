<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
'### 어벤져박스의 기적 - for app
'### 2015-01-14 이종화
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
Dim result1 , result2 , result3 
Dim winnumber
Dim itemid : itemid = "1197448"

	If left(now(),10) = "2015-01-30" then
		winnumber = 151
	End If

	'//응모 확률 
	randomize
	renloop=int(Rnd*1000)+1 '100%

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  21435
		couponid = 385
	Else
		eCode   =  58539
		couponid = 689
	End If
	userid = getloginuserid()
	mode = requestcheckvar(request("mode"),32)

	refer = request.ServerVariables("HTTP_REFERER")
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "잘못된 접속입니다."
		dbget.close() : Response.End
	end If
	
	'// expiredate
	If not(left(now(),10)>="2015-01-15" and left(now(),10)<"2015-01-31" or left(now(),10)>="2015-01-19" and left(now(),10)<"2015-01-31") Then
		Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End If

	If mode = "add" Then '//응모버튼 클릭
		'// 상품 
		dim oItem, ItemContent , dateitemlimitcnt

		dateitemlimitcnt=0

		set oItem = new CatePrdCls
		oItem.GetItemData itemid
		
		dateitemlimitcnt=getitemlimitcnt(itemid) '// 상품 제고 현황 몇개 남았는지

		Set oItem = Nothing

		If dateitemlimitcnt > 0 Then '// 제고 있음

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

			If result1 = "" And result2="" Then '//응모 내역이 없음
				'// 당첨일때 
				If renloop < winnumber Then '당첨확률 60% 5%
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '1' )" + vbcrlf
					dbget.execute sqlstr

					Response.write "SUCCESS"
					dbget.close()	:	response.End
				Else
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '0' )" + vbcrlf
					dbget.execute sqlstr

					Response.write "FAIL"
					dbget.close()	:	response.End
				End If
			ElseIf result1 = "1" Then '// 두번째 응모시
					If result2 = "0" Then '//두번쨰 응모지만 꽝일 경우
						If result3 = "" Or isnull(result3) Or result3 <> "kakao" or result3 = "NULL" Then '//카카오 초대 안하고 응모를 누른경우
							Response.write "KAKAO" '//카카오 초대를 누르시오 - 카카오 버튼 누를때 update
							Response.end
						Else '//카카오 초대 누르고 응모 누름
							If renloop < winnumber Then '당첨확률 60% '5%
								sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '1'" + vbcrlf
								sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& Date()&"'" + vbcrlf
								dbget.execute sqlstr

								Response.write "SUCCESS"
								dbget.close()	:	response.End
							Else
								sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
								sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& Date()&"'" + vbcrlf
								dbget.execute sqlstr

								Response.write "FAIL"
								dbget.close()	:	response.End
							End If
						End If
					Else '// 두번째 응모지만 당첨이력이 있는 경우 꽝처리
						If result3 = "" Or isnull(result3) Or result3 <> "kakao" or result3 = "NULL" Then '//카카오 초대 안하고 응모를 누른경우
							Response.write "KAKAO" '//카카오 초대를 누르시오 - 카카오 버튼 누를때 update
							Response.end
						Else '//카카오 초대 누르고 응모 누름
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' " + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& Date()&"'" + vbcrlf
							dbget.execute sqlstr

							Response.write "FAIL"
							dbget.close()	:	response.End
						End If
					End If 
			Else '//오늘은 이제 그만
				Response.write "END"
				Response.end
			End if
		Else
			'제고 없음 soldout
			Response.write "SOLDOUT"		
		End If 
	elseif mode="kakao" then
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
		ElseIf result1 = "1" And (result3 = "" Or isnull(result3) Or result3 <> "kakao" or result3 = "NULL") Then '//1회 참여시
			sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& mode &"')" + vbcrlf
			sqlstr = sqlstr & " update [db_event].[dbo].[tbl_event_subscript] set sub_opt3 = 'kakao'" + vbcrlf
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
		End If 
	   
	elseif mode="banner1" Or mode="banner2" then
		'//기획전배너 1 , 2
		sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '"& mode &"')" + vbcrlf
		dbget.execute sqlstr

		Response.write "OK"
		dbget.close()	:	response.end

	elseif mode="app_main" then
		'//앱실행 메인배너 클릭 카운트
		sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '"& mode &"')" + vbcrlf
		dbget.execute sqlstr

		Response.write "OK"
		dbget.close()	:	response.end

	elseif mode="notlogin" then
		'쿠키꿉는다
		response.cookies("etc").domain="10x10.co.kr"
		response.cookies("etc")("evtcode") = 58539
		
		response.write "OK"		'//성공임
		dbget.close()	:	response.end
	ElseIf mode="coupon" Then
		'//쿠폰 발급
		sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
		sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid)" + vbcrlf
		sqlstr = sqlstr & " values('" &couponid &"','"& userid &"','3','2000','어벤져박스의 기적 <차원이 다른 무료배송권>','10000','"& Date() &" 00:00:00','"& Date() &" 23:59:59','',0,'system')"
		dbget.execute sqlstr
		Response.write "SUCCESS"
		dbget.close()	:	response.end
	Else
		Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/apps/appCom/wish/web2014/event/eventmain.asp?eventid="& eCode &"'</script>"
		dbget.close() : Response.End
	end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->