<%@ language=vbscript %>
<% option explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/badgelibUTF8.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%

Dim arrBadgeList, badgeTitle, badgeContent, badgeTerm, badgeObtainYN, badgeIdx, badgeDispNo
Dim tmpArrBC, tmpItmBC, tmpBC1, tmpBC2
dim userid, i
userid = requestCheckVar(Request("uid"),32)
if userid="" then userid=GetLoginUserID

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
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
</head>
<body class="wishmate">
<div class="box">
    <div class="modal-body">
        <div class="iscroll-area">
	        <ul class="badge-list">
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
	            <li>
	                <div class="about-badge-box<%=chkIIF(badgeObtainYN="N"," pink","")%>">
	                    <span class="badge">
	                    <% if badgeObtainYN="N" then %>
	                    	<i class="etc"></i>
	                    <% else %>
	                    	<img src="http://fiximage.10x10.co.kr/web2013/common/badge/ico_badge_116_<%=badgeDispNo%>.png" style="width:50px; height:50px;" alt="<%=replace(badgeTitle,"""","")%>" />
	                   	<% end if %>
	                    </span>
	                    <div class="desc">
	                        <strong><%=badgeTitle%></strong>
	                        <p><%=badgeContent%></p>
	                    </div>
	                </div>
	                <em class="em red"><%=badgeTerm%></em>
	            </li>
		<%
			next
		%>
	        </ul>
		</div>
    </div>
</div>
	<!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->