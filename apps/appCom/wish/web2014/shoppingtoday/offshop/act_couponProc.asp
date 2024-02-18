<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<%
	Dim sNid, sPsId, sUuid, sEvtNo, sCpCd, sShopid, userid, isList, sqlStr, oJson, rstMsg, isCheck
	sNid = requestCheckVar(request.form("nid"),40)
	sPsId = requestCheckVar(request.form("pid"),512)
	sUuid = requestCheckVar(request.form("uid"),40)
	sCpCd = requestCheckVar(request.form("cpnCd"),32)
	sEvtNo = requestCheckVar(request.form("eno"),8)		'// 이벤트 구분

	if sNid="00000000-0000-0000-0000-000000000000" then sNid=""				'//iOS의 경우 nid가 0000인 경우가 있음 > 빈값으로 치환

	userid = GetLoginUserID()

	isList = false 		'쿠폰 대상자 여부
	isCheck = true		'오류 체크

	'// 유효 접근 주소 검사 //
	dim refer
	refer = request.ServerVariables("HTTP_REFERER")

	if len(sCpCd)<5 or left(sCpCd,2)<>"10" then
		rstMsg = "쿠폰 코드가 일치하지 않습니다.(C01)"
		isCheck = false
	end if

	if sNid="" and sPsId="" and sUuid="" then
		rstMsg = "파라메터 오류"
		isCheck = false
	end if

	if InStr(refer,"10x10.co.kr")<1 then
		rstMsg = "잘못된 접속입니다."
		isCheck = false
	end if

	sShopid = "streetshop" & right(sCpCd,3)		'// 오프샾 ID 생성

	'// 샾코드 확인
	if isCheck then
		sqlStr = "select count(*) as cnt from db_shop.dbo.tbl_shop_user "
		sqlStr = sqlStr & "	where userid='" & sShopid & "' and isusing='Y'"
		rsget.CursorLocation = adUseClient
        rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly
		if rsget("cnt")<=0 then
			isCheck = false
			rstMsg = "쿠폰 코드가 일치하지 않습니다.(C02)"
		end if
		rsget.Close	
	end if

	'// 쿠폰 사용여부 확인
	if isCheck then
		sqlStr = "select count(*) as cnt from db_contents.dbo.tbl_app_offshop_inflow"
		sqlStr = sqlStr & "	where eventNo=" & sEvtNo & " and ("
		if sNid<>"" then sqlStr = sqlStr & " Nid='"&sNid&"' or"
		if sUuid<>"" then sqlStr = sqlStr & " uuid='"&sUuid&"' or"
		if sPsId<>"" then sqlStr = sqlStr & " deviceid='"&sPsId&"' or"
	    sqlStr = LEFT(sqlStr,LEN(sqlStr)-3)
		sqlStr = sqlStr & ")"

		rsget.CursorLocation = adUseClient
        rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly
		if rsget("cnt")>0 then
			isList = false
			isCheck = false
			rstMsg = "쿠폰을 이미 사용하였습니다."
		else
			isList = true
		end if
		rsget.Close	
	end if

	'// json객체 선언
	Set oJson = jsObject()

	if isList then
		'// 사용 정보 저장
		sqlStr = "Insert into db_contents.dbo.tbl_app_offshop_inflow"
		sqlStr = sqlStr & " (Nid, uuid, deviceid, userid, shopid, eventNo, regdate) values "
		sqlStr = sqlStr & "('" & sNid & "'"
		sqlStr = sqlStr & ",'" & sUuid & "'"
		sqlStr = sqlStr & ",'" & sPsId & "'"
		sqlStr = sqlStr & ",'" & userid & "'"
		sqlStr = sqlStr & ",'" & sShopid & "'"
		sqlStr = sqlStr & ",'" & sEvtNo & "',getdate())"
		dbget.Execute(sqlStr)

		oJson("response") = "ok"
	else
		oJson("response") = "fail"
		oJson("faildesc") = rstMsg
	end if

	'Json 출력(JSON)
	oJson.flush
	Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->