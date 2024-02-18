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

	randomize
	renloop2=int(Rnd*2)+1   '1 or 2

	dim sqlStr, loginid, evt_code, releaseDate, evt_option, evt_option2, strsql
	Dim kit , coupon3 , coupon5 , arrList , i, mylist
	dim usermail, couponkey
	evt_code = requestCheckVar(Request("evt_code"),32)		'이벤트 코드
	loginid = GetLoginUserID()
	releaseDate = requestCheckVar(Request("releaseDate"),42)
	couponkey = requestCheckVar(Request("couponkey"),42)
	if releaseDate = "" then releaseDate = "5월 30일"
	dim referer
	referer = request.ServerVariables("HTTP_REFERER")

	Dim dfDate, daysum, nowdate
	Function sDate()

	nowdate=now()
		Select Case left(nowdate,10)
			Case "2013-05-20"
				daysum=300	'575
			Case "2013-05-21"
				daysum=135
			Case "2013-05-22"
				daysum=120
			Case "2013-05-23"
				daysum=80
			Case "2013-05-24"
				daysum=40
			Case "2013-05-25"
				daysum=20
			Case "2013-05-26"
				daysum=20
			Case "2013-05-27"
				daysum=10
			Case "2013-05-28"
				daysum=0
			Case "2013-05-29"
				daysum=0
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
						"top.location.href='/event/eventmain.asp?eventid="& evt_code &"';" &_
						"</script>"
		dbget.close()	:	response.End
	end if
	rsget.Close

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

	ElseIf renloop >= 2 And renloop < 502 Then
		evt_option2 = "2" '5000 coupon
	Else
		evt_option2 = "1" '3000 coupon
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
					"alert('하루에 한 번 응모 가능합니다.\n\n내일 다시 응모해주세요.');" &_
					"top.location.href='/event/eventmain.asp?eventid=" & evt_code& "';" &_
					"</script>"

	else
		'이벤트 정상응모
		If evt_option2 ="1" or evt_option2="2"Then				'3000 or 5000 쿠폰일 경우

			Dim objCmd , returnValue
			Set objCmd = Server.CreateObject("ADODB.COMMAND")

			With objCmd
				.ActiveConnection = dbget
				.CommandType = adCmdText
				.CommandText = "{?= call [db_temp].[dbo].[sp_Ten_event_innisfree]("&evt_option2&","&evt_code&",'"&loginid&"')}"
				.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
				.Execute, , adExecuteNoRecords
				End With	
				returnValue = objCmd(0).Value		    
			
			Set objCmd = Nothing	

			If returnValue = 0 then
				response.write "<script type='text/javascript'>" &_
						"alert('쿠폰이 모두 소진되었습니다');" &_
						"top.location.href='/event/eventmain.asp?eventid=42366';" &_
						"</script>"
				dbget.close()	:	response.End
			End if 

			sqlStr= "select top 1 b.usermail, c.couponkey from db_event.dbo.tbl_event_subscript as a" &_
			        " join db_user.dbo.tbl_user_n as b" &_
			        " on a.userid = b.userid " &_
			        " join db_temp.dbo.tbl_innisfree_coupon as c " &_
			        " on a.sub_opt1 = c.idx " &_
			        " where a.evt_code='" & evt_code & "' and a.userid='" & loginid & "'" &_
			        " order by sub_idx desc"

	        rsget.Open sqlStr,dbget,1
			usermail = rsget(0)
			couponkey = rsget(1)
			rsget.Close
			call SendMailCoupon(usermail,couponkey)
				Dim msg
				If evt_option2="1" Then
					msg="3,000"
				else
					msg="5,000"
				End If
				response.write "<script type='text/javascript'>" &_
					"alert('이니스프리 할인쿠폰 "& msg &"원에 당첨되셨습니다.\n당첨되신 쿠폰번호는 개인정보에 있는 e-mail로도 전송 됩니다.');" &_
					"top.location.href='/event/eventmain.asp?eventid=" & evt_code& "';" &_
					"</script>"
				dbget.close()	:	response.End

		else														'키트 당첨
			sqlStr = "Insert into db_event.dbo.tbl_event_subscript " &_
					" (evt_code, userid, sub_opt2) values " &_
					" (" & evt_code &_
					",'" & loginid & "'" &_
					",'" & evt_option2 & "')"
					'response.write sqlstr
			dbget.execute(sqlStr)
				response.write "<script type='text/javascript'>" &_
					"alert('BEAUTY KIT에 당첨되었습니다.\n 당첨내역은 5월 30일 (목) 게시판에 별도 공지됩니다');" &_
					"top.location.href='/event/eventmain.asp?eventid=" & evt_code& "';" &_
					"</script>"
				dbget.close()	:	response.End
		End If
		'response.redirect referer
	End If


function SendMailCoupon(usermail,couponkey)
        dim mailfrom,mailto, mailtitle, mailcontent,dirPath,fileName, i
        dim fs,objFile



        mailfrom = "텐바이텐<customer@10x10.co.kr>"
        mailtitle = "[텐바이텐] 이벤트 당첨을 축하 드립니다. "
        mailto= usermail

        Set fs = Server.CreateObject("Scripting.FileSystemObject")
        dirPath = server.mappath("/event/etc")
        fileName = dirPath&"\innisfree_mail42365.html"
        Set objFile = fs.OpenTextFile(fileName,1)
        mailcontent = objFile.readall
		If evt_option2="1" Then
        	mailcontent = replace(mailcontent,":COUPONNAME:","3,000원 할인 쿠폰")
    	ElseIf evt_option2="2" Then
    		mailcontent = replace(mailcontent,":COUPONNAME:","5,000원 할인 쿠폰")
    	End If

        mailcontent = replace(mailcontent,":COUPONNUMBER:",couponkey)

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