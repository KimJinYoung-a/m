<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp" -->
<%
response.charset = "utf-8"

'//테스트용 실서버 올릴땐 제거
'Call Response.AddHeader("Access-Control-Allow-Origin", "http://testm.10x10.co.kr:8080")

'#######################################################
' Discription : mobile_trend_json // 72서버
' History : 2017-08-21 이종화 생성
'#######################################################
Dim trenddata : trenddata = ""
Dim Ncatecode , Ncatename , Nbrandname
Dim dataList()
Dim json , jcnt , icnt
Dim sqlStr
Dim arrList
Dim vKeyName1 , vKeyName2 , vKeyName3 , vKeyName4
Dim vKeyImg1 , vKeyImg2 , vKeyImg3 , vKeyImg4
Dim CtrlDate : CtrlDate = now()
Dim lcnt : lcnt = 0
Dim ii

dim prevDate, sqlDate, vTotalCount , lprevDate , sumDate
Dim saleyn , couponYn , coupontype , couponvalue , orgPrice , sellcash , basicimage , gubun , itemURL
Dim addsql : addsql = ""
Dim userid 
Dim dt , itemcouponname , brand , itemcouponidx
Dim couponflag
Dim arrNameList , sortnum

	userid = getEncLoginUserID

	If userid <> "" Then 
		addsql = " @userid = '"& CStr(userid) &"'"
	End If 

	sqlStr = "db_sitemaster.dbo.usp_Ten_trend_data_get" & addsql
	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr,dbget,1
		IF Not (rsget.EOF OR rsget.BOF) THEN
			arrList = rsget.GetRows
		END If
	rsget.close

	sqlStr = "db_sitemaster.dbo.usp_Ten_trend_name_get"
	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr,dbget,1
		IF Not (rsget.EOF OR rsget.BOF) THEN
			arrNameList = rsget.GetRows
		END If
	rsget.close


	on Error Resume Next

	Function gaParam(gubun,num)
		Select Case gubun
			Case 1 
				gaParam = "&gaparam=trend_buy_"&num
			Case 5 
				gaParam = "&gaparam=trend_mycart_"&num
			Case 6 
				gaParam = "&gaparam=trend_cart_"&num
			Case 7 
				gaParam = "&gaparam=trend_branda_"&num
			Case 9 
				gaParam = "&gaparam=trend_mywish_"&num
			Case 10 
				gaParam = "&gaparam=trend_wish_"&num
			Case 11 
				gaParam = "&gaparam=trend_event_"&num
			Case 12 
				gaParam = "&gaparam=trend_cate_"&num
			Case 13 
				gaParam = "&gaparam=trend_coupon_"&num
		End Select
	End Function 

	Function fnBrandname(makerid)
		sqlStr = " select top 1 (Case When isNull(i.frontMakerid,'')='' then c.SocName else c2.SocName end) as BrandName "
		sqlStr = sqlStr & "	from db_item.dbo.tbl_item as i "
		sqlStr = sqlStr & " left outer join [db_user].[dbo].tbl_user_c as c "
		sqlStr = sqlStr & " on i.makerid = c.userid "
		sqlStr = sqlStr & " LEFT JOIN [db_user].[dbo].tbl_user_c c2 "
		sqlStr = sqlStr & " on i.frontMakerid= c2.userid "
		sqlStr = sqlStr & " where makerid = '"& makerid &"' "

		rsget.Open sqlStr,dbget,1
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnBrandname = rsget("BrandName")
		END If
		rsget.close
	End function
	
	'//이미지 썸네일
	Function chgimg(gubun)
		Select Case gubun
			Case 1 , 6 , 7 ,10 , 12 , 13
					chgimg = getThumbImgFromURL(basicimage,400,400,"","")
			Case 5 , 9
					chgimg = basicimage 'getThumbImgFromURL(basicimage,600,600,"","")
			Case 11
					chgimg = basicimage
		End Select 
	End Function
	
	if isarray(arrList) Then
		ReDim dataList(ubound(arrList,2))
		for jcnt = 0 to ubound(arrList,2)

			gubun		= arrList(0,jcnt)
			sortnum		= arrList(1,jcnt)
			If sortnum  = "" Then sortnum = 0
			saleyn		= arrList(8,jcnt)
			couponYn	= arrList(10,jcnt)
			coupontype  = arrList(11,jcnt)
			couponvalue = arrList(14,jcnt)
			orgPrice	= arrList(6,jcnt)
			sellcash	= arrList(5,jcnt)
			itemcouponname = arrList(16,jcnt)
			brand		   = arrList(17,jcnt)
			itemcouponidx  = arrList(18,jcnt)

			If gubun = "7" Or gubun = "12" then
				If isarray(arrNameList) Then
					For icnt = 0 To ubound(arrNameList,2)
						If gubun = arrNameList(0,icnt) Then '//7번 12번만 참조
							Ncatecode = arrNameList(1,icnt)
							Ncatename = arrNameList(2,icnt)
							Nbrandname = arrNameList(3,icnt)
						End If 
					Next 
				End If 
			End If 

			If couponYn = "Y" Then couponflag = "2"
			If saleyn = "Y" Then couponflag = "1"

			'//쿠폰 마감일자 gubun 13
			dt = "D-"& Replace(datediff("D",CDate(arrList(15,jcnt)),Date()),"-","")

			If gubun <> "11" then
				basicimage  = "http://webimage.10x10.co.kr/image/basic/"& GetImageSubFolderByItemid(arrList(2,jcnt)) &"/"& arrList(3,jcnt)
			Else
				basicimage  = arrList(3,jcnt)
			End if

			If gubun <> "11" then
				itemURL		= "/category/category_itemPrd.asp?itemid="& arrList(2,jcnt) & gaParam(gubun,sortnum)
			Else
				itemURL		= "/event/eventmain.asp?eventid="& arrList(2,jcnt) & gaParam(gubun,sortnum)
			End If 

			Set trenddata = jsObject()
				trenddata("gubun")			= ""& gubun &""
				trenddata("sortkey")		= ""& sortnum &""
				trenddata("itemid")			= ""& arrList(2,jcnt) &""
				trenddata("itemurl")		= ""& itemURL &""
				trenddata("image")			= ""& chgimg(gubun) &""
				trenddata("itemname")		= ""& arrList(4,jcnt) &""

				'// 7번 12번만 추가 항목
				If gubun = "7" Or gubun = "12" Then
					If gubun = "12" Then 
						'trenddata("catecode")	= ""& Ncatecode &""
						trenddata("cateurl")	= "/category/category_detail2020.asp?disp="& Ncatecode & gaParam(gubun,0) &""
					End If 
					trenddata("catename")		= ""& Ncatename &""
					If gubun = "7" Then 
						trenddata("brandname")	= ""& Nbrandname &""
						trenddata("brandurl")	= "/brand/brand_detail2020.asp?brandid="& Ncatename & gaParam(gubun,0) &""
					End If 
				End If 

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

				If gubun = "7" Or gubun = "9" Then
					trenddata("brand") = ""& fnBrandname(brand) &""
				End If 

				If gubun = "11" Then '//이벤트용 subcopy
					trenddata("subcopy") = ""& itemcouponname &""
					trenddata("couponflag") = ""& couponflag &""
					
					If saleyn = "Y" Or couponYn = "Y" Then
						if ubound(Split(arrList(4,jcnt),"|"))> 0 Then
							If saleyn = "Y" Or couponYn = "Y" then
								trenddata("itemname") = ""& Replace(cStr(Split(arrList(4,jcnt),"|")(0)),"<br/>","") &""
								trenddata("sale") = ""& cStr(Split(arrList(4,jcnt),"|")(1)) &""
							End If 
						Else
							trenddata("itemname") = ""& Replace(arrList(4,jcnt),"<br/>","") &""
							trenddata("sale") = ""
						end If
					Else
						trenddata("itemname") = ""& Replace(arrList(4,jcnt),"<br/>","") &""
						trenddata("sale") = ""
					End If 

				End If 

				If gubun = "13" Then '//item쿠폰용
					trenddata("dt") = ""& dt &""
					trenddata("itemcouponname") = ""& itemcouponname &""
					trenddata("itemcouponidx")  = ""& itemcouponidx &""
					trenddata("coupontype")		= ""& coupontype &""
					trenddata("couponurl")		= "/my10x10/Pop_CouponItemList.asp?itemcouponidx="& itemcouponidx & gaParam(gubun,sortnum) &""

					If coupontype = "1" Then
						trenddata("sale") = ""&  CStr(couponvalue) & ""
					ElseIf coupontype = "2" Then
						trenddata("sale") = ""&  CStr(couponvalue) & ""
					ElseIf coupontype = "3" Then
						trenddata("sale") = "무료배송"
					Else
						trenddata("sale") = ""& couponvalue &"%"
					End If

				End If 

			 Set dataList(jcnt) = trenddata
		Next

		Response.write Replace(toJSON(dataList),",null","")
	end If

	on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
