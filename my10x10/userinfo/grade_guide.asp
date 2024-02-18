<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/login/checkUserGuestlogin.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'// 2018 회원등급 개편(이 페이지는 전체가 수정되므로 덮어쓰기 해야됨)

	strHeadTitleName="등급별 혜택"

Function besturl(v)
	Select Case v
		Case 0 : besturl = "/award/awarditem.asp?userlevel=0" 'WHITE
		Case 1 : besturl = "/award/awarditem.asp?userlevel=1" 'RED
		Case 2 : besturl = "/award/awarditem.asp?userlevel=2" 'VIP
		Case 3 : besturl = "/award/awarditem.asp?userlevel=3" 'VIP GOLD
		Case 4 : besturl = "/award/awarditem.asp?userlevel=4" 'VVIP
		Case 5 : besturl = "/award/awarditem.asp?userlevel=0" 'WHITE
		Case 6 : besturl = "/award/awarditem.asp?userlevel=4" 'VVIP
	End select
End Function
%>
<!-- #include virtual="/lib/inc/head.asp" -->
</head>
<body class="default-font body-sub">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->

	<!-- contents -->
		<div id="content" class="content membershipV18">
			<!-- #include virtual="/my10x10/userinfo/inc_gradelist.asp" -->
		</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incfooter.asp" -->
</body>
</html>