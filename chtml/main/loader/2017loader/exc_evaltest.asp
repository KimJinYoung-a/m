<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'#######################################################
' Discription : today_상품후기 테스트용
' History : 2018-07-18 이종화 생성
'#######################################################
Dim dailyitems , dailytitle
Dim RvSelNum : RvSelNum = Session.SessionID Mod 2
Dim currentdate : currentdate = Date()

Select Case currentdate
	Case "2018-07-31" 
		dailyitems = "1961599,2023428,1985453"
		dailytitle = "오늘의 먹스타그램"
	Case "2018-08-01" 
		dailyitems = "1493904,1941141,406698"
		dailytitle = "이번 휴가엔 이거 꼭 챙기세요"
	Case "2018-08-02" 
		dailyitems = "1487418,1971903,1980803"
		dailytitle = "폭염 속 불쾌지수 내려주는 아이템"
	Case "2018-08-03" 
		dailyitems = "1313465,1754197,1502651"
		dailytitle = "렛츠 드링크!"
	Case "2018-08-04" 
		dailyitems = "1999929,1982630,1299284"
		dailytitle = "요즘 이 상품이 핫하다던데!"
	Case "2018-08-05" 
		dailyitems = "1890391,1746265,1921831"
		dailytitle = "당신의 삶을 케어해 드립니다."
	Case "2018-08-06" 
		dailyitems = "2022149,1922744,1942276"
		dailytitle = "오늘은 이거야!"
	Case "2018-08-07" 
		dailyitems = "1961599,2023428,1985453"
		dailytitle = "오늘의 먹스타그램"
	Case Else
		dailyitems = ""
		dailytitle = ""
End Select 

Dim itemid, itemname, orgprice, sellprice, basicimage, itemdiv, sellyn, limityn, limitno, limitsold , evalcnt , favcount , imgurl
Dim saleper , soldout , limitRemain
Dim vFdEvalTT : vFdEvalTT = 0 '// 토탈카운트
Dim strSort , oEval

on Error Resume Next

	if dailyitems<>"" then
		'정렬순서 쿼리
		dim srt , arrList , contentHtml
		Dim lp , i
		for each srt in split(dailyitems,",")
			lp = lp +1
			strSort = strSort & "When itemid=" & srt & " then " & lp & " "
		next

		dim sqlStr
		sqlStr = "Select itemid, itemname, orgprice, sellcash, sailyn, basicimage, itemdiv, sellyn, limityn, limitno, limitsold , evalcnt , ic.favcount "
		sqlStr = sqlStr & " from db_item.dbo.tbl_item as i "
		sqlStr = sqlStr & " CROSS APPLY ( "
		sqlStr = sqlStr & "		SELECT favcount FROM db_item.dbo.tbl_item_Contents where itemid = i.itemid "
		sqlStr = sqlStr & "	) as ic "
		sqlStr = sqlStr & " where itemid in (" & dailyitems & ") "
		sqlStr = sqlStr & " order by case " & strSort & " end "
	
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,1
			IF Not (rsget.EOF OR rsget.BOF) THEN
				arrList = rsget.GetRows
			END If
		rsget.close
		
		If isarray(arrList) Then
			For i = 0 To ubound(arrList,2)
				itemid = arrList(0,i)
				itemname = arrList(1,i)
				orgprice = FormatNumber(arrList(2,i),0)
				sellprice = FormatNumber(arrList(3,i),0)
				If (arrList(4,i)="Y") and (arrList(2,i) - arrList(3,i) > 0) THEN
					saleper = CLng((arrList(2,i)-arrList(3,i))/arrList(2,i)*100)
				End If

				If Not(arrList(5,i)="" Or isNull(arrList(5,i))) Then
					imgurl = "http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(itemid) & "/" & arrList(5,i)
				End If
				
				If (arrList(7,i)<>"Y") Or (arrList(8,i)="Y" And arrList(9,i)-arrList(10,i) <= 0) Then
					soldout = "true"
				Else
					soldout = "false"
				End If

				limityn = arrList(8,i)

				If (arrList(8,i)="Y" and arrList(9,i)-arrList(10,i) > 0) Then
					limitRemain = arrList(9,i)-arrList(10,i)
				Else
					limitRemain = "0"
				End If 

				evalcnt = arrList(11,i)
				favcount = arrList(12,i)

				If evalcnt > 0 Then
					Set oEval = new CEvaluateSearcher
					oEval.FRectItemID = itemid
					oEval.getItemEvalTotalPoint

					If oEval.FResultCount > 0 Then
						vFdEvalTT = chkIIF(oEval.FEvalItem.FTotalPoint="" Or isNull(oEval.FEvalItem.FTotalPoint),"0",oEval.FEvalItem.FTotalPoint)
					End if
					Set oEval = Nothing
				End If

				contentHtml = contentHtml & "<li>"
				If RvSelNum = 1 Then '// a/b test
				contentHtml = contentHtml & "	<a href="""" onclick=""fnAmplitudeEventMultiPropertiesAction('click_item_evalcount_test','itemid|type','"& itemid &"|a',function(bool){if(bool) {fnAPPpopupProduct("& itemid &");}});return false;"">"
				Else
				contentHtml = contentHtml & "	<a href="""" onclick=""fnAmplitudeEventMultiPropertiesAction('click_item_evalcount_test','itemid|type','"& itemid &"|b',function(bool){if(bool) {fnAPPpopupProduct("& itemid &");}});return false;"">"
				End If
				contentHtml = contentHtml & "		<div class=""thumbnail""><img src="""& imgurl &""" alt="""& itemname &"""></div>"
				contentHtml = contentHtml & "		<div class=""desc"">"
				contentHtml = contentHtml & "			<p class=""name"">"& itemname &"</p>"
				contentHtml = contentHtml & "			<div class=""price"">"
				If saleper > 0 Then 
				contentHtml = contentHtml & "				<b class=""discount color-red"">"& saleper &"%</b>"
				End If 
				contentHtml = contentHtml & "				<b class=""sum"">"& sellprice &"<span class=""won"">원</span></b>"
				contentHtml = contentHtml & "			</div>"
				If RvSelNum = 1 Then '// a/b test
				contentHtml = contentHtml & "			<div class=""total-review"">"
				contentHtml = contentHtml & "				<span class=""icon icon-rating""><i style=""width:"& CInt(vFdEvalTT * 20) &"%;"">"& CInt(vFdEvalTT * 20) &"점</i></span>"
				contentHtml = contentHtml & "				<span class=""counting"">"& chkIIF(evalcnt > 999,"999+", evalcnt ) &"</span>"
				contentHtml = contentHtml & "			</div>"
				End If 
				contentHtml = contentHtml & "		</div>"
				contentHtml = contentHtml & "	</a>"
				contentHtml = contentHtml & "</li>"

			Next
		End If
	End If

	Dim outHtml
	outHtml = "<div class=""for-you"">"
	outHtml = outHtml & "<h2 class=""headline headline-speech"">"
	outHtml = outHtml & "		<strong class=""label label-color""><em class=""color-blue"">For You </em></strong>"& dailytitle &""
	outHtml = outHtml & "	</h2>"
	outHtml = outHtml & "	<div class=""items"">"
	outHtml = outHtml & "		<ul>"& contentHtml &"</ul>"
	outHtml = outHtml & "	</div>"
	outHtml = outHtml & "</div>"

	Response.write outHtml
	
on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->