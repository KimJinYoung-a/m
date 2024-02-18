<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 꽃길만 걷게 해줄게요
' History : 2017-05-04 조경애 생성
'####################################################
%>
<%
Dim currentdate
	currentdate = date()
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
</style>
</head>
<body>
	<!-- 1주차 -->
	<% If currentdate <= "2017-05-14" Then %>
	<div class="week1">
		<a href="/category/category_itemPrd.asp?itemid=1469907&pEtr=77013" class="mWeb" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77831/m/img_item_01.jpg" alt="매일 달라지는 특가 1주차 KELLYSNEAKERS" /></a>
		<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1469907&pEtr=77013" class="mApp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77831/m/img_item_01.jpg" alt="매일 달라지는 특가 1주차 KELLYSNEAKERS" /></a>
	</div>

	<!-- 2주차 -->
	<% ElseIf currentdate >= "2017-05-15" AND currentdate <= "2017-05-21" Then %>
	<div class="week2">
		<a href="/category/category_itemPrd.asp?itemid=1664880&pEtr=77013" class="mWeb" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77831/m/img_item_02.jpg" alt="매일 달라지는 특가 2주차 GRAM" /></a>
		<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1664880&pEtr=77013" class="mApp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77831/m/img_item_02.jpg" alt="매일 달라지는 특가 2주차 GRAM" /></a>
	</div>

	<!-- 3주차 -->
	<% ElseIf currentdate >= "2017-05-22" AND currentdate <= "2017-05-28" Then %>
	<div class="week3">
		<a href="/category/category_itemPrd.asp?itemid=1696742&pEtr=77013" class="mWeb" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77831/m/img_item_03.jpg" alt="매일 달라지는 특가 3주차 ROCKFISH" /></a>
		<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1696742&pEtr=77013" class="mApp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77831/m/img_item_03.jpg" alt="매일 달라지는 특가 3주차 ROCKFISH" /></a>
	</div>

	<!-- 4주차 -->
	<% ElseIf currentdate >= "2017-05-29" Then %>
	<div class="week4">
		<a href="/category/category_itemPrd.asp?itemid=1618488&pEtr=77013" class="mWeb" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77831/m/img_item_04.jpg" alt="매일 달라지는 특가 4주차 STARE" /></a>
		<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1618488&pEtr=77013" class="mApp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77831/m/img_item_04.jpg" alt="매일 달라지는 특가 4주차 STARE" /></a>
	</div>
	<% End If %>
</body>
</html>