<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/base64.asp" -->
<!-- #INCLUDE Virtual="/lib/util/tenEncUtil.asp" -->
<!-- #INCLUDE Virtual="/lib/email/maillib.asp" -->
<!-- #INCLUDE Virtual="/lib/email/maillib2.asp" -->
<%
	dim chkMtd, sName, sCell, sEmail, sUserId
	dim sqlStr, oMail

	sName = session("findIDName")
	sCell = session("findIDCell")
	sEmail = session("findIDMail")

	chkMtd = requestCheckVar(Request.form("mtd"),2)
	sUserId = requestCheckVar(Request.form("sid"),168)

	if sCell="" and sEmail="" then
		Response.Write "E1"
		dbget.Close: Response.End
	end if

	if chkMtd="" or sUserId="" then
		Response.Write "E2"
		dbget.Close: Response.End
	end if

	if (chkMtd="HP" and sCell="") or (chkMtd="EM" and sEmail="") then
		Response.Write "E3"
		dbget.Close: Response.End
	end if

	'아이디 복호화
	sUserId = decTenUID(sUserId)

	Select Case chkMtd
		Case "HP"		'휴대폰 전송
			sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '"+sCell+"','1644-6030','[텐바이텐] 고객님의 아이디는 " & sUserId & " 입니다.'"
			dbget.Execute sqlStr				

			Response.Write "10"

		'/아이디 찾기 이메일 전송. 	'/2017.06.01 한용민
		Case "EM"
	        dim mailfrom, mailtitle, mailcontent,dirPath,fileName
	        dim fs,objFile

	        mailfrom = "텐바이텐<customer@10x10.co.kr>"
	        mailtitle = "[텐바이텐] 아이디를 알려드립니다."

	        Set fs = Server.CreateObject("Scripting.FileSystemObject")
	        dirPath = server.mappath("/lib/email")
'	        fileName = dirPath&"\\email_id_confirm.htm"
	        fileName = dirPath&"\\email_userid_confirm.html"
	        Set objFile = fs.OpenTextFile(fileName,1)
	        mailcontent = objFile.readall

	        mailcontent = replace(mailcontent,"::USERNAME::",sName)
	        mailcontent = replace(mailcontent,"::USERID::",sUserId)

			set oMail = New MailCls         '' mailLib2
				oMail.AddrType		= "string"
				oMail.ReceiverMail	= sEmail
				oMail.MailTitles	= mailtitle
				oMail.MailConts 	= mailcontent
				oMail.MailerMailGubun = 12		' 메일러 자동메일 번호
				oMail.Send_TMSMailer()		'TMS메일러
				'oMail.Send_Mailer()
			SET oMail = nothing
	        'call sendmail(mailfrom, sEmail, mailtitle, mailcontent)

			Response.Write "20"
	End Select


	'// 아이디 복호화 함수
	function decTenUID(cpx)
		decTenUID = tenDec(trim(Base64decode(cpx)))
	end function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->