<% option Explicit %>
<%
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
	Dim renloop, renloop2
	randomize
	renloop=int(Rnd*1000)+1 '100%

'	randomize
'// 이번 이니스프리 이벤트는 쿠폰이 한종류라 무조건 1로 셋팅
	renloop2 = 1
'	renloop2=int(Rnd*2)+1   '1 or 2

	dim sqlStr, loginid, evt_code, releaseDate, evt_option, evt_option2, strsql, Linkevt_code
	Dim kit , coupon3 , coupon5 , arrList , i, mylist
	dim usermail, couponkey
	evt_code = requestCheckVar(Request("evt_code"),32)		'이벤트 코드
	Linkevt_code = requestCheckVar(Request("linkeventid"),32) '링크코드

	loginid = GetLoginUserID()
	releaseDate = requestCheckVar(Request("releaseDate"),42)
	couponkey = requestCheckVar(Request("couponkey"),42)
	if releaseDate = "" then releaseDate = "6월 20일"
	dim referer
	referer = request.ServerVariables("HTTP_REFERER")

	Dim dfDate, daysum, nowdate
	Function sDate()

	nowdate=now()
		Select Case left(nowdate,10)
			Case "2014-06-20"
				daysum=200
			Case "2014-06-21"
				daysum=150
			Case "2014-06-22"
				daysum=150
			Case "2014-06-23"
				daysum=120
			Case "2014-06-24"
				daysum=110
			Case "2014-06-25"
				daysum=90
			Case "2014-06-26"
				daysum=60
			Case "2014-06-27"
				daysum=50
			Case "2014-06-28"
				daysum=40
			Case "2014-06-29"
				daysum=30
		End Select

	End function

	'// 로그인 여부 확인 //
	if loginid="" or isNull(loginid) then
		Response.Write	"<script language='javascript'>" &_
						"alert('이벤트에 응모를 하려면 로그인이 필요합니다.');" &_
						"top.location.href='/login/login.asp?backpath=" & RefURLQ() & "';" &_
						"</script>"
		dbget.close()	:	response.End
	end If

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
						"top.location.href='/event/eventmain.asp?eventid="& Linkevt_code &"';" &_
						"</script>"
		dbget.close()	:	response.End
	end if
	rsget.Close

	'// 0.1% 당첨확률
	If renloop < 2 Then
			call sDate()
			If daysum="" Then daysum="50"
			dim kitsum , mykitcnt , totsum
			sqlstr= "select count(case when sub_opt2 = '3' and convert(varchar(10),regdate,120) = '" & left(Now(),10) & "' then sub_opt2 end) as kitsum  " &_
				" ,count(case when sub_opt2 = '3' and userid = '" & loginid & "' then sub_opt2 end ) as mykitcnt  " &_
				" ,count(case when sub_opt2 = '3' then sub_opt2 end) as totsum  " &_
				" FROM db_event.dbo.tbl_event_subscript " &_
				" where evt_code='" & evt_code &"' "

			rsget.Open sqlStr,dbget,1
			kitsum = rsget(0)
			mykitcnt = rsget(1)
			totsum	= rsget(2)
			rsget.Close

			If totsum >= 1000 Then
				evt_option2 = renloop2
			else
				If mykitcnt > 0 Then
					evt_option2 = renloop2
				Else
					If kitsum >= daysum Then
						evt_option2 = renloop2
					Else
						evt_option2 = "3" 'kit
					End If
				End If
			End If
	Else
		evt_option2 = "1" '4000 coupon
	End If

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

	If cnt >= 1 Then
	response.write "<script type='text/javascript'>" &_
					"alert('하루 1회만 응모 가능합니다.\n\n내일 다시 응모해주세요. :)');" &_
					"top.location.href='/event/eventmain.asp?eventid=" & Linkevt_code& "';" &_
					"</script>"

	else
		'이벤트 정상응모
		If evt_option2 ="1" Then				'4000쿠폰일 경우

			Dim objCmd , returnValue
			Set objCmd = Server.CreateObject("ADODB.COMMAND")

			With objCmd
				.ActiveConnection = dbget
				.CommandType = adCmdText
				.CommandText = "{?= call [db_temp].[dbo].[sp_Ten_event_innisfree_2014]("&evt_option2&","&evt_code&",'"&loginid&"','M')}"
				.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
				.Execute, , adExecuteNoRecords
				End With	
				returnValue = objCmd(0).Value		    
			
			Set objCmd = Nothing	

			If returnValue = 0 then
				response.write "<script type='text/javascript'>" &_
						"alert('쿠폰이 모두 소진되었습니다');" &_
						"top.location.href='/event/eventmain.asp?eventid="&Linkevt_code&"';" &_
						"</script>"
				dbget.close()	:	response.End
			End if 

			sqlStr= "select top 1 b.usermail, c.couponkey from db_event.dbo.tbl_event_subscript as a" &_
			        " join db_user.dbo.tbl_user_n as b" &_
			        " on a.userid = b.userid " &_
			        " join db_temp.dbo.tbl_innisfree_coupon_2014 as c " &_
			        " on a.sub_opt1 = c.idx " &_
			        " where a.evt_code='" & evt_code & "' and a.userid='" & loginid & "'" &_
			        " order by sub_idx desc"

	        rsget.Open sqlStr,dbget,1
			usermail = rsget(0)
			couponkey = rsget(1)
			rsget.Close
			call SendMailCoupon(usermail,couponkey)
				Dim msg
				response.write "<script type='text/javascript'>" &_
					"alert('축하합니다!\n이니스프리 할인쿠폰에 당첨되셨습니다.\n내일 또 도전해주세요! :)');" &_
					"top.location.href='/event/eventmain.asp?eventid=" & Linkevt_code& "';" &_
					"</script>"
				dbget.close()	:	response.End

		else														'키트 당첨
			sqlStr = "Insert into db_event.dbo.tbl_event_subscript " &_
					" (evt_code, userid, sub_opt2, device) values " &_
					" (" & evt_code &_
					",'" & loginid & "'" &_
					",'" & evt_option2 & "'" &_
					",'M')"
					'response.write sqlstr
			dbget.execute(sqlStr)
				response.write "<script type='text/javascript'>" &_
					"alert('축하합니다!\nLETS PLAY여행패키지에 당첨되셨습니다.\n내일 또 도전해주세요! :)');" &_
					"top.location.href='/event/eventmain.asp?eventid=" & Linkevt_code& "';" &_
					"</script>"
				dbget.close()	:	response.End
		End If
		'response.redirect referer
	End If


function SendMailCoupon(usermail,couponkey)
        dim mailfrom,mailto, mailtitle, mailcontent,dirPath,fileName, i, conMailContent
        dim fs,objFile


		conMailContent = "안녕하세요, 텐바이텐입니다.<p>"
		conMailContent = conMailContent & " 텐바이텐과 이니스프리가 함께 하는<br>"
		conMailContent = conMailContent & " [Let's PLAY] 이벤트 당첨을 축하드립니다.<p><br>"
		conMailContent = conMailContent & " 이니스프리 4,000원 쿠폰에 당첨되셨습니다.<br>"
		conMailContent = conMailContent & " 쿠폰번호 : "&couponkey&"<p><br>"
		conMailContent = conMailContent & " 이니스프리 온라인 쿠폰 사용방법은 다음과 같습니다.<p>"
		conMailContent = conMailContent & " 1. 이니스프리 온라인 홈페이지(<a href='http://www.innisfree.co.kr' target=_blank>www.innisfree.co.kr</a>) 로그인<br>"
		conMailContent = conMailContent & " 2. 마이 페이지 -> 내 보유 쿠폰<br>"
		conMailContent = conMailContent & " 3. 쿠폰 등록 및 교환 (모바일:쿠폰 등록)-> Let's Play 쿠폰 선택<br>"
		conMailContent = conMailContent & " 4. 쿠폰번호 입력하여 발급받기<p><br>"
		conMailContent = conMailContent & " - 당첨된 이니스프리 할인 쿠폰은 이니스프리 온라인 쇼핑몰에서만 로그인 후 사용 가능합니다.<br>"
		conMailContent = conMailContent & " - 본 쿠폰은 유효기간이 있으며, 타 쿠폰과 중복 사용 또는 오프라인 매장에서는 사용 불가합니다.<br>"
		conMailContent = conMailContent & " - 3만원 이상 구매 시 사용 가능하고, 일부 상품은 사용에 제한이 있을 수 있습니다.<br>"
		conMailContent = conMailContent & " - 쿠폰 사용 기간 2014년 7월 20일까지 사용 가능<p><br>"
		conMailContent = conMailContent & " 텐바이텐 x 이니스프리와 함께 즐거운 여름 되시기 바랍니다.<br>"
		conMailContent = conMailContent & " 감사합니다! :)"

        mailfrom = "텐바이텐<customer@10x10.co.kr>"
        mailtitle = "[텐바이텐] 이벤트 당첨을 축하 드립니다. "
        mailto= usermail

        Set fs = Server.CreateObject("Scripting.FileSystemObject")
        dirPath = server.mappath("/event/etc")
        fileName = dirPath&"\innisfree_mail52552.htm"
        Set objFile = fs.OpenTextFile(fileName,1)
        mailcontent = objFile.readall
       	mailcontent = replace(mailcontent,":CONTENTS:",conMailContent)
        call sendmail(mailfrom, mailto, mailtitle, mailcontent)
        ''SendMailNewUser = mailcontent
end function


sub SendMail(mailfrom, mailto, mailtitle, mailcontent)

		dim cdoMessage,cdoConfig

On Error Resume Next

		Set cdoConfig = CreateObject("CDO.Configuration")

		'-> 서버 접근방법을 설정합니다
		cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2 '1 - (cdoSendUsingPickUp)  2 - (cdoSendUsingPort)

		'-> 서버 주소를 설정합니다
		cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "110.93.128.94"

		'-> 접근할 포트번호를 설정합니다
		cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25

		'-> 접속시도할 제한시간을 설정합니다
		cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 10

		'-> SMTP 접속 인증방법을 설정합니다
		cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1

		'-> SMTP 서버에 인증할 ID를 입력합니다
		cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "MailSendUser"

		'-> SMTP 서버에 인증할 암호를 입력합니다
		cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "wjddlswjddls"

		cdoConfig.Fields.Update

		Set cdoMessage = CreateObject("CDO.Message")

		Set cdoMessage.Configuration = cdoConfig

		cdoMessage.To 				= mailto
		cdoMessage.From 			= mailfrom
		cdoMessage.SubJect 	= mailtitle
		'메일 내용이 텍스트일 경우 cdoMessage.TextBody, html일 경우 cdoMessage.HTMLBody
		cdoMessage.HTMLBody	= mailcontent

		cdoMessage.BodyPart.Charset="ks_c_5601-1987"         '/// 한글을 위해선 꼭 넣어 주어야 합니다.
        cdoMessage.HTMLBodyPart.Charset="ks_c_5601-1987"     '/// 한글을 위해선 꼭 넣어 주어야 합니다.

		cdoMessage.Send

		Set cdoMessage = nothing
		Set cdoConfig = nothing

On Error Goto 0
end sub
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->