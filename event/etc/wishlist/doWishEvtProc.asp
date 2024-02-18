<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'#######################################################
'	History	:  2018-11-02 최종원 생성
'	Description : 위시리스트 이벤트 위시폴더 추가
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<%
'조회수 증가
dim idx, sqlStr
idx = request("idx")

if idx <> "" then
	sqlStr = ""
	sqlstr = "update DB_TEMP.DBO.tbl_wish_event_userfolder set viewcnt = viewcnt + 1 where idx = "&idx & vbCrlf	
	dbget.execute sqlstr
	
	dbget.close()	:	response.End		
end if
%>
<%
dim eCode, userid, currenttime, i , vreturnurl , todayCount , vsqlstr , itemcnt, selfidx	

	vreturnurl		= requestCheckvar(request("returnurl"),1024)
	selfidx			= request("selfidx")

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  "89181"
	Else
		eCode   =  "90144"
	End If	

	currenttime = now()

	userid  		= getEncLoginUserID

	dim refer
		refer = request.ServerVariables("HTTP_REFERER")
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "<script>alert('잘못된 접속입니다.');parent.location.href='"&vreturnurl&"';</script>"
		dbget.close() : Response.End
	end If


	If userid = "" Then
		Response.Write "<script>alert('로그인을 해주세요');parent.location.href='"&vreturnurl&"';</script>"
		dbget.close() : Response.End
	End IF

	If not( left(currenttime,10)>="2018-11-02" and left(currenttime,10)<="2018-11-11" ) Then
		Response.Write "<script>alert('이벤트 응모기간이 아닙니다.');parent.location.href='"&vreturnurl&"';</script>"
		dbget.close() : Response.End
	End IF

	'//참여 체크
	vsqlstr = "Select COUNT(idx) From DB_TEMP.DBO.tbl_wish_event_userfolder WHERE userid='" & userid & "'"
	'response.write vsqlstr
	rsget.Open vsqlstr,dbget,1
	IF Not rsget.Eof Then
		todayCount = rsget(0)
	else
		todayCount = 0
	END IF
	rsget.Close

	if todayCount>0 and userid <> "cjw0515" Then
		Response.Write "<script>alert('이미 참여하셨습니다.');parent.location.href='"&vreturnurl&"';</script>"		''이미  참여함
		dbget.close() : Response.End
	end If

	vsqlstr = "INSERT INTO DB_TEMP.DBO.tbl_wish_event_userfolder(fidx, userid, viewcnt, evt_code)" + vbcrlf	
	vsqlstr = vsqlstr & " VALUES(" & selfidx & ", '" & userid & "', 0, "& eCode &")" + vbcrlf

	'response.write vsqlstr & "<Br>"
	dbget.execute vsqlstr

	Response.Write "<script>alert('위시폴더가 추가되었습니다.');parent.location.replace('"&vreturnurl&"&pagereload=ON');</script>"
	dbget.close() : Response.End	
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->