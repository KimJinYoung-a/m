<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description :  텐바이텐 웰컴 투 APP어랜드 
' History : 2014.04.25 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/event/etc/event51404Cls.asp" -->

<%
dim eCode, userid, mode, sqlstr, refer, kakaotalkscriptcount, ridescriptcount, giftscriptcount, giftscriptcount2, couponscriptcount
dim giftgubun, giftval, giftexistsyn, couponissueyn, tmpidx
	mode = requestcheckvar(request("mode"),32)
	eCode=getevt_code
	userid = getloginuserid()

kakaotalkscriptcount=0
ridescriptcount=0
giftscriptcount=0
giftscriptcount2=0
couponscriptcount=0
giftgubun="" : giftval="" : giftexistsyn="N" : couponissueyn="N" : tmpidx=""

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF
If not(getnowdate>="2014-04-30" and getnowdate<"2014-05-07") Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF

if mode="kakaotalkadd" then
	kakaotalkscriptcount = getevent_subscriptexistscount(eCode, userid, "", "2", "")	'//카카오톡 초대여부
	if kakaotalkscriptcount <> 0 then
		Response.Write "<script type='text/javascript'>alert('이미 응모하셨습니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '', 2, '', 'A')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr
%>
	<script src="/lib/js/kakao.Link.js"></script>
	<script type='text/javascript'>
		parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid=<%= eCode %>'	
		parent.kakaosend();
		//alert('카카오톡 참여가 완료 되었습니다.');
	</script>
<%
	dbget.close() : Response.End

elseif mode="giftadd" then
	kakaotalkscriptcount = getevent_subscriptexistscount(eCode, userid, "", "2", "")	'//카카오톡 초대여부
	if kakaotalkscriptcount = 0 then
		Response.Write "<script type='text/javascript'>alert('카카오톡 초대후, 참여 하실수 있습니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if

	giftscriptcount = getevent_subscriptexistscount(eCode, userid, "", "3", "")		'//기프트 응모여부
	if giftscriptcount <> 0 then
		Response.Write "<script type='text/javascript'>alert('이미 응모하셨습니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if

	couponscriptcount=getbonuscouponexistscount(userid, getcoupon3000, "", "", "")	'//보너스쿠폰 응모여부
	if couponscriptcount <> 0 then
		Response.Write "<script type='text/javascript'>alert('이미 응모하셨습니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if
	
	'//기프티콘 테이블에서 응모 내역 있는지 체크
	sqlstr = "select count(*) as cnt"
	sqlstr = sqlstr & " from db_temp.dbo.tbl_event_etc_yongman t"
	sqlstr = sqlstr & " where isusing='Y' and t.userid='"& userid &"' and t.event_code="&eCode&" "

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		giftscriptcount2=rsget("cnt")
	END IF
	rsget.close
	if giftscriptcount2 <> 0 then
		Response.Write "<script type='text/javascript'>alert('이미 응모하셨습니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if
	
	On Error Resume Next
	
	'//트랜젝션 시작
	dbget.beginTrans
	
	giftgubun="" : giftval="" : giftexistsyn="N" : tmpidx=""
	'//날짜별 기프티콘, 맥북 제한수량 랜덤으로 임시테이블에 셋팅
	sqlstr = "select top 1"
	sqlstr = sqlstr & " t.idx, t.couponidx, t.bigo"
	sqlstr = sqlstr & " from db_temp.dbo.tbl_event_etc_yongman t"
	sqlstr = sqlstr & " where isusing='Y' and isnull(t.userid,'')='' and t.event_code="&eCode&" and t.winnerdate='"&getnowdate&"'"
	sqlstr = sqlstr & " order by newid()"		'//랜덤으로 가져옴

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		giftgubun=rsget("couponidx")		'//1바나나우유, 2스마트초이스, 3카페아메리카노, 4싱글킹, 5파인트, 10맥북
		giftval=getNumeric(rsget("bigo"))		'//바코드값 , 맥북여부
		tmpidx=rsget("idx")
		giftexistsyn="Y"
	END IF
	rsget.close
	
	'//11시보다 작으면 쿠폰 발행
	if hour(Now()) < 11 then
		giftexistsyn="N"
	end if
	
	couponissueyn="N"
	'//오늘 날짜에 제한수량중 기프티콘이나 맥북이 있을경우
	if giftexistsyn="Y" then
		sqlstr = "update db_temp.dbo.tbl_event_etc_yongman" + vbcrlf
		sqlstr = sqlstr & " set userid='"& userid &"' where" + vbcrlf
		sqlstr = sqlstr & " idx="&tmpidx&" and event_code="&eCode&"" + vbcrlf

		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr

		'//맥북
		if giftgubun=10 then
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', 'macbook', 3, '', 'A')" + vbcrlf
	
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr
		
		'//기프티콘
		else
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', 'giftcon', 3, '', 'A')" + vbcrlf
	
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr
		end if

	'없을경우 3천원 쿠폰 발급
	else
		couponissueyn="Y"

		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', 'coupon', 3, '', 'A')" + vbcrlf
	
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr
	end if
	
	If Err.Number = 0 Then
	    dbget.CommitTrans
	    'dbget.RollBackTrans
	    
	Else
	    dbget.RollBackTrans
	End If
	
	on error goto 0

	'//디비 락 방지를 위해서 트랜젝션 밖에서 처리
	'//해당 대상자 쿠폰 발급
	if couponissueyn="Y" then
		sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
		sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
		sqlstr = sqlstr & " 	SELECT " + vbcrlf
		sqlstr = sqlstr & " 	m.idx, '" & userid & "', m.coupontype, m.couponvalue, m.couponname, m.minbuyprice, m.targetitemlist" + vbcrlf
		sqlstr = sqlstr & " 	, m.startdate, m.expiredate, m.couponmeaipprice, m.validsitename" + vbcrlf
		sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
		sqlstr = sqlstr & " 	where m.idx="&getcoupon3000&"" + vbcrlf

		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr		
	end if

%>
	<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
	<script type='text/javascript'>
		parent.$('#giftbutton').empty().html("<a href='#' onclick='jsSubmitgift_ajax(); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2014/51404/appland_btn_storage.png' alt='보관함' /></a>")
		parent.jsgift_ajax();
	</script>
<%	
	dbget.close() : Response.End

elseif mode="rideadd" then
	ridescriptcount = getevent_subscriptexistscount(eCode, userid, "", "4", "")		'//놀이기구 응모여부
	if ridescriptcount <> 0 then
		Response.Write "<script type='text/javascript'>alert('이미 응모하셨습니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '', 4, '', 'A')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('참여가 완료 되었습니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End

else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->