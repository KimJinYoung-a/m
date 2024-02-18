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
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim eCode, userid, currenttime, i , stype , vreturnurl , todayCount , itemid , device , vsqlstr , itemcnt

	stype    		= requestCheckvar(request("hidM"),1)
	itemid    		= requestCheckvar(request("itemid"),20)
	vreturnurl		= requestCheckvar(request("returnurl"),1024)

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  "66282"
	Else
		eCode   =  "76291"
	End If
	
	If isapp then
		device = "A"
	Else
		device = "M"
	End If 

	currenttime = now()

	userid = GetEncLoginUserID()

	'// 날짜 구분 없을때 구분값
	function dategubun(v)
		Select Case CStr(v)
			Case "2017-02-22"
				dategubun = "1"
			Case "2017-02-23"
				dategubun = "2"
			Case "2017-02-24"
				dategubun = "3"
			Case "2017-02-25"
				dategubun = "4"
			Case "2017-02-26"
				dategubun = "5"
			Case "2017-02-27"
				dategubun = "6"
			Case "2017-02-28"
				dategubun = "7"
			Case Else
				dategubun = "1"
		end Select
	end function

	dim refer
		refer = request.ServerVariables("HTTP_REFERER")
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "<script>alert('잘못된 접속입니다.');parent.location.href='"&vreturnurl&"';</script>"
		dbget.close() : Response.End
	end If

	if stype="I" then
		If userid = "" Then
			Response.Write "<script>alert('로그인을 해주세요');parent.location.href='"&vreturnurl&"';</script>"
			dbget.close() : Response.End
		End IF

		If not( left(currenttime,10)>="2017-02-22" and left(currenttime,10)<="2017-02-28" ) Then
			Response.Write "<script>alert('이벤트 응모기간이 아닙니다.');parent.location.href='"&vreturnurl&"';</script>"
			dbget.close() : Response.End
		End IF

		'//참여 체크
		vsqlstr = "Select COUNT(idx) From db_temp.dbo.tbl_event_itemwish WHERE userid='" & userid & "' and gubun = '"& dategubun(Date()) &"' "
		'response.write vsqlstr
		rsget.Open vsqlstr,dbget,1
		IF Not rsget.Eof Then
			todayCount = rsget(0)
		else
			todayCount = 0
		END IF
		rsget.Close

		if todayCount>4 Then
			Response.Write "<script>alert('한 ID당 하루 최대 5개의 상품을 등록하실 수 있습니다.');parent.location.href='"&vreturnurl&"';</script>"		''이미  참여함
			dbget.close() : Response.End
		end If

		'//참여 체크
		vsqlstr = "Select COUNT(idx) From db_temp.dbo.tbl_event_itemwish WHERE userid='" & userid & "' and gubun = '"& dategubun(Date()) &"' and itemid = '"& itemid &"' "
		'response.write vsqlstr
		rsget.Open vsqlstr,dbget,1
		IF Not rsget.Eof Then
			itemcnt = rsget(0)
		else
			itemcnt = 0
		END IF
		rsget.Close

		if itemcnt>0 Then
			Response.Write "<script>alert('동일한 상품을 2번 이상 등록하실 수 없습니다.');parent.location.href='"&vreturnurl&"';</script>"		''이미  참여함
			dbget.close() : Response.End
		end If

		vsqlstr = "INSERT INTO db_temp.dbo.tbl_event_itemwish(evt_code, itemid, gubun, userid, device)" + vbcrlf
		vsqlstr = vsqlstr & " VALUES("& eCode &", " & itemid & ", '"& dategubun(Date()) &"' ,'" & userid & "', '" & device & "')" + vbcrlf

		'response.write vsqlstr & "<Br>"
		dbget.execute vsqlstr

		Response.Write "<script>alert('응모가 완료 되었습니다.');parent.location.href='"&vreturnurl&"&gubun="& dategubun(Date()) &"';</script>"
		dbget.close() : Response.End
	Else
		Response.Write "<script>alert('정삭정인 경로가 아닙니다.');parent.location.href='"&vreturnurl&"';</script>"
		dbget.close() : Response.End
	end If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->