<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : GS25 NFC 응모 전송 처리
' History : 2014.07.24 허진원 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/rndSerial.asp" -->
<%
	Dim vUuid, vName, vHp1, vHp2, vHp3, vHP, vUidx
	Dim chkErr, sqlStr, chkDiv
	chkErr = False
	chkDiv = "1"		'1:우유당첨, 2:텐텐쿠폰

	vUuid = requestcheckvar(request("uuid"),40)
	vName = requestcheckvar(request("vname"),32)
	vHp1 = getNumeric(requestcheckvar(request("vhp1"),4))
	vHp2 = getNumeric(requestcheckvar(request("vhp2"),4))
	vHp3 = getNumeric(requestcheckvar(request("vhp3"),4))
	vHP = vHp1 & "-" & vHp2 & "-" & vHp3

	if vUuid="" then chkErr=True
	if vName="" then chkErr=True
	if vHp1="" then chkErr=True
	if vHp2="" then chkErr=True
	if vHp3="" then chkErr=True

	if chkErr then
		Call Alert_return("파라메터 오류입니다.")
		dbget.close() : Response.End
	end if

	if now<cdate("2014-08-01") then
		chkDiv = "2"
		Call Alert_return("2014년 8월 1일부터 참여하실 수 있습니다.")
		dbget.close() : Response.End
	end if

	'// 8월 1일 9시 이전에는 쿠폰만 지급
	if now<cdate("2014-08-01 09:00:00") then
		chkDiv = "2"
	end if

	if date>="2014-09-01" then
		Call Alert_return("죄송합니다. 종료된 이벤트 입니다.")
		dbget.close() : Response.End
	end if

	''on Error Resume Next

	'발급 여부 확인(참여 완료고객; stat- 0:등록대기, 1:참여완료, 2:중복참여)
	sqlStr = "Select count(idx) as cnt From db_temp.dbo.tbl_gs25nfcInfo where UUID='" & vUuid & "' and stat='1'"
	rsget.Open sqlStr,dbget,1
	if rsget("cnt")>0 then
		Call Alert_return("이미 이벤트에 참여하셨습니다.\n한 기기당 1회만 참여하실 수 있습니다.")
		rsget.Close(): dbget.close() : Response.End
	end if
	rsget.Close

	'휴대폰 번호당 발급 여부 확인
	sqlStr = "Select count(idx) as cnt From db_temp.dbo.tbl_gs25nfcInfo where hp='" & vHP & "' and stat='1'"
	rsget.Open sqlStr,dbget,1
	if rsget("cnt")>0 then
		Call Alert_return("이미 이벤트에 참여하셨습니다.\n한 개의 휴대폰 번호 당 1회만 참여하실 수 있습니다.")
		rsget.Close(): dbget.close() : Response.End
	end if
	rsget.Close

	'// UUID 등록 (및 정보 업데이트)
	sqlStr = "IF Not EXISTS(Select idx from db_temp.dbo.tbl_gs25nfcInfo where UUID='" & vUuid & "') " & vbCrLf
	sqlStr = sqlStr & "begin " & vbCrLf
	sqlStr = sqlStr & "	Insert Into db_temp.dbo.tbl_gs25nfcInfo (UUID,name,hp,stat,div) values ('" & vUuid & "','" & vName & "','" & vHP & "','0','N') " & vbCrLf
	sqlStr = sqlStr & "end " & vbCrLf
	sqlStr = sqlStr & " ELSE " & vbCrLf
	sqlStr = sqlStr & "begin " & vbCrLf
	sqlStr = sqlStr & " update db_temp.dbo.tbl_gs25nfcInfo " & vbCrLf
    sqlStr = sqlStr & "	set name='" & vName & "', hp='" & vHP & "' " & vbCrLf
    sqlStr = sqlStr & "	Where UUID='" & vUuid & "' " & vbCrLf
    sqlStr = sqlStr & "end"
	dbget.Execute(sqlStr)

	'// UUID 일련번호 접수
	sqlStr = "Select idx From db_temp.dbo.tbl_gs25nfcInfo where UUID='" & vUuid & "'"
	rsget.Open sqlStr,dbget,1
	if Not(rsget.EOF or rsget.BOF) then
		vUidx = rsget("idx")
	end if
	rsget.Close

	if vUidx="" then
		Call Alert_return("처리중 오류가 발생했습니다.(1)")
		dbget.close() : Response.End
	end if

	'// 바나나맛 우유 당첨 하루 제한량 검사
	'작일 09시~금일 09시까지 발행된 수 확인
	dim chkLimit: chkLimit = 0
	sqlStr = "Select count(*) as cnt "
	sqlStr = sqlStr & "from db_temp.dbo.tbl_gs25nfcInfo "
	sqlStr = sqlStr & "where stat='1' and div='G' "
	sqlStr = sqlStr & "	and datediff(d,dateadd(hh,-9,lastUpdate),dateadd(hh,-9,getdate()))=0 "
	rsget.Open sqlStr,dbget,1
	if Not(rsget.EOF or rsget.BOF) then
		chkLimit = rsget("cnt")
	end if
	rsget.Close

	'금일 150건 이상이면 - 텐바이텐 쿠폰으로 발급
	if chkLimit>=150 then
		chkDiv = "2"
	end if

'----------------------------

	'// SY커뮤니케이션 발급 처리 페이지로 이동 처리
	if chkDiv="1" then
%>
<script type="text/javascript">
parent.location.replace("http://gs25.mytory.kr/10x10/?ms=20140801&mn=<%=vHP%>&uid=<%=rdmSerialEnc(vUidx)%>");
</script>
<%	elseif chkDiv="2" then %>
<script type="text/javascript">
parent.location.replace("/apps/appcom/wish/webview/event/etc/gs25/resultinfo.asp?uid=<%=rdmSerialEnc(vUidx)%>&rst=2");
</script>
<%	end if %>
<!-- #include virtual="/lib/db/dbclose.asp" -->