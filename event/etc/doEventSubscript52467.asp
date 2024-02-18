<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 내가 꿈꾸던 로망이 있는 집
' History : 2014.06.09 원승현 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
dim eCode, userid, sqlstr, subscriptcount, evtOpt, i, intLoop, QuizGubun, ePageSt, refer, mode, murl, productName, votecode, eCUrl, vsql, vVotechk , getnowdate
	mode = requestcheckvar(request("mode"),32)
	votecode = requestcheckvar(request("votecode"),32)
	userid = getloginuserid()

	
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  21198
		eCUrl = 21198
	Else
		eCode   =  52467
		eCUrl = 52467
	End If

	vsql = " Select top 1 sub_opt1, sub_opt3, userid From db_event.dbo.tbl_event_subscript Where evt_code='"&eCode&"' And userid='"&userid&"' And convert(varchar(10), regdate, 120) = '"&Left(Now(), 10)&"' "
	rsget.Open vsql,dbget
	IF not rsget.EOF THEN
		vVotechk = True
	else
		vVotechk = False
	END IF
	rsget.close

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/event/eventmain.asp?eventid="&eCUrl&"'</script>"
	dbget.close() : Response.End
End IF

if mode="vote" then
	if votecode="" then
		Response.Write "<script type='text/javascript'>alert('꼭 갖고 싶은 인테리어 상품 하나를 선택해 주세요!'); parent.top.location.href='/event/eventmain.asp?eventid="&eCUrl&"'</script>"
		dbget.close() : Response.End
	end If
	
	if vVotechk then
		Response.Write "<script type='text/javascript'>alert('투표는 1일 1회만 가능합니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCUrl&"'</script>"
		dbget.close() : Response.End
	end if

	dim tmpSelIid, vFidx, myfavorite

	'// 이벤트 기간 확인 //
	vsql = "Select evt_startdate, evt_enddate " &VBCRLF
	vsql = vsql & " From db_event.dbo.tbl_event " &VBCRLF
	vsql = vsql & " WHERE evt_code='" & eCode & "'"
	rsget.Open vsql,dbget,1
	if rsget.EOF or rsget.BOF then
		Response.Write	"<script language='javascript'>" &_
						"alert('존재하지 않는 이벤트입니다.');" &_
						"</script>"
		dbget.close()	:	response.End
	elseif date<rsget("evt_startdate") or date>rsget("evt_enddate") then
		Response.Write	"<script language='javascript'>" &_
						"alert('죄송합니다. 이벤트 기간이 아닙니다.');" &_
						"top.location.href='/event/eventmain.asp?eventid="& eCode &"';" &_
						"</script>"
		dbget.close()	:	response.End
	end if
	rsget.Close
	
	Select Case Trim(votecode)
		Case "311343"
			productName = "자작나무숲2"
		
		Case "558283"
			productName = "환상의달빛"

		Case "782102"
			productName = "런던트립"
		
		Case "587856"
			productName = "심플리펜던트"

		Case "420853"
			productName = "LED우든클락"
		
		Case "319713"
			productName = "노엘컬러4단선반"

		Case "1073599"
			productName = "바람꽃인견카페트아쿠아블루"

		Case "570780"
			productName = "스윙테이블"
		
		Case "1065338"
			productName = "원목사다리선반행거"

		Case Else
			productName = ""

	End Select

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3 , device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"&votecode&"', 0, '"&productName&"' , 'M')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr


	Response.Write "<script type='text/javascript'>alert('투표가 완료 되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCUrl&"'</script>"
	dbget.close() : Response.End	
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCUrl&"'</script>"
	dbget.close() : Response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->