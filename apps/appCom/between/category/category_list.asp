<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
response.charset = "utf-8"
%>

<%
'####################################################
' Description :  비트윈 카테고리 리스트
' History : 2014.04.10 원승현 생성
'####################################################
%>

<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->

<%
Dim vDisp : vDisp = getNumeric(requestCheckVar(request("disp"),15))
Dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),9))
Dim CurrPage 	: CurrPage = getNumeric(requestCheckVar(request("cpg"),9))
Dim ChkCateVal : ChkCateVal = getNumeric(requestCheckVar(request("cv"),9))
Dim vCkhs : vCkhs = getNumeric(requestCheckVar(request("ckhs"),9))
Dim ord	: ord = requestCheckVar(request("ord"), 1)

If Trim(PageSize) = "" Or Len(Trim(PageSize))=0 Then
	PageSize="10"
End If

If Trim(CurrPage)="" Or Len(Trim(CurrPage))=0 Then
	CurrPage = "1"
End If

If Trim(vDisp)="" Or Len(Trim(vDisp))=0 Then
	vDisp="101"
End If

If Trim(ord)="" Or Len(Trim(ord))=0 Then
	ord="1"
End If
%>
<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<script type="text/javascript">


$(function(){
   $('.swiper-slide select').on('mousedown touchstart MSPointerDown', function(e){
           e.stopPropagation();
   }); 
	//Swiper Content
	var contentSwiper = $('.swiper-content').swiper({
		onImagesReady:function(){
			setContentSize(0);
		},
		onSlideChangeStart:function(){
			updateNavPosition();
			$("#cpg").val("1");
			$("#psz").val("10");
			$("#ord").val("1");

			$("#pdselect1 option:eq(0)").attr('selected', 'selected');
			$("#pdselect2 option:eq(0)").attr('selected', 'selected');
			$("#pdselect3 option:eq(0)").attr('selected', 'selected');
			$("#pdselect4 option:eq(0)").attr('selected', 'selected');
			$("#pdselect5 option:eq(0)").attr('selected', 'selected');
			$("#pdselect6 option:eq(0)").attr('selected', 'selected');
			$("#pdselect7 option:eq(0)").attr('selected', 'selected');

			$("#scpg").val("1");
			$("#spsz").val("10");
			contentSwiper2.activeIndex=contentSwiper.activeIndex;
			switch(contentSwiper.activeIndex) {
				case 0 :
					getSwipeContents("101", "btcouplelist", "0");
					break;
				case 1 :
					getSwipeContents("102", "bthobbylist", "1");
					break;
				case 2 :
					getSwipeContents("103", "btdigitallist", "2");
					break;
				case 3 :
					getSwipeContents("104", "btfoodlist", "3");
					break;
				case 4 :
					getSwipeContents("105", "btfashionlist", "4");
					break;
				case 5 :
					getSwipeContents("106", "btbeautylist", "5");
					break;
				case 6 :
					getSwipeContents("107", "btsalelist", "6");
					break;
			}

		},
		onSlideChangeEnd:function(){
			switch(contentSwiper.activeIndex) {
				case 0 :
					getSwipeContents("101", "btcouplelist", "0");
					break;
				case 1 :
					getSwipeContents("102", "bthobbylist", "1");
					break;
				case 2 :
					getSwipeContents("103", "btdigitallist", "2");
					break;
				case 3 :
					getSwipeContents("104", "btfoodlist", "3");
					break;
				case 4 :
					getSwipeContents("105", "btfashionlist", "4");
					break;
				case 5 :
					getSwipeContents("106", "btbeautylist", "5");
					break;
				case 6 :
					getSwipeContents("107", "btsalelist", "6");
					break;
			}
		}
	});
	//Swiper Content
	var contentSwiper2 = $('.swiper-content').swiper({
		onImagesReady:function(){
			setContentSize(0);
		},
		onSlideChangeStart:function(){
			updateNavPosition2();
			switch(contentSwiper2.activeIndex) {
				case 0 :
					getSwipeContents2("101", "btcouplelist", "0");
					break;
				case 1 :
					getSwipeContents2("102", "bthobbylist", "1");
					break;
				case 2 :
					getSwipeContents2("103", "btdigitallist", "2");
					break;
				case 3 :
					getSwipeContents2("104", "btfoodlist", "3");
					break;
				case 4 :
					getSwipeContents2("105", "btfashionlist", "4");
					break;
				case 5 :
					getSwipeContents2("106", "btbeautylist", "5");
					break;
				case 6 :
					getSwipeContents2("107", "btsalelist", "6");
					break;
			}

		},
		onSlideChangeEnd:function(){
			switch(contentSwiper2.activeIndex) {
				case 0 :
					getSwipeContents2("101", "btcouplelist", "0");
					break;
				case 1 :
					getSwipeContents2("102", "bthobbylist", "1");
					break;
				case 2 :
					getSwipeContents2("103", "btdigitallist", "2");
					break;
				case 3 :
					getSwipeContents2("104", "btfoodlist", "3");
					break;
				case 4 :
					getSwipeContents2("105", "btfashionlist", "4");
					break;
				case 5 :
					getSwipeContents2("106", "btbeautylist", "5");
					break;
				case 6 :
					getSwipeContents2("107", "btsalelist", "6");
					break;
			}
		}
	});

	//Nav
	var navSwiper = $('.swiper-nav').swiper({
		visibilityFullFit:true,
		slidesPerView:'auto',
		onSlideClick:function(){
			contentSwiper.swipeTo(navSwiper.clickedSlideIndex);
			contentSwiper2.swipeTo(navSwiper.clickedSlideIndex);
		}
	});

	//Update Nav Position
	function updateNavPosition(){
		$('.swiper-nav .active-nav').removeClass('active-nav');
		var activeNav = $('.swiper-nav .swiper-slide').eq(contentSwiper.activeIndex).addClass('active-nav');
		if (!activeNav.hasClass('swiper-slide-visible')) {
			if (activeNav.index()>navSwiper.activeIndex) {
				var thumbsPerNav = Math.floor(navSwiper.width/activeNav.width())-1;
				navSwiper.swipeTo(activeNav.index()-thumbsPerNav);
			}
			else {
				navSwiper.swipeTo(activeNav.index());
			}
		}
	}

	//Update Nav Position
	function updateNavPosition2(){
		$('.swiper-nav .active-nav').removeClass('active-nav');
		var activeNav = $('.swiper-nav .swiper-slide').eq(contentSwiper2.activeIndex).addClass('active-nav');
		if (!activeNav.hasClass('swiper-slide-visible')) {
			if (activeNav.index()>navSwiper.activeIndex) {
				var thumbsPerNav = Math.floor(navSwiper.width/activeNav.width())-1;
				navSwiper.swipeTo(activeNav.index()-thumbsPerNav);
			}
			else {
				navSwiper.swipeTo(activeNav.index());
			}
		}
	}




	window.onload = function() {
		<% if ChkCateVal="1" then %>
			if(document.location.hash)
			{
				contentSwiper2.swipeTo(<%=getCateActiveIndexValue(vDisp)%>);
				getSwipeContents2('<%=vDisp%>','<%=getCateDivName(vDisp)%>','<%=getCateActiveIndexValue(vDisp)%>');
			}
			else
			{
				contentSwiper.swipeTo(<%=getCateActiveIndexValue(vDisp)%>);
				getSwipeContents('<%=vDisp%>','<%=getCateDivName(vDisp)%>','<%=getCateActiveIndexValue(vDisp)%>');
			}
		<% else %>
			if(document.location.hash)
			{
				getSwipeContents2('101','btcouplelist','0');
			}
			else
			{
				getSwipeContents('101','btcouplelist','0');
			}
		<% end if %>

	}

	// 해쉬에 값 저장
	$("#Hlink").live("click", function(e) {
		var AIdex;
		var Dv;
		var Dp;

		switch(contentSwiper2.activeIndex) {
			case 0 :
				AIdex = "0";
				Dv = "btcouplelist";
				Dp = "101";
				break;
			case 1 :
				AIdex = "1";
				Dv = "bthobbylist";
				Dp = "102";
				break;
			case 2 :
				AIdex = "2";
				Dv = "btdigitallist";
				Dp = "103";
				break;
			case 3 :
				AIdex = "3";
				Dv = "btfoodlist";
				Dp = "104";
				break;
			case 4 :
				AIdex = "4";
				Dv = "btfashionlist";
				Dp = "105";
				break;
			case 5 :
				AIdex = "5";
				Dv = "btbeautylist";
				Dp = "106";
				break;
			case 6 :
				AIdex = "6";
				Dv = "btsalelist";
				Dp = "107";
				break;
			default :
				AIdex = "0";
				Dv = "btcouplelist";
				Dp = "101";
				break;
		}
		str_hash = AIdex+"^"+Dv+"^"+Dp+"^"+$("#cpg").val()+"^"+($("#cpg").val()*10)+"^"+document.body.scrollTop;
		document.location.hash=str_hash;

	});


	// 저장된 해쉬 값을 불러와 셋팅
	 if(document.location.hash)
	 {
		var str_hash = document.location.hash;
		str_hash = str_hash.replace("#","");
		var arr_curpage=str_hash.split("^");
		var AIdx=arr_curpage[0];
		var Dv=arr_curpage[1];
		var Dp=arr_curpage[2];
		var Cup=arr_curpage[3];
		var Psz=arr_curpage[4];
		var Tsn=arr_curpage[5];
		var Od =arr_curpage[6];
		$("#cpg").val(Cup);
		$("#psz").val("10");
		$("#scpg").val("1");
		$("#spsz").val(Psz);
		$("#sord").val(Od);
		contentSwiper2.swipeTo(AIdx);
		$(window).load(function()
		 {
			$('body, html').delay(500).animate({ scrollTop: Tsn }, 50);
		 });
	}


		$("#lyLoading").hide();

		$("#lyLoading")
		.ajaxStart(function()
		{
			$('#lyLoading').css('position', 'absolute');
			$('#lyLoading').css('left', $('#ListBtn').offset().left);
			$('#lyLoading').css('top', $('#ListBtn').offset().top-70);
			$('#lyLoading').css('width', $('#ListBtn').css('width'));
			$('#lyLoading').css('height', $('#ListBtn').css('height'));
			$(this).fadeIn(500);
		})
		.ajaxStop(function()
		{
			$(this).fadeOut(500);
		});

});


function setContentSize(sIdx) {
	$('.swiper-content').css({
		height: ($('.swiper-content .swiper-slide ul').eq(sIdx).outerHeight() + $('.swiper-content .swiper-slide .listAddBtn').eq(sIdx).outerHeight()+40)
	})
}


function getSwipeContents(dispValue, DivValue, lnum) {
	$("#listAddBtnHref").attr("href", "javascript:getMoreList('"+DivValue+"','"+lnum+"');").attr("href");
	$("#disp").val(""+dispValue+"");
	getList(""+DivValue+"");
	setTimeout("setContentSize("+lnum+")", 500);
	$('html,body').animate({scrollTop:$("#btwCtgy").offset().top}, 0);
}

function getSwipeContents2(dispValue, DivValue, lnum) {
	$("#listAddBtnHref").attr("href", "javascript:getMoreList('"+DivValue+"','"+lnum+"');").attr("href");
	$("#disp").val(""+dispValue+"");
	$("#sdisp").val(""+dispValue+"");
	getList2(""+DivValue+"");
	setTimeout("setContentSize("+lnum+")", 500);

}

function getMoreList(g, lnum)	{
	var pg = $("#cpg").val();
	pg++;
	$("#cpg").val(pg);
	getList(""+g+"");
	setTimeout("setContentSize("+lnum+")", 500);
}

function getMoreList2(g, lnum)	{
	var pg = $("#scpg").val();
	pg++;
	$("#scpg").val(pg);
	getList2(""+g+"");
	setTimeout("setContentSize("+lnum+")", 500);
}

function chgOrd(od, dispid){
	var pg = $("#cpg").val();
	$("#cpg").val(pg);
	$("#ord").val(od);

	var $str;
	$.ajax({
		type:"GET",
		url:"inc_pdtlist.asp",
        data: $("#popularfrm").serialize(),
        dataType: "text",
		async:false,
		cache:true,
		success : function(Data, textStatus, jqXHR){
			$str = $(Data);
			if (jqXHR.readyState == 4) {
				if (jqXHR.status == 200) {
					if(Data!="") {
						$('#'+dispid+'').html(Data);
					} else {
						alert("상품이 없습니다.");
					}
				}
			}
		},
		error:function(jqXHR, textStatus, errorThrown){

		}
	});

}

function getList(g) {

	var $str;

	$.ajax({
		type:"GET",
		url:"inc_pdtlist.asp",
        data: $("#popularfrm").serialize(),
        dataType: "text",
		async:false,
		cache:true,
		success : function(Data, textStatus, jqXHR){
				$str = $(Data);
				if (jqXHR.readyState == 4) {
					if (jqXHR.status == 200) {
						if(Data!="") {
							if($("#cpg").val()=="1") {
								$('#'+g+'').html(Data);
							} else {
								$str.appendTo($('#'+g+''));
							}
						} else {
							alert("상품이 없습니다.");
						}
					}
				}


		},
		error:function(jqXHR, textStatus, errorThrown){

		}
	});
}

function getList2(g) {

	var $str;

	$.ajax({
		type:"GET",
		url:"inc_pdtlist2.asp",
        data: $("#popularfrm2").serialize(),
        dataType: "text",
		async:false,
		cache:true,
		success : function(Data, textStatus, jqXHR){
				$str = $(Data);
				if (jqXHR.readyState == 4) {
					if (jqXHR.status == 200) {
						if(Data!="") {
							if($("#scpg").val()=="1") {
								$('#'+g+'').html(Data);
							} else {
								$str.appendTo($('#'+g+''));
							}
						} else {
							alert("상품이 없습니다.");
						}
					}
				}

		},
		error:function(jqXHR, textStatus, errorThrown){

		}
	});
}

</script>
</head>
<body>
<form id="popularfrm" name="popularfrm" method="get" style="margin:0px;">
	<input type="hidden" name="cpg" id="cpg" value="<%=CurrPage%>" />
	<input type="hidden" name="disp" id="disp" value="<%=vDisp%>" />
	<input type="hidden" name="psz" id="psz" value="<%=PageSize%>">
	<input type="hidden" name="ord" id="ord" value="<%=ord%>">
</form>
<form id="popularfrm2" name="popularfrm2" method="get" style="margin:0px;">
	<input type="hidden" name="scpg" id="scpg" value="<%=CurrPage%>" />
	<input type="hidden" name="sdisp" id="sdisp" value="<%=vDisp%>" />
	<input type="hidden" name="spsz" id="spsz" value="<%=PageSize%>">
	<input type="hidden" name="sord" id="sord" value="<%=ord%>">
</form>
<div class="wrapper" id="btwCtgy"><!-- for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) -->
	<div id="content">
		<h1 class="noView">카테고리</h1>
		<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<div class="subNaviWrap swiper-container swiper-nav">
				<ul class="subNavi swiper-wrapper">
					<% 'for dev msg : 선택시 active-nav 클래스 추가%>
					<li class="swiper-slide <% If vDisp="" Or vDisp="101" Then %>active-nav<% End If %>"><span>커플</span></li>
					<li class="swiper-slide <% If vDisp="102" Then %>active-nav<% End If %>"><span>소품/취미</span></li>
					<li class="swiper-slide <% If vDisp="103" Then %>active-nav<% End If %>"><span>디지털</span></li>
					<li class="swiper-slide <% If vDisp="104" Then %>active-nav<% End If %>"><span>키친/푸드</span></li>
					<li class="swiper-slide <% If vDisp="105" Then %>active-nav<% End If %>"><span>패션</span></li>
					<li class="swiper-slide <% If vDisp="106" Then %>active-nav<% End If %>"><span>뷰티</span></li>
					<li class="swiper-slide <% If vDisp="107" Then %>active-nav<% End If %>"><span>SALE</span></li>
				</ul>
			</div>
			<!-- Product List -->
			<div class="pdtListWrap swiper-container swiper-content boxMdl">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<div class="sorting">
							<select title="상품 정렬방식 선택" onchange="chgOrd(this.value, 'btcouplelist');" name="select1" id="pdselect1">
								<option value="1">인기상품순</option>
								<option value="2">신상품순</option>
								<option value="3">가격높은순</option>
								<option value="4">가격낮은순</option>
								<option value="5">높은할인율순</option>
							</select>
						</div>
						<ul class="pdtList list03" id="btcouplelist">
						</ul>
					</div>

					<div class="swiper-slide">
						<div class="sorting">
							<select title="상품 정렬방식 선택" onchange="chgOrd(this.value, 'bthobbylist');" name="select2" id="pdselect2">
								<option value="1" <%= Chkiif(ord="1", "selected", "") %> >인기상품순</option>
								<option value="2" <%= Chkiif(ord="2", "selected", "") %> >신상품순</option>
								<option value="3" <%= Chkiif(ord="3", "selected", "") %> >가격높은순</option>
								<option value="4" <%= Chkiif(ord="4", "selected", "") %> >가격낮은순</option>
								<option value="5" <%= Chkiif(ord="5", "selected", "") %> >높은할인율순</option>
							</select>
						</div>
						<ul class="pdtList list03" id="bthobbylist">
						</ul>
					</div>

					<div class="swiper-slide">
						<div class="sorting">
							<select title="상품 정렬방식 선택" onchange="chgOrd(this.value, 'btdigitallist');"  name="select3" id="pdselect3">
								<option value="1" <%= Chkiif(ord="1", "selected", "") %> >인기상품순</option>
								<option value="2" <%= Chkiif(ord="2", "selected", "") %> >신상품순</option>
								<option value="3" <%= Chkiif(ord="3", "selected", "") %> >가격높은순</option>
								<option value="4" <%= Chkiif(ord="4", "selected", "") %> >가격낮은순</option>
								<option value="5" <%= Chkiif(ord="5", "selected", "") %> >높은할인율순</option>
							</select>
						</div>
						<ul class="pdtList list03" id="btdigitallist">
						</ul>
					</div>

					<div class="swiper-slide">
						<div class="sorting">
							<select title="상품 정렬방식 선택" onchange="chgOrd(this.value, 'btfoodlist');" name="select4" id="pdselect4">
								<option value="1" <%= Chkiif(ord="1", "selected", "") %> >인기상품순</option>
								<option value="2" <%= Chkiif(ord="2", "selected", "") %> >신상품순</option>
								<option value="3" <%= Chkiif(ord="3", "selected", "") %> >가격높은순</option>
								<option value="4" <%= Chkiif(ord="4", "selected", "") %> >가격낮은순</option>
								<option value="5" <%= Chkiif(ord="5", "selected", "") %> >높은할인율순</option>
							</select>
						</div>
						<ul class="pdtList list03" id="btfoodlist">
						</ul>
					</div>

					<div class="swiper-slide">
						<div class="sorting">
							<select title="상품 정렬방식 선택" onchange="chgOrd(this.value, 'btfashionlist');" name="select5" id="pdselect5">
								<option value="1" <%= Chkiif(ord="1", "selected", "") %> >인기상품순</option>
								<option value="2" <%= Chkiif(ord="2", "selected", "") %> >신상품순</option>
								<option value="3" <%= Chkiif(ord="3", "selected", "") %> >가격높은순</option>
								<option value="4" <%= Chkiif(ord="4", "selected", "") %> >가격낮은순</option>
								<option value="5" <%= Chkiif(ord="5", "selected", "") %> >높은할인율순</option>
							</select>
						</div>
						<ul class="pdtList list03" id="btfashionlist">
						</ul>
					</div>

					<div class="swiper-slide">
						<div class="sorting">
							<select title="상품 정렬방식 선택" onchange="chgOrd(this.value, 'btbeautylist');" name="select6" id="pdselect6">
								<option value="1" <%= Chkiif(ord="1", "selected", "") %> >인기상품순</option>
								<option value="2" <%= Chkiif(ord="2", "selected", "") %> >신상품순</option>
								<option value="3" <%= Chkiif(ord="3", "selected", "") %> >가격높은순</option>
								<option value="4" <%= Chkiif(ord="4", "selected", "") %> >가격낮은순</option>
								<option value="5" <%= Chkiif(ord="5", "selected", "") %> >높은할인율순</option>
							</select>
						</div>
						<ul class="pdtList list03" id="btbeautylist">
						</ul>
					</div>

					<div class="swiper-slide">
						<div class="sorting">
							<select title="상품 정렬방식 선택" onchange="chgOrd(this.value, 'btsalelist');" name="select7" id="pdselect7">
								<option value="1" <%= Chkiif(ord="1", "selected", "") %> >인기상품순</option>
								<option value="2" <%= Chkiif(ord="2", "selected", "") %> >신상품순</option>
								<option value="3" <%= Chkiif(ord="3", "selected", "") %> >가격높은순</option>
								<option value="4" <%= Chkiif(ord="4", "selected", "") %> >가격낮은순</option>
								<option value="5" <%= Chkiif(ord="5", "selected", "") %> >높은할인율순</option>
							</select>
						</div>
						<ul class="pdtList list03" id="btsalelist">
						</ul>
					</div>
				</div>
			</div>
			<!-- // Product List -->
			<div class="listAddBtn" id="ListBtn">
				<a href="javascript:getMoreList('btcouplelist','0');" id="listAddBtnHref">상품 더 보기</a>
			</div>
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
<div id="lyLoading" style="text-align:center; padding-top:70px;filter:alpha(opacity=60);opacity:alpha*0.6;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="height:16px;" /></div>
</body>
</html>
<%

Function getCateDivName(val)
	Select Case Trim(val)
		Case "101"
			getCateDivName = "btcouplelist"
		Case "102"
			getCateDivName = "bthobbylist"
		Case "103"
			getCateDivName = "btdigitallist"
		Case "104"
			getCateDivName = "btfoodlist"
		Case "105"
			getCateDivName = "btfashionlist"
		Case "106"
			getCateDivName = "btbeautylist"
		Case "107"
			getCateDivName = "btsalelist"
	End Select
End Function

Function getCateActiveIndexValue(val)
	Select Case Trim(val)
		Case "101"
			getCateActiveIndexValue = "0"
		Case "102"
			getCateActiveIndexValue = "1"
		Case "103"
			getCateActiveIndexValue = "2"
		Case "104"
			getCateActiveIndexValue = "3"
		Case "105"
			getCateActiveIndexValue = "4"
		Case "106"
			getCateActiveIndexValue = "5"
		Case "107"
			getCateActiveIndexValue = "6"
	End Select
End Function

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->