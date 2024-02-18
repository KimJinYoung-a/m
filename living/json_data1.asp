<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'// 헤더 출력
Response.ContentType = "application/json"
response.charset = "utf-8"

'//테스트용 실서버 올릴땐 제거
'Call Response.AddHeader("Access-Control-Allow-Origin", "http://stgm.10x10.co.kr")

'#######################################################
' Discription : mobile_fashion_json // 72서버 // 롤링이미지1~8 / 이벤트 1~6
' History : 2018-04-18 이종화 생성
'#######################################################
Dim livingdata : livingdata = ""
Dim itemdata : itemdata = ""
Dim dataList(), dataList2()
Dim json , jcnt, icnt, kcnt, hcnt
Dim sqlStr, sqlStr2
Dim arrList, arrList2 , rsMem, rsMem2
Dim gaparam, gaparam2

Dim gubun , eventname , evturl , eventsubcopy , evtimage1, evtimage2
Dim eName , eNameredsale
Dim itemid, listimage, itemname, sellcash, orgprice, sailyn, itemurl, itemjson
Dim itemcouponyn, itemcoupontype, itemcouponvalue, totalprice, totalsaleper

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName, dummyName2
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "LIVINGDATA_"&Cint(timer/60)
	dummyName2 = "LIVINGEVENTITMEDATA_"&Cint(timer/60)
Else
	cTime = 60*5
	dummyName = "LIVINGDATA"
	dummyName2 = "LIVINGEVENTITMEDATA"
End If
kcnt = 1
hcnt=0
sqlStr = "db_sitemaster.dbo.usp_WWW_LivingEvent_Data_Get"

set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrList = rsMem.GetRows
END IF
rsMem.close

	on Error Resume Next
	
	'//이미지 썸네일

	if isarray(arrList) Then
		ReDim dataList(ubound(arrList,2))
		For jcnt = 0 to ubound(arrList,2)

		
		'기획전 아이템 3종 ########################################################
			sqlStr2 = "db_sitemaster.dbo.usp_WWW_LivingEvent_Item_Get " & arrList(1,jcnt)

			Set rsMem2 = getDBCacheSQL(dbget, rsget, dummyName2, sqlStr2, cTime)
			If Not (rsMem2.EOF Or rsMem2.BOF) Then
				arrList2 = rsMem2.GetRows
			End If
			rsMem2.close
			if isarray(arrList2) Then
			
				ReDim dataList2(ubound(arrList2,2))
				For icnt = 0 To ubound(arrList2,2)
					If jcnt=0 Or jcnt=8 Then
					itemid			= arrList2(0,icnt)
					itemurl			= "/category/category_itemprd.asp?itemid="& itemid
					itemname		= arrList2(1,icnt)
					sellcash		= arrList2(2,icnt)
					orgprice		= arrList2(3,icnt)
					sailyn			= arrList2(4,icnt)
					itemcouponyn	= arrList2(5,icnt)
					itemcoupontype	= arrList2(6,icnt)
					itemcouponvalue = arrList2(7,icnt)
					listimage		= webImgUrl & "/image/basic/" & GetImageSubFolderByItemid(itemid) + "/" & (arrList2(8,icnt))
					'// 가격 할인
					If sailyn = "N" and itemcouponyn = "N" Then
						totalprice = formatNumber(orgPrice,0)
					End If
					If sailyn = "Y" and itemcouponyn = "N" Then
						totalprice = formatNumber(sellCash,0)
					End If

					if itemcouponyn = "Y" And itemcouponvalue>0 Then
						If itemcoupontype = "1" Then
							totalprice =  formatNumber(sellCash - CLng(itemcouponvalue*sellCash/100),0)
						ElseIf itemcoupontype = "2" Then
							totalprice =  formatNumber(sellCash - itemcouponvalue,0)
						ElseIf itemcoupontype = "3" Then
							totalprice =  formatNumber(sellCash,0)
						Else
							totalprice =  formatNumber(sellCash,0)
						End If
					End If
					
					If sailyn = "Y" And itemcouponyn = "Y" And itemcouponvalue>0 Then
						If itemcoupontype = "1" Then
							'//할인 + %쿠폰
							totalsaleper = CLng((orgPrice-(sellCash - CLng(itemcouponvalue*sellCash/100)))/orgPrice*100)
						ElseIf itemcoupontype = "2" Then
							'//할인 + 원쿠폰
							totalsaleper = CLng((orgPrice-(sellCash - itemcouponvalue))/orgPrice*100)
						Else
							'//할인 + 무배쿠폰
							totalsaleper = CLng((orgPrice-sellCash)/orgPrice*100)
						End If
					elseif sailyn = "Y" and itemcouponyn = "N" Then
						If CLng((orgPrice-sellCash)/orgPrice*100)> 0 Then
							totalsaleper = CLng((orgPrice-sellCash)/orgPrice*100) 
						End If
					elseif itemcouponyn = "Y" And itemcouponvalue>0 Then
						If itemcoupontype = "1" Then
							totalsaleper = CStr(itemcouponvalue) 
						ElseIf itemcoupontype = "2" Then
							totalsaleper = ""
						ElseIf itemcoupontype = "3" Then
							totalsaleper = ""
						Else
							totalsaleper = CStr(itemcouponvalue) 
						End If
					Else
							totalsaleper = ""
					End If
					If icnt < 3 Then
						 gaparam2 = "&gaparam=living_event"&jcnt+1&"_0"& icnt+1
					Else
						 gaparam2 = "&gaparam=living_event"&jcnt+1&"_0"& icnt-2
					End If 

					Set itemdata = jsObject()
					itemdata("itemid")		= ""& itemid &""
					itemdata("linkurl")		= ""& itemurl & gaparam2 &""
					itemdata("itemname")		= ""& itemname &""
					itemdata("listimage")	= ""& listimage &""
					itemdata("totalprice")	= ""& totalprice &""
					itemdata("totalsaleper")		= ""& totalsaleper &""
					If ubound(arrList2,2) > 1 Then
					Set dataList2(icnt) = itemdata
					hcnt=icnt
					End If
					End If
				Next
			
			End If
		'##########################################################################


			evturl			= "/event/eventmain.asp?eventid="& db2html(arrList(1,jcnt))
			eventname		= Replace(arrList(11,jcnt),"<br>","")
			eventsubcopy	= Replace(arrList(23,jcnt),"<br>","")
			gubun			= db2html(arrList(28,jcnt))
			evtimage1  = db2html(arrList(22,jcnt))
			evtimage2  = db2html(arrList(24,jcnt))
						
			'//이벤트 명 할인이나 쿠폰시
			If arrList(12,jcnt) Or arrList(14,jcnt) Then
				if ubound(Split(eventname,"|"))> 0 Then
					If arrList(12,jcnt) Or (arrList(12,jcnt) And arrList(14,jcnt)) then
						eName	= cStr(Split(eventname,"|")(0))
						eNameredsale	= cStr(Split(eventname,"|")(1))
					ElseIf arrList(14,jcnt) Then
						eName	= cStr(Split(eventname,"|")(0))
						eNameredsale	= cStr(Split(eventname,"|")(1))
					End If
				Else
					eName = eventname
					eNameredsale	= ""
				end If
			Else
				eName = eventname
				eNameredsale	= ""
			End If

			If jcnt < 8 Then
				 gaparam = "&gaparam=living_event_0"& jcnt+1
			Else
				 gaparam = "&gaparam=living_event_0"& jcnt-7
			End If 

			Set livingdata = jsObject()
				livingdata("gubun")		= ""& gubun &""
				livingdata("linkurl")		= ""& evturl & gaparam &""
				livingdata("image")		= ""& evtimage1 &""
				livingdata("imagewide")	= ""& evtimage2 &""
				livingdata("eventname")	= ""& eName &""
				livingdata("saleper")		= ""& eNameredsale &""
				livingdata("eventsubcopy")	= ""& eventsubcopy &""
				livingdata("itemcnt")		= ""& hcnt &""
				livingdata("itemlist")	= dataList2
			 Set dataList(jcnt) = livingdata
			hcnt=0
			 kcnt=kcnt+1
			 If kcnt=4 Then
				kcnt=1
				jcnt=jcnt+1
			End If
		
		Next

		Response.write Replace(toJSON(dataList),",null","")
	end If

	on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->