<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 슈퍼백의 기적(박스이벤트)
' History : 2015.03.11 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/event/etc/event59795Cls.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/wishCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<%
dim eCode, userid, itemid, oItem, mode, renloop, winnumber, sqlstr, result1, result2, result3, bonuscouponexistscount
	mode = requestcheckvar(request("mode"),32)

eCode=getevt_code
userid = getloginuserid()

bonuscouponexistscount=0
winnumber = 0
renloop = 0
itemid=""

dim refer
	refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end If

If mode = "add" Then '//응모버튼 클릭
	if not( (left(currenttime,10)>="2015-03-16" and left(currenttime,10)<"2015-03-21") or (left(currenttime,10)>="2015-03-23" and left(currenttime,10)<"2015-03-26") ) then
		Response.Write "DATENOT"
		dbget.close() : Response.End
	End If
	if userid="" then
		Response.Write "USERNOT"
		dbget.close() : Response.End
	End If
	if Hour(currenttime) < 10 then
		Response.write "TIMENOT"
		Response.end
	end if
	if staffconfirm and request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW
		Response.write "STAFF"
		dbget.close() : Response.End
	end if

	'Response.write "SUCCESS"
	'Response.write "FAIL"
	'dbget.close()	:	response.End

'	if left(currenttime,10)="2015-03-16" then
'		winnumber=0
'	elseif left(currenttime,10)="2015-03-17" then
'		winnumber=0
'	elseif left(currenttime,10)="2015-03-18" then
'		winnumber=0
'	elseif left(currenttime,10)="2015-03-19" then
'		winnumber=201
'	elseif left(currenttime,10)="2015-03-20" then
'		winnumber=151
'	else
'		winnumber=0
'	end if
	
	'//http://scm.10x10.co.kr/admin/datamart/mkt/event59795_manage.asp 확률 어드민에서 가져옴
	sqlStr = "select top 1 bigo as winnumber"
	sqlStr = sqlStr & " from db_temp.dbo.tbl_event_etc_yongman"
	sqlStr = sqlStr & " where event_code="& eCode &" and isusing='Y'"
	
	'response.write sqlStr & "<br>"
	rsget.Open sqlStr,dbget
	if Not(rsget.EOF or rsget.BOF) Then
		winnumber=rsget("winnumber")
	else
		winnumber=0
	End If
	rsget.close
	winnumber=getNumeric(winnumber)
	if winnumber="" then
		winnumber=0
	end if
	'winnumber=0

	'//응모 확률
	randomize
	renloop=int(Rnd*1000)+1

	itemid = getdateitem(left(currenttime,10))

	set oItem = new CatePrdCls
		oItem.GetItemData itemid

	IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem) Then

		'// 응모내역 검색
		sqlstr = "select top 1 sub_opt1 , sub_opt2 , isnull(sub_opt3,'') as sub_opt3 "
		sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
		sqlstr = sqlstr & " where evt_code="& eCode &""
		sqlstr = sqlstr & " and userid='"& userid &"' and convert(varchar(10),regdate,121) = '"& left(currenttime,10)&"'"
		
		'response.write sqlstr & "<br>"
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
			If clng(renloop) < clng(winnumber) Then
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '1' ,'"& trim(dateconvert(currenttime)) &"', 'A')" + vbcrlf
				
				'response.write sqlstr & "<br>"
				dbget.execute sqlstr

				sqlstr = " insert into db_my10x10.dbo.tbl_my_baguni "
				sqlstr = sqlstr & " (userKey , isLoginUser , itemid , itemoption , itemea , chkorder) "
				sqlstr = sqlstr & " 	select top 1 '"& userid &"','Y', i.itemid, '0000', '1', 'N'"
				sqlstr = sqlstr & " 	from db_item.dbo.tbl_item i"
				sqlstr = sqlstr & " 	left join db_my10x10.dbo.tbl_my_baguni t"
				sqlstr = sqlstr & " 		on i.itemid = t.itemid"
				sqlstr = sqlstr & " 		and userKey='"& userid &"'"
				sqlstr = sqlstr & " 		and itemoption='0000'"
				sqlstr = sqlstr & " 	where i.itemid ="& itemid &" "
				sqlstr = sqlstr & " 	and t.itemid is null"

				'response.write sqlstr & "<br>"
				dbget.execute sqlstr

				Response.write "SUCCESS"
				dbget.close()	:	response.End
			Else
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '0' ,'"& trim(dateconvert(currenttime)) &"', 'A')" + vbcrlf
				
				'response.write sqlstr & "<br>"
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
						If clng(renloop) < clng(winnumber) Then
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '1'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,121) = '"& left(currenttime,10) &"'" + vbcrlf
							
							'response.write sqlstr & "<br>"
							dbget.execute sqlstr

							sqlstr = " insert into db_my10x10.dbo.tbl_my_baguni "
							sqlstr = sqlstr & " (userKey , isLoginUser , itemid , itemoption , itemea , chkorder) "
							sqlstr = sqlstr & " 	select top 1 '"& userid &"','Y', i.itemid, '0000', '1', 'N'"
							sqlstr = sqlstr & " 	from db_item.dbo.tbl_item i"
							sqlstr = sqlstr & " 	left join db_my10x10.dbo.tbl_my_baguni t"
							sqlstr = sqlstr & " 		on i.itemid = t.itemid"
							sqlstr = sqlstr & " 		and userKey='"& userid &"'"
							sqlstr = sqlstr & " 		and itemoption='0000'"
							sqlstr = sqlstr & " 	where i.itemid ="& itemid &" "
							sqlstr = sqlstr & " 	and t.itemid is null"
			
							'response.write sqlstr & "<br>"
							dbget.execute sqlstr

							Response.write "SUCCESS"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,121) = '"& left(currenttime,10) &"'" + vbcrlf
							
							'response.write sqlstr & "<br>"
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
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,121) = '"& left(currenttime,10) &"'" + vbcrlf
						
						'response.write sqlstr & "<br>"
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
		Response.write "SOLDOUT"		
	End If
	
	Set oItem = Nothing

ElseIf mode="coupon" Then
	if not( (left(currenttime,10)>="2015-03-16" and left(currenttime,10)<"2015-03-21") or (left(currenttime,10)>="2015-03-23" and left(currenttime,10)<"2015-03-26") ) then
		Response.Write "DATENOT"
		dbget.close() : Response.End
	End If
	if userid="" then
		Response.Write "USERNOT"
		dbget.close() : Response.End
	End If
	if Hour(currenttime) < 10 then
		Response.write "TIMENOT"
		Response.end
	end if
	if staffconfirm and request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW
		Response.write "STAFF"
		dbget.close() : Response.End
	end if
	
	bonuscouponexistscount=getbonuscouponexistscount(userid, getbonuscoupon(), "", "", left(currenttime,10))
	if bonuscouponexistscount>2 then
		Response.write "MAXCOUPON"
		dbget.close() : Response.End
	end if

	'// 응모내역 검색
	sqlstr = "select top 1 sub_opt1 , sub_opt2 , isnull(sub_opt3,'') as sub_opt3 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& userid &"' and convert(varchar(10),regdate,121) = '"& left(currenttime,10) &"'"
	
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
		sqlstr = sqlstr & " (masteridx, userid, coupontype, couponvalue, couponname, minbuyprice, targetitemlist, startdate, expiredate, couponmeaipprice, validsitename, reguserid)" + vbcrlf
		sqlstr = sqlstr & " 	SELECT " + vbcrlf
		sqlstr = sqlstr & " 	m.idx, '"& userid &"', m.coupontype, m.couponvalue, m.couponname, m.minbuyprice, m.targetitemlist" + vbcrlf
		sqlstr = sqlstr & " 	, '"& left(currenttime,10) &" 00:00:00', '"& left(currenttime,10) &" 23:59:59', m.couponmeaipprice, m.validsitename, 'SYSTEM'" + vbcrlf
		sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
		sqlstr = sqlstr & " 	where isusing='Y'" + vbcrlf
		sqlstr = sqlstr & " 	and m.idx="& getbonuscoupon &""
		
		'response.write sqlstr & "<br>"
		dbget.execute sqlstr
		Response.write "SUCCESS"
		dbget.close()	:	response.end
	End If

elseif mode="kakao" then
	if not( (left(currenttime,10)>="2015-03-16" and left(currenttime,10)<"2015-03-21") or (left(currenttime,10)>="2015-03-23" and left(currenttime,10)<"2015-03-26") ) then
		Response.Write "DATENOT"
		dbget.close() : Response.End
	End If
	if userid="" then
		Response.Write "USERNOT"
		dbget.close() : Response.End
	End If
	if Hour(currenttime) < 10 then
		Response.write "TIMENOT"
		Response.end
	end if
	if staffconfirm and request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW
		Response.write "STAFF"
		dbget.close() : Response.End
	end if

	'Response.write "SUCCESS"
	'dbget.close()	:	response.End

	'//카카오초대 클릭 카운트 
	'// 응모내역 검색
	sqlstr = "select top 1 sub_opt1 , sub_opt2 , isnull(sub_opt3,'') as sub_opt3 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& userid &"' and convert(varchar(10),regdate,121) = '"& left(currenttime,10) &"'"
	
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
	ElseIf result1 = "1" And (result3 = "" Or isnull(result3) Or result3 <> "kakao" or result3 = "NULL") Then '//1회 참여시
		sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '"& mode &"')" + vbcrlf
		'response.write sqlstr & "<br>"
		dbget.execute sqlstr
		
		sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt3 = 'kakao'" + vbcrlf
		sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and convert(varchar(10),regdate,121) = '"& left(currenttime,10) &"'"
		
		'response.write sqlstr & "<br>"
		dbget.execute sqlstr '// 응모 기회 한번 더줌

		Response.write "SUCCESS"
		dbget.close()	:	response.End
	ElseIf result1 = "1" And result3 = "kakao" Then
		Response.write "NOT2"
		dbget.close()	:	response.End
	ElseIf (result1 = "1" And result3 = "kakao") Or result1 = "2" Then 
		Response.write "END" '//오늘 참여 끝
		dbget.close()	:	response.End
	End If 

elseif mode="KAKAOHOILDAY" then
	if not( left(currenttime,10)>="2015-03-21" and left(currenttime,10)<"2015-03-23" ) then
		Response.Write "DATENOT"
		dbget.close() : Response.End
	end if

	'//앱바로가기 클릭 카운트
	sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '"& mode &"')"
	
	'response.write sqlstr & "<br>"
	dbget.execute sqlstr

	Response.write "OK"
	dbget.close()	:	response.end

elseif mode="app_main" then
	'//앱실행 메인배너 클릭 카운트
	sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '"& mode &"')"
	
	'response.write sqlstr & "<br>"
	dbget.execute sqlstr

	Response.write "OK"
	dbget.close()	:	response.end

elseif mode="mo_main" then
	'//앱바로가기 클릭 카운트
	sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '"& mode &"')"
	
	'response.write sqlstr & "<br>"
	dbget.execute sqlstr

	Response.write "OK"
	dbget.close()	:	response.end

elseif mode="notlogin" then
	'쿠키꿉는다
	response.cookies("etc").domain="10x10.co.kr"
	response.cookies("etc")("evtcode") = eCode
	
	response.write "OK"		'//성공임
	dbget.close()	:	response.end

Else
	Response.Write "정상적인 경로가 아닙니다."
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
