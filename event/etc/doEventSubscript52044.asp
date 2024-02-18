<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  10x10 오감충족 이벤트 2탄 혹시 자리 있으세요?
' History : 2014.05.20 원승현 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<!-- #include virtual="/event/2014openevent/cls2014openevent.asp" -->

<%
dim eCode, userid, mode, sqlstr, refer, gubun, subscriptcount, evtOpt, i, intLoop, oleCode
	mode = requestcheckvar(request("mode"),32)
	evtOpt = requestcheckvar(request("productSelect"),200)
	userid = getloginuserid()


	evtOpt = CStr(evtOpt)
	
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  21177
		oleCode = 21176
	Else
		eCode   =  52044
		oleCode = 52043
	End If

subscriptcount=0

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF

if mode="addevent" then

	subscriptcount = getevent_subscriptexistscount(oleCode, userid, "", "", "")
	if subscriptcount > 1 then
		Response.Write "<script type='text/javascript'>alert('1회만 응모가 가능 합니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if

	dim tmpSelIid, vFidx, myfavorite

	If not(getnowdate>="2014-05-20" and getnowdate<"2014-05-31") Then
		Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.');parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF

	'# 이벤트 폴더 생성
	set myfavorite = new CMyFavorite	
		myfavorite.FRectUserID = userid
		myfavorite.FFolderName = "[DIY 패키지]"
		myfavorite.fviewisusing = "Y"
		vFidx = myfavorite.fnSetFolder
	set myfavorite = nothing

	IF vFidx > 0  THEN
		'# 상품 추가
		set myfavorite = new CMyFavorite
		myfavorite.FRectUserID = userid
		myfavorite.FFolderIdx = vFidx
		myfavorite.selectedinsert(evtOpt)

		'폴더정보 업데이트
		myfavorite.fnUpdateFolderInfo
		set myfavorite = Nothing

		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& oleCode &", '" & userid & "', '1', 0, '"&evtOpt&"')" + vbcrlf
	
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr

	ELSEIF vFidx =-1 THEN
		Response.Write "<script type='text/javascript'>alert('위시리스트는 최대 10개까지만 생성이 가능합니다.\n이벤트에 참여를 원하시면 위시리스트를 정리해주세요.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	ELSE
		Response.Write "<script type='text/javascript'>alert('처리중 오류가 발생했습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End if

	Response.Write "<script type='text/javascript'>alert('응모가 완료 되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End	
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->