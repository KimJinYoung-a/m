<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/main/main_Pick.asp" -->
<!-- #INCLUDE Virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<%
'#######################################################
' Discription : mobile_mdpicklist 
' History : 2017-09-06 유태욱 생성
'#######################################################
	Dim cPk , page , pagesize , intI
	dim vWishArr, iLp
	page = requestCheckvar(request("page"),9)

	if (page="") then page = 1

	pagesize = 30

	SET cPk = New CPick
		cPk.FPageSize = pagesize
		cPk.FCurrPage = page
		cPk.fnGetMdPickList()

'	strHeadTitleName = "MD PICK"

	'// 검색결과 내위시 표시정보 접수
	if IsUserLoginOK then
		'// 검색결과 상품목록 작성
		dim rstArrItemid: rstArrItemid=""
		IF cPk.FResultCount >0 then
			For iLp=0 To cPk.FResultCount -1
				rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & cPk.FItemList(iLp).FItemID
			Next
		End if
		'// 위시결과 상품목록 작성
		if rstArrItemid<>"" then
			Call getMyFavItemList(getLoginUserid(),rstArrItemid,vWishArr)
		end if
	end if
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/imagesloaded.pkgd.min.js"></script>
<script type="text/javascript">
var vPg=1, vScrl=true;
$(function(){
	// 스크롤시 추가페이지 접수
	$(window).scroll(function() {
		var currentPercentage = ($(window).scrollTop() / ($(document).outerHeight() - $(window).height())) * 100;
//		if ( $(window).scrollTop() >= ($(document).height() - $(window).height()-1000) ) {
		if(currentPercentage>70){
			if(vScrl) {
				vScrl = false;
				vPg++;
				$.ajax({
					url: "index_ajax.asp?page="+vPg,
					cache: false,
					success: function(message) {
						if(message!="") {
							var $items = $(message);
							$items.imagesLoaded().done( function( instance ) {
								$("#lyrEvtList").append($items);
							});
							vScrl=true;
						} else {
							$(window).unbind("scroll");
						}
					}
					,error: function(err) {
						alert(err.responseText);
						$(window).unbind("scroll");
					}
				});
			}
		}
	});

//	// 로딩중 표시
//	$("#lyLoading").ajaxStart(function(){
//		$(this).show();
//	}).ajaxStop(function(){
//		$(this).hide();
//	});
});

function goWishPop(i,ecd){
	<% If IsUserLoginOK() Then ''ErBValue.value -> 공통파일의 구분값 (cate는 1)%>
	   fnAPPpopupBrowserURL("위시폴더","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popWishFolder.asp?itemid="+i+"&ErBValue=11&gb=search2017",'','wishfolder');
	<% Else %>
		calllogin();
		return false;
	<% End If %>
}

function jsAfterWishBtn(i){
	if($("#wish"+i+"").hasClass("on")){
		
	}else{
		$("#wish"+i+"").addClass("on");
		
		var cnt = $("#cnt"+i+"").text();

		if(cnt == ""){
			$("#wish"+i+"").empty();
			$("#cnt"+i+"").empty().text("1");
		}else{
			cnt = parseInt(cnt) + 1;
			if(cnt > 999){
				$("#cnt"+i+"").empty().text("999+");
			}else{
				$("#cnt"+i+"").empty().text(cnt);
			}
		}
	}
}
</script>
</head>
<body class="default-font body-sub">
	<!-- contents -->
	<div id="content" class="content">
		<div class="md-pick-items">
			<p class="subcopy">최근 일주일간<br /> MD&#39;S PICK에 소개된 상품입니다.</p>

			<% If cPk.FResultCount > 0 Then %>
				<div class="items type-grid">
					<ul id="lyrEvtList">
						<% For intI =0 To cPk.FResultCount-1 %>
							<li>
								<a href="" onclick="fnAPPpopupProduct('<% = cPk.FItemList(intI).Fitemid %>'); return false;">
									<div class="thumbnail"><img src="<%= getThumbImgFromURL(cPk.FItemList(intI).Fimage,400,400,"true","false") %>" alt="" /></div>
									<div class="desc">
										<span class="brand"><%=UCase(cPk.FItemList(intI).Fbrandname)%></span>
										<p class="name"><%=cPk.FItemList(intI).Fitemname%></p>


										<%
										If cPk.FItemList(intI).FsailYN = "N" and cPk.FItemList(intI).FcouponYn = "N" then %>
											<div class="price">
												<div class="unit">
													<b class="sum"><%=formatNumber(cPk.FItemList(intI).ForgPrice,0)%><span class="won">원<% if cPk.FItemList(intI).Fitemdiv="21" Then %>~<% End If %></span></b> 
												</div>
											</div>
										<%
										End If 

										If cPk.FItemList(intI).FsailYN = "Y" and cPk.FItemList(intI).FcouponYn = "N" Then
										%>
											<div class="price">
												<div class="unit"><b class="sum"><%=formatNumber(cPk.FItemList(intI).FsellCash,0)%><span class="won">원<% if cPk.FItemList(intI).Fitemdiv="21" Then %>~<% End If %></span></b> 
													<b class="discount color-red"><% If CLng((cPk.FItemList(intI).ForgPrice-cPk.FItemList(intI).FsellCash)/cPk.FItemList(intI).ForgPrice*100)> 0 Then  %><%=CLng((cPk.FItemList(intI).ForgPrice-cPk.FItemList(intI).FsellCash)/cPk.FItemList(intI).ForgPrice*100)%>%<% End If %></b> 
												</div>
											</div>
										<%
										End If 

										if cPk.FItemList(intI).FcouponYn = "Y" And cPk.FItemList(intI).Fcouponvalue>0 then
										%>
											<div class="price">
												<div class="unit">
													<b class="sum">
														<%
														If cPk.FItemList(intI).Fcoupontype = "1" Then
															response.write formatNumber(cPk.FItemList(intI).FsellCash - CLng(cPk.FItemList(intI).Fcouponvalue*cPk.FItemList(intI).FsellCash/100),0)
														ElseIf cPk.FItemList(intI).Fcoupontype = "2" Then
															response.write formatNumber(cPk.FItemList(intI).FsellCash - cPk.FItemList(intI).Fcouponvalue,0)
														ElseIf cPk.FItemList(intI).Fcoupontype = "3" Then
															response.write formatNumber(cPk.FItemList(intI).FsellCash,0)
														Else
															response.write formatNumber(cPk.FItemList(intI).FsellCash,0)
														End If
														%>
														<span class="won">원<% if cPk.FItemList(intI).Fitemdiv="21" Then %>~<% End If %></span>
													</b> 
													<b class="discount color-green">
														<%
														If cPk.FItemList(intI).Fcoupontype = "1" Then
															response.write CStr(cPk.FItemList(intI).Fcouponvalue) & "%<small>쿠폰</small>"
														ElseIf cPk.FItemList(intI).Fcoupontype = "2" Then
															response.write formatNumber(cPk.FItemList(intI).Fcouponvalue,0) & "원 할인"
														Else
														'	response.write cPk.FItemList(intI).Fcouponvalue
														End If
														%>
													</b>
												</div>
											</div>
										<% end if %>
									</div>
								</a>
								<div class="etc">
									<% If cPk.FItemList(intI).FPoints > 0 Then %><div class="tag review"><span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(cPk.FItemList(intI).FPoints,"search")%>%;">리뷰 종합 별점 <%=fnEvalTotalPointAVG(cPk.FItemList(intI).FPoints,"search")%>점</i></span><span class="counting"><%=chkiif(cPk.FItemList(intI).FMDevalcnt>999,"999+",cPk.FItemList(intI).FMDevalcnt)%></span></div><% End If %>
									<button class="tag wish btn-wish" onclick="goWishPop('<%=cPk.FItemList(intI).FItemid%>');">
										<%
										If cPk.FItemList(intI).FfavCount > 0 Then
											If fnIsMyFavItem(vWishArr,cPk.FItemList(intI).FItemID) Then
												Response.Write "<span class=""icon icon-wish on"" id=""wish"&cPk.FItemList(intI).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&cPk.FItemList(intI).FItemID&""">"
												Response.Write CHKIIF(cPk.FItemList(intI).FfavCount>999,"999+",formatNumber(cPk.FItemList(intI).FfavCount,0)) & "</span>"
											Else
												Response.Write "<span class=""icon icon-wish"" id=""wish"&cPk.FItemList(intI).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&cPk.FItemList(intI).FItemID&""">"
												Response.Write CHKIIF(cPk.FItemList(intI).FfavCount>999,"999+",formatNumber(cPk.FItemList(intI).FfavCount,0)) & "</span>"
											End If
										Else
											Response.Write "<span class=""icon icon-wish"" id=""wish"&cPk.FItemList(intI).FItemID&"""><i> wish</i></span><span class=""counting"" id=""cnt"&cPk.FItemList(intI).FItemID&"""></span>"
										End If
										%>
									</button>
									
									<% If cPk.FItemList(intI).Fcoupontype = "3" Then %>
										<div class="tag shipping"><span class="icon icon-shipping"><i>무료배송</i></span> FREE</div>
									<% end if %>
								</div>
							</li>
						<% next %>
					</ul>
				</div>
			<% end if %>
		</div>
	</div>
	<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
	<!-- //contents -->

	<!-- include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<% SET cPk = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->