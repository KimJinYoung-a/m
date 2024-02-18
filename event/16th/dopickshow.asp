<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : [텐쑈]뽑아주쑈!
' History : 2017.09.27 정태훈
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%

Dim currenttime, refer, LoginUserid, eItemCode, ItemGroup
Dim itemid1, itemid2, itemid3, eCode, evt_sub_code, mydaycnt

LoginUserid	=	getencLoginUserid()
refer				= request.ServerVariables("HTTP_REFERER")
itemid1			= requestcheckvar(request("itemid1"),9)
If itemid1="" Then itemid1="0"
itemid2			= requestcheckvar(request("itemid2"),9)
If itemid2="" Then itemid2="0"
itemid3			= requestcheckvar(request("itemid3"),9)
If itemid3="" Then itemid3="0"
eCode			= requestcheckvar(request("eCode"),9)
evt_sub_code	= requestcheckvar(request("evt_sub_code"),9)

IF application("Svr_Info") = "Dev" THEN
	eCode = "67435"
	eItemCode="67436"
Else
	eCode = "80412"
	eItemCode="80741"
End If

currenttime = date()
'currenttime = "2017-10-10"

If currenttime="2017-10-10" Then
	ItemGroup="220325"
ElseIf currenttime="2017-10-11" Then
	ItemGroup="220326"
ElseIf currenttime="2017-10-12" Then
	ItemGroup="220327"
ElseIf currenttime="2017-10-13" Then
	ItemGroup="220328"
ElseIf currenttime="2017-10-14" Then
	ItemGroup="220329"
ElseIf currenttime="2017-10-15" Then
	ItemGroup="220437"
ElseIf currenttime="2017-10-16" Then
	ItemGroup="220438"
ElseIf currenttime="2017-10-17" Then
	ItemGroup="220439"
ElseIf currenttime="2017-10-18" Then
	ItemGroup="220440"
ElseIf currenttime="2017-10-19" Then
	ItemGroup="220441"
ElseIf currenttime="2017-10-20" Then
	ItemGroup="220442"
ElseIf currenttime="2017-10-21" Then
	ItemGroup="220443"
ElseIf currenttime="2017-10-22" Then
	ItemGroup="220444"
ElseIf currenttime="2017-10-23" Then
	ItemGroup="220445"
ElseIf currenttime="2017-10-24" Then
	ItemGroup="220446"
ElseIf currenttime="2017-10-25" Then
	ItemGroup="220447"
Else
	ItemGroup="137205"
End If

'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "<script>alert('잘못된 접속입니다.');history.back();</script>"
	Response.End
End If

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "<script>alert('로그인 후 참여하실 수 있습니다.');history.back();</script>"
	response.End
End If

If evt_sub_code<> ItemGroup Then
	Response.Write "<script>alert('응모 기간이 아닙니다. 현재 진행중인 카테고리 선택 후 참여해 주세요.');history.back();</script>"
	Response.End
End If

'// expiredate
If not(currenttime >= "2017-09-10" and currenttime <= "2017-10-25") Then
	Response.Write "<script>alert('이벤트 응모 기간이 아닙니다.');history.back();</script>"
	Response.End
End If

Dim sqlstr

	sqlstr = ""
	sqlstr = "select count(idx) as cnt"
	sqlstr = sqlstr & " from [db_temp].[dbo].[tbl_event_16th_pickshow]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and evt_sub_code="& ItemGroup &" and userid='"& LoginUserid &"'"
	rsget.Open sqlstr, dbget, 1
		mydaycnt = rsget("cnt")
	rsget.close

	If mydaycnt < 1 Then
	dbget.BeginTrans
	On Error resume Next
'Response.write itemid1 & "<br>"
'Response.write itemid2 & "<br>"
'Response.write itemid3 & "<br>"
'Response.end
		If itemid1<>"0" Then
				sqlStr = ""
				sqlstr = sqlstr & "if not exists(select * from [db_temp].[dbo].[tbl_event_16th_pickcount] where evt_code="+CStr(eCode)+" and evt_sub_code="+CStr(ItemGroup)+" and itemid="+CStr(itemid1)+")" & vbCrlf
				sqlstr = sqlstr & "	begin" & vbCrlf
				sqlstr = sqlstr & "		insert into [db_temp].[dbo].[tbl_event_16th_pickcount](evt_code, evt_sub_code, itemid, pickcount)" & vbCrlf
				sqlstr = sqlstr & "		values("+CStr(eCode)+","+CStr(ItemGroup)+","+CStr(itemid1)+",1)" & vbCrlf
				sqlstr = sqlstr & "	end" & vbCrlf
				sqlstr = sqlstr & "else" & vbCrlf
				sqlstr = sqlstr & "	begin" & vbCrlf
				sqlstr = sqlstr & "		update [db_temp].[dbo].[tbl_event_16th_pickcount]" & vbCrlf
				sqlstr = sqlstr & "		set pickcount=pickcount+1" & vbCrlf
				sqlstr = sqlstr & "		where evt_code="+CStr(eCode)+"" & vbCrlf
				sqlstr = sqlstr & "		 and evt_sub_code="+CStr(ItemGroup)+"" & vbCrlf
				sqlstr = sqlstr & "		 and itemid="+CStr(itemid1)+"" & vbCrlf
				sqlstr = sqlstr & "	end" & vbCrlf
				dbget.execute sqlstr

			IF (Err) then
				dbget.RollBackTrans
				On Error Goto 0
			End If
		End If
		If itemid2<>"0" Then
				sqlStr = ""
				sqlstr = sqlstr & "if not exists(select * from [db_temp].[dbo].[tbl_event_16th_pickcount] where evt_code="+CStr(eCode)+" and evt_sub_code="+CStr(ItemGroup)+" and itemid="+CStr(itemid2)+")" & vbCrlf
				sqlstr = sqlstr & "	begin" & vbCrlf
				sqlstr = sqlstr & "		insert into [db_temp].[dbo].[tbl_event_16th_pickcount](evt_code, evt_sub_code, itemid, pickcount)" & vbCrlf
				sqlstr = sqlstr & "		values("+CStr(eCode)+","+CStr(ItemGroup)+","+CStr(itemid2)+",1)" & vbCrlf
				sqlstr = sqlstr & "	end" & vbCrlf
				sqlstr = sqlstr & "else" & vbCrlf
				sqlstr = sqlstr & "	begin" & vbCrlf
				sqlstr = sqlstr & "		update [db_temp].[dbo].[tbl_event_16th_pickcount]" & vbCrlf
				sqlstr = sqlstr & "		set pickcount=pickcount+1" & vbCrlf
				sqlstr = sqlstr & "		where evt_code="+CStr(eCode)+"" & vbCrlf
				sqlstr = sqlstr & "		 and evt_sub_code="+CStr(ItemGroup)+"" & vbCrlf
				sqlstr = sqlstr & "		 and itemid="+CStr(itemid2)+"" & vbCrlf
				sqlstr = sqlstr & "	end" & vbCrlf
				dbget.execute sqlstr

			IF (Err) then
				dbget.RollBackTrans
				On Error Goto 0
			End If
		End If
		If itemid3<>"0" Then
			sqlStr = ""
			sqlstr = sqlstr & "if not exists(select * from [db_temp].[dbo].[tbl_event_16th_pickcount] where evt_code="+CStr(eCode)+" and evt_sub_code="+CStr(ItemGroup)+" and itemid="+CStr(itemid3)+")" & vbCrlf
			sqlstr = sqlstr & "	begin" & vbCrlf
			sqlstr = sqlstr & "		insert into [db_temp].[dbo].[tbl_event_16th_pickcount](evt_code, evt_sub_code, itemid, pickcount)" & vbCrlf
			sqlstr = sqlstr & "		values("+CStr(eCode)+","+CStr(ItemGroup)+","+CStr(itemid3)+",1)" & vbCrlf
			sqlstr = sqlstr & "	end" & vbCrlf
			sqlstr = sqlstr & "else" & vbCrlf
			sqlstr = sqlstr & "	begin" & vbCrlf
			sqlstr = sqlstr & "		update [db_temp].[dbo].[tbl_event_16th_pickcount]" & vbCrlf
			sqlstr = sqlstr & "		set pickcount=pickcount+1" & vbCrlf
			sqlstr = sqlstr & "		where evt_code="+CStr(eCode)+"" & vbCrlf
			sqlstr = sqlstr & "		 and evt_sub_code="+CStr(ItemGroup)+"" & vbCrlf
			sqlstr = sqlstr & "		 and itemid="+CStr(itemid3)+"" & vbCrlf
			sqlstr = sqlstr & "	end" & vbCrlf
			dbget.execute sqlstr
			IF (Err) then
				dbget.RollBackTrans
				On Error Goto 0
			End If
		End If

		sqlStr = ""
		sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_16th_pickshow] (userid, evt_code, evt_sub_code, pickitem1, pickitem2, pickitem3)" & vbCrlf
		sqlstr = sqlstr & " VALUES ('"& LoginUserid &"', "& eCode &", "& ItemGroup & "," & itemid1 & "," & itemid2 & "," & itemid3 & ")"
		dbget.execute sqlstr

		IF (Err) then
			dbget.RollBackTrans
			On Error Goto 0
			dbget.close()
			Response.write "<script>alert('일시적 오류 입니다. 다시 한번 시도해 주세요.');history.back();</script>"
			response.End
		Else
			dbget.CommitTrans
			On Error Goto 0
		End If
		dbget.close()
		if isApp=1 then
		Response.write "<script>alert('참여가 완료되었습니다.');location.href='/apps/appcom/wish/web2014/event/16th/pickshow.asp';</script>"
		Else
		Response.write "<script>alert('참여가 완료되었습니다.');location.href='/event/16th/pickshow.asp';</script>"
		End If
		response.End
	ElseIf mydaycnt > 0 Then
		dbget.close()
		Response.Write "<script>alert('하루에 한번씩만 참여가 가능 합니다.');history.back();</script>"
		response.End
	Else
		dbget.close()
		Response.write "<script>alert('정상적인 경로로 참여해주시기 바랍니다.');history.back();</script>"
		response.End
	End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->