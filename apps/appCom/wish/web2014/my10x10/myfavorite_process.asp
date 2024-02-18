<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>

<!-- #include virtual="/apps/appCom/wish/web2014/login/checkLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/badgelibUTF8.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<!-- #include virtual="/apps/appCom/wish/protoV2/inAppComm_function.asp"-->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->

</head>

<%

dim i, sqlStr
dim userid, bagarray, mode, itemid, vIsPop, vECode
dim backurl,fidx,oldfidx
dim arrList, intLoop

userid  	= getEncLoginUserID
bagarray	= Trim(requestCheckvar(request("bagarray"),1024))
mode    	= requestCheckvar(request("mode"),16)
itemid  	= request("itemid")
fidx		= requestCheckvar(request("fidx"),9)
backurl =  requestCheckvar(request("backurl"),100)
oldfidx	= requestCheckvar(request("oldfidx"),9)
vIsPop		= requestCheckvar(request("ispop"),3)


if backurl ="" then backurl = request.ServerVariables("HTTP_REFERER")
dim myfavorite, vWishEventOX
vWishEventOX = "x"
'####### 위시리스트 이벤트용으로 구분값에 따라 데이터 처리.

set myfavorite = new CMyFavorite
	'---데이터 처리
	myfavorite.FRectUserID = userid
	myfavorite.FFolderIdx = fidx

	arrList = myfavorite.fnGetFolderList

	If Now() > #09/23/2015 00:00:00# AND Now() < #10/01/2015 00:00:00# Then
		IF isArray(arrList) THEN
			For intLoop = 0 To UBound(arrList,2)
				If trim(arrList(1,intLoop)) = "드래곤볼 Z" AND CStr(arrList(0,intLoop)) = CStr(fidx) Then
					vWishEventOX = "o"
						IF application("Svr_Info") = "Dev" THEN
							vECode = "64896"
						Else
							vECode = "66390"
						End If
				End If
				If trim(arrList(1,intLoop)) = "드래곤볼 Z" AND CStr(arrList(0,intLoop)) = CStr(oldfidx) AND mode = "Change" Then
					vWishEventOX = "c"
						IF application("Svr_Info") = "Dev" THEN
							vECode = "64896"
						Else
							vECode = "66390"
						End If
				End If
			Next
		End If
	End If

	If Now() > #08/24/2015 00:00:00# AND Now() < #08/31/2015 00:00:00# Then
		IF isArray(arrList) THEN
			For intLoop = 0 To UBound(arrList,2)
				If trim(arrList(1,intLoop)) = "내가 꿈꾸는 키친" AND CStr(arrList(0,intLoop)) = CStr(fidx) Then
					vWishEventOX = "o"
						IF application("Svr_Info") = "Dev" THEN
							vECode = "64860"
						Else
							vECode = "65703"
						End If
				End If
				If trim(arrList(1,intLoop)) = "내가 꿈꾸는 키친" AND CStr(arrList(0,intLoop)) = CStr(oldfidx) AND mode = "Change" Then
					vWishEventOX = "c"
						IF application("Svr_Info") = "Dev" THEN
							vECode = "64860"
						Else
							vECode = "65703"
						End If
				End If
			Next
		End If
	End If

	If Now() > #08/31/2015 00:00:00# AND Now() < #09/07/2015 00:00:00# Then
		IF isArray(arrList) THEN
			For intLoop = 0 To UBound(arrList,2)
				If trim(arrList(1,intLoop)) = "내가 꿈꾸는 서재" AND CStr(arrList(0,intLoop)) = CStr(fidx) Then
					vWishEventOX = "o"
						IF application("Svr_Info") = "Dev" THEN
							vECode = "64866"
						Else
							vECode = "65808"
						End If
				End If
				If trim(arrList(1,intLoop)) = "내가 꿈꾸는 서재" AND CStr(arrList(0,intLoop)) = CStr(oldfidx) AND mode = "Change" Then
					vWishEventOX = "c"
						IF application("Svr_Info") = "Dev" THEN
							vECode = "64866"
						Else
							vECode = "65808"
						End If
				End If
			Next
		End If
	End If


	If Now() >= #09/07/2015 00:00:00# AND Now() < #09/14/2015 00:00:00# Then
		IF isArray(arrList) THEN
			For intLoop = 0 To UBound(arrList,2)
				If trim(arrList(1,intLoop)) = "내가 꿈꾸는 침실" AND CStr(arrList(0,intLoop)) = CStr(fidx) Then
					vWishEventOX = "o"
						IF application("Svr_Info") = "Dev" THEN
							vECode = "64876"
						Else
							vECode = "65972"
						End If
				End If
				If trim(arrList(1,intLoop)) = "내가 꿈꾸는 침실" AND CStr(arrList(0,intLoop)) = CStr(oldfidx) AND mode = "Change" Then
					vWishEventOX = "c"
						IF application("Svr_Info") = "Dev" THEN
							vECode = "64876"
						Else
							vECode = "65972"
						End If
				End If
			Next
		End If
	End If

	If Now() > #09/14/2015 00:00:00# AND Now() < #09/21/2015 00:00:00# Then
		IF isArray(arrList) THEN
			For intLoop = 0 To UBound(arrList,2)
				If trim(arrList(1,intLoop)) = "내가 꿈꾸는 거실" AND CStr(arrList(0,intLoop)) = CStr(fidx) Then
					vWishEventOX = "o"
						IF application("Svr_Info") = "Dev" THEN
							vECode = "64881"
						Else
							vECode = "66102"
						End If
				End If
				If trim(arrList(1,intLoop)) = "내가 꿈꾸는 거실" AND CStr(arrList(0,intLoop)) = CStr(oldfidx) AND mode = "Change" Then
					vWishEventOX = "c"
						IF application("Svr_Info") = "Dev" THEN
							vECode = "64881"
						Else
							vECode = "66102"
						End If
				End If
			Next
		End If
	End If

'	If Now() > #03/23/2015 00:00:00# AND Now() < #04/21/2015 00:00:00# Then
'		IF isArray(arrList) THEN
'			For intLoop = 0 To UBound(arrList,2)
'				If trim(arrList(1,intLoop)) = "마이 웨딩 위시" AND CStr(arrList(0,intLoop)) = CStr(fidx) Then
'					vWishEventOX = "o"
'						IF application("Svr_Info") = "Dev" THEN
'							vECode = "21511"
'						Else
'							vECode = "60386"
'						End If
'				End If
'				If trim(arrList(1,intLoop)) = "마이 웨딩 위시" AND CStr(arrList(0,intLoop)) = CStr(oldfidx) AND mode = "Change" Then
'					vWishEventOX = "c"
'						IF application("Svr_Info") = "Dev" THEN
'							vECode = "21511"
'						Else
'							vECode = "60386"
'						End If
'				End If
'			Next
'		End If
'	End If
'
'	If Now() > #04/03/2015 00:00:00# AND Now() < #04/13/2015 00:00:00# Then
'		IF isArray(arrList) THEN
'			For intLoop = 0 To UBound(arrList,2)
'				If trim(arrList(1,intLoop)) = "위시리스트를 부탁해" AND CStr(arrList(0,intLoop)) = CStr(fidx) Then
'					vWishEventOX = "o"
'						IF application("Svr_Info") = "Dev" THEN
'							vECode = "21536"
'						Else
'							vECode = "61006"
'						End If
'				End If
'				If trim(arrList(1,intLoop)) = "위시리스트를 부탁해" AND CStr(arrList(0,intLoop)) = CStr(oldfidx) AND mode = "Change" Then
'					vWishEventOX = "c"
'						IF application("Svr_Info") = "Dev" THEN
'							vECode = "21536"
'						Else
'							vECode = "61006"
'						End If
'				End If
'			Next
'		End If
'	End If

	If Now() > #09/22/2015 00:00:00# AND Now() < #09/28/2015 00:00:00# Then
		IF isArray(arrList) THEN
			For intLoop = 0 To UBound(arrList,2)
				If trim(arrList(1,intLoop)) = "달님" AND CStr(arrList(0,intLoop)) = CStr(fidx) Then
					vWishEventOX = "o"
						IF application("Svr_Info") = "Dev" THEN
							vECode = "64894"
						Else
							vECode = "66331"
						End If
				End If
				If trim(arrList(1,intLoop)) = "달님" AND CStr(arrList(0,intLoop)) = CStr(oldfidx) AND mode = "Change" Then
					vWishEventOX = "c"
						IF application("Svr_Info") = "Dev" THEN
							vECode = "64894"
						Else
							vECode = "66331"
						End If
				End If
			Next
		End If
	End If

	If Now() > #11/05/2015 00:00:00# AND Now() < #11/14/2015 00:00:00# Then
		IF isArray(arrList) THEN
			For intLoop = 0 To UBound(arrList,2)
				If trim(arrList(1,intLoop)) = "습격자들" AND CStr(arrList(0,intLoop)) = CStr(fidx) Then
					vWishEventOX = "o"
						IF application("Svr_Info") = "Dev" THEN
							vECode = "65944"
						Else
							vECode = "67204"
						End If
				End If
				If trim(arrList(1,intLoop)) = "습격자들" AND CStr(arrList(0,intLoop)) = CStr(oldfidx) AND mode = "Change" Then
					vWishEventOX = "c"
						IF application("Svr_Info") = "Dev" THEN
							vECode = "65944"
						Else
							vECode = "67204"
						End If
				End If
			Next
		End If
	End If

	If Now() > #12/14/2015 00:00:00# AND Now() < #12/21/2015 00:00:00# Then
		IF isArray(arrList) THEN
			For intLoop = 0 To UBound(arrList,2)
				If trim(arrList(1,intLoop)) = "크리스마스 선물" AND CStr(arrList(0,intLoop)) = CStr(fidx) Then
					vWishEventOX = "o"
						IF application("Svr_Info") = "Dev" THEN
							vECode = "65981"
						Else
							vECode = "67490"
						End If
				End If
				If trim(arrList(1,intLoop)) = "크리스마스 선물" AND CStr(arrList(0,intLoop)) = CStr(oldfidx) AND mode = "Change" Then
					vWishEventOX = "c"
						IF application("Svr_Info") = "Dev" THEN
							vECode = "65981"
						Else
							vECode = "67490"
						End If
				End If
			Next
		End If
	End If

	If Now() > #12/28/2015 00:00:00# AND Now() < #01/04/2016 00:00:00# Then
		IF isArray(arrList) THEN
			For intLoop = 0 To UBound(arrList,2)
				If trim(arrList(1,intLoop)) = "2016 소원수리" AND CStr(arrList(0,intLoop)) = CStr(fidx) Then
					vWishEventOX = "o"
						IF application("Svr_Info") = "Dev" THEN
							vECode = "65994"
						Else
							vECode = "68315"
						End If
				End If
				If trim(arrList(1,intLoop)) = "2016 소원수리" AND CStr(arrList(0,intLoop)) = CStr(oldfidx) AND mode = "Change" Then
					vWishEventOX = "c"
						IF application("Svr_Info") = "Dev" THEN
							vECode = "65994"
						Else
							vECode = "68315"
						End If
				End If
			Next
		End If
	End If

	If Now() > #02/10/2016 10:00:00# AND Now() < #02/15/2016 00:00:00# Then
		IF isArray(arrList) THEN
			For intLoop = 0 To UBound(arrList,2)
				If trim(arrList(1,intLoop)) = "오늘은 털날" AND CStr(arrList(0,intLoop)) = CStr(fidx) Then
					vWishEventOX = "o"
						IF application("Svr_Info") = "Dev" THEN
							vECode = "66021"
						Else
							vECode = "68889"
						End If
				End If
				If trim(arrList(1,intLoop)) = "오늘은 털날" AND CStr(arrList(0,intLoop)) = CStr(oldfidx) AND mode = "Change" Then
					vWishEventOX = "c"
						IF application("Svr_Info") = "Dev" THEN
							vECode = "66021"
						Else
							vECode = "68889"
						End If
				End If
			Next
		End If
	End If

	If Now() > #04/04/2016 00:00:00# AND Now() < #04/08/2016 23:59:59# Then
		IF isArray(arrList) THEN
			For intLoop = 0 To UBound(arrList,2)
				If trim(arrList(1,intLoop)) = "PROWISH 101" AND CStr(arrList(0,intLoop)) = CStr(fidx) Then
					vWishEventOX = "o"
						IF application("Svr_Info") = "Dev" THEN
							vECode = "66096"
						Else
							vECode = "69919"
						End If
				End If
				If trim(arrList(1,intLoop)) = "PROWISH 101" AND CStr(arrList(0,intLoop)) = CStr(oldfidx) AND mode = "Change" Then
					vWishEventOX = "c"
						IF application("Svr_Info") = "Dev" THEN
							vECode = "66096"
						Else
							vECode = "69919"
						End If
				End If
			Next
		End If
	End If

	If Now() > #05/26/2016 00:00:00# AND Now() < #06/06/2016 00:00:00# Then
		IF isArray(arrList) THEN
			For intLoop = 0 To UBound(arrList,2)
				If trim(arrList(1,intLoop)) = "또! 담아영" AND CStr(arrList(0,intLoop)) = CStr(fidx) Then
					vWishEventOX = "o"
						IF application("Svr_Info") = "Dev" THEN
							vECode   =  "66139"
						Else
							vECode   =  "70923"
						End If
				End If
				If trim(arrList(1,intLoop)) = "또! 담아영" AND CStr(arrList(0,intLoop)) = CStr(oldfidx) AND mode = "Change" Then
					vWishEventOX = "c"
						IF application("Svr_Info") = "Dev" THEN
							vECode   =  "66139"
						Else
							vECode   =  "70923"
						End If
				End If
			Next
		End If
	End If

	If Now() > #09/08/2016 00:00:00# AND Now() < #09/26/2016 00:00:00# Then
		IF isArray(arrList) THEN
			For intLoop = 0 To UBound(arrList,2)
				If trim(arrList(1,intLoop)) = "달님♥" AND CStr(arrList(0,intLoop)) = CStr(fidx) Then
					vWishEventOX = "o"
						IF application("Svr_Info") = "Dev" THEN
							vECode   =  "66197"
						Else
							vECode   =  "72959"
						End If
				End If
				If trim(arrList(1,intLoop)) = "달님♥" AND CStr(arrList(0,intLoop)) = CStr(oldfidx) AND mode = "Change" Then
					vWishEventOX = "c"
						IF application("Svr_Info") = "Dev" THEN
							vECode   =  "66197"
						Else
							vECode   =  "72959"
						End If
				End If
			Next
		End If
	End If

	If Now() > #11/18/2016 00:00:00# and Now() < #12/18/2016 23:59:59# Then
		IF isArray(arrList) THEN
			For intLoop = 0 To UBound(arrList,2)
				If trim(arrList(1,intLoop)) = "산타의 WISH" AND CStr(arrList(0,intLoop)) = CStr(fidx) Then
					vWishEventOX = "o"
					IF application("Svr_Info") = "Dev" THEN
						vECode   =  "66238"
					Else
						vECode   =  "74319"
					End If
				End If
				If trim(arrList(1,intLoop)) = "산타의 WISH" AND CStr(arrList(0,intLoop)) = CStr(oldfidx) AND mode = "Change" Then
					vWishEventOX = "c"
					IF application("Svr_Info") = "Dev" THEN
						vECode   =  "66238"
					Else
						vECode   =  "74319"
					End If
				End If
			Next
		End If
	End If

	If Now() > #12/26/2019 00:00:00# and Now() < #01/12/2020 23:59:59# Then
		IF isArray(arrList) THEN
			For intLoop = 0 To UBound(arrList,2)
				If trim(arrList(1,intLoop)) = "2020 소원템" AND CStr(arrList(0,intLoop)) = CStr(fidx) Then
					vWishEventOX = "o"
					IF application("Svr_Info") = "Dev" THEN
						vECode   =  "90452"
					Else
						vECode   =  "99678"
					End If
				End If
				If trim(arrList(1,intLoop)) = "2020 소원템" AND CStr(arrList(0,intLoop)) = CStr(oldfidx) AND mode = "Change" Then
					vWishEventOX = "c"
					IF application("Svr_Info") = "Dev" THEN
						vECode   =  "90452"
					Else
						vECode   =  "99678"
					End If
				End If
			Next
		End If
	End If

	If (GetLoginUserID = "dlwjseh") Or (Now() > #12/23/2020 00:00:00# and Now() < #12/29/2020 23:59:59#) Then
		IF isArray(arrList) THEN
			For intLoop = 0 To UBound(arrList,2)
				If trim(arrList(1,intLoop)) = "쓸데없는 선물" AND CStr(arrList(0,intLoop)) = CStr(fidx) Then
					vWishEventOX = "o"
					IF application("Svr_Info") = "Dev" THEN
						vECode   =  "104280"
					Else
						vECode   =  "108614"
					End If
				End If
				If trim(arrList(1,intLoop)) = "쓸데없는 선물" AND CStr(arrList(0,intLoop)) = CStr(oldfidx) AND mode = "Change" Then
					vWishEventOX = "c"
					IF application("Svr_Info") = "Dev" THEN
						vECode   =  "104280"
					Else
						vECode   =  "108614"
					End If
				End If
			Next
		End If
	End If
	
	if (mode = "DelFavItems") then
		myfavorite.selectdelete(bagarray)
		IF vWishEventOX = "o" Then
			myfavorite.FRectUserID	= userid
			myfavorite.FFolderIdx	= fidx
			myfavorite.Fevtcode	= vECode
			myfavorite.FItemID	= itemid
			myfavorite.fnWishListEventSave
		End IF
	elseif (mode= "AddFavItems") then
		myfavorite.selectedinsert(bagarray)
		'// 뱃지 카운트(위시 등록)
		Call MyBadge_CheckInsertBadgeLog(userid, "0004", "", bagarray, "")
		IF vWishEventOX = "o" Then
			myfavorite.FRectUserID	= userid
			myfavorite.FFolderIdx	= fidx
			myfavorite.Fevtcode	= vECode
			myfavorite.FItemID	= itemid
			myfavorite.fnWishListEventSave
		End IF
		''2017/05/23 :: 위시 로그 추가==================================
		if (userid<>"") then
		    Dim bufBagArr : bufBagArr= split(bagarray,",")
		    if IsArray(bufBagArr) then
    		    for intloop = 0 to ubound(bufBagArr)
    		        if (bufBagArr(intLoop)<>"") then
    		            Call fnUserLogCheck("fav", userid, bufBagArr(intLoop), "", "arr", "app")
    		        end if
    		    next
    		end if
		end if
		''==============================================================
	elseif (mode= "add") then
		myfavorite.iteminsert(itemid)
		'// 뱃지 카운트(위시 등록)
		Call MyBadge_CheckInsertBadgeLog(userid, "0004", "", itemid, "")
		IF vWishEventOX = "o" Then
			myfavorite.FRectUserID	= userid
			myfavorite.FFolderIdx	= fidx
			myfavorite.Fevtcode	= vECode
			myfavorite.FItemID	= itemid
			myfavorite.fnWishListEventSave
		End IF
		''2017/05/23 :: 위시 로그 추가==================================
		if (userid<>"") then
		    Call fnUserLogCheck("fav", userid, itemid, "", "", "app")
		end if
		''==============================================================
	elseif(mode ="Change") then
		myfavorite.FOldFolderIdx		= oldfidx
		myfavorite.fnChangeFolder(bagarray)

		IF vWishEventOX = "c" Then
			vWishEventOX = "o"
			fidx = oldfidx
		End IF

		IF vWishEventOX = "o" Then
			myfavorite.FRectUserID	= userid
			myfavorite.FFolderIdx	= fidx
			myfavorite.Fevtcode	= vECode
			myfavorite.FItemID	= itemid
			myfavorite.fnWishListEventSave
		End IF
	end if

	'// 폴더 정보 업데이트
	myfavorite.fnUpdateFolderInfo

set myfavorite = nothing


Dim vQuery
If mode = "add" Then	'### 1개만 지울때 itemid만 넘어옴.
	bagarray = itemid
End IF
IF Left(bagarray,1) = "," Then		'### 끝에 , 일때 지워줌.
	bagarray = Right(bagarray,Len(bagarray)-1)
End IF
IF Right(bagarray,1) = "," Then		'### 끝에 , 일때 지워줌.
	bagarray = Left(bagarray,Len(bagarray)-1)
End IF

If Trim(bagarray) = "" Then
	dbget.close()
	response.end
End If

vQuery = "UPDATE R SET " & vbCrLf
vQuery = vQuery & " 	favcount = D.cnt " & vbCrLf
vQuery = vQuery & " FROM [db_item].[dbo].[tbl_item_Contents] AS R " & vbCrLf
vQuery = vQuery & " INNER JOIN " & vbCrLf
vQuery = vQuery & " ( " & vbCrLf
vQuery = vQuery & " 	SELECT itemid, count(itemid) AS cnt FROM [db_my10x10].[dbo].[tbl_myfavorite] where itemid in(" & bagarray & ") " & vbCrLf
vQuery = vQuery & " 	GROUP BY itemid " & vbCrLf
vQuery = vQuery & " ) AS D ON R.itemid = D.itemid " & vbCrLf
vQuery = vQuery & " where R.itemid in(" & bagarray & ") " & vbCrLf
dbget.Execute vQuery


if (mode = "DelFavItems") then
	response.write "<script>location.replace('" & backurl & "?fidx="&fidx&"');</script>"
	dbget.close()
	response.end
elseif(mode="Change") then
	If vIsPop = "pop" Then
		response.write "<script>opener.location.reload();window.close();</script>"
	Else
%>
		<script>
			fnAPPopenerJsCallClose("goModifyCompleteMove('<%=oldfidx%>')");
		</script>
<%
'		response.write "<script>location.replace('" & backurl & "?fidx="&fidx&"');</script>"
		dbget.close()
		response.end
	End If
end if

	Dim wishActionLinkUrl
	'// 위시 담은 후 링크액션
	Select Case Trim(backurl)
		Case "close"
			wishActionLinkUrl="location.href='/inipay/ShoppingBag.asp'"

		Case "mywishlist.asp"
			wishActionLinkUrl="location.href='"&backurl&"?fidx="&fidx&"'"

		Case "popWishFolder_listajax.asp"
            if (FALSE) then '' 일시 중지 2015/09/25      중지 2015/11/27
            ''if (fnChkNudgeWishCouponEvalPreCheckValid(userid)) then  ''2015/09/14 넛지 wish 쿠폰 발급 관련 선체크 (최근 N일 발급 받았으면 기존 프로세스)           
		        wishActionLinkUrl="parent.jsNudgeAddNCloseThis();"
            else
                wishActionLinkUrl="parent.jsCloseThis();"
            end if
		Case Else
			If vIsPop="pop" Then
				wishActionLinkUrl="window.close();"
			Else
				wishActionLinkUrl="location.href='"&Replace(backurl,"^","&")&"'"
			End If
		End Select

	'// 위시액션 쿠폰발급 FALSE=>2015/11/26 Enable
	If (Trim(backurl)="popWishFolder_listajax.asp") Then
	    if (Trim(fnWishActionCouponInApp(userid))="2") Then
	        
%>
	<% Dim Strtext
		Strtext = ""
		Strtext = Strtext & "<div class='wishAction'>"
		Strtext = Strtext & "	<p class='box1'><em>지금 텐바이텐 APP에서만 사용할 수 있는<br /> <strong>3천원 할인쿠폰</strong>을 지급해드렸습니다.</em> (3만원이상 구매시,24시간 이내사용)</p>"
		''Strtext = Strtext & "   <img src='http://fiximage.10x10.co.kr/m/apps/cpn_3000.jpg' width=400>"
		Strtext = Strtext & "	<div class='btnwrap'><span class='button btB1 btRed cWh1'><button type='button' onclick="&wishActionLinkUrl&">확인</button></span></div>"
		Strtext = Strtext & "	<ul>"
		Strtext = Strtext & "		<li>* 텐바이텐 APP에서만 사용가능합니다.</li>"
		Strtext = Strtext & "		<li>* 발급 기준 24시간이내 사용하지않으면 자동소멸됩니다.</li>"
		Strtext = Strtext & "	</ul>"
		Strtext = Strtext & "</div>"
	%>
	<script>parent.$("#wishfolderdiv").empty().append("<%=Strtext%>");</script>
<%
       else
            response.write "<script>"&wishActionLinkUrl&";</script>"
		    response.End
       end if
	Else
		response.write "<script>"&wishActionLinkUrl&";</script>"
		response.End
	End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
