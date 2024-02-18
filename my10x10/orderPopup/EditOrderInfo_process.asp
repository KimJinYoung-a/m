<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 마이텐바이텐
' History : 2015.06.04 한용민 생성
'####################################################
%>
<!-- #include virtual="/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/cscenter/lib/csAsfunction.asp" -->
<!-- #include virtual="/lib/util/aspJSON1.17.asp" -->
<%
Const CFINISH_SYSTEM = "system"

dim i, mode, backurl
mode        = request.Form("mode")
backurl     = request.ServerVariables("HTTP_REFERER")

''' html2db : 입력시 사용. : 2가지 Case RegCSMaster에서는 html2db 사용하지 말것.
''구매자
dim buyname, buyphone, buyhp, buyemail
buyname     = request.Form("buyname")
buyphone    = request.Form("buyphone1") + "-" + request.Form("buyphone2") + "-" + request.Form("buyphone3")
buyhp       = request.Form("buyhp1") + "-" + request.Form("buyhp2") + "-" + request.Form("buyhp3")
buyemail    = request.Form("buyemail")

''입금자명
dim accountnamedisable, accountname, accountno
accountnamedisable  = request.Form("accountnamedisable")
accountname         = request.Form("accountname")
accountno           = request.Form("accountno")

''수령인
dim reqname, reqphone, reqhp
dim reqzipcode, reqzipaddr, reqaddress
dim comment

reqname     = request.Form("reqname")
reqzipaddr  = request.Form("txAddr1")
reqaddress  = request.Form("txAddr2")
comment     = request.Form("comment")

reqhp       = request.Form("reqhp1") + "-" + request.Form("reqhp2") + "-" + request.Form("reqhp3")

Dim emsAreaCode, reqemail, emsZipcode
emsAreaCode = req("emsAreaCode","KR")
If emsAreaCode = "KR" Then
	reqphone    = request.Form("reqphone1") + "-" + request.Form("reqphone2") + "-" + request.Form("reqphone3")
	reqzipcode  = request.Form("txZip")
Else
	reqphone    = request.Form("reqphone1") + "-" + request.Form("reqphone2") + "-" + request.Form("reqphone3") + "-" + request.Form("reqphone4")
	emsZipcode  = req("emsZipcode","")
	reqemail  = req("reqemail","")
End If

''플라워 지정일
dim fixdeliveryedit, yyyy,mm,dd, cardribbon, message, fromname, reqdate, reqtime
fixdeliveryedit = request.Form("fixdeliveryedit")
yyyy            = request.Form("yyyy")
mm              = request.Form("mm")
dd              = request.Form("dd")

if fixdeliveryedit<>"" then
    on Error Resume Next
    reqdate = Left(CStr(DateSerial(yyyy,mm,dd)),10)
    on Error Goto 0
end if
reqtime         = request.Form("tt")
cardribbon      = request.Form("cardribbon")
message         = request.Form("message")
fromname        = request.Form("fromname")

''주문제작문구
dim requiredetail, detailidx
requiredetail = LeftB(request.Form("requiredetail"),1024)
detailidx     = request.Form("detailidx")

''현장수령
dim RcvSiteyyyymmdd
RcvSiteyyyymmdd = request.Form("RcvSiteyyyymmdd")

dim userid, orderserial, IsBiSearch
userid      = getEncLoginUserID
orderserial = request.form("orderserial")
detailidx   = request.form("detailidx")

if ((userid="") and session("userorderserial")<>"") then
	IsBiSearch = true
	orderserial = session("userorderserial")
end if

dim myorder
set myorder = new CMyOrder
	if IsBiSearch then
	    ''비회원주문
		myorder.FRectOrderserial = orderserial
	
		if (orderserial<>"") then
		    myorder.GetOneOrder
		end if
	else
	    ''회원주문
		myorder.FRectUserID = userid
		myorder.FRectOrderserial = orderserial
	
		if (userid<>"") and (orderserial<>"") then
		    myorder.GetOneOrder
		end if
	end if

dim myorderdetail
set myorderdetail = new CMyOrder
	myorderdetail.FRectOrderserial = orderserial
	myorderdetail.FRectIdx = detailidx
	
	if (myorder.FResultCount>0) then
	    if (mode="edithandmadereq") then
	        myorderdetail.GetOneOrderDetail
	    else
	        myorderdetail.GetOrderDetail
	    end if
	else
	    response.write "<script type='text/javascript'>alert('주문/배송정보 수정 가능 상태가 아닙니다. - 고객센터로 문의해 주세요');</script>"
	    response.write "<script type='text/javascript'>history.back();</script>"
	    dbget.close()	:	response.End
	end if

dim IsWebEditEnabled
IsWebEditEnabled = myorder.FOneItem.IsWebOrderInfoEditEnable
if (Not IsWebEditEnabled) then
    response.write "<script type='text/javascript'>alert('주문/배송정보 수정 가능 상태가 아닙니다. - 고객센터로 문의해 주세요');</script>"
    response.write "<script type='text/javascript'>history.back();</script>"
    dbget.close()	:	response.End
end if

if (mode="payn") and (accountnamedisable<>"") then
    response.write "<script type='text/javascript'>alert('입금자정보  수정 가능 상태가 아닙니다. - 고객센터로 문의해 주세요');</script>"
    response.write "<script type='text/javascript'>history.back();</script>"
    dbget.close()	:	response.End
end if

if (mode="flow") and (fixdeliveryedit<>"on") then
    response.write "<script type='text/javascript'>alert('플라워 배송정보  수정 가능 상태가 아닙니다. - 고객센터로 문의해 주세요');</script>"
    response.write "<script type='text/javascript'>history.back();</script>"
    dbget.close()	:	response.End
end if

CONST CNEXT = " => "
dim sqlStr, errcode, reguserid, divcd, title, gubun01, gubun02, contents_jupsu, finishuser, contents_finish
dim iAsID, preqdate

''주문/배송 정보 수정
if (mode="ordr") then
    On Error Resume Next
    dbget.beginTrans

    If Err.Number = 0 Then
        errcode = "001"

        reguserid   = userid
        divcd       = "A900"
        title       = "[고객변경]주문자 정보 수정"
        gubun01     = "C004"
        gubun02     = "CD99"

        contents_jupsu  = ""
        contents_finish = ""

        if (reguserid="") then reguserid="GuestOrder"
        finishuser      = CFINISH_SYSTEM

        sqlStr = " select top 1 IsNULL(buyname,'') as buyname"
        sqlStr = sqlStr + " ,IsNULL(buyphone,'') as buyphone"
        sqlStr = sqlStr + " ,IsNULL(buyhp,'') as buyhp"
        sqlStr = sqlStr + " ,IsNULL(buyemail,'') as buyemail"
        sqlStr = sqlStr + " from [db_order].[dbo].tbl_order_master "
        sqlStr = sqlStr + " where orderserial='" + CStr(orderserial) + "' " + VbCrlf
        rsget.Open sqlStr,dbget,1
        if Not rsget.Eof then

            if (db2html(rsget("buyname"))<>buyname) then
                contents_jupsu = contents_jupsu & "주문자명: " & rsget("buyname") & CNEXT & buyname & VbCrlf
            end if

            if (rsget("buyphone")<>buyphone) then
                contents_jupsu = contents_jupsu & "주문자전화: " & rsget("buyphone") & CNEXT & buyphone & VbCrlf
            end if

            if (rsget("buyhp")<>buyhp) then
                contents_jupsu = contents_jupsu & "주문자핸드폰: " & rsget("buyhp") & CNEXT & buyhp & VbCrlf
            end if

            if (db2html(rsget("buyemail"))<>buyemail) then
                contents_jupsu = contents_jupsu & "주문자이메일: " & rsget("buyemail") & CNEXT & buyemail & VbCrlf
            end if

        end if
        rsget.Close

    end if

    if (contents_jupsu="") then
        response.write "<script type='text/javascript'>alert('수정하실 내역이 기존 내역과 일치합니다. 수정되지 않았습니다.');</script>"
        response.write "<script type='text/javascript'>history.back();</script>"
        dbget.RollBackTrans
        dbget.close()	:	response.End
    else
        contents_jupsu = "변경 내역" & VbCrlf & contents_jupsu
        contents_finish = contents_jupsu
    end if

    If Err.Number = 0 Then
        errcode = "002"

        sqlStr = " update [db_order].[dbo].tbl_order_master "     + VbCrlf
        sqlStr = sqlStr + " set buyname='" + html2db(buyname) + "' "   + VbCrlf
        sqlStr = sqlStr + " ,buyphone = '" + CStr(buyphone) + "' "  + VbCrlf
        sqlStr = sqlStr + " ,buyhp = '" + CStr(buyhp) + "' "        + VbCrlf
        sqlStr = sqlStr + " ,buyemail = '" + html2db(buyemail) + "' "  + VbCrlf
        sqlStr = sqlStr + " where orderserial='" + CStr(orderserial) + "' " + VbCrlf

        dbget.Execute sqlStr

    end if

    If Err.Number = 0 Then
        errcode = "003"
        '' html2db 사용하지 말것.
        iAsID = RegCSMaster(divcd , orderserial, reguserid, title, contents_jupsu, gubun01, gubun02)
    end if

    If Err.Number = 0 Then
        errcode = "004"
        Call FinishCSMaster(iAsid, finishuser, html2db(contents_finish))

    end if

    If Err.Number = 0 Then
        dbget.CommitTrans

        response.write "<script type='text/javascript'>alert('변경 되었습니다.');</script>"
        response.write "<script type='text/javascript'>location.replace('/my10x10/orderPopup/popEditOrderInfo.asp?orderserial="& orderserial &"&etype=ordr');</script>"
        dbget.close()	:	response.End
    Else
        dbget.RollBackTrans
        response.write "<script>alert('데이타를 저장하는 도중에 에러가 발생하였습니다.\r\n(에러코드 : " + CStr(errcode) + ")')</script>"
        response.write "<script>history.back()</script>"
        dbget.close()	:	response.End
    End If
    On Error Goto 0

elseif (mode="payn") then
    On Error Resume Next
    dbget.beginTrans

    If Err.Number = 0 Then
        errcode = "001"

        reguserid   = userid
        divcd       = "A900"
        title       = "[고객변경]입금자 정보 수정"
        gubun01     = "C004"
        gubun02     = "CD99"

        contents_jupsu  = ""
        contents_finish = ""
        finishuser      = CFINISH_SYSTEM

        sqlStr = " select top 1 IsNULL(accountname,'') as accountname"
        sqlStr = sqlStr + " ,IsNULL(accountno,'') as accountno"
        sqlStr = sqlStr + " from [db_order].[dbo].tbl_order_master "
        sqlStr = sqlStr + " where orderserial='" + CStr(orderserial) + "' " + VbCrlf
        rsget.Open sqlStr,dbget,1
        if Not rsget.Eof then
            ''contents_jupsu = contents_jupsu & "변경 내역" & VbCrlf

            if (db2html(rsget("accountname"))<>accountname) then
                contents_jupsu = contents_jupsu & "입금자명: " & rsget("accountname") & CNEXT & accountname & VbCrlf
            end if

            if (db2html(rsget("accountno"))<>accountno) then
                contents_jupsu = contents_jupsu & "입금은행: " & rsget("accountno") & CNEXT & accountno & VbCrlf
            end if
        end if
        rsget.Close

    end if

    if (contents_jupsu="") then
        response.write "<script type='text/javascript'>alert('수정하실 내역이 기존 내역과 일치합니다. 수정되지 않았습니다.');</script>"
        response.write "<script type='text/javascript'>history.back();</script>"
        dbget.RollBackTrans
        dbget.close()	:	response.End
    else
        contents_jupsu = "변경 내역" & VbCrlf & contents_jupsu
        contents_finish = contents_jupsu
    end if

    If Err.Number = 0 Then
        errcode = "002"

        sqlStr = " update [db_order].[dbo].tbl_order_master "     + VbCrlf
        sqlStr = sqlStr + " set accountname='" + html2db(accountname) + "' "   + VbCrlf
        sqlStr = sqlStr + " ,accountno = '" + html2db(accountno) + "' "  + VbCrlf
        sqlStr = sqlStr + " where orderserial='" + CStr(orderserial) + "' " + VbCrlf

        dbget.Execute sqlStr
    end if

    If Err.Number = 0 Then
        errcode = "003"
        '' html2db 사용하지 말것.
        iAsID = RegCSMaster(divcd , orderserial, reguserid, title, contents_jupsu, gubun01, gubun02)
    end if

    If Err.Number = 0 Then
        errcode = "004"
        Call FinishCSMaster(iAsid, finishuser, html2db(contents_finish))
    end if

    If Err.Number = 0 Then
        dbget.CommitTrans

        response.write "<script type='text/javascript'>alert('변경 되었습니다.');</script>"
        response.write "<script type='text/javascript'>opener.location.reload();</script>"
        response.write "<script type='text/javascript'>window.close();</script>"
        dbget.close()	:	response.End
    Else
        dbget.RollBackTrans
        response.write "<script>alert('데이타를 저장하는 도중에 에러가 발생하였습니다.\r\n(에러코드 : " + CStr(errcode) + ")')</script>"
        response.write "<script>history.back()</script>"
        dbget.close()	:	response.End
    End If
    On Error Goto 0

elseif (mode="recv") then
    On Error Resume Next
    dbget.beginTrans

    If Err.Number = 0 Then
        errcode = "001"

        reguserid   = userid
        divcd       = "A900"
        IF (RcvSiteyyyymmdd<>"") then
            title       = "[고객변경]수령인 정보 수정"
        ELSE
            title       = "[고객변경]배송지 정보 수정"
        end if

        gubun01     = "C004"
        gubun02     = "CD99"

        contents_jupsu  = ""
        contents_finish = ""
        finishuser      = CFINISH_SYSTEM

        sqlStr = " select top 1 IsNULL(reqname,'') as reqname"
        sqlStr = sqlStr + " ,IsNULL(reqphone,'') as reqphone"
        sqlStr = sqlStr + " ,IsNULL(reqhp,'') as reqhp"
        sqlStr = sqlStr + " ,IsNULL(reqzipcode,'') as reqzipcode"
        sqlStr = sqlStr + " ,IsNULL(reqzipaddr,'') as reqzipaddr"
        sqlStr = sqlStr + " ,IsNULL(reqaddress,'') as reqaddress"
        sqlStr = sqlStr + " ,IsNULL(comment,'') as comment"
        sqlStr = sqlStr + " ,IsNULL(reqemail,'') as reqemail"
        sqlStr = sqlStr + " ,IsNULL(emsZipcode,'') as emsZipcode"
        sqlStr = sqlStr + " ,IsNULL(reqdate,'') as reqdate"
        sqlStr = sqlStr + " from [db_order].[dbo].tbl_order_master m "
        sqlStr = sqlStr + " left outer join [db_order].[dbo].tbl_ems_orderInfo e "
        sqlStr = sqlStr + " ON m.orderSerial = e.orderSerial "
        sqlStr = sqlStr + " where m.orderSerial = '" + CStr(orderserial) + "' " + VbCrlf
        rsget.Open sqlStr,dbget,1
        if Not rsget.Eof then
            'contents_jupsu = contents_jupsu & "변경 내역" & VbCrlf

            if (db2html(rsget("reqname"))<>reqname) then
                contents_jupsu = contents_jupsu & "수령인명: " & rsget("reqname") & CNEXT & reqname & VbCrlf
            end if

            if (rsget("reqphone")<>reqphone) then
                contents_jupsu = contents_jupsu & "수령인전화: " & rsget("reqphone") & CNEXT & reqphone & VbCrlf
            end if

			If emsAreaCode = "KR" Then	' 국내배송
				if (rsget("reqhp")<>reqhp) then
					contents_jupsu = contents_jupsu & "수령인핸드폰: " & rsget("reqhp") & CNEXT & reqhp & VbCrlf
				end if
				if (Trim(rsget("reqzipcode"))<>Trim(reqzipcode)) or (Trim(db2html(rsget("reqzipaddr")))<>Trim(reqzipaddr)) or (Trim(db2html(rsget("reqaddress")))<>Trim(reqaddress))  then
					contents_jupsu = contents_jupsu & "우편번호: " & rsget("reqzipcode") & CNEXT & reqzipcode & VbCrlf
					contents_jupsu = contents_jupsu & "주소1: " & rsget("reqzipaddr") & CNEXT & reqzipaddr & VbCrlf
					contents_jupsu = contents_jupsu & "주소2: " & rsget("reqaddress") & CNEXT & reqaddress & VbCrlf
				end if
            Else						' 해외배송
				if (rsget("reqemail")<>reqemail) then
					contents_jupsu = contents_jupsu & "수령인이메일: " & rsget("reqemail") & CNEXT & reqemail & VbCrlf
				end if
				if (rsget("emsZipcode")<>emsZipcode) or (db2html(rsget("reqzipaddr"))<>reqzipaddr) or (db2html(rsget("reqaddress"))<>reqaddress)  then
					contents_jupsu = contents_jupsu & "우편번호: " & rsget("emsZipcode") & CNEXT & emsZipcode & VbCrlf
					contents_jupsu = contents_jupsu & "도시 및 주 (City/State): " & rsget("reqzipaddr") & CNEXT & reqzipaddr & VbCrlf
					contents_jupsu = contents_jupsu & "상세주소 (Address): " & rsget("reqaddress") & CNEXT & reqaddress & VbCrlf
				end if
			End If
            ''2012/05 추가
            preqdate = db2html(rsget("reqdate"))
            IF (preqdate="1900-01-01") then
                preqdate=""
            end if

            if (preqdate<>RcvSiteyyyymmdd)  then
                contents_jupsu = contents_jupsu & "수령날짜: " & rsget("reqdate") & CNEXT & RcvSiteyyyymmdd & VbCrlf
            end if

            if (db2html(rsget("comment"))<>comment) then
                contents_jupsu = contents_jupsu & "유의사항: " & rsget("comment") & CNEXT & comment & VbCrlf
            end if
        end if
        rsget.Close

    end if

    if (contents_jupsu="") then
        response.write "<script type='text/javascript'>alert('수정하실 내역이 기존 내역과 일치합니다. 수정되지 않았습니다.');</script>"
        response.write "<script type='text/javascript'>history.back();</script>"
        dbget.RollBackTrans
        dbget.close()	:	response.End
    else
        contents_jupsu = "변경 내역" & VbCrlf & contents_jupsu
        contents_finish = contents_jupsu
    end if

    If Err.Number = 0 Then
        errcode = "002"

        sqlStr = " update [db_order].[dbo].tbl_order_master "     + VbCrlf
        sqlStr = sqlStr + " set reqname='" + html2db(reqname) + "' "   + VbCrlf
        sqlStr = sqlStr + " ,reqphone = '" + CStr(reqphone) + "' "  + VbCrlf

		If emsAreaCode = "KR" Then
			sqlStr = sqlStr + " ,reqhp = '" + CStr(reqhp) + "' "  + VbCrlf
			sqlStr = sqlStr + " ,reqzipcode = '" + CStr(reqzipcode) + "' "  + VbCrlf
		Else
			sqlStr = sqlStr + " ,reqemail = '" + CStr(reqemail) + "' "  + VbCrlf
		End If

        sqlStr = sqlStr + " ,reqzipaddr = '" + html2db(reqzipaddr) + "' "  + VbCrlf
        sqlStr = sqlStr + " ,reqaddress = '" + html2db(reqaddress) + "' "  + VbCrlf
        sqlStr = sqlStr + " ,comment = '" + html2db(comment) + "' "  + VbCrlf
        if (RcvSiteyyyymmdd<>"") then
            sqlStr = sqlStr + " ,reqdate = '" + html2db(RcvSiteyyyymmdd) + "' "  + VbCrlf
        end if
        sqlStr = sqlStr + " where orderserial='" + CStr(orderserial) + "' " + VbCrlf

		dbget.Execute sqlStr

		If emsAreaCode <> "KR" Then
			' 해외배송 우편번호 업데이트
			Dim emsSQL
			emsSQL = " update [db_order].[dbo].tbl_ems_orderInfo "     + VbCrlf
			emsSQL = emsSQL + " set emsZipcode='" & emsZipcode & "' "   + VbCrlf
			emsSQL = emsSQL + " where orderserial='" + CStr(orderserial) + "' " + VbCrlf
			dbget.Execute emsSQL
		End If

        '' 이니렌탈 주문일 경우 이니시스에 배송지 수정 값 보내줄 것
        If myorder.FOneItem.FAccountDiv = "150" Then
            dim xmlHttp, postdata, strData, iniMid, inimodifyAuthUrl, oJSON, resultCode
            IF application("Svr_Info")="Dev" THEN
                iniMid = "teenxtest1"
                inimodifyAuthUrl = "https://inirt.inicis.com/apis/v1/rental/modify"
                Set xmlHttp = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")
            Else
                iniMid = "teenxteenr"
                inimodifyAuthUrl = "https://inirt.inicis.com/apis/v1/rental/modify"
                Set xmlHttp = CreateObject("Msxml2.ServerXMLHTTP.3.0")
            End If
            
            postdata = "mid="&CStr(iniMid)
            postdata = postdata&"&type=Modify"
            postdata = postdata&"&clientIp="&CStr(request.ServerVariables("LOCAL_ADDR"))
            postdata = postdata&"&"&CStr("timestamp")&"="&DateDiff("s", "1970-01-01 09:00:00", now)*1000+clng(timer)
            postdata = postdata&"&tid="&Cstr(myorder.FOneItem.Fpaygatetid)
            postdata = postdata&"&recvName="&Server.URLEncode(Trim(html2db(reqname)))
            postdata = postdata&"&recvPost="&CStr(Trim(reqzipcode))
            postdata = postdata&"&recvAddr1="&Server.URLEncode(Trim(html2db(reqzipaddr)))
            postdata = postdata&"&recvAddr2="&Server.URLEncode(Trim(html2db(reqaddress)))
            postdata = postdata&"&recvTel="&CStr(replace(reqhp,"-",""))

            xmlHttp.open "POST",inimodifyAuthUrl, False
            xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded; charset=utf-8"  ''UTF-8 charset 필요.
            xmlHttp.setTimeouts 90000,90000,90000,90000 ''2013/03/14 추가
            xmlHttp.Send postdata	'post data send
            strData = BinaryToText(xmlHttp.responseBody, "UTF-8")

            Set xmlHttp = nothing

            Set oJSON = New aspJSON
            oJSON.loadJSON(strData)
            resultCode = oJSON.data("resultCode")
            Set oJSON = Nothing
        End If

	end if

    If Err.Number = 0 Then
        errcode = "003"
        '' html2db 사용하지 말것.
        iAsID = RegCSMaster(divcd , orderserial, reguserid, title, contents_jupsu, gubun01, gubun02)
    end if

    If Err.Number = 0 Then
        errcode = "004"
        Call FinishCSMaster(iAsid, finishuser, html2db(contents_finish))
    end if

    '// 이니시스측에 정상적으로 배송지 수정이 되지 않았을시
    If myorder.FOneItem.FAccountDiv = "150" Then
        If resultCode<>"00" Then
            dbget.RollBackTrans
            response.write "<script>alert('데이타를 저장하는 도중에 에러가 발생하였습니다.\r\n(에러코드 : " + CStr(errcode) + resultCode + ")')</script>"
            response.write "<script>history.back()</script>"
            dbget.close()	:	response.End
        End If
    End If

    If Err.Number = 0 Then
        dbget.CommitTrans

        response.write "<script type='text/javascript'>alert('변경 되었습니다.');</script>"
        response.write "<script type='text/javascript'>location.replace('/my10x10/orderPopup/popEditOrderInfo.asp?orderserial="& orderserial &"&etype=recv');</script>"
        dbget.close()	:	response.End
    Else
        dbget.RollBackTrans
        response.write "<script>alert('데이타를 저장하는 도중에 에러가 발생하였습니다.\r\n(에러코드 : " + CStr(errcode) + ")')</script>"
        response.write "<script>history.back()</script>"
        dbget.close()	:	response.End
    End If
    On Error Goto 0

elseif (mode="flow") then
    On Error Resume Next
    dbget.beginTrans

    If Err.Number = 0 Then
        errcode = "001"

        reguserid   = userid
        divcd       = "A900"
        title       = "[고객변경]플라워 배송 정보 수정"
        gubun01     = "C004"
        gubun02     = "CD99"

        contents_jupsu  = ""
        contents_finish = ""
        finishuser      = CFINISH_SYSTEM

        sqlStr = " select top 1 IsNULL(reqdate,'') as reqdate"
        sqlStr = sqlStr + " ,IsNULL(reqtime,'') as reqtime"
        sqlStr = sqlStr + " ,IsNULL(cardribbon,'') as cardribbon"
        sqlStr = sqlStr + " ,IsNULL(message,'') as message"
        sqlStr = sqlStr + " ,IsNULL(fromname,'') as fromname"
        sqlStr = sqlStr + " from [db_order].[dbo].tbl_order_master "
        sqlStr = sqlStr + " where orderserial='" + CStr(orderserial) + "' " + VbCrlf
        rsget.Open sqlStr,dbget,1
        if Not rsget.Eof then
            contents_jupsu = contents_jupsu & "변경 내역" & VbCrlf

            if (db2html(rsget("fromname"))<>fromname) then
                contents_jupsu = contents_jupsu & "플라워 보내시는분: " & rsget("fromname") & CNEXT & fromname & VbCrlf
            end if

            if (rsget("reqdate")<>reqdate) or (rsget("reqtime")<>reqtime) then
                contents_jupsu = contents_jupsu & "플라워 지정일: " & rsget("reqdate") & " " & rsget("reqtime") & CNEXT & reqdate & " " & reqtime & VbCrlf
            end if

            if (rsget("cardribbon")<>cardribbon) then
                contents_jupsu = contents_jupsu & "카드리본: " & getCardRibonName(rsget("cardribbon")) & CNEXT & getCardRibonName(cardribbon) & VbCrlf
            end if

            if (db2html(rsget("message"))<>message) then
                contents_jupsu = contents_jupsu & "메세지: " & rsget("message") & CNEXT & message & VbCrlf
            end if
        end if
        rsget.Close
    end if

    if (contents_jupsu="") then
        response.write "<script type='text/javascript'>alert('수정하실 내역이 기존 내역과 일치합니다. 수정되지 않았습니다.');</script>"
        response.write "<script type='text/javascript'>history.back();</script>"
        dbget.close()	:	response.End
    else
        contents_jupsu = "변경 내역" & VbCrlf & contents_jupsu
        contents_finish = contents_jupsu
    end if

    If Err.Number = 0 Then
        errcode = "002"

        sqlStr = " update [db_order].[dbo].tbl_order_master "     + VbCrlf
        sqlStr = sqlStr + " set cardribbon='" + cardribbon + "'"  + VbCrlf
        if (reqdate<>"") then
            sqlStr = sqlStr + " , reqdate='" + CStr(reqdate) + "'" + VbCrlf
        end if
        sqlStr = sqlStr + " , reqtime='" + CStr(reqtime) + "'" + VbCrlf
        sqlStr = sqlStr + " , message='" + html2db(message) + "'" + VbCrlf
        sqlStr = sqlStr + " , fromname='" + html2db(fromname) + "'" + VbCrlf
        sqlStr = sqlStr + " where orderserial='" + CStr(orderserial) + "' " + VbCrlf

        dbget.Execute sqlStr
    end if

    If Err.Number = 0 Then
        errcode = "003"
        '' html2db 사용하지 말것.
        iAsID = RegCSMaster(divcd , orderserial, reguserid, title, contents_jupsu, gubun01, gubun02)
    end if

    If Err.Number = 0 Then
        errcode = "004"
        Call FinishCSMaster(iAsid, finishuser, html2db(contents_finish))
    end if

    If Err.Number = 0 Then
        dbget.CommitTrans

        response.write "<script type='text/javascript'>alert('변경 되었습니다.');</script>"
        response.write "<script type='text/javascript'>location.replace('/my10x10/orderPopup/popEditOrderInfo.asp?orderserial="& orderserial &"&etype=flow');</script>"
        dbget.close()	:	response.End
    Else
        dbget.RollBackTrans
        response.write "<script>alert('데이타를 저장하는 도중에 에러가 발생하였습니다.\r\n(에러코드 : " + CStr(errcode) + ")')</script>"
        response.write "<script>history.back()</script>"
        dbget.close()	:	response.End
    End If
    On Error Goto 0

elseif (mode="edithandmadereq") then
    ''갯수가 여러개 일때
    if (myorderdetail.FOneItem.FItemNo>1) then
        requiredetail = ""
        for i=0 to myorderdetail.FOneItem.FItemNo-1
            if (request.form("requiredetail"&i)<>"") then
                requiredetail = requiredetail & request.form("requiredetail"&i) & CAddDetailSpliter
            end if
        next

        if Right(requiredetail,2)=CAddDetailSpliter then
            requiredetail = Left(requiredetail,Len(requiredetail)-2)
        end if
    end if

    On Error Resume Next
    dbget.beginTrans

    If Err.Number = 0 Then
        errcode = "001"

        reguserid   = userid
        divcd       = "A900"
        title       = "[고객변경]주문제작 상품 문구 수정"
        gubun01     = "C004"
        gubun02     = "CD99"

        contents_jupsu  = ""
        contents_finish = ""
        finishuser      = CFINISH_SYSTEM

        sqlStr = " select top 1 IsNULL(requiredetail,'') as requiredetail"
        sqlStr = sqlStr + " ,IsNULL(itemname,'') as itemname"
        sqlStr = sqlStr + " ,IsNULL(itemoptionname,'') as itemoptionname"
        sqlStr = sqlStr + " from [db_order].[dbo].tbl_order_detail "
        sqlStr = sqlStr + " where orderserial='" + CStr(orderserial) + "' " + VbCrlf
        sqlStr = sqlStr + " and idx=" + CStr(detailidx)

        rsget.Open sqlStr,dbget,1
        if Not rsget.Eof then

            contents_jupsu = contents_jupsu & "변경 내역" & VbCrlf

            if (db2html(rsget("requiredetail"))<>requiredetail) then
                contents_jupsu = contents_jupsu & "상품명(옵션): " & db2html(rsget("itemname"))
                if (rsget("itemoptionname")<>"") then
                    contents_jupsu = contents_jupsu & "(" & db2html(rsget("itemoptionname")) & ")" & VbCrlf
                end if
                contents_jupsu = contents_jupsu & "문구: " & rsget("requiredetail") & VbCrlf & CNEXT & VbCrlf & requiredetail & VbCrlf
            end if

        end if
        rsget.Close
    end if

    if (contents_jupsu="") then
        response.write "<script type='text/javascript'>alert('수정하실 내역이 기존 내역과 일치합니다. 수정되지 않았습니다.');</script>"
        response.write "<script type='text/javascript'>history.back();</script>"
        dbget.close()	:	response.End
    else
        contents_jupsu = VbCrlf & contents_jupsu
        contents_finish = contents_jupsu
    end if

    If Err.Number = 0 Then
        errcode = "002"

        sqlStr = "update [db_order].[dbo].tbl_order_detail" + VbCrlf
        sqlStr = sqlStr + " set requiredetail='" + html2db(requiredetail) + "'" + VbCrlf
        sqlStr = sqlStr + " where idx=" + CStr(detailidx)

        dbget.Execute sqlStr

        sqlStr = "if exists(" & VbCrlf
        sqlStr = sqlStr & " select top 1 requiredetailUTF8 from [db_order].[dbo].tbl_order_require where detailidx="& detailidx &"" & VbCrlf
        sqlStr = sqlStr & " )" & VbCrlf
        sqlStr = sqlStr & " begin" & VbCrlf
        sqlStr = sqlStr & " update [db_order].[dbo].tbl_order_require set requiredetailUTF8=N'" & trim(html2db(requiredetail)) & "' , lastupdate=getdate() where detailidx="& detailidx &"" & VbCrlf
        sqlStr = sqlStr & " end" & VbCrlf
        sqlStr = sqlStr & " else" & VbCrlf
        sqlStr = sqlStr & " begin" & VbCrlf
        sqlStr = sqlStr & " insert into [db_order].[dbo].tbl_order_require (detailidx, requiredetailUTF8, regdate, lastupdate) values (" & VbCrlf
        sqlStr = sqlStr & " "& trim(detailidx) &", N'" & trim(html2db(requiredetail)) & "', getdate(), getdate())" & VbCrlf
        sqlStr = sqlStr & " end" & VbCrlf
        'response.write sqlStr & "<br>"
        'response.end
        dbget.Execute sqlStr
    end if

    If Err.Number = 0 Then
        errcode = "003"
        '' html2db 사용하지 말것.
        iAsID = RegCSMaster(divcd , orderserial, reguserid, title, contents_jupsu, gubun01, gubun02)
    end if

    If Err.Number = 0 Then
        errcode = "004"
        Call FinishCSMaster(iAsid, finishuser, html2db(contents_finish))
    end if

    If Err.Number = 0 Then
        dbget.CommitTrans

        response.write "<script type='text/javascript'>alert('변경 되었습니다.');</script>"
        response.write "<script type='text/javascript'>location.replace('/my10x10/orderPopup/popEditHandMadeReq.asp?orderserial="& orderserial &"&idx="& detailidx &"');</script>"
        dbget.close()	:	response.End
    Else
        dbget.RollBackTrans
        response.write "<script>alert('데이타를 저장하는 도중에 에러가 발생하였습니다.\r\n(에러코드 : " + CStr(errcode) + ")')</script>"
        response.write "<script>history.back()</script>"
        dbget.close()	:	response.End
    End If
    On Error Goto 0

elseif (mode="editorderinfo") then
    dbget.close()	:	response.End
else
    response.write "<script type='text/javascript'>alert('Not valid Access');</script>"
    response.write "<script type='text/javascript'>history.back();</script>"
    dbget.close()	:	response.End
end if

set myorder = Nothing
set myorderdetail = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
