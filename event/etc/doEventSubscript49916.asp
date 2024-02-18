<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
'####################################################
' Description : 자, 이제 위시리스트 시작이야
' History : 2014.02.07 허진원 생성
'####################################################

Response.Expires = -1
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cahce"
Response.AddHeader "cache-Control", "no-cache"
Response.CharSet = "UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<%
dim eCode, userid, evtOpt, arrItems, i, intLoop, sqlStr, mECd
dim strSql
dim isSubscript: isSubscript=false

IF application("Svr_Info") = "Dev" THEN
	eCode = "21106"
	mECd = "21109"
Else
	eCode = "49915"
	mECd = "49916"
End If

userid = getloginuserid()
evtOpt = requestCheckVar(Request("evt_option"),240)		'상품(8 * 30개 제한)

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요');</script>"
	dbget.close() : Response.End
End IF
If not(date>="2014-03-07" and date<="2014-03-19") Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.');</script>"
	dbget.close() : Response.End
End IF

arrItems = split(evtOpt,",")
If Not(isArray(arrItems)) Then
	Response.Write "<script type='text/javascript'>alert('선택된 상품이 없습니다.');</script>"
	dbget.close() : Response.End
elseif ubound(arrItems)<4 then
	Response.Write "<script type='text/javascript'>alert('상품은 최소 5개 이상 선택해주세요.');</script>"
	dbget.close() : Response.End
End IF

'// 응모여부 확인
strSql = "select count(*) cnt " &_
		"from db_event.dbo.tbl_event_subscript " &_
		"where evt_code=" & eCode &_
		"	and userid='" & userid & "' "
rsget.Open strSql,dbget,1
if rsget(0)>0 then isSubscript = true		'응모여부
rsget.Close

if isSubscript then
	Response.Write "<script type='text/javascript'>alert('이미 응모하셨습니다.');top.history.go(0);</script>"
	dbget.close() : Response.End
end if

'===========================================================
dim tmpSelIid, vFidx

'// 이벤트 위시 폴더 생성 및 상품 추가
	dim myfavorite
	'# 이벤트 폴더 생성
	set myfavorite = new CMyFavorite	
		myfavorite.FRectUserID = userid
		myfavorite.FFolderName = "[3월의 위시리스트]"
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

	ELSEIF 	vFidx =-1 THEN
		Response.Write "<script type='text/javascript'>alert('위시리스트는 최대 10개까지만 생성이 가능합니다.\n이벤트에 참여를 원하시면 위시리스트를 정리해주세요.');top.history.go(0);</script>"
		dbget.close() : Response.End
	ELSE
		Response.Write "<script type='text/javascript'>alert('처리중 오류가 발생했습니다.');</script>"
		dbget.close() : Response.End
	End if

'// 응모값 저장 (10개 상품까지 저장)
	for i=0 to ubound(arrItems)
		if i>10 then Exit For
		tmpSelIid = tmpSelIid & chkIIF(tmpSelIid="","",",") & arrItems(i)
	next

	strSql = "Insert into db_event.dbo.tbl_event_subscript (evt_code,userid,sub_opt3) values "
	strSql = strSql & "(" & eCode & ",'" & userid & "','" & tmpSelIid & "')"
	dbget.Execute(strSql)


	'#참여 결과 안내
	Response.Write "<script type='text/javascript'>alert('이벤트에 응모되셨습니다!');top.history.go(0);</script>"
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->