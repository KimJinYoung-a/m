<%
''EMail ComboBox
function DrawEamilBoxHTML_App(frmName,txBoxName, cbBoxName,emailVal,classNm1,classNm2,jscript1,jscript2)
    dim RetVal, i, isExists : isExists=false
    dim eArr : eArr = Array("naver.com","netian.com","paran.com","hanmail.net","dreamwiz.com","nate.com" _
                ,"empal.com","orgio.net","unitel.co.kr","chol.com","kornet.net","korea.com" _
                ,"freechal.com","hanafos.com","hitel.net","hanmir.com","hotmail.com")
	emailVal = LCase(emailVal)

    RetVal = "<input name='"&txBoxName&"' class='"&classNm1&"' type='text' value='' style='display:none;' "&jscript1&" />&nbsp;"
    RetVal = RetVal & "<select name='"&cbBoxName&"' id='select3' class='"&classNm2&"' "&jscript2&" \>"
    ''RetVal = RetVal & "<option value=''>메일선택</option>"
    for i=LBound(eArr) to UBound(eArr)
        if (eArr(i)=emailVal) then
            isExists = true
            RetVal = RetVal & "<option value='"&eArr(i)&"' selected>"&eArr(i)&"</option>"
        else
            RetVal = RetVal & "<option value='"&eArr(i)&"' >"&eArr(i)&"</option>"
        end if
    next

    if (Not isExists) and (emailVal<>"") then
        RetVal = RetVal & "<option value='"&emailVal&"' selected>"&emailVal&"</option>"
    end if
    RetVal = RetVal & "<option value='etc' >직접 입력</option>"
    RetVal = RetVal & "</select>"

    response.write RetVal

end Function

' 페이징 함수 <%=fnPaging_Apps(페이지파라미터, 토탈레코드카운트, 현재페이지, 페이지사이즈, 블럭사이즈) 앱용
Function fnPaging_Apps(ByVal pageParam, ByVal iTotalCount, ByVal iCurrPage, ByVal iPageSize, ByVal iBlockSize)

	If iTotalCount = "" Then iTotalCount = 0
	Dim iTotalPage
	iTotalPage  = Int ( (iTotalCount - 1) / iPageSize ) + 1
	If iTotalCount = 0 Then	iTotalPage = 1

	Dim str, i, iStartPage
	Dim url, arr
	url = getThisFullURL()
	If InStr(url,pageParam) > 0 Then
		arr = Split(url, pageParam&"=")
		If UBOUND(arr) > 0 Then
			If InStr(arr(1),"&") Then
				url = arr(0) & Mid(arr(1),InStr(arr(1),"&")+1) & "&" & pageParam&"="
			Else
				url = arr(0) & pageParam&"="
			End If
		End If
	ElseIf InStr(url,"?") > 0 Then
		url = url & "&" &  pageParam & "="
	Else
		url = url & "?" &  pageParam & "="
	End If
	url = Replace(url,"?&","?")

	Dim imgPrev01, imgNext01, imgPrev02, imgNext02
	imgPrev01	= "&lt;"
	imgNext01	= "&gt;"

	' 시작페이지
	If (iCurrPage Mod iBlockSize) = 0 Then
		iStartPage = (iCurrPage - iBlockSize) + 1
	Else
		iStartPage = ((iCurrPage \ iBlockSize) * iBlockSize) + 1
	End If

	' 이전 Block으로 이동
	If (iCurrPage / iBlockSize) > 1 Then
		str = str & "<a href=""javascript:goPage(" & (iStartPage - iBlockSize) & ");"" class=""btn-prev"">" & imgPrev01 & "</a>"
	Else
		str = str & "<a href=""javascript:goPage(1);"" class=""btn-prev"">" & imgPrev01 & "</a>"
	End If

	' 페이지 Count 루프
	i = iStartPage

	Do While ((i < iStartPage + iBlockSize) And (i <= iTotalPage))
		If i > iStartPage Then str = str & ""
		If Int(i) = Int(iCurrPage) Then
			str = str & "<a href=""javascript:goPage(" & i & ");"" class=""current""><span>" & i & "</span></a>"
		Else
			str = str & "<a href=""javascript:goPage(" & i & ");"" class=""""><span>" & i & "</span></a>"
		End If
		i = i + 1
	Loop

	' 다음 Block으로 이동
	If (iStartPage+iBlockSize) < iTotalPage+1 Then
		str = str & "<a href=""javascript:goPage(" & i & ");"" class=""btn-next"">" & imgNext01 & "</a>"
	Else
		str = str & "<a href=""javascript:goPage(" & iTotalPage & ");"" class=""btn-next"">" & imgNext01 & "</a>"
	End If

	fnPaging_Apps	= str

End function

'// 송장 링크(app 외부 브라우저 호출)
function GetSongjangURL(currST,dlvURL,songNo)
	if (currST<>"7") then
		GetSongjangURL = ""
		exit function
	end if

	if (dlvURL="" or isnull(dlvURL)) or (songNo="" or isnull(songNo)) then
		GetSongjangURL = "<span onclick=""alert('▷▷▷▷▷ 화물추적 불능안내 ◁◁◁◁◁\n\n고객님께서 주문하신 상품의 배송조회는\n배송업체 사정상 조회가 불가능 합니다.\n이 점 널리 양해해주시기 바라며,\n보다 빠른 배송처리가 이뤄질수 있도록 최선의 노력을 다하겠습니다.');"" style=""cursor:pointer;"">" & songNo & "</span>"
	else
		GetSongjangURL = "<span onclick=""openbrowser('" & db2html(dlvURL) & songNo & "');"">" & songNo & "</span>"
	end if
end function

'// 얼럿 후 APP창 닫음
Sub Alert_AppClose(strMSG)
	dim strTemp
	strTemp = 	"<script>" & vbCrLf &_
			"alert('" & strMSG & "');" & vbCrLf &_
			"window.location = 'callnativefunction:%7B%22funcname%22%3A%22closePopup%22%7D';" & vbCrLf &_
			"</script>"
	Response.Write strTemp
End Sub
%>