<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
%>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checkLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%

dim boardqna
dim boarditem
dim id, itemid, mode, userid,username, title, qadiv, emailok, usermail, contents
dim makerid, cdl, brandname, userlevel,masterid, smsok, userhp
dim dispCate, flag , secretYN

''질문구분 추가 - 카메라몰 :서동석
dim qna_comm_cd, groupcd

id = requestCheckVar(request("id"),9)
itemid = requestCheckVar(request("itemid"),9)
mode = requestCheckVar(request("mode"),9)
userid = getEncLoginUserID()
username = requestCheckVar(request("username"),32)
''title = requestCheckVar(request("title"),128)  ''사용안함
qadiv = requestCheckVar(request("qadiv"),9)
emailok = requestCheckVar(request("emailok"),9)
usermail = requestCheckVar(request("usermail"),128)
smsok = requestCheckVar(request("smsok"),1)
userhp = requestCheckVar(request("userhp"),15)
contents = requestCheckVar(request("contents"),1024)
qna_comm_cd = requestCheckVar(request("qna_comm_cd"),4)
groupcd = requestCheckVar(request("groupcd"),9)
dispCate = requestCheckVar(request("disp"),18)
flag = requestCheckVar(request("flag"),2)
secretYN = requestCheckVar(request("secretYN"),1) '//비밀글

if secretYN="" or isNull(secretYN) then
	secretYN="N"
end if

if checkNotValidHTML(contents) then
	Call Alert_Return("HTML은 사용하실 수 없습니다.")
	response.end
end if

makerid = requestCheckVar(request("makerid"),32)
cdl = requestCheckVar(request("cdl"),3)
brandname = requestCheckVar(html2db(request("brandname")),64)
userlevel = GetLoginUserLevel()
masterid = requestCheckVar(request("masterid"),9)

dim sql
if (cdl="") or (makerid="") or (brandname="") then
	if (itemid<>"") then
		sql = "select top 1 makerid, cate_large, brandname from [db_item].[dbo].tbl_item" + VbCrlf
		sql = sql + " where itemid=" + CStr(itemid)

		rsget.Open sql, dbget, 1
		if Not rsget.Eof then
			makerid = rsget("makerid")
			cdl = rsget("cate_large")
			brandname = rsget("brandname")
		end if
		rsget.Close
	end if
end if

Select Case mode
	Case "write"
		sql = " insert into [db_cs].[dbo].tbl_my_item_qna"
		sql = sql + " (userid, username, cdl, dispCate, orderserial, "
		sql = sql + " qadiv, usermail, emailok, userhp, smsok, contents, "
		sql = sql + " regdate, replyuser, replycontents, "
		sql = sql + " itemid, isusing, makerid, brandname,"
		if (qna_comm_cd<>"") then
			sql = sql + " qna_comm_cd,"
		end if
		sql = sql + "  userlevel ,secretYN) " + VbCRLF
		sql = sql + " values('" + userid + "'" + VbCRLF
		sql = sql + " ,'" + html2db(username) + "'" + VbCRLF
		sql = sql + " ,'" + cdl + "'" + VbCRLF
		sql = sql + " ,'" + dispCate + "'" + VbCRLF
		sql = sql + ", ''" + VbCRLF
		sql = sql + ", '" + Cstr(qadiv) + "'" + VbCRLF
		sql = sql + ", '" + html2db(usermail) + "'" + VbCRLF
		sql = sql + ", '" + emailok + "'" + VbCRLF
		sql = sql + ", '" + html2db(userhp) + "'" + VbCRLF
		sql = sql + ", '" + smsok + "'" + VbCRLF
		sql = sql + ", '" + html2db(contents) + "'" + VbCRLF
		sql = sql + ", getdate()" + VbCRLF
		sql = sql + ", ''" + VbCRLF
		sql = sql + ", ''" + VbCRLF
		sql = sql + ", " + Cstr(itemid) + " " + VbCRLF
		sql = sql + ",'Y'" + VbCRLF
		sql = sql + ", '" + makerid + "'" + VbCRLF
		sql = sql + ",'" + html2db(brandname) + "'" + VbCRLF
		if (qna_comm_cd<>"") then
			sql = sql + " ,'" + qna_comm_cd + "'" + VbCRLF
		end if
		sql = sql + ",'" + userlevel + "'" + VbCRLF
		sql = sql + ",'" + secretYN + "') " + VbCRLF
	
		sql = sql + " UPDATE db_item.dbo.tbl_item_contents set QnaCnt = QnaCnt +1 Where Itemid=" & Cstr(itemid)

		dbget.Execute sql

	Case "modi"
		sql = " update [db_cs].[dbo].tbl_my_item_qna Set "
		sql = sql + " usermail='" + html2db(usermail) + "'"
		sql = sql + " ,emailok='" + emailok + "'"
		sql = sql + " ,userhp='" + html2db(userhp) + "'"
		sql = sql + " ,smsok='" + smsok + "'"
		sql = sql + " ,contents='" + html2db(contents) + "'"
		sql = sql + " ,secretYN='" + html2db(secretYN) + "'"
		sql = sql + " where userid='" + userid + "'" + VbCRLF
		sql = sql + " and id=" + id + "" + VbCRLF

		dbget.Execute sql

	Case "del"
		sql = " update [db_cs].[dbo].tbl_my_item_qna" + VbCRLF
		sql = sql + " set isusing='N'" + VbCRLF
		sql = sql + " where userid='" + userid + "'" + VbCRLF
		sql = sql + " and id=" + id + "" + VbCRLF
	
		sql = sql + " UPDATE db_item.dbo.tbl_item_contents set QnaCnt = QnaCnt -1 Where Itemid=" & Cstr(itemid)
	
		'response.write sql&"<br>"
		dbget.Execute sql

end Select

dim referer
referer = request.ServerVariables("HTTP_REFERER")

if Not(referer="" or isNull(referer) or (InStr(referer,"/category/")>0)) then
	response.redirect referer
else
	'// iframe 전송시 처리
	if flag="fd" then
		response.Write "<script>fnAPPopenerJsCallClose('goPageQna(1)');</script>"
	else
		if mode="del" then
			response.Write "<result>1000</result>"
		else
			'삭제가 아니면 현재창을 닫고 부모창 Q&A 페이지 리플레시
			response.Write "<script>fnAPPopenerJsCallClose('goPageQna(1)');</script>"
		end if
	end if
end if
%>
</head>
<body></body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->