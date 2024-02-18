<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.contentType = "text/html; charset=UTF-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/rndSerial.asp" -->
<%
	dim sqlStr, evt_code , uname , uphone
	Dim ccnt , invitecnt , temppin ,upin , returnpin
	Dim returnIdx , returnPhone
	Dim resultGo
	Dim idx ,uip
	Dim addr , przidx
	Dim iidx , zipcode , footsize 
	evt_code = requestCheckVar(Request("evt_code"),32)		'이벤트 코드
	uname = requestCheckVar(Request("uname"),20)		
	uphone = requestCheckVar(Request("uphone"),11)		
	upin = requestCheckVar(Request("upin"),200)		'1차 끌어온사람정보
	resultGo = requestCheckVar(Request("resultGo"),1)		' 당첨 로직
	zipcode = requestCheckVar(Request("zipcode"),7)		'당첨자 우편번호
	addr = requestCheckVar(Request("addr"),200)		'당첨자 주소
	przidx = requestCheckVar(Request("przidx"),10)		'당첨자idx
	iidx = requestCheckVar(Request("iidx"),10)		'당첨자idx
	footsize = requestCheckVar(Request("footsize"),1)		'발사이즈
	temppin = rdmSerialEnc(iidx)&","&rdmSerialEnc(uphone) 'url 인식코드

	If upin <> "" Then '보낸이 정보
		returnpin = Split(upin,",")
		returnIdx = rdmSerialDec(Trim(returnpin(0)))
		returnPhone =  rdmSerialDec(Trim(returnpin(1)))
	End If 

''	response.write evt_code &"<br>"
'	response.write uname &"<br>"
'	response.write uphone &"<br>"
'	response.write upin &"<br>"
'	response.write temppin &"<br>"
'	response.write returnIdx &"<br>"
'	response.write returnPhone &"<br>"
'	'response.end

	'// 이벤트 기간 확인 //
	sqlStr = "Select evt_startdate, evt_enddate " &_
			" From db_event.dbo.tbl_event " &_
			" WHERE evt_code='" & evt_code & "'"
	rsget.Open sqlStr,dbget,1
	if rsget.EOF or rsget.BOF then
		Response.Write	"<script language='javascript'>" &_
						"alert('존재하지 않는 이벤트입니다.');" &_
						"</script>"
		dbget.close()	:	response.End
	elseif date<rsget("evt_startdate") or date>rsget("evt_enddate") then
		Response.Write	"<script language='javascript'>" &_
						"alert('죄송합니다. 이벤트 기간이 아닙니다.');" &_
						"</script>"
		dbget.close()	:	response.End
	end if
	rsget.Close

	'// 누적 카운트
	sqlStr = "Select count(idx) " &_
		" From db_temp.dbo.kakao_invite " &_
		" WHERE evt_code='" & evt_code & "'" &_
		" and uname='" & uname & "' and uphone = '" &  uphone & "' and isusing = 'Y' "
	rsget.Open sqlStr,dbget,1
	ccnt = rsget(0)
	rsget.Close

	If ccnt = 10 Then
		Response.Write	"<script language='javascript'>" &_
						"alert('1인당 최대 10회까지만 이벤트 참여 하실 수 있습니다.');" &_
						"</script>"
		response.End
	End If 

	If resultGo = "B" Then '배송 시작

		sqlStr = "Select count(finidx) " &_
		" From db_temp.dbo.kakao_result " &_
		" WHERE evt_code='" & evt_code & "'" &_
		" and uname='"& uname &"' and uphone = '"& uphone &"' and okcode = 'N'  and inviteidx = "&przidx
		rsget.Open sqlStr,dbget,1
		cnt = rsget(0)
		rsget.Close

		If cnt > 0 then
			sqlStr = "update db_temp.dbo.kakao_result set okcode = 'Y' , address = '"& addr &"' , zipcode = '"& zipcode &"' , prizeopt1 = '"& footsize &"' where uname='"& uname &"' and uphone = '"& uphone &"' and inviteidx = "&przidx
			dbget.execute(sqlStr)
			Response.Write	"<script language='javascript'>" &_
						"alert('배송지 작성이 완료 되었습니다.');top.document.location.reload();" &_
						"</script>"
		End if

	ElseIf resultGo = "G" Then '즉석당첨 시작
		sqlStr = "Select top 1 idx " &_
		" From db_temp.dbo.kakao_invite " &_
		" WHERE evt_code='" & evt_code & "'" &_
		" and uname='"& uname &"' and uphone = '"& uphone &"' and isusing = 'N'  and invitecnt = 2 "

		rsget.Open sqlStr,dbget,1
		if rsget.EOF or rsget.BOF Then
		idx = 0
		Else 
		idx = rsget(0)
		End if
		rsget.Close

		'response.write idx &"--응모idx<br>"

		if idx = "0" Then
			Response.Write	"<script language='javascript'>" &_
						"alert('응모를 확인 해주세요.');" &_
						"parent.history.go(0);" &_
						"</script>"
			dbget.close()	:	response.End
		Else
			'// 당첨 확율에 따라 결과 지정
			Dim rndPt, przNo, przMsg, przStt, lmtCnt
			randomize
			rndPt=int(Rnd*5000)+1 '확률 1/5000

			if rndPt>0 and rndPt<=3 then
				'#락피쉬 오리지널 글로스 3
				przNo = 1
				lmtCnt = 3
			elseif rndPt>5 and rndPt<=100 then
				'#F-TROUPE 7
				przNo = 2
				lmtCnt = 7
			elseif rndPt>100 and rndPt<=200 then
				'#3단 수동 우산 20
				przNo = 3
				lmtCnt = 20
			elseIf rndPt>200 and rndPt<=800 Then
					If IsUserLoginOK and (rndPt > 400 And rndPt<=800) then
						przNo = 4
						lmtCnt = 120
					Elseif IsUserLoginOK Or rndPt <= 400 Then
						przNo = 4
						lmtCnt = 120
					else
						przNo = 9
						lmtCnt = 0
					End If 
			else
				'꽝
				przNo = 9
				lmtCnt = 0
			end If

			'// 제한수 확인 (제한보다 많으면 꽝!) '
			Dim cnt
			sqlStr = "Select count(finidx) " &_
					" From db_temp.dbo.kakao_result " &_
					" WHERE evt_code='" & evt_code & "'" &_
					" and prizecode='" & przNo & "' and okcode = 'Y' "
			rsget.Open sqlStr,dbget,1
			cnt = rsget(0)
			rsget.Close
	
			if cnt>=lmtCnt then
				przNo = 9 '초과하면 꽝처리 복불복
			end If

			'// 결과 저장
			sqlStr = "update db_temp.dbo.kakao_invite set isusing = 'Y' where uname='" & uname & "' and uphone = '" &  uphone & "' and  idx = "& idx &" "
'			response.write sqlStr
			dbget.execute(sqlStr)

			sqlStr = "Insert into db_temp.dbo.kakao_result " &_
					" (evt_code, inviteidx, uname, uphone, prizecode) values " &_
					" (" & evt_code &_
					"," & idx & "" &_
					",'" & uname & "'" &_
					",'" & uphone & "'" &_
					",'" & przNo & "')"
			'response.write sqlStr
			dbget.execute(sqlStr)

			'// 결과 표시
			Response.Write "<div id='przCode' value='"& przNo &"'></div>"
			Response.Write "<div id='przidx' value='"& idx &"'></div>"
			Response.End
		End if


	Else '응모하기가 아닌 일반
		If returnIdx <> "" And returnPhone <> "" Then '초대에응하기 일때
			sqlStr = "Select top 1 idx , invitecnt , uip " &_
					" From db_temp.dbo.kakao_invite " &_
					" WHERE evt_code='" & evt_code & "'" &_
					" and idx='" & returnIdx & "' and uphone = '" &  returnPhone & "' and isusing = 'N' "
			rsget.Open sqlStr,dbget,1
			if rsget.EOF or rsget.BOF Then
			idx = ""
			Else 
			idx = rsget(0)
			invitecnt = rsget(1)
			uip = rsget(2)
			End if
			rsget.Close

			If idx = "" Then '내역에 없을때
				Response.Write	"<script language='javascript'>" &_
							"if (confirm('당신을 초대한 친구가 목표 초대수(2명)를 이미 달성하였습니다.\n 이제 직접 이벤트에 참여해 <장마 대비 스페셜선물>에 도전하고 싶으면 아래의 확인 버튼을 누르세요.')){ top.document.location.href = 'http://m.10x10.co.kr/event/eventmain.asp?eventid="& evt_code &"'}else{ top.document.location.href = 'http://m.10x10.co.kr' 	} " &_
							"</script>"
				response.end	
			Else
				If uip = Request.ServerVariables("REMOTE_ADDR") Then '동일 ip접속시 튕김
					Response.Write	"<script language='javascript'>" &_
							"alert('동일 IP로 접속 하셨습니다.');" &_
							"</script>"
					response.end	
				End If 
				If invitecnt < 2 Then '2명이하일때 update
					sqlStr = "Select count(idx) " &_
						" From db_temp.dbo.kakao_invite " &_
						" WHERE evt_code='" & evt_code & "'" &_
						" and uname='" & uname & "' and uphone = '" &  uphone & "' and isusing = 'N' "
					rsget.Open sqlStr,dbget,1
					ccnt = rsget(0)
					rsget.Close
					If ccnt > 0 then
						Response.Write	"<script language='javascript'>" &_
							"alert('초대를 받은 사람이 초대를 한 친구를 \n 다시 초대할 수 없습니다.\n다른 친구를 초대해 주세요: )');" &_
							"</script>"
						response.end
					else
						sqlStr = "update db_temp.dbo.kakao_invite set invitecnt = "& invitecnt + 1 &" where idx = "& idx &" and uphone = '" &  returnPhone & "'  "
						dbget.execute(sqlStr)
						'초대한사람 카운트 update 후 본인 등록
						sqlStr = " insert into db_temp.dbo.kakao_invite "&_
									" (evt_code , uName , uPhone , uip , invitecnt , ridx) "&_
									" values "&_
									" ('"& evt_code &"' , '"& uname  &"' , '"& uphone &"' , '"& Request.ServerVariables("REMOTE_ADDR") &"' , 0 , "& idx &") "
						dbget.execute(sqlStr)
						sqlStr = "select @@identity" 
						rsget.Open sqlStr,dbget,1
						iidx = rsget(0)
						rsget.Close
						response.write "<div id='checkok' value='1' style='display:none;'></div>" '로그인ok 여부
						response.write "<div id='invitecnt' value='0' ></div>"  '카운트수 0명
						response.write "<div id='invitecode' value='"& rdmSerialEnc(iidx)&","&rdmSerialEnc(uphone) &"' ></div>"
						Response.Write	"<script language='javascript'>" &_
												"alert('친구의 초대에 응하셨네요!! ^^ \n 감사합니다! \n\n 이제 직접 이벤트에 참여하셔서 사첼백에 도전하세요~!');" &_
												"</script>"
					End If 
				Elseif invitecnt = 2 Then
					'// 초대 받은 사람이 이미 응모한 사람을 또 초대 했을경우
					sqlStr = "Select count(idx) " &_
						" From db_temp.dbo.kakao_invite " &_
						" WHERE evt_code='" & evt_code & "'" &_
						" and uname='" & uname & "' and uphone = '" &  uphone & "' and isusing = 'N' "
					rsget.Open sqlStr,dbget,1
					ccnt = rsget(0)
					rsget.Close
					If ccnt > 0 then
						Response.Write	"<script language='javascript'>" &_
							"alert('이미 등록하신 사용자 입니다.');" &_
							"</script>"
						response.end
					else
						sqlStr = " insert into db_temp.dbo.kakao_invite "&_
									" (evt_code , uName , uPhone , uip , invitecnt , ridx) "&_
									" values "&_
									" ('"& evt_code &"' , '"& uname  &"' , '"& uphone &"' , '"& Request.ServerVariables("REMOTE_ADDR") &"' , 0 , "& idx &" ) "
						dbget.execute(sqlStr)
						sqlStr = "select @@identity" 
						rsget.Open sqlStr,dbget,1
						iidx = rsget(0)
						rsget.Close
						response.write "<div id='checkok' value='1' style='display:none;'></div>" '로그인ok 여부
						response.write "<div id='invitecnt' value='0' ></div>"  '카운트수 0명
						response.write "<div id='invitecode' value='"& rdmSerialEnc(iidx)&","&rdmSerialEnc(uphone) &"' ></div>"
					End If 
				End If 
			End If 


		Else '그냥등록

			'분기 설정 '등록자 입력
			sqlStr = "Select count(idx) " &_
					" From db_temp.dbo.kakao_invite " &_
					" WHERE evt_code='" & evt_code & "'" &_
					" and uname='" & uname & "' and uphone = '" &  uphone & "' and isusing ='N' "
			rsget.Open sqlStr,dbget,1
			ccnt = rsget(0)
			rsget.Close
			
			'최초등록자
			If ccnt = 0 Then
				sqlStr = " insert into db_temp.dbo.kakao_invite "&_
							" (evt_code , uName , uPhone , uip , invitecnt ) "&_
							" values "&_
							" ('"& evt_code &"' , '"& uname  &"' , '"& uphone &"' , '"& Request.ServerVariables("REMOTE_ADDR") &"' , 0 ) "
				dbget.execute(sqlStr)
				sqlStr = "select @@identity" 
				rsget.Open sqlStr,dbget,1
				iidx = rsget(0)
				rsget.Close
				response.write "<div id='checkok' value='1' style='display:none;'></div>" '로그인ok 여부
				response.write "<div id='invitecnt' value='0' ></div>"  '카운트수 0명
				response.write "<div id='invitecode' value='"& rdmSerialEnc(iidx)&","&rdmSerialEnc(uphone) &"' ></div>" 
			ElseIf ccnt > 0 Then '등록후 로그인 추천인수 카운트
				sqlStr = "Select top 1 invitecnt ,idx " &_
					" From db_temp.dbo.kakao_invite " &_
					" WHERE evt_code='" & evt_code & "'" &_
					" and uname='" & uname & "' and uphone = '" &  uphone & "' and isusing ='N' "
				rsget.Open sqlStr,dbget,1
				invitecnt = rsget(0)
				iidx = rsget(1)
				rsget.Close
				response.write "<div id='invitecnt' value='"& invitecnt &"' ></div>"  '카운트수 0명
				response.write "<div id='invitecode' value='"& rdmSerialEnc(iidx)&","&rdmSerialEnc(uphone) &"' ></div>" 
			End If 
		End If 
End if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->