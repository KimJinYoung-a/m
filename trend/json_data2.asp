<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbEVTopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp" -->
<%
response.charset = "utf-8"

'//테스트용 실서버 올릴땐 제거
'Call Response.AddHeader("Access-Control-Allow-Origin", "http://stgm.10x10.co.kr")

'#######################################################
' Discription : mobile_trend_json // 73서버
' History : 2017-08-21 이종화 생성
'#######################################################
Dim trenddata : trenddata = ""
Dim dataList()
Dim json , jcnt
Dim sqlStr
Dim rsMem , arrList
Dim vKeyName1 , vKeyName2 , vKeyName3 , vKeyName4
Dim vKeyImg1 , vKeyImg2 , vKeyImg3 , vKeyImg4
Dim CtrlDate : CtrlDate = now()
Dim lcnt : lcnt = 0
Dim ii

dim prevDate, sqlDate, vTotalCount , lprevDate , sumDate
Dim saleyn , couponYn , coupontype , couponvalue , orgPrice , sellcash , basicimage, itemdiv
Dim addsql : addsql = ""
Dim userid 

	userid = getEncLoginUserID

	If userid <> "" Then 
		addsql = " @userid = '"& CStr(userid) &"'"
	End If 

	sqlStr = "db_analyze_data_raw.dbo.usp_Ten_trend_data_new_get " & addsql
	rsEVTget.Open sqlStr, dbEVTget, adOpenForwardOnly, adLockReadOnly
	IF Not (rsEVTget.EOF OR rsEVTget.BOF) THEN
		arrList = rsEVTget.GetRows
	END IF
	rsEVTget.close

	on Error Resume Next

	Function gaParam(gubun,num)
		Select Case gubun
			Case 2 
				gaParam = "&gaparam=trend_myview_"&num
			Case 4 
				gaParam = "&gaparam=trend_view_"&num
		End Select
	End Function 
    
    ''gubun2Cnt<6 이면 array에서 제거하자.--
    dim gubun4Cnt, gubun2Cnt, coli,rowi
    dim arrListBuf
    if (isarray(arrList)) Then
        for jcnt = 0 to ubound(arrList,2)
            if (arrList(0,jcnt)="2") then
                gubun2Cnt=gubun2Cnt+1
            end if
            
            if (arrList(0,jcnt)="4") then
                gubun4Cnt=gubun4Cnt+1
            end if
        next
        
        if (gubun2Cnt<6) and (gubun4Cnt>=6) then
            reDim arrListBuf(ubound(arrList),ubound(arrList,2)-gubun2Cnt)
            rowi = 0
            for jcnt = 0 to ubound(arrList,2)
                if (arrList(0,jcnt)<>"2") then
                    for coli=0 to ubound(arrList)
                        arrListBuf(coli,rowi) = arrList(coli,jcnt)
                    next
                    
                    rowi = rowi +1
                end if
            next
            
            reDim arrList(ubound(arrListBuf),ubound(arrListBuf,2))
            rowi = 0
            for jcnt = 0 to ubound(arrListBuf,2)
                for coli=0 to ubound(arrListBuf)
                    arrList(coli,rowi) = arrListBuf(coli,jcnt)
                next
                rowi = rowi +1
            next
        end if
    end if
    ''-------------------------------------
    
	if isarray(arrList) Then
		ReDim dataList(ubound(arrList,2))
		for jcnt = 0 to ubound(arrList,2)

			saleyn		= arrList(8,jcnt)
			couponYn	= arrList(10,jcnt)
			coupontype  = arrList(11,jcnt)
			couponvalue = arrList(14,jcnt)
			orgPrice	= arrList(6,jcnt)
			sellcash	= arrList(5,jcnt)
			itemdiv  = arrList(15,jcnt)

			If itemdiv="21" Then
				if instr(arrList(3,jcnt),"/") > 0 then
					basicimage  = "http://webimage.10x10.co.kr/image/basic/"& arrList(3,jcnt)
				Else
					basicimage  = "http://webimage.10x10.co.kr/image/basic/"& GetImageSubFolderByItemid(arrList(2,jcnt)) &"/"& arrList(3,jcnt)
				End If
			Else
				basicimage  = "http://webimage.10x10.co.kr/image/basic/"& GetImageSubFolderByItemid(arrList(2,jcnt)) &"/"& arrList(3,jcnt)
			End If
			Set trenddata = jsObject()
				trenddata("gubun")			= ""& arrList(0,jcnt) &""
				trenddata("sortkey")		= ""& arrList(1,jcnt) &""
				trenddata("itemid")			= ""& arrList(2,jcnt) &""
				trenddata("itemurl")		= "/category/category_itemPrd.asp?itemid="& arrList(2,jcnt) & gaParam(arrList(0,jcnt),arrList(1,jcnt)) &""
				trenddata("image")			= ""& getThumbImgFromURL(basicimage,400,400,"","") &""
				trenddata("itemname")		= ""& arrList(4,jcnt) &""

				If saleyn = "N" and couponYn = "N" Then
					trenddata("price") = ""&formatNumber(orgPrice,0) &""
				End If
				If saleyn = "Y" and couponYn = "N" Then
					trenddata("price") = ""&formatNumber(sellCash,0) &""
				End If
				if couponYn = "Y" And couponvalue>0 Then
					If coupontype = "1" Then
					trenddata("price") = ""&formatNumber(sellCash - CLng(couponvalue*sellCash/100),0) &""
					ElseIf coupontype = "2" Then
					trenddata("price") = ""&formatNumber(sellCash - couponvalue,0) &""
					ElseIf coupontype = "3" Then
					trenddata("price") = ""&formatNumber(sellCash,0) &""
					Else
					trenddata("price") = ""&formatNumber(sellCash,0) &""
					End If
				End If
				If saleyn = "Y" And couponYn = "Y" And couponvalue>0 Then
					If coupontype = "1" Then
						'//할인 + %쿠폰
						trenddata("sale") = ""& CLng((orgPrice-(sellCash - CLng(couponvalue*sellCash/100)))/orgPrice*100)&"%"
					ElseIf coupontype = "2" Then
						'//할인 + 원쿠폰
						trenddata("sale") = ""& CLng((orgPrice-(sellCash - couponvalue))/orgPrice*100)&"%"
					Else
						trenddata("sale") = ""& CLng((orgPrice-sellCash)/orgPrice*100)&"%"
					End If 
				ElseIf saleyn = "Y" and couponYn = "N" Then
					If CLng((orgPrice-sellCash)/orgPrice*100)> 0 Then
						trenddata("sale") = ""& CLng((orgPrice-sellCash)/orgPrice*100)&"%"
					End If
				elseif saleyn = "N" And couponYn = "Y" And couponvalue>0 Then
					If coupontype = "1" Then
						trenddata("sale") = ""&  CStr(couponvalue) & "%"
					ElseIf coupontype = "2" Then
						trenddata("sale") = "쿠폰"
					ElseIf coupontype = "3" Then
						trenddata("sale") = "쿠폰"
					Else
						trenddata("sale") = ""& couponvalue &"%"
					End If
				Else 
					trenddata("sale") = ""
				End If

			 Set dataList(jcnt) = trenddata
		Next
		Response.write Replace(toJSON(dataList),",null","")
	end If

	on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbEVTclose.asp" -->