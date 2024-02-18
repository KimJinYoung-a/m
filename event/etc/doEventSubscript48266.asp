<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
%>
<%
'####################################################
' Description :  스폐셜 뱃지 있는 사람 손들어
' History : 2014.01.07 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/enjoy/event48266Cls.asp" -->

<%
dim eCode, userid, mode, sqlstr
dim subscriptexistscount, subscriptexistscount1, subscriptexistscount2, mileageexistscount
dim badgeexistscount10, badgeexistscount11, badgeexistscount12, badgecount
	eCode   =  getevt_code
	mode = requestcheckvar(request("mode"),32)

userid = GetLoginUserID()
subscriptexistscount=0
subscriptexistscount1=0
subscriptexistscount2=0
mileageexistscount=0
badgeexistscount10=0
badgeexistscount11=0
badgeexistscount12=0
badgecount=0

'Response.Write "<script type='text/javascript'>alert('현재 서비스 정검중입니다. 잠시만 기다려주세요.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
'dbget.close() : Response.End
		
If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF
If not(getnowdate>="2014-01-08" and getnowdate<"2014-01-16") Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF

'/응모여부
subscriptexistscount2 = getevent_subscriptexistscount(eCode, GetLoginUserID(), "1", "1", "")
if subscriptexistscount2>0 then
	Response.Write "<script type='text/javascript'>alert('이미 참여 하셨습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if

'//10월뱃지획득
badgeexistscount10=getbadgeexistscount(userid, "13", "", "", "")
'//11월뱃지획득
badgeexistscount11=getbadgeexistscount(userid, "14", "", "", "")
'//12월뱃지획득
badgeexistscount12=getbadgeexistscount(userid, "15", "", "", "")
		
if mode="badgecheck3" then

	'/응모여부
	subscriptexistscount = getevent_subscriptexistscount(eCode, GetLoginUserID(), "", "", "")
	'//처음참여
	if subscriptexistscount=0 then

		'////////////////모두 리셋////////////
		'//뺏지 이미지 처리
		Response.Write "<script type='text/javascript'>parent.$('#badgeimg10').html('<img src=""http://webimage.10x10.co.kr/eventIMG/2013/48266/img_special_badge_01_off.png"" alt=""10월 스페셜 뱃지"" />')</script>"
		Response.Write "<script type='text/javascript'>parent.$('#badgeimg11').html('<img src=""http://webimage.10x10.co.kr/eventIMG/2013/48266/img_special_badge_02_off.png"" alt=""11월 스페셜 뱃지"" />')</script>"
		Response.Write "<script type='text/javascript'>parent.$('#badgeimg12').html('<img src=""http://webimage.10x10.co.kr/eventIMG/2013/48266/img_special_badge_03_off.png"" alt=""12월 스페셜 뱃지"" />')</script>"
		'//응모버튼 처리
		Response.Write "<script type='text/javascript'>parent.$('#badgestats01').hide();</script>"
		Response.Write "<script type='text/javascript'>parent.$('#badgestats02').hide();</script>"
		Response.Write "<script type='text/javascript'>parent.$('#badgestats03').hide();</script>"
		'//코멘트 처리
		Response.Write "<script type='text/javascript'>parent.$('#badgecomment00').hide();</script>"
		Response.Write "<script type='text/javascript'>parent.$('#badgecomment01').hide();</script>"
		Response.Write "<script type='text/javascript'>parent.$('#badgecomment02').hide();</script>"
		Response.Write "<script type='text/javascript'>parent.$('#badgecommentall').hide();</script>"
		'////////////////모두 리셋////////////
		
		'//10월 응모 일경우
		if badgeexistscount10>0 then
			Response.Write "<script type='text/javascript'>parent.$('#badgeimg10').html('<img src=""http://webimage.10x10.co.kr/eventIMG/2013/48266/img_special_badge_01_on.png"" alt=""10월 스페셜 뱃지"" />')</script>"
			badgecount=badgecount+1
		end if
		'//11월 응모 일경우
		if badgeexistscount11>0 then
			Response.Write "<script type='text/javascript'>parent.$('#badgeimg11').html('<img src=""http://webimage.10x10.co.kr/eventIMG/2013/48266/img_special_badge_02_on.png"" alt=""11월 스페셜 뱃지"" />')</script>"
			badgecount=badgecount+1
		end if
		'//12월 응모 일경우
		if badgeexistscount12>0 then
			Response.Write "<script type='text/javascript'>parent.$('#badgeimg12').html('<img src=""http://webimage.10x10.co.kr/eventIMG/2013/48266/img_special_badge_03_on.png"" alt=""11월 스페셜 뱃지"" />')</script>"
			badgecount=badgecount+1
		end if
		
		'/뱃지0개
		if badgecount=0 then
			sqlstr = "IF NOT EXISTS(select sub_idx from [db_event].[dbo].[tbl_event_subscript] where evt_code = "& eCode &" and userid = '" & userid & "')" + vbcrlf
			sqlstr = sqlstr & " BEGIN" + vbcrlf
			sqlstr = sqlstr & " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)" + vbcrlf
			sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '2', '', 'M꽝')" + vbcrlf
			sqlstr = sqlstr & " END"
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr

			Response.Write "<script type='text/javascript'>parent.$('#badgestats03').show();</script>"
			Response.Write "<script type='text/javascript'>parent.$('#badgecomment00').show();</script>"
			Response.Write "<script type='text/javascript'>alert('획득하신 스폐셜 뱃지가 하나도 없으시네요~ 2014년에는 꼭 도전하세요!'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
			
		'/뱃지1개
		elseif badgecount=1 then
			sqlstr = "IF NOT EXISTS(select sub_idx from [db_event].[dbo].[tbl_event_subscript] where evt_code = "& eCode &" and userid = '" & userid & "')" + vbcrlf
			sqlstr = sqlstr & " BEGIN" + vbcrlf
			sqlstr = sqlstr & " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)" + vbcrlf
			sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '2', '', 'M꽝')" + vbcrlf
			sqlstr = sqlstr & " END"
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr

			Response.Write "<script type='text/javascript'>parent.$('#badgestats03').show();</script>"
			Response.Write "<script type='text/javascript'>parent.$('#badgecomment01').show();</script>"
			Response.Write "<script type='text/javascript'>alert('아쉽게도 스폐셜 뱃지 1개만 모으셨네요~ 2014년에 다시 돌아올 스폐셜 뱃지에 도전하세요!'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
			
		'/뱃지2개
		elseif badgecount=2 then
			sqlstr = "IF NOT EXISTS(select sub_idx from [db_event].[dbo].[tbl_event_subscript] where evt_code = "& eCode &" and userid = '" & userid & "')" + vbcrlf
			sqlstr = sqlstr & " BEGIN" + vbcrlf
			sqlstr = sqlstr & " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)" + vbcrlf
			sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '2', '', 'M꽝')" + vbcrlf
			sqlstr = sqlstr & " END"
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr

			Response.Write "<script type='text/javascript'>parent.$('#badgestats03').show();</script>"			
			Response.Write "<script type='text/javascript'>parent.$('#badgecomment02').show();</script>"
			Response.Write "<script type='text/javascript'>alert('아쉽게도 스폐셜 뱃지 2개만 모으셨네요~ 2014년에 다시 돌아올 스폐셜 뱃지에 도전하세요!'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
			
		'/뱃지3개
		elseif badgecount=3 then
			'/마일리지 발급여부
			mileageexistscount = getmileageexistscount(GetLoginUserID(), "1000", "스폐셜 뱃지 있는 사람 손들어 1000 마일리지 적립", "+1000")
			if mileageexistscount>0 then
				Response.Write "<script type='text/javascript'>alert('마일리지가 이미 발급되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
				dbget.close() : Response.End
			end if	

			sqlstr = "IF NOT EXISTS(select sub_idx from [db_event].[dbo].[tbl_event_subscript] where evt_code = "& eCode &" and userid = '" & userid & "')" + vbcrlf
			sqlstr = sqlstr & " BEGIN" + vbcrlf
			sqlstr = sqlstr & " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)" + vbcrlf
			sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '1', '', 'Mmileage')" + vbcrlf
			sqlstr = sqlstr & " END"
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr
			sqlstr = "update db_user.dbo.tbl_user_current_mileage" + vbcrlf
			sqlstr = sqlstr & " set bonusmileage = bonusmileage+1000" + vbcrlf
			sqlstr = sqlstr & " where userid = '" & userid & "'" + vbcrlf
			sqlstr = sqlstr & " insert into db_user.dbo.tbl_mileagelog(userid , mileage , jukyocd , jukyo , deleteyn)" + vbcrlf
			sqlstr = sqlstr & " values('" & userid & "', '+1000', 1000, '스폐셜 뱃지 있는 사람 손들어 1000 마일리지 적립','N')"
			'response.write sqlstr & "<Br>"
			dbget.execute(sqlstr)
		
			Response.Write "<script type='text/javascript'>parent.$('#badgestats02').show();</script>"			
			Response.Write "<script type='text/javascript'>parent.$('#badgecommentall').show();</script>"
		end if
		
		dbget.close() : Response.End
		
	'//기프트 응모
	else
		'/응모여부
		subscriptexistscount1 = getevent_subscriptexistscount(eCode, GetLoginUserID(), "1", "", "")
		if subscriptexistscount1=0 then
			Response.Write "<script type='text/javascript'>alert('잘못된 경로로 접속 하셨습니다. 이벤트 응모를 먼저 해주세요.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if	
		
		if badgeexistscount10>0 and badgeexistscount11>0 and badgeexistscount12>0 then
			sqlstr = "IF EXISTS(select sub_idx from [db_event].[dbo].[tbl_event_subscript] where evt_code = "& eCode &" and userid = '" & userid & "' and sub_opt1='1')" + vbcrlf
			sqlstr = sqlstr & " BEGIN" + vbcrlf
			sqlstr = sqlstr & " 	update [db_event].[dbo].[tbl_event_subscript]" + vbcrlf
			sqlstr = sqlstr & " 	set sub_opt2=1" + vbcrlf
			sqlstr = sqlstr & " 	,sub_opt3='Mgift'" + vbcrlf
			sqlstr = sqlstr & " 	where evt_code = "& eCode &" and userid = '" & userid & "' and sub_opt1='1'" + vbcrlf
			sqlstr = sqlstr & " END"
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr
		
			Response.Write "<script type='text/javascript'>alert('응모완료! 당첨자 발표일은 1월 16일 입니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		else
			Response.Write "<script type='text/javascript'>alert('뱃지 참여 횟수가 부족 합니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if
	end if
	
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->