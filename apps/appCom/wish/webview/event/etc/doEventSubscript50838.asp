<% @  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<% Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 어머, 이건 담아야해_APP 런칭 이벤트 2차(APP)
' History : 2014.04.11 유태욱
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/event/etc/event50838Cls.asp" -->
<!-- #include virtual="/apps/appCom/wish/webview/lib/classes/Apps_eventCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<%
dim eCode, userid, evtOpt, arrItems, i, intLoop, sqlStr, mECd
dim strSql
dim isSubscript: isSubscript=false

userid = getloginuserid()
eCode=getevt_code

evtOpt = requestCheckVar(Request("itemid"),10)

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"';</script>"
	dbget.close() : Response.End
End IF
If not(left(currenttime,10)>="2014-05-12" and left(currenttime,10)<="2014-05-23") Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.');</script>"
	dbget.close() : Response.End
End IF

'arrItems = split(evtOpt,",")
'If Not(isArray(arrItems)) Then
'	Response.Write "<script type='text/javascript'>alert('선택된 상품이 없습니다.');</script>"
'	dbget.close() : Response.End
'End IF

If evtOpt="" Then
	Response.Write "<script type='text/javascript'>alert('선택된 상품이 없습니다.');</script>"
	dbget.close() : Response.End
End IF

'// 응모여부 확인
strSql = "select count(*) cnt " &_
		"from db_event.dbo.tbl_event_subscript " &_
		"where evt_code=" & eCode &_
		"	and userid='" & userid & "' and sub_opt1='"&left(currenttime,10)&"'"
'response.write strsql
rsget.Open strSql,dbget,1


if rsget(0)>0 then isSubscript = true		'응모여부
rsget.Close

if isSubscript then
	Response.Write "<script type='text/javascript'>alert('이미 응모하셨습니다.');top.history.go(0);</script>"
	dbget.close() : Response.End
end if

'===========================================================
dim tmpSelIid, vFidx
vFidx=""

'//존재하는 위시 폴더 인지 체크
sqlstr = "select fidx"
sqlstr = sqlstr & " from [db_my10x10].[dbo].[tbl_myfavorite_folder]"
sqlstr = sqlstr & " where userid ='"&userid&"' and foldername='어머, 이건 담아야해'"

'response.write sqlstr & "<Br>"
rsget.Open sqlstr,dbget
IF not rsget.EOF THEN
	vFidx = rsget("fidx")
END IF
rsget.close

'//폴더가 존재할경우
if vFidx<>"" then

	IF vFidx > 0  THEN
		'# 상품 추가
		set myfavorite = new CMyFavorite
		myfavorite.FRectUserID = userid
		myfavorite.FFolderIdx = vFidx
		myfavorite.selectedinsert(evtOpt)

		'폴더정보 업데이트
		myfavorite.fnUpdateFolderInfo
		set myfavorite = Nothing

		'// 응모값 저장 (10개 상품까지 저장)
'		for i=0 to ubound(arrItems)
'			if i>10 then Exit For
'			tmpSelIid = tmpSelIid & chkIIF(tmpSelIid="","",",") & arrItems(i)
'		next
		
		strSql = "Insert into db_event.dbo.tbl_event_subscript (evt_code,userid,sub_opt1,sub_opt2,device) values "
		strSql = strSql & "(" & eCode & ",'" & userid & "','"&left(currenttime,10)&"'," & evtOpt & ",'A')"
		dbget.Execute(strSql)
	
		'#참여 결과 안내
		Response.Write "<script type='text/javascript'>alert('이벤트에 응모되셨습니다!');top.history.go(0);</script>"
	end if

'폴더가 존재 안할경우
else

	'// 이벤트 위시 폴더 생성 및 상품 추가
	dim myfavorite
	'# 이벤트 폴더 생성
	set myfavorite = new CMyFavorite	
		myfavorite.FRectUserID = userid
		myfavorite.FFolderName = "어머, 이건 담아야해"
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

		'// 응모값 저장 (10개 상품까지 저장)
'		for i=0 to ubound(arrItems)
'			if i>10 then Exit For
'			tmpSelIid = tmpSelIid & chkIIF(tmpSelIid="","",",") & arrItems(i)
'		next
		
		strSql = "Insert into db_event.dbo.tbl_event_subscript (evt_code,userid,sub_opt1,sub_opt2,device) values "
		strSql = strSql & "(" & eCode & ",'" & userid & "','"&left(currenttime,10)&"'," & evtOpt & ",'A')"
		dbget.Execute(strSql)
	
		'#참여 결과 안내
		Response.Write "<script type='text/javascript'>alert('이벤트에 응모되셨습니다!');top.history.go(0);</script>"

	ELSEIF 	vFidx =-1 THEN
		Response.Write "<script type='text/javascript'>alert('위시리스트는 최대 10개까지만 생성이 가능합니다.\n이벤트에 참여를 원하시면 위시리스트를 정리해주세요.');top.history.go(0);</script>"
		dbget.close() : Response.End
	ELSE
		Response.Write "<script type='text/javascript'>alert('처리중 오류가 발생했습니다.');</script>"
		dbget.close() : Response.End
	End if
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->