<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
'	Description : 비트윈 주문/배송조회 API
'	History	:  2015.05.08 한용민 API용으로 변경/생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/commFunc_api.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/ordercls/csAsfunction.asp" -->
<%
Const CFINISH_SYSTEM = "system"

dim backurl , orderserial , emsAreaCode
dim RcvSiteyyyymmdd
backurl		 = request.ServerVariables("HTTP_REFERER")
orderserial  = requestCheckvar(request("orderserial"),11)

If emsAreaCode = "" Then emsAreaCode = "KR"

if usersn="" then
	response.write "<script type='text/javascript'>alert('고객번호가 없습니다.');</script>"
	dbget.close()	:	response.end
end if

''수령인
dim reqname, reqphone, reqhp
dim reqzipcode, reqzipaddr, reqaddress
dim comment

reqname     = request.Form("reqname")
reqzipaddr  = request.Form("txAddr1")
reqaddress  = request.Form("txAddr2")
comment     = request.Form("comment")

reqhp       = request.Form("reqhp1") + "-" + request.Form("reqhp2") + "-" + request.Form("reqhp3")

reqphone    = request.Form("reqphone1") + "-" + request.Form("reqphone2") + "-" + request.Form("reqphone3")
reqzipcode  = request.Form("txZip")

dim myorder
set myorder = new CMyOrder

''회원주문
myorder.FRectUserID = usersn
myorder.FRectOrderserial = orderserial

if (usersn<>"") and (orderserial<>"") then
	myorder.GetOneOrder
end if

dim IsWebEditEnabled
IsWebEditEnabled = myorder.FOneItem.IsWebOrderInfoEditEnable
if (Not IsWebEditEnabled) then
    response.write "<script language='javascript'>alert('주문/배송정보 수정 가능 상태가 아닙니다. - 고객센터로 문의해 주세요');</script>"
    response.write "<script language='javascript'>history.back();</script>"
    dbget.close()	:	response.End
end If

CONST CNEXT = " => "
dim sqlStr, errcode
dim regusersn, divcd, title, gubun01, gubun02, contents_jupsu, finishuser, contents_finish
dim iAsID
dim preqdate

''주문/배송 정보 수정
    On Error Resume Next
    dbget.beginTrans

    If Err.Number = 0 Then
        errcode = "001"

        regusersn   = usersn
        divcd       = "A900"

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
        response.write "<script language='javascript'>alert('수정하실 내역이 기존 내역과 일치합니다. 수정되지 않았습니다.');</script>"
        response.write "<script language='javascript'>history.back();</script>"
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

		'Response.write sqlStr

		dbget.Execute sqlStr

		If emsAreaCode <> "KR" Then
			' 해외배송 우편번호 업데이트
			Dim emsSQL
			emsSQL = " update [db_order].[dbo].tbl_ems_orderInfo "     + VbCrlf
			emsSQL = emsSQL + " set emsZipcode='" & emsZipcode & "' "   + VbCrlf
			emsSQL = emsSQL + " where orderserial='" + CStr(orderserial) + "' " + VbCrlf
			dbget.Execute emsSQL
		End If

	end if

    If Err.Number = 0 Then
        errcode = "003"
        '' html2db 사용하지 말것.
        iAsID = RegCSMaster(divcd , orderserial, regusersn, title, contents_jupsu, gubun01, gubun02)
    end if

    If Err.Number = 0 Then
        errcode = "004"
        Call FinishCSMaster(iAsid, finishuser, html2db(contents_finish))

    end if

    If Err.Number = 0 Then
        dbget.CommitTrans

        response.write "<script language='javascript'>alert('변경 되었습니다.');</script>"
        response.write "<script language='javascript'>location.replace('" + Cstr(backurl) + "');</script>"
        dbget.close()	:	response.End
    Else
        dbget.RollBackTrans
        response.write "<script>alert('데이타를 저장하는 도중에 에러가 발생하였습니다.\r\n(에러코드 : " + CStr(errcode) + ")')</script>"
        response.write "<script>history.back()</script>"
        dbget.close()	:	response.End
    End If

    On Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
