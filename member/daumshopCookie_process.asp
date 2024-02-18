<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
Dim due, gourl, sqlStr, AssignedRow
due = request("due")
gourl = request("gourl")
If due = "one" Then
	response.Cookies("daumshop").domain = "10x10.co.kr"
	response.cookies("daumshop")("mode") = "x"
	response.cookies("daumshop").Expires = Date + 1
	If gourl <> "" Then
		response.write "<script>top.location.href='"&gourl&"';</script>"
	End If
ElseIf due = "lg" Then
	sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & GetLoginUserID & "' AND masteridx = '862') " & vbCrlf
	sqlStr = sqlStr & "insert into [db_user].[dbo].tbl_user_coupon " & vbCrlf
	sqlStr = sqlStr & " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice, " & vbCrlf
	sqlStr = sqlStr & " targetitemlist,startdate,expiredate) " & vbCrlf
	sqlStr = sqlStr & " values(862,'" & GetLoginUserID & "',3000,'2','[5월 다음]쿠폰_3000원 할인',30000, " & vbCrlf
	sqlStr = sqlStr & " '','2016-05-23 00:00:00' ,'2016-05-29 23:59:59') " & vbCrlf

'	sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & GetLoginUserID & "' AND masteridx = '313') " & vbCrlf
'	sqlStr = sqlStr & "insert into [db_user].[dbo].tbl_user_coupon " & vbCrlf
'	sqlStr = sqlStr & " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice, " & vbCrlf
'	sqlStr = sqlStr & " targetitemlist,startdate,expiredate) " & vbCrlf
'	sqlStr = sqlStr & " values(313,'" & GetLoginUserID & "',5,'1','네이버 유입고객 쿠폰 5%',30000, " & vbCrlf
'	sqlStr = sqlStr & " '','2014-03-07 00:00:00' ,'2014-03-23 23:59:59') " & vbCrlf
	dbget.Execute sqlStr, AssignedRow
	If (AssignedRow = 1) Then
		response.Cookies("daumshop").domain = "10x10.co.kr"
		response.cookies("daumshop")("mode") = "y"
		response.cookies("daumshop").Expires = Date + 7
		response.write 	"<script language='javascript'>alert('다음X텐바이텐 할인쿠폰\n\n쿠폰지급 완료');</script>"
	End If
End If
%>
<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->