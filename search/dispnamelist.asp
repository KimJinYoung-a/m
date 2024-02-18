<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<title>10x10: 카테고리 검색</title>
<%
	Dim cDisp, vDispArr, i, vSScrnGubun, vSScrnMasking
	SET cDisp = New CDBSearch
	cDisp.FRectDisp = "0"
	vDispArr = cDisp.fnDispNameList
	SET cDisp = Nothing


	vSScrnMasking = fnMaskingImage()
	vSScrnGubun = Split(vSScrnMasking,"$$")(0)
	vSScrnMasking = Split(vSScrnMasking,"$$")(1)
	If vSScrnGubun = "i" Then
		vSScrnMasking = "style=""background-image:url(" & vSScrnMasking & ");"""
	ElseIf vSScrnGubun = "c" Then
		vSScrnMasking = "style=""background-color:#" & vSScrnMasking & ";"""
	End If
%>
<script type="text/javascript">
$(function(){
	$("#searchbar input").on("keyup", function(){
		$(".btn-reset").show();
		$("#navCategory").hide();
		$("#searchResult").show();
	});

	$("#searchcontent").css({"margin-top":"15.02rem"});

	$(window).scroll(function() {
		var y = $(window).scrollTop();
		var is2DepthOpen=false; // 2뎁스가 열려있는지 여부
		// 2뎁스 오픈 여부 확인
		$("#navCategory .depth2").each(function(){
			if($(this).css("display")=="block"&&!is2DepthOpen){
				is2DepthOpen = true;
			}
		});
		//if (y > 0 || is2DepthOpen) {// 스크롤 되거나, 2뎁스가 열려있으면 헤더 접음
		if (y > 0) {
			headerOnOff(false);
		} else if (y < 10) {
			// 헤더 펼침
			headerOnOff(true);
		}
	});

	/* categroy nav */
	$("#navCategory a").on("click", function() {
		if ($(this).parent().parent().hasClass("depth1")){
			$("#navCategory ul li ul").hide();
		}
		
		var thisItem = $(this);
		if ($(this).attr("href")=="") {
			$(this).addClass("on");
			$(this).next().slideToggle();
			
			// 헤더가 펼쳐있으면 접음
			if(!$("#headerSearch").hasClass("header-small")){
				headerOnOff(false);
			}

			setTimeout(function(){
				var headerHeight = $("#headerSearch").height(); // 헤더높이 접수
				$('html, body').animate({scrollTop: $(thisItem).offset().top-headerHeight}, 500);
			},200);
			
			return false;
		} else {
			$(this).next().slideToggle();
			return false;
		}
	});
});

function headerOnOff(bYn) {
	if(bYn){
		// 펼침
		$("#headerSearch").removeClass("header-small");
		$("#searchcontent").css({"margin-top":"15.02rem"});
	} else {
		// 접읍
		$("#headerSearch").addClass("header-small");
		$("#searchcontent").css({"margin-top":"4.78rem"});
	}
}

function jsDispNextDepth(disp) {
	if($("#disp"+disp+"").is(":hidden")){
		$.ajax({
				url: "dispnamelist_ajax.asp?disp="+disp+"",
				cache: false,
				success: function(message)
				{
					$("#disp"+disp+"").empty().append(message);
					$("#disp"+disp+"").show();
				}
		});
	}else{
		$("#disp"+disp+"").hide();
	}
}
	
function jsKeywordReset(){
	$("#searchResult").hide();
	$("#navCategory").show();
}

function jsDispKeywordInput(){
		$.ajax({
			type: "GET",
			url: "dispnamelist_keyword_ajax.asp",
			data:"str=" + $("#dispkeyword").val(),
			dataType: "xml",
			cache: false,
			async: true,
			timeout: 5000,
			beforeSend: function(x) {
				if(x && x.overrideMimeType) {
					x.overrideMimeType("text/xml;charset=utf-8");
				}
			},
			success: function(xml) {

				if($(xml).find("categoryPage").find("item").length>0) {
					$("#searchResult").show();
					$("#nodata").hide();
					
					var result="";

					// item노드 Loop
					$(xml).find("categoryPage").find("item").each(function(idx) {
						if($(this).find("meta1").text() != ""){
							result+= "<li class='category"+$(this).find("disp1").text()+"'><a href='/category/category_list.asp?disp="+$(this).find("meta1").text()+"'>";
							result+= $(this).find("meta2").text();
							result+= "</a></li>";
						}
					});
					strCont= result;

					//자동완성 레이어 출력
					$("#searchResult_real").html(strCont);
				}else{
					$("#searchResult_real").empty();
					$("#searchResult").hide();
					$("#nodata").show();
				}
			}
		});
}
</script>
</head>
<body class="default-font">
	<header id="headerSearch" class="header-search-bg header-search-category">
		<div class="btn-back"><a href="" onclick="history.back(); return false;">이전</a></div>
		<div class="bg" <%=vSScrnMasking%>></div>
		<h1>카테고리 검색</h1>
		<h1 class="heading">카테고리 검색</h1>
		<div id="searchbar" class="searchbar searchbar-round">
			<form>
				<fieldset>
				<div class="textfield">
					<input type="search" id="dispkeyword" name="dispkeyword" onkeyup="jsDispKeywordInput();" onKeyPress="if (event.keyCode == 13){ return false;}" autocomplete="off" title="검색어 입력" placeholder="검색어를 입력해주세요" />
					<button type="reset" class="btn-reset" onclick="jsKeywordReset();">리셋</button>
				</div>
				</fieldset>
			</form>
		</div>
	</header>

	<div id="searchcontent" class="search-content">
		<nav id="navCategory" class="list-line nav-category">
			<ul class="depth1">
			<%
			If isArray(vDispArr) Then
				For i = 0 To UBound(vDispArr,2)
			%>
				<li class="icon-category<%=vDispArr(0,i)%>"><a href="" onclick="jsDispNextDepth('<%=vDispArr(0,i)%>'); return false;"><span><%=vDispArr(1,i)%></span></a>
					<ul class="depth2" id="disp<%=vDispArr(0,i)%>" style="display:none;">
					</ul>
				</li>
			<%
				Next
			End If
			%>
			</ul>
		</nav>

		<!-- search result list -->
		<div id="searchResult" class="list-line search-result-list search-result-list-catergory" style="display:none;">
			<ul id="searchResult_real"></ul>
		</div>

		<!-- 검색 결과가 없을 경우 -->
		<div id="nodata" class="nodata nodata-search" style="display:none;">
			<p><b>아쉽게도 일치하는 내용이 없습니다</b></p>
			<p>품절 또는 종료된 경우에는 검색되지 않습니다</p>
		</div>
	</div>
	<div id="gotop" class="btn-top"><button type="button">맨위로</button></div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->