<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>

<!-- #include virtual="/login/checkLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/wish/WishCls.asp" -->


<%
	Dim i, sqlStr, vUid, vfIdx, CurrPage, vViewListGubun, vItemSplitData
	Dim vECode

	
	vUid = requestCheckVar(Request("duid"),32)
	vfIdx = getNumeric(requestCheckVar(request("dIdx"),9))
	CurrPage = getNumeric(requestCheckVar(request("dcpg"),9))	
	vViewListGubun = requestCheckVar(Request("dvlg"),32)
	vItemSplitData = requestCheckVar(Request("itemsplitdata"),800)

	If vUid <> getEncLoginUserID() Then
		response.write "<script>alert('위시 상품은 본인만 삭제할 수 있습니다.');</script>"
		response.End
	End If

	If Trim(vUid)="" Or Trim(vViewListGubun)="" Or Trim(vItemSplitData)="" Then
		response.write "<script>alert('정상적인 경로로 접근해주세요');</script>"
		response.End
	End If

	Dim tempvItemSplitData

	tempvItemSplitData = Split(vItemSplitData,",")

	For i=0 To UBound(tempvItemSplitData)

		sqlStr = " Delete From [db_my10x10].[dbo].tbl_myfavorite" + VbCrlf
	    sqlStr = sqlStr + " Where userid='"&vUid&"' And itemid='"&tempvItemSplitData(i)&"' "
	    dbget.Execute sqlStr

		If (GetLoginUserID = "dlwjseh") Or (Now() > #12/23/2020 00:00:00# and Now() < #12/29/2020 23:59:59#) Then
            '위시 삭제시 위시 이벤트 진행기간 동안에는 db_temp.dbo.tbl_wishlist_event 내용도 같이 지워줌
            IF application("Svr_Info") = "Dev" THEN
                vECode   =  "104280"
            Else
                vECode   =  "108614"
            End If
            sqlStr = " Delete From [db_temp].[dbo].tbl_wishlist_event" + VbCrlf
            sqlStr = sqlStr + " Where userid='"&vUid&"' And itemid='"&tempvItemSplitData(i)&"' And evt_code='"&vECode&"' "
            dbget.Execute sqlStr
        End If

	Next

	response.write "<script>top.location.href='myWish.asp?ucid="&Server.UrlEncode(tenEnc(vUid))&"&fIdx="&vfIdx&"&vlg="&vViewListGubun&"&cpg="&CurrPage&"'</script>"
	response.End


%>