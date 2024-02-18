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
' Description : 아이러브치킨 2차
' History : 2015.06.22 한용민 생성
'//http://scm.10x10.co.kr/admin/datamart/mkt/event63739_manage.asp 확률 어드민에서 가져옴
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->

<%
dim mode, line1, line2, line3, winnumber, renloop
	mode = requestcheckvar(request("mode"),32)
	line1 = requestcheckvar(request("line1"),1)
	line2 = requestcheckvar(request("line2"),1)
	line3 = requestcheckvar(request("line3"),1)

dim currenttime, userid, i, sqlstr
	userid = getloginuserid()
	currenttime =  now()
	'currenttime = #06/23/2015 09:00:00#

dim eCode, eCodedisp
IF application("Svr_Info") = "Dev" THEN
	eCode   =  63794
	eCodedisp = 63794
Else
	eCode   =  63739
	eCodedisp = 63739
End If

dim refer
	refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end If

dim event_subscriptexistscount, coffe_event_subscripttotalcount, machine_event_subscripttotalcount
event_subscriptexistscount = 0
coffe_event_subscripttotalcount = 0
machine_event_subscripttotalcount = 0

dim evtUserCell, refip
	evtUserCell = get10x10onlineusercell(userid)
	refip = Request.ServerVariables("REMOTE_ADDR")

dim limitcoffecnt, limitmachinecnt, rvalue
limitcoffecnt = 300		'300
limitmachinecnt = 10	'10

dim coupon1, coupon2, coupon3, coupon4
IF application("Svr_Info") = "Dev" THEN
	coupon1 = 11105
	coupon2 = 11106
	coupon3 = 11107
	coupon4 = 11108
else
	coupon1 = 10413
	coupon2 = 10414
	coupon3 = 10415
	coupon4 = 10416
end if

'response.write line1 & "/" & line2 & "/" & line3
'dbget.close() : Response.End

If mode = "add" Then '//응모버튼 클릭
	if not( left(currenttime,10)>="2015-06-23" and left(currenttime,10)<"2015-06-26" ) then
		Response.Write "DATENOT!@#"
		dbget.close() : Response.End
	end if
	if userid="" then
		Response.Write "USERNOT!@#"
		dbget.close() : Response.End
	End If
	if line1="" or line2="" or line3="" then
		Response.Write ""
		dbget.close() : Response.End
	End If
	'/본인응모수
	event_subscriptexistscount = getevent_subscriptexistscount(eCode, userid, left(currenttime,10), "", "")
	if event_subscriptexistscount>0 then
		Response.write "END!@#"
		dbget.close() : Response.End
	end if

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
	'winnumber=999

	'//응모 확률
	randomize
	renloop=int(Rnd*1000)+1

	'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함
	If event_userCell_Selection(evtUserCell, Left(currenttime, 10), eCode) > 0 Then
		rvalue = fnSetItemCouponDown(userid, coupon1)	'/itemcoupon 처리

		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"& left(currenttime,10) &"', '"& coupon1 &"', '', getdate(), 'A')"
		dbget.execute sqlstr

		'// 해당 유저의 로그값 집어넣는다.
		sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value2, value3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '"&renloop&"', '1줄:"& line1 &"2줄:"& line2 &"3줄:"& line3 &"-전화번호중복-쿠폰:"& coupon1 &"', 'A')"
		dbget.execute sqlstr

		Response.write "SUCCESS!@#<div class='present'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_present_coupon_a.jpg' alt='내커피는 바로 여기에! 리버스 보틀' /><div class='btncoupon'><a href='' onclick='fnAPPpopupProduct(1299633); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_get.png' alt='바로 구매하러가기' /></a></div></div><div class='bnr'><a href='' onclick='fnAPPpopupEvent(63596); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_bnr_01.jpg' alt='6월의 더치박스 GO! BORMI' /></a></div><button type='button' class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_close.png' alt='닫기' /></button>"
		dbget.close()	:	response.End
	End If

	'/전체응모수
	coffe_event_subscripttotalcount = getevent_subscripttotalcount(eCode, left(currenttime,10), "1", "")
	machine_event_subscripttotalcount = getevent_subscripttotalcount(eCode, left(currenttime,10), "2", "")

	'/첫줄 A선택
	if line1="A" then
		'/두번째줄 A선택
		if line2="A" then
			'/BBQ치킨 제한수량체크
			'/제한수량초과 쿠폰발급 꽝처리
			if clng(coffe_event_subscripttotalcount) >= clng(limitcoffecnt) then
				rvalue = fnSetItemCouponDown(userid, coupon1)	'/itemcoupon 처리
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"& left(currenttime,10) &"', '"& coupon1 &"', '', getdate(), 'A')"
				dbget.execute sqlstr
		
				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value2, value3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '"&renloop&"', '1줄:"& line1 &"2줄:"& line2 &"3줄:"& line3 &"-제한수량초과-쿠폰:"& coupon1 &"', 'A')"
				dbget.execute sqlstr
		
				Response.write "SUCCESS!@#<div class='present'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_present_coupon_a.jpg' alt='내커피는 바로 여기에! 리버스 보틀' /><div class='btncoupon'><a href='' onclick='fnAPPpopupProduct(1299633); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_get.png' alt='바로 구매하러가기' /></a></div></div><div class='bnr'><a href='' onclick='fnAPPpopupEvent(63596); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_bnr_01.jpg' alt='6월의 더치박스 GO! BORMI' /></a></div><button type='button' class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_close.png' alt='닫기' /></button>"
				dbget.close()	:	response.End

			else
				'/당첨일때
				If clng(renloop) < clng(winnumber) Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"& left(currenttime,10) &"', '1', '', getdate(), 'A')"
					dbget.execute sqlstr
			
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '"&renloop&"', '1줄:"& line1 &"2줄:"& line2 &"3줄:"& line3 &"-당첨', 'A')"
					dbget.execute sqlstr

					Response.write "SUCCESS!@#<div class='present'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_present_bbq_a.jpg' alt='잠이 달아나는 한방! 스타벅스 아이스 아메리카노 톨' /><div class='mobile'><strong>"& evtUserCell &"</strong><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/mymain.asp""); return false;' class='btnmodify'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_modify.png' alt='수정' /></a></div></div><div class='bnr'><a href='' onclick='fnAPPpopupEvent(63596); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_bnr_01.jpg' alt='6월의 더치박스 GO! BORMI' /></a></div><button type='button' class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_close.png' alt='닫기' /></button>"
					dbget.close()	:	response.End
				else
					rvalue = fnSetItemCouponDown(userid, coupon1)	'/itemcoupon 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"& left(currenttime,10) &"', '"& coupon1 &"', '', getdate(), 'A')"
					dbget.execute sqlstr
			
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '"&renloop&"', '1줄:"& line1 &"2줄:"& line2 &"3줄:"& line3 &"-꽝-쿠폰:"& coupon1 &"', 'A')"
					dbget.execute sqlstr
			
					Response.write "SUCCESS!@#<div class='present'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_present_coupon_a.jpg' alt='내커피는 바로 여기에! 리버스 보틀' /><div class='btncoupon'><a href='' onclick='fnAPPpopupProduct(1299633); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_get.png' alt='바로 구매하러가기' /></a></div></div><div class='bnr'><a href='' onclick='fnAPPpopupEvent(63596); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_bnr_01.jpg' alt='6월의 더치박스 GO! BORMI' /></a></div><button type='button' class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_close.png' alt='닫기' /></button>"
					dbget.close()	:	response.End
				end if
			end if

		'/두번째줄 B선택
		elseif line2="B" then
			'/계란후라이타올 제한수량체크
			'/제한수량초과 쿠폰발급 꽝처리
			if clng(machine_event_subscripttotalcount) >= clng(limitmachinecnt) then
				rvalue = fnSetItemCouponDown(userid, coupon2)	'/itemcoupon 처리
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"& left(currenttime,10) &"', '"& coupon2 &"', '', getdate(), 'A')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value2, value3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '"&renloop&"', '1줄:"& line1 &"2줄:"& line2 &"3줄:"& line3 &"-제한수량초과-쿠폰:"& coupon2 &"', 'A')"
				dbget.execute sqlstr

				Response.write "SUCCESS!@#<div class='present'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_present_coupon_b.jpg' alt='내려! 하우스 커피 세트! THE GOLDEN THINGS' /><div class='btncoupon'><a href='' onclick='fnAPPpopupProduct(1263647); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_get.png' alt='바로 구매하러가기' /></a></div></div><div class='bnr'><a href='' onclick='fnAPPpopupEvent(63904); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_bnr_02.jpg' alt='동남아의 그 유명한 코코넛워터!' /></a></div><button type='button' class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_close.png' alt='닫기' /></button>"
				dbget.close()	:	response.End
				
			else
				'/당첨일때
				If clng(renloop) < clng(winnumber) Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"& left(currenttime,10) &"', '2', '', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '"&renloop&"', '1줄:"& line1 &"2줄:"& line2 &"3줄:"& line3 &"-당첨', 'A')"
					dbget.execute sqlstr

					Response.write "SUCCESS!@#<div class='present'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_present_towel_a.jpg' alt='찐하게 한번 마셔봐? 레꼴뜨 계란후라이타올' /></div><div class='bnr'><a href='' onclick='fnAPPpopupEvent(63904); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_bnr_02.jpg' alt='동남아의 그 유명한 코코넛워터!' /></a></div><button type='button' class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_close.png' alt='닫기' /></button>"
					dbget.close()	:	response.End
				else
					rvalue = fnSetItemCouponDown(userid, coupon2)	'/itemcoupon 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"& left(currenttime,10) &"', '"& coupon2 &"', '', getdate(), 'A')"
					dbget.execute sqlstr
			
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '"&renloop&"', '1줄:"& line1 &"2줄:"& line2 &"3줄:"& line3 &"-꽝-쿠폰:"& coupon2 &"', 'A')"
					dbget.execute sqlstr

					Response.write "SUCCESS!@#<div class='present'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_present_coupon_b.jpg' alt='내려! 하우스 커피 세트! THE GOLDEN THINGS' /><div class='btncoupon'><a href='' onclick='fnAPPpopupProduct(1263647); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_get.png' alt='바로 구매하러가기' /></a></div></div><div class='bnr'><a href='' onclick='fnAPPpopupEvent(63904); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_bnr_02.jpg' alt='동남아의 그 유명한 코코넛워터!' /></a></div><button type='button' class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_close.png' alt='닫기' /></button>"
					dbget.close()	:	response.End
				end if
			end if
		end if

	'/첫줄 B선택
	elseif line1="B" then
		'/두번째줄 A선택
		if line2="A" then
			'/BBQ치킨 제한수량체크
			'/제한수량초과 쿠폰발급 꽝처리
			if clng(coffe_event_subscripttotalcount) >= clng(limitcoffecnt) then
				rvalue = fnSetItemCouponDown(userid, coupon3)	'/itemcoupon 처리
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"& left(currenttime,10) &"', '"& coupon3 &"', '', getdate(), 'A')"
				dbget.execute sqlstr
		
				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value2, value3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '"&renloop&"', '1줄:"& line1 &"2줄:"& line2 &"3줄:"& line3 &"-제한수량초과-쿠폰:"& coupon3 &"', 'A')"
				dbget.execute sqlstr
		
				Response.write "SUCCESS!@#<div class='present'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_present_coupon_c.jpg' alt='호주머니 속에 더치커피! 보르딘 더치커피 세트' /><div class='btncoupon'><a href='' onclick='fnAPPpopupProduct(856316); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_get.png' alt='바로 구매하러가기' /></a></div></div><div class='bnr'><a href='' onclick='fnAPPpopupEvent(63529); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_bnr_03.jpg' alt='시원한 티타임 함께 하실래요?' /></a></div><button type='button' class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_close.png' alt='닫기' /></button>"
				dbget.close()	:	response.End

			else
				'/당첨일때
				If clng(renloop) < clng(winnumber) Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"& left(currenttime,10) &"', '1', '', getdate(), 'A')"
					dbget.execute sqlstr
			
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '"&renloop&"', '1줄:"& line1 &"2줄:"& line2 &"3줄:"& line3 &"-당첨', 'A')"
					dbget.execute sqlstr

					Response.write "SUCCESS!@#<div class='present'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_present_bbq_b.jpg' alt='물인듯 커피인듯 스타벅스 아이스 아메리카노 톨' /><div class='mobile'><strong>"& evtUserCell &"</strong><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/mymain.asp""); return false;' class='btnmodify'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_modify.png' alt='수정' /></a></div></div><div class='bnr'><a href='' onclick='fnAPPpopupEvent(63529); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_bnr_03.jpg' alt='시원한 티타임 함께 하실래요?' /></a></div><button type='button' class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_close.png' alt='닫기' /></button>"
					dbget.close()	:	response.End
				else
					rvalue = fnSetItemCouponDown(userid, coupon3)	'/itemcoupon 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"& left(currenttime,10) &"', '"& coupon3 &"', '', getdate(), 'A')"
					dbget.execute sqlstr
			
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '"&renloop&"', '1줄:"& line1 &"2줄:"& line2 &"3줄:"& line3 &"-꽝-쿠폰:"& coupon3 &"', 'A')"
					dbget.execute sqlstr
			
					Response.write "SUCCESS!@#<div class='present'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_present_coupon_c.jpg' alt='호주머니 속에 더치커피! 보르딘 더치커피 세트' /><div class='btncoupon'><a href='' onclick='fnAPPpopupProduct(856316); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_get.png' alt='바로 구매하러가기' /></a></div></div><div class='bnr'><a href='' onclick='fnAPPpopupEvent(63529); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_bnr_03.jpg' alt='시원한 티타임 함께 하실래요?' /></a></div><button type='button' class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_close.png' alt='닫기' /></button>"
					dbget.close()	:	response.End
				end if
			end if
		'/두번째줄 B선택
		elseif line2="B" then
			'/계란후라이타올 제한수량체크
			'/제한수량초과 쿠폰발급 꽝처리
			if clng(machine_event_subscripttotalcount) >= clng(limitmachinecnt) then
				rvalue = fnSetItemCouponDown(userid, coupon4)	'/itemcoupon 처리
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"& left(currenttime,10) &"', '"& coupon4 &"', '', getdate(), 'A')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value2, value3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '"&renloop&"', '1줄:"& line1 &"2줄:"& line2 &"3줄:"& line3 &"-제한수량초과-쿠폰:"& coupon4 &"', 'A')"
				dbget.execute sqlstr

				Response.write "SUCCESS!@#<div class='present'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_present_coupon_d.jpg' alt='함께라면 어디든 카페! 플라밍고 티코스터' /><div class='btncoupon'><a href='' onclick='fnAPPpopupProduct(1184954); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_get.png' alt='바로 구매하러가기' /></a></div></div><div class='bnr'><a href='' onclick='fnAPPpopupEvent(63665); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_bnr_04.jpg' alt='세상에서 가장 작은 카페' /></a></div><button type='button' class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_close.png' alt='닫기' /></button>"
				dbget.close()	:	response.End
				
			else
				'/당첨일때
				If clng(renloop) < clng(winnumber) Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"& left(currenttime,10) &"', '2', '', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '"&renloop&"', '1줄:"& line1 &"2줄:"& line2 &"3줄:"& line3 &"-당첨', 'A')"
					dbget.execute sqlstr

					Response.write "SUCCESS!@#<div class='present'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_present_towel_b.jpg' alt='부드러운 내스타일 커피 레꼴뜨 계란후라이타올' /></div><div class='bnr'><a href='' onclick='fnAPPpopupEvent(63665); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_bnr_04.jpg' alt='세상에서 가장 작은 카페' /></a></div><button type='button' class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_close.png' alt='닫기' /></button>"
					dbget.close()	:	response.End
				else
					rvalue = fnSetItemCouponDown(userid, coupon4)	'/itemcoupon 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"& left(currenttime,10) &"', '"& coupon4 &"', '', getdate(), 'A')"
					dbget.execute sqlstr
			
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '"&renloop&"', '1줄:"& line1 &"2줄:"& line2 &"3줄:"& line3 &"-꽝-쿠폰:"& coupon4 &"', 'A')"
					dbget.execute sqlstr

					Response.write "SUCCESS!@#<div class='present'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_present_coupon_d.jpg' alt='함께라면 어디든 카페! 플라밍고 티코스터' /><div class='btncoupon'><a href='' onclick='fnAPPpopupProduct(1184954); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_get.png' alt='바로 구매하러가기' /></a></div></div><div class='bnr'><a href='' onclick='fnAPPpopupEvent(63665); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/img_bnr_04.jpg' alt='세상에서 가장 작은 카페' /></a></div><button type='button' class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_close.png' alt='닫기' /></button>"
					dbget.close()	:	response.End
				end if
			end if
		end if
	end if
	
elseif mode="KAKAO" then
	if not( left(currenttime,10)>="2015-06-19" and left(currenttime,10)<"2015-06-29" ) then
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

'//앱실행 메인배너 클릭 카운트
elseif mode="app_main" then
	sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '"& mode &"')"
	
	'response.write sqlstr & "<br>"
	dbget.execute sqlstr

	Response.write "OK"
	dbget.close()	:	response.end

'//앱 다운받기 클릭 카운트
elseif mode="mo_main" then
	sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '"& mode &"')"
	
	'response.write sqlstr & "<br>"
	dbget.execute sqlstr

	Response.write "OK"
	dbget.close()	:	response.end

Else
	Response.Write "정상적인 경로가 아닙니다."
	dbget.close() : Response.End
end if

'## 상품쿠폰 다운 함수
Function fnSetItemCouponDown(ByVal userid, ByVal idx)
	dim sqlStr
	Dim objCmd
	Set objCmd = Server.CreateObject("ADODB.COMMAND")
	With objCmd
		.ActiveConnection = dbget
		.CommandType = adCmdText
		.CommandText = "{?= call [db_item].[dbo].sp_Ten_itemcoupon_down("&idx&",'"&userid&"')}"
		.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
		.Execute, , adExecuteNoRecords
		End With	
	    fnSetItemCouponDown = objCmd(0).Value	
	Set objCmd = Nothing	
END Function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->