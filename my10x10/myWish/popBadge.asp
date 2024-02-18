<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/login/checkLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/wish/WishCls.asp" -->
<!-- #include virtual="/lib/util/badgelibUTF8.asp" -->
<%
	Dim arrBadgeList, badgeTitle, badgeContent, badgeTerm, badgeObtainYN, badgeIdx, badgeDispNo
	Dim tmpArrBC, tmpItmBC, tmpBC1, tmpBC2, vErrBackLocationUrl
	dim userid, i
	userid = requestCheckVar(Request("uid"),200)

	'// userid Decoding
	userid = tenDec(userid)

	if userid="" then userid=getEncLoginUserID


	vErrBackLocationUrl	= "/my10x10/mywish/myWish.asp?uid="&userid

	'뱃지목록 Get
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
	end if

%>
</head>
<div class="layerPopup">
	<div class="popWin">
		<div class="header">
			<h1>뱃지</h1>
			<p class="btnPopClose"><button type="button" class="pButton" onclick="fnCloseModal();">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content" id="layerScroll">
			<div id="scrollarea">
				<ul class="badgeList">
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
						else
							badgeTitle = arrBadgeList(1,i)
							badgeContent = arrBadgeList(3,i)
							badgeObtainYN = arrBadgeList(2,i)
							badgeIdx = arrBadgeList(4,i)
							badgeDispNo = arrBadgeList(0,i)
			
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
					<li <% If badgeObtainYN="N" Then %> class="none" <%End If %>>
						<span class="badge"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_black_badge<%=Num2Str(badgeDispNo, 2, "0", "R")%>.png" alt="<%=replace(badgeTitle,"""","")%>" /></span>
						<dl>
							<dt><%=badgeTitle%></dt>
							<dd><%=badgeContent%></dd>
						</dl>
						<p class="tip"><%=badgeTerm%></p>
					</li>
			<%
				next
			%>
				</ul>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->