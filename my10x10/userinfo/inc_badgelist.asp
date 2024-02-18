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

Function badgemore(v)
	Select Case v
		Case 01 '// 슈퍼 코멘터
			If isapp = "1" Then 
				badgemore = "<a href='' onclick=""fnAPPpopupBrowserURL('상품후기','"& wwwUrl &"/apps/appCom/wish/web2014/my10x10/goodsusing.asp','right','','sc'); return false;"" class='go-shopping btn btn-small btn-radius color-black btn-icon'>상품후기 작성하기<span class='icon icon-arrow'></span></a>"
			else
				badgemore = "<a href='/my10x10/goodsusing.asp' class='go-shopping btn btn-small btn-radius color-black btn-icon'>상품후기 작성하기<span class='icon icon-arrow'></span></a>"
			End If 
		Case 02 '// 기프트초이스
			badgemore = ""
		Case 03 '// 위시메이커
			If isapp = "1" Then 
				badgemore = "<a href='' onclick=""fnAPPpopupBrowserURL('카테고리','"& wwwUrl &"/apps/appCom/wish/web2014/category/category_main.asp','right'); return false;"" class='go-shopping btn btn-small btn-radius color-black btn-icon'>카테고리별 상품보기<span class='icon icon-arrow'></span></a>"
			Else 
				badgemore = "<a href='/category/category_main.asp' class='go-shopping btn btn-small btn-radius color-black btn-icon'>카테고리별 상품보기<span class='icon icon-arrow'></span></a>"
			End if
		Case 04 '// 포토 코멘더
			If isapp = "1" Then
				badgemore = "<a href='' onclick=""fnAPPpopupBrowserURL('상품후기','"& wwwUrl &"/apps/appCom/wish/web2014/my10x10/goodsusing.asp','right','','sc'); return false;"" class='go-shopping btn btn-small btn-radius color-black btn-icon'>상품후기 작성하기<span class='icon icon-arrow'></span></a>"
			Else
				badgemore = "<a href='/my10x10/goodsusing.asp' class='go-shopping btn btn-small btn-radius color-black btn-icon'>상품후기 작성하기<span class='icon icon-arrow'></span></a>"
			End If 
		Case 05 '// 브랜드 쿨
			If isapp = "1" Then
				badgemore = "<a href='' onclick=""fnAPPpopupBrowserURL('찜 브랜드','"& wwwUrl &"/apps/appCom/wish/web2014/my10x10/myzzimbrand.asp','right','','sc'); return false;"" class='go-shopping btn btn-small btn-radius color-black btn-icon'>나의 찜 브랜드 보기<span class='icon icon-arrow'></span></a>"
			Else
				badgemore = "<a href='/my10x10/myzzimbrand.asp' class='go-shopping btn btn-small btn-radius color-black btn-icon'>나의 찜 브랜드 보기<span class='icon icon-arrow'></span></a>"
			End If 
		Case 06 '// 얼리버드
			If isapp = "1" Then
				badgemore = "<a href='' onclick=""fnAPPpopupNEW_URL('"& wwwUrl &"/apps/appcom/wish/web2014/newitem/newitem.asp','right','','sc');return false;"" class='go-shopping btn btn-small btn-radius color-black btn-icon'>신상품 쇼핑하기<span class='icon icon-arrow'></span></a>"
			Else
			    badgemore = "<a href='/list/new/new_summary2020.asp' class='go-shopping btn btn-small btn-radius color-black btn-icon'>신상품 쇼핑하기<span class='icon icon-arrow'></span></a>"
			End If 
		Case 07 '// 세일헌터
			If isapp = "1" Then
				badgemore = "<a href='' onclick=""fnAPPpopupBrowserRenewal('push', 'SALE', '" & wwwUrl & "/apps/appCom/wish/web2014/list/sale/sale_summary2020.asp', 'sale');return false;"" class='go-shopping btn btn-small btn-radius color-black btn-icon'>세일상품 쇼핑하기<span class='icon icon-arrow'></span></a>"
			Else
				badgemore = "<a href='/list/sale/sale_summary2020.asp' class='go-shopping btn btn-small btn-radius color-black btn-icon'>세일상품 쇼핑하기<span class='icon icon-arrow'></span></a>"
			End If 
		Case 08 '// 스타일리스트
			badgemore = ""
		Case 09 '// 컬러홀릭
			If isapp = "1" Then
				badgemore = "<a href='' onclick=""fnAPPpopupBrowserURL('카테고리','"& wwwUrl &"/apps/appCom/wish/web2014/category/category_main.asp','right'); return false;"" class='go-shopping btn btn-small btn-radius color-black btn-icon'>카테고리별 쇼핑하기<span class='icon icon-arrow'></span></a>"
			Else 
				badgemore = "<a href='/category/category_main.asp' class='go-shopping btn btn-small btn-radius color-black btn-icon'>카테고리별 쇼핑하기<span class='icon icon-arrow'></span></a>"
			End If 
		Case 10 '// 텐텐트윅스
			badgemore = ""
		Case 11 '// 카테고리 마스터
			If isapp = "1" Then
				badgemore = "<a href='' onclick=""fnAPPpopupBrowserURL('카테고리','"& wwwUrl &"/apps/appCom/wish/web2014/category/category_main.asp','right'); return false;"" class='go-shopping btn btn-small btn-radius color-black btn-icon'>카테고리별 쇼핑하기<span class='icon icon-arrow'></span></a>"
			Else 
				badgemore = "<a href='/category/category_main.asp' class='go-shopping btn btn-small btn-radius color-black btn-icon'>카테고리별 쇼핑하기<span class='icon icon-arrow'></span></a>"
			End If 
		Case 12 '// 톡! 엔젤
			If isapp = "1" Then
				badgemore = "<a href='' onclick=""fnAPPpopupBrowserURL('기프트','"& wwwUrl &"/apps/appCom/wish/web2014/gift/gifttalk/index.asp','right','','sc');return false;"" class='go-shopping btn btn-small btn-radius color-black btn-icon'>쇼핑 고민 풀어주기<span class='icon icon-arrow'></span></a>"
			Else 
				badgemore = "<a href='/gift/gifttalk/' class='go-shopping btn btn-small btn-radius color-black btn-icon'>쇼핑 고민 풀어주기<span class='icon icon-arrow'></span></a>"
			End if
		Case 13 '// 10월 스페셜
			badgemore = ""
		Case 14 '// 11월 스페셜
			badgemore = ""
		Case 15 '// 12월 스페셜
			badgemore = ""
	End select
End Function 

	Dim arrBadgeList, badgeTitle, badgeContent, badgeTerm, badgeObtainYN, badgeIdx, badgeDispNo, badgeTotalCnt
	Dim tmpArrBC, tmpItmBC, tmpBC1, tmpBC2
	dim userid, i

	userid = GetLoginUserID

	'// 비회원도 뱃지 목록은 출력
	arrBadgeList = MyBadge_MyBadgeList(userid)

	dim totalObtainBadgeCount : totalObtainBadgeCount = 0
	dim firstObtainBadgeIdx : firstObtainBadgeIdx = 0

	IF isArray(arrBadgeList) THEN
		for i = 0 to UBound(arrBadgeList,2)
			if (arrBadgeList(2,i) = "Y") then
				'내가 취득한 총 뱃지 수
				totalObtainBadgeCount = totalObtainBadgeCount + 1

				'초기 뱃지 표시
				if (firstObtainBadgeIdx = 0) then firstObtainBadgeIdx = arrBadgeList(4,i)
			end if
		next
	end If
%>
<div class="badge-list">
	<ul>
		<%
			for i = 0 to UBound(arrBadgeList,2)
				IF isArray(arrBadgeList) THEN
					if (UBound(arrBadgeList,2) < i) then
						badgeTitle = ""
						badgeContent = ""
						badgeTerm = ""
						badgeObtainYN = "N"
						badgeIdx = "0"
						badgeDispNo = "0"
						badgeTotalCnt = 0
					else
						badgeTitle = arrBadgeList(1,i)
						badgeContent = arrBadgeList(3,i)
						badgeObtainYN = arrBadgeList(2,i)
						badgeIdx = arrBadgeList(4,i)
						badgeDispNo = arrBadgeList(0,i)
						badgeTotalCnt = arrBadgeList(5,i)
		
						if (userid = "10x10green") and (i < 12) then
							'// 테스트 계정은 전부 표시
							badgeObtainYN = "Y"
						end if
		
						'설명 분해 표시
						tmpArrBC = split(badgeContent, vbCrLf)
						if isArray(tmpArrBC) then
							tmpBC1="": tmpBC2=""
							for each tmpItmBC in tmpArrBC
								if instr(tmpItmBC,":")>0 then
									tmpBC2 = tmpBC2 & chkIIF(tmpBC2<>"","<br>","") & tmpItmBC
								else
									tmpBC1 = tmpBC1 & chkIIF(tmpBC1<>"","<br>","") & tmpItmBC
								end if
							next
							badgeContent = tmpBC1
							badgeTerm = chkIIF(tmpBC2<>"",tmpBC2,"&nbsp;")
						end if
					end if
				else
					badgeTitle = ""
					badgeContent = ""
					badgeTerm = ""
					badgeObtainYN = "N"
					badgeIdx = "0"
					badgeDispNo = "0"
				end if
		
		%>
		<li>
			<div class="wrap">
				<div class="badge <%=chkiif(badgeObtainYN="N","unkown-badge","")%>">
					<div class="icon"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_black_badge<%=Num2Str(badgeDispNo, 2, "0", "R")%>.png" alt=""/></div>
					<div class="name"><%= chkiif(badgeTitle = "카테고리 마스터","카테고리<br/>마스터",badgeTitle) %></div>
				</div>
				<div class="desc">
					<p class="detail"><%=badgeContent%></p>
					<p class="condition"><%=badgeTerm%></p>
					<p class="member-num">뱃지보유 회원 : <em><%=formatNumber(badgeTotalCnt,0)%></em>명</p>
					<%=badgemore(Num2Str(badgeDispNo, 2, "0", "R"))%>
				</div>
			</div>
		</li>
		<% 
				Next 
		%>
	</ul>
</div>