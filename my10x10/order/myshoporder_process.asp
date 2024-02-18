<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 오프라인 배송 주소 입력
' History : 2018.02.02 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/classes/offshop/upchebeasong_cls.asp" -->

<%
dim orderNo, certNo, confirmcertno, shopid, dbCertNo, cjumunmaster, ExistsBeasongYN, regdate, mode, sql
dim buyemail, reqname, reqzipcode, reqzipaddr, reqaddress, reqphone, reqhp, comment, shopname, UserHp, UserHp1, UserHp2, UserHp3
dim shopIpkumDivName, SmsYN, KakaoTalkYN, cbeasongmaster, buyemail1, buyemail2, reqphone1, reqphone2, reqphone3, reqhp1, reqhp2, reqhp3
	orderNo = requestcheckvar(getNumeric(request("orderNo")),16)
	certNo = requestcheckvar(request("certNo"),40)
	reqname = requestcheckvar(request("reqname"),32)
	buyemail1 = requestcheckvar(request("buyemail1"),32)
	buyemail2 = requestcheckvar(request("buyemail2"),80)
	buyemail = buyemail1&"@"&buyemail2
	reqzipcode = requestcheckvar(request("txZip"),5)
	reqzipaddr = requestcheckvar(request("txAddr1"),128)
	reqaddress = requestcheckvar(request("txAddr2"),512)
	comment = request("comment")
	reqphone1 = requestcheckvar(getNumeric(request("reqphone1")),4)
	reqphone2 = requestcheckvar(getNumeric(request("reqphone2")),4)
	reqphone3 = requestcheckvar(getNumeric(request("reqphone3")),4)
	reqphone = reqphone1&"-"&reqphone2&"-"&reqphone3
	reqhp1 = requestcheckvar(getNumeric(request("reqhp1")),4)
	reqhp2 = requestcheckvar(getNumeric(request("reqhp2")),4)
	reqhp3 = requestcheckvar(getNumeric(request("reqhp3")),4)
	reqhp = reqhp1&"-"&reqhp2&"-"&reqhp3
	mode = requestcheckvar(request("mode"),16)

if orderNo="" or isnull(orderNo) or certNo="" or isnull(certNo) then
	response.write "<script type='text/javascript'>"
	response.write "	alert('정상적인 인증 경로가 아닙니다[0].');"
	response.write "</script>"
	dbget.close()	:	response.End
end if

' 인증코드 & 주문내역 조회
set cjumunmaster = new cupchebeasong_list
	cjumunmaster.frectorderNo = orderNo
	cjumunmaster.fshopjumun_master()

if cjumunmaster.ftotalcount < 1 then
	response.write "<script type='text/javascript'>"
	response.write "	alert('존재하지 않는 주문 입니다.');"
	response.write "</script>"
	dbget.close()	:	response.End
end if

UserHp = cjumunmaster.FOneItem.fUserHp
dbCertNo = cjumunmaster.FOneItem.fCertNo
shopid = cjumunmaster.FOneItem.fshopid
orderno = cjumunmaster.FOneItem.forderno
SmsYN = cjumunmaster.FOneItem.fSmsYN
KakaoTalkYN = cjumunmaster.FOneItem.fKakaoTalkYN
regdate = cjumunmaster.FOneItem.fregdate

if datediff("m",regdate,date()) >= 1 then
	response.write "<script type='text/javascript'>"
	response.write "	alert('1달 이후 주문건은 조회가 불가능 합니다.');"
	response.write "</script>"
	dbget.close()	:	response.End
end if

confirmcertno = md5(trim(orderno) & dbCertNo & replace(trim(UserHp),"-",""))

if trim(certNo) <> confirmcertno then
	response.write "<script type='text/javascript'>"
	response.write "	alert('인증된 코드값이 아닙니다.');"
	response.write "</script>"
	dbget.close()	:	response.End
end if

set cbeasongmaster = new cupchebeasong_list
	cbeasongmaster.frectorderno = orderNo
	cbeasongmaster.fshopjumun_edit()

if cbeasongmaster.ftotalcount < 1 then
	response.write "<script type='text/javascript'>"
	response.write "	alert('해당 주문건에 배송건이 존재 하지 않습니다.');"
	response.write "</script>"
	dbget.close()	:	response.End
end if

'//배송지 정보 수정
if mode="addressedit" then
	' 통보 이후 라면
	if cbeasongmaster.FOneItem.fIpkumDiv >= 5 then
		response.write "<script language='javascript'>"
		response.write "	alert('배송중 입니다. 수정하실수 없습니다.');"
		response.write "	history.back();"
		response.write "</script>"
		dbget.close()	:	response.End
	end if

	'//코맨트에 뻘짓 해논거 없나 체크
	if comment<>"" and isnull(comment) then
		if checkNotValidHTML(comment) then
			response.write "<script language='javascript'>"
			response.write "	alert('주문 유의사항에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요');"
			response.write "	history.back();"
			response.write "</script>"
			dbget.close()	:	response.End
		end if
	end if

	buyemail = replace(buyemail,"'","")
	reqname = replace(reqname,"'","")
	reqzipcode = replace(reqzipcode,"'","")
	reqzipaddr = replace(reqzipaddr,"'","")
	reqaddress = replace(reqaddress,"'","")
	reqphone = replace(reqphone,"'","")
	reqhp = replace(reqhp,"'","")
	comment = replace(comment,"'","""")

	sql = "update db_shop.dbo.tbl_shopbeasong_order_master" + vbcrlf
	sql = sql & " set ipkumdiv='2'" + vbcrlf
	sql = sql & " ,buyemail = '"&html2db(trim(buyemail))&"'" + vbcrlf
	sql = sql & " ,reqname = '"&html2db(trim(reqname))&"'" + vbcrlf
	sql = sql & " ,reqzipcode = '"&trim(reqzipcode)&"'" + vbcrlf
	sql = sql & " ,reqzipaddr = '"&html2db(trim(reqzipaddr))&"'" + vbcrlf
	sql = sql & " ,reqaddress = '"&html2db(trim(reqaddress))&"'" + vbcrlf
	sql = sql & " ,reqphone = '"&trim(reqphone)&"'" + vbcrlf
	sql = sql & " ,reqhp = '"&trim(reqhp)&"'" + vbcrlf
	sql = sql & " ,comment = '"&html2db(trim(comment))&"'" + vbcrlf
	sql = sql & " ,lastupdateadminid = '"& trim(orderno) &"' where" + vbcrlf
	sql = sql & " orderno = '"&trim(orderno)&"'"

	'response.write sql &"<br>"
	dbget.execute sql

	response.write "<script language='javascript'>"
	response.write "	alert('입력 되었습니다. 감사합니다.');"
	response.write "	location.replace('"& M_SSLUrl &"/my10x10/order/myshoporder.asp?orderNo="&orderNo&"&certNo="& certNo &"');"
	response.write "</script>"
	dbget.close()	:	response.End
else
	response.write "정상적인 경로가 아닙니다"
	dbget.close()	:	response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->