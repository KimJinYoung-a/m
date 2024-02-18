<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
	dim orderserial, itemid, transactionId, mediaCode, adCode, gadid, numOfItem
	dim strSql

	'// 전송값 접수
	orderserial = requestCheckVar(Request.form("orderserial"),12)
	itemid = requestCheckVar(Request.form("itemid"),10)
	transactionId = requestCheckVar(Request.form("transactionId"),256)
	mediaCode = requestCheckVar(Request.form("mediaCode"),256)
	adCode = requestCheckVar(Request.form("adCode"),256)
	gadid = requestCheckVar(Request.form("gadid"),256)
	numOfItem = requestCheckVar(Request.form("numOfItem"),10)
	if numOfItem="" then numOfItem=0

	if orderserial<>"" and itemid<>"" and numOfItem>0 then 

		strSql = "IF NOT EXISTS(Select * from db_temp.dbo.tbl_focusm_orderInfo where orderserial='" & orderserial & "' and itemid='" & itemid & "') " & vbCrLf &_
				" BEGIN " & vbCrLf &_
				" insert into db_temp.dbo.tbl_focusm_orderInfo (orderserial, itemid, transactionId, mediaCode, adCode, gadid, numOfItem, status) values " &_
				" ('" & orderserial & "'" &_
				" ,'" & itemid & "'"  &_
				" ,'" & transactionId & "'"  &_
				" ,'" & mediaCode & "'"  &_
				" ,'" & adCode & "'"  &_
				" ,'" & gadid & "'"  &_
				" ,'" & numOfItem & "',0)" & vbCrLf &_
				" END "
		dbget.execute(strSql)

		'// 주문 완료시 포커스엠에 전송
		Dim oXML
		set oXML = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")	'xmlHTTP컨퍼넌트 선언
		oXML.open "POST", "http://ad.focusm.kr/receive/event/tenByTen.php", false
		oXML.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
		oXML.send "eventType=21&transactionId=" & transactionId & "&mediaCode=" & mediaCode & "&adCode=" & adCode & "&gadid=" & gadid & "&numOfItem=" & numOfItem
		'통신 결과 출력
		if oXML.status=200 then
			dim oRstJS, rstCd
			set oRstJS = JSON.parse(oXML.responseText)
			rstCd = oRstJS.result
			set oRstJS = Nothing

			'상태값 저장(Status - 0:대기, 1:주문완료, 2:배송완료, 8:주문정보 전송오류, 9:배송정보 전송오류)
			strSql = "UPDATE db_temp.dbo.tbl_focusm_orderInfo SET status=" & chkIIF(cStr(rstCd)="1","1","8") & " where orderserial='" & orderserial & "' and itemid='" & itemid & "'"
			dbget.execute(strSql)
		end if

		Set oXML = Nothing	'컨퍼넌트 해제

	end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->