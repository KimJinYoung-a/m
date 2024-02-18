<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'#######################################################
'	History	:  2015-08-19 이종화 생성
'	Description : 이벤트용 - 위시리스트 관리
'#######################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<%

dim i, sqlStr , viewisusing , userid, bagarray, mode, itemid, wishEvent, wishEventOX, vECode
dim foldername,fidx,backurl , arrList, intLoop,stype , myfavorite, intResult, vOpenerChk, vreturnurl
Dim snsno
	userid  		= getEncLoginUserID
	stype    		= requestCheckvar(request("hidM"),1)
	viewisusing		= "Y"
	foldername		= requestCheckvar(request("foldername"),100)
	fidx			= requestCheckvar(request("fidx"),9)
	backurl			= requestCheckvar(request("backurl"),100)
	bagarray		= Trim(requestCheckvar(request("bagarray"),1024))
	mode    		= requestCheckvar(request("mode"),16)
	itemid  		= requestCheckvar(request("itemid"),9)
	vOpenerChk		= requestCheckvar(request("op"),1)
	vECode			= requestCheckvar(request("eventid"),9)
	snsno			= requestCheckvar(request("snsno"),2)
	vreturnurl		= requestCheckvar(request("returnurl"),1024)
%>
<!-- #include virtual="/event/etc/wishlist/wish_samename_folder_check.asp" -->
<%
SELECT CASE stype
	CASE "I"	'폴더추가

		set myfavorite = new CMyFavorite
			myfavorite.FRectUserID = userid
			myfavorite.FFolderName = foldername
			myfavorite.fviewisusing = viewisusing
			intResult = myfavorite.fnSetFolder
		set myfavorite = nothing

		IF intResult > 0  THEN
			Set wishEvent = new CMyFavorite
				wishEvent.FRectUserID	= userid
				wishEvent.FFolderIdx	= intResult
				wishEvent.fnWishListEventSave

				wishEventOX = wishEvent.FResultCount
			Set wishEvent = Nothing

			If wishEventOX = "x" Then
				Response.Write "<script>alert('데이터 처리에 문제가 생겼습니다.');</script>"
				dbget.close()
				Response.End
			ElseIf wishEventOX = "o" Then
				sqlStr = "if exists(select top 1 * from db_temp.dbo.tbl_wishlist_event where evt_code="& vECode &" and userid='"& userid &"')" + vbcrlf
				sqlStr = sqlStr & " begin" + vbcrlf
				sqlStr = sqlStr & " 	delete from db_temp.dbo.tbl_wishlist_event where evt_code="& vECode &" and userid='"& userid &"'" + vbcrlf
				sqlStr = sqlStr & " end"

				'response.write sqlstr
				dbget.execute(sqlStr)
				
				Call JoinEvent(vECode)
				Call JoinEventSubscript(vECode)

				Response.Write "<script>"
				Response.Write "	alert('"& foldername &" 위시폴더가 생성되었습니다.\n\n※기본 폴더명을 수정하거나 수동으로 만드는 폴더는 응모대상에서 제외 됩니다.');"
				If Trim(vreturnurl)<>"" Then 
					Response.Write " parent.location.href='"&vreturnurl&"'"
				Else
					Response.Write " history.back();"
				End If
				Response.Write "</script>"
				dbget.close() : Response.End
			End IF

		ELSEIF 	intResult =-1 THEN
			Alert_return("폴더는 10개까지만 등록가능합니다.")
			dbget.Close
			response.end
		ELSE
			Alert_return("데이터처리에 문제가 발생했습니다.")
			dbget.Close
			response.end
		END If
	
	CASE "S"	'SNS 카운팅

		sqlstr = "insert into db_log.[dbo].[tbl_caution_event_log] (evt_code, userid, refip, value1 , value2, value3, device ) values " &_
			" ('"& vECode &"' " &_
			", '"& userid &"' " &_
			", '"& Left(request.ServerVariables("REMOTE_ADDR"),32) & "' " &_
			", '"& snsno &"' " &_
			", '' " &_
			", '' " &_
			", 'M') "
		dbget.Execute sqlstr
		if snsno = "tw" then
			Response.write "tw"
		elseif snsno = "fb" then
			Response.write "fb"
		elseif snsno = "ka" then
			Response.write "ka"
		elseif snsno = "ln" then
			Response.write "ln"
		else
			Response.write "99"
		end if
		Response.End
END Select

Function JoinEvent(evt_code)
Dim vQuery
	vQuery = "IF NOT EXISTS(SELECT userid FROM [db_event].[dbo].[tbl_event_comment] WHERE evt_code = '" & evt_code & "' AND userid = '" & getEncLoginUserID & "') " & vbCrLf
	vQuery = vQuery & "BEGIN " & vbCrLf
	vQuery = vQuery & "		INSERT INTO [db_event].[dbo].[tbl_event_comment](evt_code,userid,evtcom_txt,evtcom_point,evtcom_regdate,evtcom_using,evtbbs_idx,evtgroup_code,refip,blogurl,device) " & vbCrLf
	vQuery = vQuery & "		SELECT '" & evt_code & "','" & getEncLoginUserID & "','','0',getdate(),'Y','0','0','" & Request.ServerVariables("REMOTE_ADDR") & "',null,'M'" & vbCrLf
	vQuery = vQuery & "END "
	dbget.execute(vQuery)
End Function

Function JoinEventSubscript(evt_code)
Dim vQuery
	vQuery = "IF NOT EXISTS(SELECT userid FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & evt_code & "' AND userid = '" & getEncLoginUserID & "') " & vbCrLf
	vQuery = vQuery & "BEGIN " & vbCrLf
	vQuery = vQuery & "		INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code,userid,sub_opt1,sub_opt2,sub_opt3,regdate,device) " & vbCrLf
	vQuery = vQuery & "		SELECT '" & evt_code & "','" & getEncLoginUserID & "','','0','',getdate(),'M'" & vbCrLf
	vQuery = vQuery & "END "
	dbget.execute(vQuery)
End Function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->