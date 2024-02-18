<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리스토리
' History : 2014-10-13 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appCom/wish/webview/diarystory2015/lib/worker_only_view.asp" -->
<!-- #include virtual="/diarystory2015/lib/classes/diary_class.asp" -->

<%
dim GiftSu, i, weekDate

GiftSu=0

dim cDiary
Set cDiary = new cdiary_list
	cDiary.getOneplusOneDaily '1+1
	
if cDiary.ftotalcount>0 then
	GiftSu = cDiary.getGiftDiaryExists(cDiary.FOneItem.Fitemid) '사은품 수
		if GiftSu = false then GiftSu=0
else
	GiftSu=0

	Set cDiary = new cdiary_list
		cDiary.getOneDailynot
end if

dim cDiarycnt
Set cDiarycnt = new cdiary_list
	cDiarycnt.getDiaryCateCnt '상태바 count

weekDate = weekDayName(weekDay(now)) '// 요일 구하기 내장 함수
%>

<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->

<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/webview/css/diary2015.css?v=1.1">
<script type='text/javascript'>

// 관심 품목 담기 - 상품 페이지 전용 : 상품 코드로 변경
function TnAddFavoritePrd(iitemid){
	<% if IsUserLoginOK then %>
		jsOpenModal('/apps/appcom/wish/webview/my10x10/ajax_MyFavorite.asp?ispop=ajax&mode=add&itemid=' + iitemid + '&backurl=<%=Replace(CurrURLQ(),"&","^")%>')
	<% else %>
		calllogin();
		//location.href='/apps/appCom/wish/webview/login/login.asp?backpath=<%=server.URLEncode(CurrURLQ())%>';
	<% end if %>
	return;
}

function searchlink(v){
	if (v == ""){
		document.location = "/apps/appCom/wish/webview/diarystory2015/list.asp";
	}else{
		document.location = "/apps/appCom/wish/webview/diarystory2015/list.asp?arrds=" + v + ",";
	}
}

</script>
</head>
<body class="diarystory2015">
	<!-- wrapper -->
	<div class="wrapper">
		<!-- #content -->
		<div id="content">

			<% if cDiary.ftotalcount>0 then %>
				<!-- TODAY DIARY -->
				<% ' for dev msg : 투데이 다이어리에 등록된 상품을 불러와서 배경처리해주세요 %>
				<div class="diaryTopic" style="background-image:url(<%= getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid( cDiary.FOneItem.Fitemid )&"/"&db2html( cDiary.FOneItem.fbasicimage ),"240","240","true","false") %>);)">
					<div class="desc">
						<% ' for dev msg : 주말, 공휴일에 투데이 초이스로 타이틀 변경해주세요  %>
						<% If weekDate = "토요일" Or weekDate = "일요일" Then %>
							<h1><img src="http://fiximage.10x10.co.kr/m/2014/diarystory2015/tit_today_choice.png" alt="투데이 초이스" /></h1>
						<% else %>
							<h1><img src="http://fiximage.10x10.co.kr/m/2014/diarystory2015/tit_today_diary.png" alt="투데이 다이어리" /></h1>
						<% end if %>
						
						<% if date < "2014-10-21" then %>
							<a href="" onclick="TnGotoProduct('<%=cDiary.FOneItem.FItemid%>'); return false;">
						<% else %>
							<a href="/apps/appCom/wish/webview/diarystory2015/today.asp">
						<% end if %>
							<div class="pPhoto"><img src="<%= getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid( cDiary.FOneItem.Fitemid )&"/"&db2html( cDiary.FOneItem.fbasicimage ),"240","240","true","false") %>" alt="<%= cDiary.FOneItem.Fitemname %>" /></div>
							<% ' for dev msg : 주말, 공휴일엔 1+1과 남은 수량 숨겨주세요. %>
							<% If not(weekDate = "토요일" Or weekDate = "일요일") Then %>
								<% If GiftSu > 0 Then %>
									<strong class="plus">
										<% if cDiary.FOneItem.fplustype="1" then %>
											1+1
										<% else %>
											1:1
										<% end if %>
									</strong>
									<em class="countdown"><span>남은수량 <%= GiftSu %>개</span></em>
								<% End If %>
							<% end if %>

							<div class="pdtCont">
								<p class="pBrand">[<%= cDiary.FOneItem.Fsocname %>]</p>
								<p class="pName"><%= cDiary.FOneItem.Fitemname %></p>
								<p class="pPrice"><span class="cRd1">
									<%
										IF cDiary.FOneItem.IsSaleItem or cDiary.FOneItem.isCouponItem Then
											If  cDiary.FOneItem.getRealPrice <> cDiary.FOneItem.FSellCash then
												IF cDiary.FOneItem.IsSaleItem then
									%>
												<%=FormatNumber(cDiary.FOneItem.getRealPrice,0) %>원
									<%
												End If
												IF cDiary.FOneItem.IsCouponItem then
									%>
												<%= FormatNumber(cDiary.FOneItem.GetCouponAssignPrice,0)%>원
									<%
												End If
											Else
									%>
												<%= FormatNumber(cDiary.FOneItem.GetCouponAssignPrice,0)%>원
									<%
											End If
										ELSE
									%>
											<%= FormatNumber(cDiary.FOneItem.FSellCash,0)%>원
									<%
										End If
									%>
								</span></p>
							</div>
						</a>
					</div>
					<span class="mask"></span>
				</div>
			<% end if %>

			<div class="diaryGift">
				<p><a href="gift.asp"><img src="http://fiximage.10x10.co.kr/m/2014/diarystory2015/img_bnr_diarystory2015_gjft.gif" alt="다이어리 구매금액별로 사은품을 드립니다. 히치하이커 스티커북, 데코 러쉬 리필 세트, CIRCUS BOY BAND POUCH, 무료배송의 혜택을 드립니다." /></a></p>
			</div>

			<div class="diaryFinder">
				<ul>
					<li><a href="" onclick="searchlink('10'); return false;" class="box1">SIMPLE <span class="cRd1">(
						<% if cDiarycnt.fresultcount > 1 then %>
							<%=cDiarycnt.FItemList(2).FdiaryCount1%>
						<% else %>
							0
						<% end if %>
					)</span></a></li>
					<li><a href="" onclick="searchlink('20'); return false;" class="box1">ILLUST <span class="cRd1">(
						<% if cDiarycnt.fresultcount > 1 then %>
							<%=cDiarycnt.FItemList(2).FdiaryCount2%>
						<% else %>
							0
						<% end if %>						
					)</span></a></li>
					<li><a href="" onclick="searchlink('30'); return false;" class="box1">PATTERN <span class="cRd1">(
						<% if cDiarycnt.fresultcount > 1 then %>
							<%=cDiarycnt.FItemList(2).FdiaryCount3%>
						<% else %>
							0
						<% end if %>
					)</span></a></li>
					<li><a href="" onclick="searchlink('40'); return false;" class="box1">PHOTO <span class="cRd1">(
						<% if cDiarycnt.fresultcount > 1 then %>
							<%=cDiarycnt.FItemList(2).FdiaryCount4%>
						<% else %>
							0
						<% end if %>
					)</span></a></li>
				</ul>
				<!--<span class="button btB1 btRed cWh1 w100p"><a href="/apps/appCom/wish/webview/diarystory2015/search/search.asp"><em>나의 2015 다이어리 찾기</em></a></span>-->
				<span class="button btB1 btRed cWh1 w100p"><a href="/apps/appCom/wish/webview/diarystory2015/list.asp"><em>2015 다이어리 둘러보기</em></a></span>
			</div>
			<a name="abest"></a>
			<div class="diaryList inner5">				
				<!-- #include virtual="/apps/appCom/wish/webview/diarystory2015/inc/inc_best.asp" -->
			</div>

			<!-- DIARY EVENT -->
			<div class="diaryEvt inner5">
				<!-- #include virtual="/apps/appCom/wish/webview/diarystory2015/inc/inc_event_main.asp" -->
			</div>
			<div id="modalCont" style="display:none;"></div>
		</div>
		<!-- #content -->

		<!-- #footer -->
		<footer id="footer">
			<a href="#" class="btn-top">top</a>
		</footer><!-- #footer -->

		</div>
	<!-- //wrapper -->
</body>
</html>

<%
Set cDiary = Nothing
Set cDiarycnt = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->