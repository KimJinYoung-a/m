<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 고객센터 파일전송
' History : 2019.11.26 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/classes/cscenter/customer_file_cls.asp" -->
<%
dim authidx, certno, comment, mode, userhp, dbCertNo, regdate, status, sqlStr, i, confirmcertno
dim sfile1, sfile2, sfile3, sfile4, sfile5
    authidx = requestcheckvar(request("authidx"),10)
    certno = requestcheckvar(request("certno"),40)
    comment = requestcheckvar(request("comment"),3000)
    mode = requestcheckvar(request("mode"),40)
	sfile1 = requestcheckvar(request("sfile1"),128)
	sfile2 = requestcheckvar(request("sfile2"),128)
	sfile3 = requestcheckvar(request("sfile3"),128)
	sfile4 = requestcheckvar(request("sfile4"),128)
	sfile5 = requestcheckvar(request("sfile5"),128)

if mode="fileedit" then
    if authidx="" then
    	Alert_return("정상적인 인증 경로가 아닙니다.")
    	dbget.Close : response.end
    end if

    sqlStr = "select top 1" & vbcrlf 
    sqlStr = sqlStr & " authidx,userhp,userid,orderserial,comment,fileurl1,fileurl2,fileurl3,fileurl4" & vbcrlf 
    sqlStr = sqlStr & " ,fileurl5,smsyn,kakaotalkyn,certno,status,isusing,regdate" & vbcrlf 
    sqlStr = sqlStr & " from db_cs.dbo.tbl_customer_filelist with (readuncommitted)" & vbcrlf 
    sqlStr = sqlStr & " where isusing='Y' and authidx="& authidx &""

    'response.write sqlStr &"<br>"
    rsget.CursorLocation = adUseClient
    rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

    if  not rsget.EOF  then
        userhp = rsget("userhp")
        dbCertNo = rsget("certno")
        authidx = rsget("authidx")
        regdate = rsget("regdate")
        status = rsget("status")
    end if
    rsget.Close

    confirmcertno = md5(trim(authidx) & trim(dbCertNo) & replace(trim(userhp),"-",""))
    'response.write certNo & "<Br>"
    'response.write confirmcertno & "<Br>"

    if trim(status)<>"0" then
    	Alert_return("이미 파일이 전송되었습니다.")
    	dbget.Close : response.end
    end if

    if trim(certno) <> trim(confirmcertno) then
    	Alert_return("인증된 코드값이 아닙니다.")
    	dbget.Close : response.end
    end if

    if datediff("d",regdate,date()) > 7 then
    	Alert_return("파일전송 요청후 7일이후에는 조회가 불가능 합니다.")
    	dbget.Close : response.end
    end if

    if trim(comment)<>"" and isnull(comment) then
        if (checkNotValidHTML(comment) = True) then
        	Alert_return("문의내용에는유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.")
        	dbget.close()	:	response.End
        end if
    end if

	sqlStr = "update db_cs.dbo.tbl_customer_filelist" & vbcrlf
	sqlStr = sqlStr & " set status=1" & vbcrlf

    if trim(comment) <> "" Then
        sqlStr = sqlStr & " ,comment = '"&html2db(trim(comment))&"'" & vbcrlf
    end if

    if trim(sfile1)<>"" and not(isnull(sfile1)) Then
    	sqlStr = sqlStr & " ,fileurl1 = '"&html2db(trim(sfile1))&"'" & vbcrlf
    end if
    if trim(sfile2)<>"" and not(isnull(sfile2)) Then
    	sqlStr = sqlStr & " ,fileurl2 = '"&html2db(trim(sfile2))&"'" & vbcrlf
    end if
    if trim(sfile3)<>"" and not(isnull(sfile3)) Then
    	sqlStr = sqlStr & " ,fileurl3 = '"&html2db(trim(sfile3))&"'" & vbcrlf
    end if
    if trim(sfile4)<>"" and not(isnull(sfile4)) Then
    	sqlStr = sqlStr & " ,fileurl4 = '"&html2db(trim(sfile4))&"'" & vbcrlf
    end if
    if trim(sfile5)<>"" and not(isnull(sfile5)) Then
    	sqlStr = sqlStr & " ,fileurl5 = '"&html2db(trim(sfile5))&"'" & vbcrlf
    end if

    sqlStr = sqlStr & " ,customer_file_regdate = getdate() where" & vbcrlf
	sqlStr = sqlStr & " authidx = '"&trim(authidx)&"' and userhp='"& userhp &"'"

	'response.write sqlStr &"<br>"
	dbget.execute sqlStr
else
	Alert_return("정상적인 경로가 아닙니다.")
	dbget.Close : response.end
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->

<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=utf-8" >
</HEAD>
<BODY>
	<script type="text/javascript">
	    alert('접수 되었습니다. 감사합니다.');
        location.replace('http://m.10x10.co.kr');
	</script>
</BODY>
</HTML>
