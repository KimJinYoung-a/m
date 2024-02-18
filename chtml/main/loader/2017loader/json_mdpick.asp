<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
response.charset = "utf-8"
'#######################################################
' Discription : mobile_mdpick // cache DB경유
' History : 2016-04-27 이종화 생성
' 		  : 2018-09-07 최종원 수정 frontimg 추가
'		  : 2019-05-02 미리보기 기능
'#######################################################

Dim lprevDate , sqlStr , arrMdpick , i 
Dim image , itemname , itemid , sellCash , orgPrice , sailYN , couponYn , couponvalue , LimitYn , tentenimg400
Dim coupontype , newyn , limitno , limitdispyn , makerid , brandname , gubun , linkurl, frontimg
Dim rt_mdpick , rt_new , rt_best , rt_sale , htmlstr'// 2016년 1 2 4 3
Dim rt_mdpick_c , rt_new_c , rt_best_c , rt_sale_c '// 컨텐츠
Dim CtrlTime : CtrlTime = hour(time)
Dim tempnum : tempnum = 1
Dim tempgubun
Dim itemdiv , saleper 'deal 상품용
'미리보기용 변수
dim currentDate, testdate

testdate = request("testdate")
if testdate <> "" Then
	currentDate = cdate(testdate) 
end if

Dim mdpick, newarrival , bestseller , onsale , tagname , bestyn, isLowestPrice

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "MDPICK_"&Cint(timer/60)
Else
'	cTime = 60*5
	cTime = 1*1
	dummyName = "MDPICK"
End If

''//fngaparam 
function fngaParam(gubun)
	if gubun = "" then exit Function
	If gubun = 1 Then
		fngaParam = "&gaparam=today_mdpick_" ''//MDPICK
	ElseIf gubun = 2 Then
		fngaParam = "&gaparam=today_new_" ''//NEW
	ElseIf gubun = 3 Then
		fngaParam = "&gaparam=today_best_" ''//BEST
	ElseIf gubun = 4 Then
		fngaParam = "&gaparam=today_sale_" ''//SALE
	End If 
end Function


'// 세일 상품 여부 '! 
public Function IsSaleItem() 
	IsSaleItem = ((FSaleYn="Y") and (FOrgPrice-FSellCash>0)) 
end Function

'// 신상품 여부 '! 
public Function IsNewItem() 
	IsNewItem =	(datediff("d",FRegdate,now())<= 14)
end Function

	Dim mdpickAB : mdpickAB = Session.SessionID Mod 2
	'// app 만 실험

	if testdate <> "" and GetLoginUserLevel = "7" Then
	'if testdate <> "" Then
		sqlStr = "EXEC db_sitemaster.dbo.usp_Ten_test_Mdpick_ItemListGet '"& currentDate &"' "	
	else
		If isapp And IsVIPUser() Then 
			If mdpickAB = 1 Then '// A그룹이면서 VIP 그룹인 사람
				sqlStr = "db_sitemaster.dbo.usp_Ten_Mdpick_ItemListGet_test @userlevelgubun=2"
			Else
				sqlStr = "db_sitemaster.dbo.usp_Ten_Mdpick_ItemListGet_test @userlevelgubun=1"
			End If 
		Else
			sqlStr = "db_sitemaster.dbo.usp_Ten_Mdpick_ItemListGet "
		End If 
	end if
'response.write testdate
'response.end

	dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,dummyName,sqlStr,cTime)
	If Not rsMem.EOF Then
		arrMdpick 	= rsMem.GetRows
	End if
	rsMem.close

	on Error Resume Next

	If isArray(arrMdpick) and not(isnull(arrMdpick)) Then

		Dim obj ,json
		Set obj = jsObject()
		Set obj("gubun1") = jsArray()
		Set obj("gubun2") = jsArray()
		'Set obj("gubun3") = jsArray()
		Set obj("gubun4") = jsArray()
		Set json = jsArray()
		Set	json(null) = obj ''배열 처리 따로 해줘야함
		'----------
		FOR i=0 to ubound(arrMdpick,2)

			itemname		= db2Html(arrMdpick(5,i))
			itemid			= trim(arrMdpick(2,i))
			sellCash		= arrMdpick(11,i)
			orgPrice		= arrMdpick(12,i)
			sailYN			= arrMdpick(13,i)
			couponYn		= arrMdpick(14,i)
			couponvalue 	= arrMdpick(15,i)
			LimitYn			= arrMdpick(16,i)
			coupontype		= arrMdpick(17,i)
			newyn			= arrMdpick(10,i)
			limitno			= arrMdpick(18,i)
			limitdispyn 	= arrMdpick(19,i)
			makerid			= arrMdpick(20,i)
			brandname		= arrMdpick(21,i)
			gubun			= arrMdpick(22,i) '//gubun mdpick , rookie , chance , best
			itemdiv			= arrMdpick(24,i)
			saleper			= arrMdpick(25,i)
			frontimg		= arrMdpick(26,i)
			isLowestPrice	= arrMdpick(27,i)
			If Trim(isLowestPrice) = "" or ISNULL(isLowestPrice) or Trim(isLowestPrice)="N" Then
				isLowestPrice = 0
			Else
				isLowestPrice = 1
			End If

			If itemdiv = "21" Then
				if instr(db2Html(arrMdpick(6,i)),"/") > 0 then
					tentenimg400= webImgUrl & "/image/tenten400/" + GetImageSubFolderByItemid(db2Html(arrMdpick(2,i))) + "/" + db2Html(arrMdpick(23,i))
					image		= webImgUrl & "/image/basic/" + db2Html(arrMdpick(6,i))
				Else
					tentenimg400= webImgUrl & "/image/tenten400/" + GetImageSubFolderByItemid(db2Html(arrMdpick(2,i))) + "/" + db2Html(arrMdpick(23,i))
					image		= webImgUrl & "/image/basic/" + GetImageSubFolderByItemid(db2Html(arrMdpick(2,i))) + "/" + db2Html(arrMdpick(6,i))
				End If
			Else
				tentenimg400= webImgUrl & "/image/tenten400/" + GetImageSubFolderByItemid(db2Html(arrMdpick(2,i))) + "/" + db2Html(arrMdpick(23,i))
				image		= webImgUrl & "/image/basic/" + GetImageSubFolderByItemid(db2Html(arrMdpick(2,i))) + "/" + db2Html(arrMdpick(6,i))
			End If 

			If tempgubun <> gubun Then tempnum = 1

			tagname = ""
			If newyn = "Y" Then tagname = "NEW"

			If gubun <> 3 then
				If db2Html(arrMdpick(23,i)) = "" Or isnull(db2Html(arrMdpick(23,i))) Then '//tentenimg
					tentenimg400 = ""
				End If 
				
				Set obj("gubun"& gubun &"")(null) = jsObject()
					obj("gubun"& gubun &"")(null)("gubun") = ""& gubun &""
				If isapp = "1" Then
					obj("gubun"& gubun &"")(null)("link") = ""& itemid & fngaParam(gubun) & (tempnum) &""
				Else
					obj("gubun"& gubun &"")(null)("link") = "/category/category_itemPrd.asp?itemid="& itemid & fngaParam(gubun) & (tempnum) &""
				End If 

				If frontimg <> "" Then
					obj("gubun"& gubun &"")(null)("imgsrc") = ""& frontimg &""
				Else
					If application("Svr_Info") = "Dev" Then
						obj("gubun"& gubun &"")(null)("imgsrc") = ""& chkiif(Not(isnull(tentenimg400) Or tentenimg400 = ""),tentenimg400,image) &""
					Else
						obj("gubun"& gubun &"")(null)("imgsrc") = ""& chkiif(Not(isnull(tentenimg400) Or tentenimg400 = ""),tentenimg400,getThumbImgFromURL(image,200,200,"true","false")) &""
					End If 
				End if

					'//최저가 표시유무
					obj("gubun"& gubun &"")(null)("islowestprice") = ""& isLowestPrice &""					

					obj("gubun"& gubun &"")(null)("alt") = ""& CStr(itemname) &""
					obj("gubun"& gubun &"")(null)("name") = ""& CStr(itemname) &""
					
					If itemdiv = "21" Then 
						obj("gubun"& gubun &"")(null)("price") = ""&formatNumber(sellCash,0) &""
						If saleper > 0 Then
						obj("gubun"& gubun &"")(null)("sale") = ""& saleper &"%"
						Else
						obj("gubun"& gubun &"")(null)("sale") = ""
						End If
						obj("gubun"& gubun &"")(null)("sale_coupontag") = "1" '//sale 
					else
						If sailYN = "N" and couponYn = "N" Then
							obj("gubun"& gubun &"")(null)("price") = ""&formatNumber(orgPrice,0) &""
						End If
						If sailYN = "Y" and couponYn = "N" Then
							obj("gubun"& gubun &"")(null)("price") = ""&formatNumber(sellCash,0) &""
						End If
						if couponYn = "Y" And couponvalue>0 Then
							If coupontype = "1" Then
							obj("gubun"& gubun &"")(null)("price") = ""&formatNumber(sellCash - CLng(couponvalue*sellCash/100),0) &""
							ElseIf coupontype = "2" Then
							obj("gubun"& gubun &"")(null)("price") = ""&formatNumber(sellCash - couponvalue,0) &""
							ElseIf coupontype = "3" Then
							obj("gubun"& gubun &"")(null)("price") = ""&formatNumber(sellCash,0) &""
							Else
							obj("gubun"& gubun &"")(null)("price") = ""&formatNumber(sellCash,0) &""
							End If
						End If
						If sailYN = "Y" And couponYn = "Y" Then
							If coupontype = "1" Then
								'//할인 + %쿠폰
								obj("gubun"& gubun &"")(null)("sale") = ""& CLng((orgPrice-(sellCash - CLng(couponvalue*sellCash/100)))/orgPrice*100)&"%"
							ElseIf coupontype = "2" Then
								'//할인 + 원쿠폰
								obj("gubun"& gubun &"")(null)("sale") = ""& CLng((orgPrice-(sellCash - couponvalue))/orgPrice*100)&"%"
							Else
								'//할인 + 무배쿠폰
								obj("gubun"& gubun &"")(null)("sale") = ""& CLng((orgPrice-sellCash)/orgPrice*100)&"%"
							End If 
							obj("gubun"& gubun &"")(null)("sale_coupontag") = "1" '//sale coupon 둘다 있을 경우 세일 우선
						ElseIf sailYN = "Y" and couponYn = "N" Then
							If CLng((orgPrice-sellCash)/orgPrice*100)> 0 Then
								obj("gubun"& gubun &"")(null)("sale") = ""& CLng((orgPrice-sellCash)/orgPrice*100)&"%"
							End If
							obj("gubun"& gubun &"")(null)("sale_coupontag") = "1" '//sale 
						elseif sailYN = "N" And couponYn = "Y" And couponvalue>0 Then
							If coupontype = "1" Then
								obj("gubun"& gubun &"")(null)("sale") = ""&  CStr(couponvalue) & "%"
							ElseIf coupontype = "2" Then
								obj("gubun"& gubun &"")(null)("sale") = "쿠폰"
							ElseIf coupontype = "3" Then
								obj("gubun"& gubun &"")(null)("sale") = "쿠폰"
							Else
								obj("gubun"& gubun &"")(null)("sale") = ""& couponvalue &"%"
							End If
							obj("gubun"& gubun &"")(null)("sale_coupontag") = "2" '//coupon 
						Else 
							obj("gubun"& gubun &"")(null)("sale") = ""
							obj("gubun"& gubun &"")(null)("sale_coupontag") = "" '//sale coupon 둘다 해당 안됨 
						End If
					End If 

				If LimitYn="Y" And limitdispyn = "Y" then
					obj("gubun"& gubun &"")(null)("itemno") = ""& limitno &""
				End If
					'//tag 유무
					obj("gubun"& gubun &"")(null)("tagname") = ""& tagname &""

				If gubun = 1 Then
					If isapp And IsVIPUser() Then 
						If mdpickAB = 1 Then '// A그룹이면서 VIP 그룹인 사람
							obj("gubun"& gubun &"")(null)("ampevt") = "click_maintodaymdpick_vips"
							obj("gubun"& gubun &"")(null)("ampevtp") = "todaymdpicknumber|itemid|categoryname|brand_id|type"
							obj("gubun"& gubun &"")(null)("ampevtpv") = tempnum&"|"&itemid&"|"&fnItemIdToCategory1DepthName(itemid)&"|"&fnItemIdToBrandName(itemid)&"|test"
						Else
							obj("gubun"& gubun &"")(null)("ampevt") = "click_maintodaymdpick_vips"
							obj("gubun"& gubun &"")(null)("ampevtp") = "todaymdpicknumber|itemid|categoryname|brand_id|type"
							obj("gubun"& gubun &"")(null)("ampevtpv") = tempnum&"|"&itemid&"|"&fnItemIdToCategory1DepthName(itemid)&"|"&fnItemIdToBrandName(itemid)&"|control"
						End If
					Else 
						obj("gubun"& gubun &"")(null)("ampevt") = "click_maintodaymdpick"
						obj("gubun"& gubun &"")(null)("ampevtp") = "todaymdpicknumber|itemid|categoryname|brand_id"
						obj("gubun"& gubun &"")(null)("ampevtpv") = tempnum&"|"&itemid&"|"&fnItemIdToCategory1DepthName(itemid)&"|"&fnItemIdToBrandName(itemid)
					End If 
				ElseIf gubun = 2 Then
					obj("gubun"& gubun &"")(null)("ampevt") = "click_maintodaynew"
					obj("gubun"& gubun &"")(null)("ampevtp") = "todaynewnumber|itemid"
					obj("gubun"& gubun &"")(null)("ampevtpv") = tempnum &"|"& itemid
				ElseIf gubun = 3 Then
					obj("gubun"& gubun &"")(null)("ampevt") = "click_maintodaybest"
					obj("gubun"& gubun &"")(null)("ampevtp") = "todaybestnumber|itemid"
					obj("gubun"& gubun &"")(null)("ampevtpv") = tempnum &"|"& itemid
				ElseIf gubun = 4 Then
					obj("gubun"& gubun &"")(null)("ampevt") = "click_maintodaysale"
					obj("gubun"& gubun &"")(null)("ampevtp") = "todaysalenumber|itemid"
					obj("gubun"& gubun &"")(null)("ampevtpv") = tempnum &"|"& itemid
				End If 
			End If
			
			tempnum = tempnum + 1
			tempgubun = gubun '// 구분값
		Next
	End If

	Response.write toJSON(json)

	on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->