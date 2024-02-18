<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
'	Description : 이메일 인증
'	History	:  2014.01.08 한용민 생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #INCLUDE Virtual="/lib/email/maillib2.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
'// 유효 접근 주소 검사 //
dim refer
refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	response.write "<script type='text/javascript'>alert('유효하지 못한 접근입니다.');</script>'"	'--유효하지 못한 접근
	dbget.close(): response.End
end if

' -------------------------------------------------
'  아이디를 받아 유효한 정보인지 확인 후 메일 발송
' -------------------------------------------------
dim txUserId, txUsermail, chkStat, joinDt, CnfIdx, CnfDate, sqlStr
dim sRUrl, dExp

	txUserId = requestCheckVar(Request("id"),32)		' 사용자 아이디 입력 받음
	txUsermail = requestCheckVar(Request("mail"),128)	' 사용자 이메일 입력 받음

	If txUserId="" Then 
		response.write "<script type='text/javascript'>alert('잘못된 접근입니다.');</script>'"
		dbget.close(): response.End
	end if

	'// 회원 여부 확인
	sqlStr = "Select userStat, regdate From db_user.dbo.tbl_user_n Where userid='" & txUserid & "'"
	rsget.Open sqlStr,dbget,1
	if Not(rsget.EOF or rsget.BOF) then
		chkStat = rsget("userStat")
		joinDt = rsget("regdate")
	end if
	rsget.close

	if joinDt="" or (chkStat="N" and datediff("h",joinDt,now())>12) then
		'# 회원정보 없음(또는 유효기간 종료 고객)
		response.write "<script type='text/javascript'>alert('회원 정보가 존재하지 않습니다.');</script>'"
		dbget.close(): response.End
	end if

	'# 연속발송 제한 확인 (6시간동안 5회까지만 허용;이메일,휴대폰 총발송수)
	Dim chkSendCnt
	sqlStr = "Select count(*) From db_log.dbo.tbl_userConfirm Where userid='" & txUserid & "' and datediff(hh,regdate,getdate())<6 "
	rsget.Open sqlStr,dbget,1
	if Not(rsget.EOF or rsget.BOF) then
		chkSendCnt = rsget(0)
	end if
	rsget.close

	if chkSendCnt>5 then
		response.write "<script type='text/javascript'>alert('단기간에 많은 인증요청으로 더이상 인증을 할 수 없습니다.\n잠시 후 다시 시도해주세요.');</script>'"
		dbget.close(): response.End
	end if

	'# 유효 인증 대기값이 있는지 확인
	sqlStr = "Select top 1 idx, regdate From db_log.dbo.tbl_userConfirm Where userid='" & txUserid & "' and confDiv='E' and isConfirm='N' and datediff(hh,regdate,getdate())<12 order by idx desc "
	rsget.Open sqlStr,dbget,1
	if Not(rsget.EOF or rsget.BOF) then
		CnfIdx = rsget("idx")
		CnfDate = rsget("regdate")
	end if
	rsget.close

	if CnfIdx<>"" then
		'// 재발송

		'# 인증확인 URL
		sRUrl = wwwUrl & "/my10x10/userInfo/doEmailConfirm.asp?strkey=" & server.URLEncode(tenEnc(txuserid & "||" & CnfIdx))
		'# 인증 종료일
		dExp = cStr(dateadd("h",12,CnfDate))
		'# 인증 메일 발송
		Call SendMailReConfirm(txUsermail,txuserid,dExp,sRUrl)
	else
		'//신규발송
		'# 인증 로그에 저장
		On Error Resume Next
		dbget.beginTrans

		sqlStr = "insert into db_log.dbo.tbl_userConfirm (userid, confDiv, usermail, pFlag, evtFlag) values ("
		sqlStr = sqlStr + " '" & txuserid & "'"
		sqlStr = sqlStr + " ,'E'"
		sqlStr = sqlStr + " ,'" & txUsermail & "'"
		sqlStr = sqlStr + " ,'T','N'"
		sqlStr = sqlStr + " )"
		dbget.execute(sqlStr)
		
		sqlStr = "Select IDENT_CURRENT('db_log.dbo.tbl_userConfirm') as maxIdx "
		rsget.Open sqlStr,dbget,1
			CnfIdx = rsget("maxIdx")
		rsget.close

		If Err.Number = 0 Then
		        '// 처리 완료
		        dbget.CommitTrans
		Else
		        '//오류가 발생했으므로 롤백
		        dbget.RollBackTrans
				response.write "<script type='text/javascript'>alert('처리중 오류가 발생했습니다.');</script>'"
				dbget.close(): response.End
		End If
		on error Goto 0

		'# 인증확인 URL
		sRUrl = wwwUrl & "/my10x10/userInfo/doEmailConfirm.asp?strkey=" & server.URLEncode(tenEnc(txuserid & "||" & CnfIdx))
		'# 인증 종료일
		dExp = cStr(dateadd("h",12,now()))
		'# 인증 메일 발송
		Call SendMailReConfirm(txUsermail,txuserid,dExp,sRUrl)
	end if
%>

<div class="layerPopup">
	<div class="popWin">
		<div class="header">
			<h1>이메일 인증하기</h1>
			<p class="btnPopClose"><button type="button" class="pButton" onclick="fnCloseModal();">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content certPhone" id="layerScroll">
			<div id="scrollarea">
				<div class="inner5 tMar15">
					<div class="box1">
						<span class="userNum"><%=txUsermail%></span>
						<p class="t01">위 메일로 인증번호를 발송하였습니다.<br /><span class="cRd1">12시간 안에 꼭 확인해주세요!</span></p>
						<p class="t03">가입승인 시간 내에 승인을 하지 않으시면<br />인증이 취소됩니다. 인증메일이 도착하지 않았을 경우<br />팝업창을 닫고 &quot;이메일 인증하기&quot; 버튼을 클릭하시면<br />다시 메일을 받으실 수 있습니다.</p>
					</div>
				</div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>

<!-- #include virtual="/lib/db/dbclose.asp" -->