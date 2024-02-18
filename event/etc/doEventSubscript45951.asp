<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.contentType = "text/html; charset=UTF-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
	dim sqlStr, loginid, evt_code, evt_option,couponcode 
	Dim mytotsum , arrList , i , sub_opt1 , sub_opt3
	Dim num1 , num2 , num3 , num4 , totnum , per1 , per2 , per3 , per4
	evt_code = requestCheckVar(Request("evt_code"),32)		'이벤트 코드
	loginid = GetLoginUserID()
	sub_opt1 = requestCheckVar(Request("holjjak"),1)

	'// 유효 접근 주소 검사 //
	dim refer
	refer = request.ServerVariables("HTTP_REFERER")

	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "잘못된 접속입니다."
		response.end
	end if

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

	'// 로그인 여부 확인 //
	if loginid="" or isNull(loginid) then
		Response.Write	"<script language='javascript'>" &_
						"alert('이벤트에 응모를 하려면 로그인이 필요합니다.');" &_
						"top.location.href='/login/login.asp?backpath=" & RefURLQ() & "';" &_
						"</script>"
		dbget.close()	:	response.End
	end if

	'응모 처리
	'중복 응모 확인
	Dim cnt
	sqlStr = "Select count(sub_idx) " &_
			" From db_event.dbo.tbl_event_subscript " &_
			" WHERE evt_code='" & evt_code & "'" &_
			" and userid='" & loginid & "' and convert(varchar(10),regdate,120) = '" &  Left(now(),10) & "'"
	rsget.Open sqlStr,dbget,1
	cnt = rsget(0)
	rsget.Close

	If cnt >= 1 Then '오늘 응모 끝
%>
	<div style="display:none;" id="rtresult" value="9"></div>
	<div style="display:none;" id="rtresult2" value="5"></div>
<%
	Else
		'// 당첨 확율에 따라 결과 지정
		Dim rndPt, przNo ,lmtCnt , bpoint
		Dim resultcnt  :  resultcnt = 500 '100마일리지
		Dim resultcnt2 : resultcnt2 = 100 '300마일리지
		randomize
		rndPt=int(Rnd*100)+1 '확률 1/100

		If rndPt < 26 Then '25% 
			If rndPt < 5 Then '300마일리지
				przNo = 3
				lmtCnt	=	100
				bpoint	=	300
			Else '100마일리지
				przNo = 1
				lmtCnt	=	500
				bpoint	=	100
			End If 
		Else
			przNo = 9 '꽝
		End If 

		'// 결과 저장
		sqlStr = "Insert into db_event.dbo.tbl_event_subscript " &_
				" (evt_code, userid, sub_opt2) values " &_
				" (" & evt_code &_
				",'" & loginid & "'" &_
				",'" & przNo & "'" &_
				" )"
		dbget.execute(sqlStr)

		If przNo =  1 Or przNo =  3 Then '100마일리지 혹은 300마일리지 당첨일때 
			'// 제한수 확인 (제한보다 많으면 꽝!)
			sqlStr = "Select count(sub_idx) " &_
					" From db_event.dbo.tbl_event_subscript " &_
					" WHERE evt_code='" & evt_code & "'" &_
					" and sub_opt2='" & przNo & "'"
			rsget.Open sqlStr,dbget,1
			cnt = rsget(0)
			rsget.Close

			If cnt >= lmtCnt Then
				przNo = 9 '꽝
				'//당첨이지만 꽝처리 일경우
				If sub_opt1 = 1 Then '홀일경우
					response.write "<div style=""display:none;"" id=""rtresult"" value=""2""></div>"
					response.write "<div style=""display:none;"" id=""rtresult2"" value=""9""></div>"
				Else '짝일경우
					response.write "<div style=""display:none;"" id=""rtresult"" value=""1""></div>"
					response.write "<div style=""display:none;"" id=""rtresult2"" value=""9""></div>"
				End If 
			Else
				Dim strSql
				strSql = " insert into [db_user].[dbo].[tbl_mileagelog] (userid,mileage,jukyocd,jukyo,deleteyn) " &_
					" values ('" & loginid & "'," & bpoint & ",'1000','12주년 이벤트 홀,짝','N');" & vbCrLf &_
					"update  [db_user].[dbo].tbl_user_current_mileage " &_
					"set bonusmileage=bonusmileage + " & bpoint &_
					" , lastupdate = getdate() " &_
					"Where userid='" & loginid & "'"
				dbget.execute(strSql)
				
				'//당첨일때
				response.write "<div style=""display:none;"" id=""rtresult"" value="&sub_opt1&"></div>"
				response.write "<div style=""display:none;"" id=""rtresult2"" value="&przNo&"></div>"
			End If 
		Else'비당첨일때
			If sub_opt1 = 1 Then '홀일경우
				response.write "<div style=""display:none;"" id=""rtresult"" value=""2""></div>"
				response.write "<div style=""display:none;"" id=""rtresult2"" value=""9""></div>"
			Else '짝일경우
				response.write "<div style=""display:none;"" id=""rtresult"" value=""1""></div>"
				response.write "<div style=""display:none;"" id=""rtresult2"" value=""9""></div>"
			End If 
		End if
	End If 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->