<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	History	:  2010.04.08 한용민 생성
'	Description : culturestation 이벤트 처리
'#######################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
dim isusing , mode, contents , idx , gubun , ck_userid
	gubun = requestCheckVar(request("gubun"),2)
	ck_userid = getloginuserid()                             ''수정 2012/01/15
	isusing = "N"
	contents = request("contents")
	idx = getNumeric(requestCheckVar(request("idx"),5))

dim referer
	referer = request.ServerVariables("HTTP_REFERER")

dim sqlStr

If ck_userid = "" Then
	Response.Write "01||로그인을 해주세요."
	dbget.close() : Response.End
End IF

'//기존 삭제여부 Y
if idx <> "" then
	sqlStr = "update db_culture_station.dbo.tbl_thanks_10x10 set" &VbCRLF
	sqlStr = sqlStr & " isusing_del = 'Y'"&VbCRLF
	sqlStr = sqlStr & " where idx = '"& idx &"'"&VbCRLF
    sqlStr = sqlStr & " and userid='"&ck_userid&"'"&VbCRLF   '' 추가 2012/01/15
    dbget.Execute sqlStr

	sqlStr = "delete from db_culture_station.dbo.tbl_thanks_10x10_comment where idx = "& idx &""	
	dbget.execute sqlStr
	
	Response.Write "03||삭제되었습니다."
	dbget.close() : Response.End
end if

if checkNotValidHTML(contents) then
	Response.Write "02||내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요."
	dbget.close() : Response.End
end if
	'' 디비에 저장
	sqlStr = " insert into db_culture_station.dbo.tbl_thanks_10x10" + VbCrlf
	sqlStr = sqlStr + " (userid,contents,isusing_display,gubun)" + VbCrlf
	sqlStr = sqlStr + " values(" + VbCrlf
	sqlStr = sqlStr + " '" & ck_userid & "'" + VbCrlf
	sqlStr = sqlStr + " ,'" & html2db(contents) & "'" + VbCrlf
	sqlStr = sqlStr + " ,'" & isusing & "'" + VbCrlf
	sqlStr = sqlStr + " ,'" & gubun & "'" + VbCrlf
	sqlStr = sqlStr + " )"
	dbget.Execute sqlStr
	
	Response.Write "04||고객님의 글이 저장되었습니다."
	dbget.close() : Response.End
%>    
<!-- #include virtual="/lib/db/dbclose.asp" -->