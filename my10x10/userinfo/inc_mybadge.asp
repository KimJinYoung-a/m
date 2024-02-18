<%
'########################################################
' Description : 마이텐바이텐 - 뱃지 리스트 가저오기
' History : 2017-12-28 이종화
'########################################################
Function MyBadge_MyBadgeList(userid)
	Dim strSql
	strSql ="[db_my10x10].[dbo].usp_Ten_MyBadgeGetList ('"&userid&"')"
	rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
	IF Not (rsget.EOF OR rsget.BOF) THEN
		MyBadge_MyBadgeList = rsget.GetRows()
	END IF
	rsget.close
end Function

	Dim arrBadgeList, badgeTitle, badgeContent, badgeObtainYN, badgeIdx, badgeDispNo, badgeTotalCnt
	Dim tmpArrBC, tmpItmBC, tmpBC1, tmpBC2
	Dim bdgGbnCnt: bdgGbnCnt=1
	Dim lpBdg , userid

	userid = GetLoginUserID

	'// 비회원도 뱃지 목록은 출력
	arrBadgeList = MyBadge_MyBadgeList(userid)

	dim totalObtainBadgeCount : totalObtainBadgeCount = 0
	dim firstObtainBadgeIdx : firstObtainBadgeIdx = 0

	IF isArray(arrBadgeList) THEN
		for lpBdg = 0 to UBound(arrBadgeList,2)
			if (arrBadgeList(2,lpBdg) = "Y") then
				'내가 취득한 총 뱃지 수
				totalObtainBadgeCount = totalObtainBadgeCount + 1

				'초기 뱃지 표시
				if (firstObtainBadgeIdx = 0) then firstObtainBadgeIdx = arrBadgeList(4,lpBdg)
			end if
		next
	end If
%>
<div class="badge-hgroup">획득한<span><%=totalObtainBadgeCount%></span>개의 뱃지
	<% If isapp = "1" Then %>
	<a href="" onclick="fnAPPpopupBrowserURL('뱃지 안내','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/userinfo/badge_guide.asp'); return false;" class="btn-guide btn btn-xsmall btn-radius color-black btn-icon">뱃지 안내<span class="icon icon-arrow"></span></a>
	<% Else %>
	<a href="/my10x10/userinfo/badge_guide.asp" class="btn-guide btn btn-xsmall btn-radius color-black btn-icon">뱃지 안내<span class="icon icon-arrow"></span></a>
	<% End If %>
</div>

<div class="my-bage-list">
	<ul>
		<%
			If totalObtainBadgeCount > 0 Then 
				for lpBdg = 0 to UBound(arrBadgeList,2)
					IF isArray(arrBadgeList) THEN
						if (UBound(arrBadgeList,2) < lpBdg) then
							badgeTitle = ""
							badgeContent = ""
							badgeObtainYN = "N"
							badgeIdx = "0"
							badgeDispNo = "0"
							badgeTotalCnt = 0
						else
							badgeTitle = arrBadgeList(1,lpBdg)
							badgeContent = arrBadgeList(3,lpBdg)
							badgeObtainYN = arrBadgeList(2,lpBdg)
							badgeIdx = arrBadgeList(4,lpBdg)
							badgeDispNo = arrBadgeList(0,lpBdg)
							badgeTotalCnt = arrBadgeList(5,lpBdg)
			
							if (userid = "10x10green") and (lpBdg < 12) then
								'// 테스트 계정은 전부 표시
								badgeObtainYN = "Y"
							end if
						end if
					else
						badgeTitle = ""
						badgeContent = ""
						badgeObtainYN = "N"
						badgeIdx = "0"
						badgeDispNo = "0"
						badgeTotalCnt = 0
					end If
					
					If badgeObtainYN = "Y" then
		%>
		<li class="badge badge<%=lpBdg+1%>">
			<div class="wrap">
				<div class="icon"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_black_badge<%=Num2Str(badgeDispNo, 2, "0", "R")%>.png" alt="<%= badgeTitle %>"/></div>
				<div class="name"><%= chkiif(badgeTitle = "카테고리 마스터","카테고리<br/>마스터",badgeTitle) %></div>
			</div>
		</li>
		<%
					End If 
				Next
			End if
		%>
		<% 
		'// 나머지 물음표 채워 넣기
			Dim ii 
			For ii = 0 To (UBound(arrBadgeList,2) - totalObtainBadgeCount) + 1
		%>
		<li>
			<div class="wrap"></div>
		</li>
		<% Next %>
	</ul>
</div>