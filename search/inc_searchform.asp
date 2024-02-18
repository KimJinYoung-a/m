<%
dim arrMyKwd, mykeywordloop, vNowFile, vSScrnGubun
Dim cSScrn, vSScrnIDX, vSScrnBGgubun, vSScrnBGcolor, vSScrnBGimg, vSScrnMasking, vSScrnTxtUse, vSScrnTxt1, vSScrnTxt1URL, vSScrnTxt2, vSScrnTxt2URL
dim chkMyKeyword : chkMyKeyword=True '나의 검색어
dim vPrectcnt

vSScrnIDX = NullFillWith(requestCheckVar(request("searchscreenidx"),15),0)
vNowFile = GetFileName()

'// 나의 검색어
if chkMyKeyword then
	arrMyKwd = split(session("myKeyword"),",")
end if

If vNowFile = "search_item" Then
	vSScrnMasking = fnMaskingImage()
	vSScrnGubun = Split(vSScrnMasking,"$$")(0)
	vSScrnMasking = Split(vSScrnMasking,"$$")(1)
	If vSScrnGubun = "i" Then
		vSScrnMasking = "style=""background-image:url(" & vSScrnMasking & ");"""
	ElseIf vSScrnGubun = "c" Then
		vSScrnMasking = "style=""background-color:#" & vSScrnMasking & ";"""
	End If
	vPrectcnt = vItemTotalCount
Else
	SET cSScrn = New CDBSearch
	cSScrn.FRectDevice = "m"
	cSScrn.FRectIsMasking = "x"
	If vSScrnIDX <> 0 AND GetLoginUserLevel() = "7" Then
		cSScrn.FRectIDX = vSScrnIDX
	Else
		cSScrn.FRectUseYN = "y"
		cSScrn.FRectDevice = "m"
	End If
	cSScrn.FRectNowDate = date() & " 10:00:00"
	cSScrn.fnSearchScreen
	vSScrnBGgubun	= cSScrn.FOneItem.Fbggubun
	vSScrnBGcolor	= cSScrn.FOneItem.Fbgcolor
	vSScrnBGimg	= cSScrn.FOneItem.Fbgimg
	vSScrnMasking	= cSScrn.FOneItem.Fmaskingimg
	vSScrnTxtUse	= cSScrn.FOneItem.Ftextinfouse
	vSScrnTxt1		= cSScrn.FOneItem.Ftextinfo1
	vSScrnTxt1URL	= cSScrn.FOneItem.Ftextinfo1url
	vSScrnTxt2		= cSScrn.FOneItem.Ftextinfo2
	vSScrnTxt2URL	= cSScrn.FOneItem.Ftextinfo2url

	If cSScrn.FResultCount < 1 Then
		vSScrnBGgubun = "c"
		vSScrnBGcolor = "BAD3E0"
	End If
	SET cSScrn = Nothing
	
	If vSScrnBGgubun = "i" Then
		vSScrnMasking = "style=""background-image:url(" & vSScrnBGimg & ");"""
	Else
		vSScrnMasking = "style=""background-color:#" & vSScrnBGcolor & ";"""
	End If
End If

'// Amplitude로 전송할 데이터
Dim vAmplitudeSearchTypeValue
If InStr(LCase(request.servervariables("HTTP_REFERER")), "search/") > 0 Then
	If InStr(LCase(request.servervariables("HTTP_REFERER")), "search/index") > 0 Or InStr(LCase(request.servervariables("HTTP_REFERER")), "search/?") > 0 Then
		vAmplitudeSearchTypeValue = "search_main"
	Else
		vAmplitudeSearchTypeValue = "search_result"
	End If
Else
	vAmplitudeSearchTypeValue = "search_main"
End If
%>
	<header id="searchbar" class="searchbar searchbar-<%=CHKIIF(vNowFile="index","inverse","default")%>" <%=vSScrnMasking%>>
		<div class="btn-back"><a href="" onclick="history.back(); return false;">이전</a></div>
		<h1 class="hidden">텐바이텐 검색</h1>
		<form action="<%=wwwUrl%>/search/search_item.asp" onSubmit="return fnTopSearch();" name="searchForm" method="get" style="margin:0px;">
		<input type="hidden" name="cpg" value="1">
		<input type="hidden" name="burl" value="<%=retUrl%>">
		<input type="hidden" name="prectcnt" value="<%=vPrectcnt%>">
		<input type="hidden" name="ampsearchtype" value="<%=vAmplitudeSearchTypeValue%>">
			<fieldset>
			<legend class="hidden">검색 폼</legend>
			<div class="textfield">
				<input type="search" id="rect" name="rect" value="<%=SearchText%>" title="검색어 입력" required placeholder="검색어를 입력해주세요" onkeyup="fnKeyInput();" autocomplete="off" />
				<button type="button" class="btn-reset">리셋</button>
				<%
				If vNowFile="index" Then
					Response.Write "<button type=""button"" class=""btn-cancle btn-cancle1"">닫기</button>"
				Else
					'If vTotalCount > 0 Then
					'	Response.Write "<button type=""button"" class=""btn-cancle btn-cancle2"" onclick=""history.back();"">취소</button>"
					'Else
						Response.Write "<button type=""button"" class=""btn-cancle btn-cancle2"" onclick=""location.href='/';fnAmplitudeEventMultiPropertiesAction('click_search_result_cancel','','');"">닫기</button>"
					'End IF
				End If
				%>
			</div>
			</fieldset>
		</form>
		<div class="list-hashtag">
			<%
			If vSScrnTxtUse > 0 Then
				Response.Write "<a href=""" & vSScrnTxt1URL & "&pNtr=qt_"&vSScrnTxt1&""" onclick=fnAmplitudeEventMultiPropertiesAction('click_search_main','action','tag');>#" & vSScrnTxt1 & "</a>"
				If vSScrnTxtUse > 1 Then
					Response.Write " <a href=""" & vSScrnTxt2URL & "&pNtr=qt_"&vSScrnTxt2&""" onclick=fnAmplitudeEventMultiPropertiesAction('click_search_main','action','tag');>#" & vSScrnTxt2 & "</a>"
				End If
			End If
			%>
		</div>
	</header>

	<%
		Dim vIsExistMyKwd
		vIsExistMyKwd = "x"
		if chkMyKeyword then
			if ubound(arrMyKwd)>=0 then
				vIsExistMyKwd = "o"
	%>
			<div id="recentSearch" class="recent-search">
				<h2>최근 검색어</h2>
				<button type="button" class="btn-del-all" onClick="delMyKeywordAll();return false;">전체삭제</button>
				<ul class="list-line" id="recent">
				<% For mykeywordloop=0 to ubound(arrMyKwd) %>
					<li>
						<a href="/search/search_item.asp?rect=<%=server.URLEncode(arrMyKwd(mykeywordloop))%>&exkw=1&burl=<%=Server.URLEncode(retUrl)%>" onclick=fnAmplitudeEventMultiPropertiesAction('click_search','action|keyword|searchkeyword|view','recent||<%=Server.URLEncode(arrMyKwd(mykeywordloop))%>|<%=vAmplitudeSearchTypeValue%>');><%=arrMyKwd(mykeywordloop)%></a>
						<button type="button" class="btn-del" onclick="delMyKeyword('<%=server.URLEncode(arrMyKwd(mykeywordloop))%>');return false;">삭제</button>
					</li>
				<%
						If mykeywordloop>=4 then Exit For
					next
				%>
				</ul>
			</div>
	<%
			end if
		end if
	%>
	<div id="searchAutoComplete" class="search-auto-complete">
		<div id="autokeywordad" class="auto-ad" style="display:none;">
			<ul>
			</ul>
		</div>
		<div class="auto-keyword">
			<ul id="autocompletelist">
			</ul>
		</div>
	</div>

	<script type="text/javascript">
	var userAgent = navigator.userAgent.toLowerCase();
	$(function(){
		checkOS();

		/* for dev msg : 코딩파일에서 검색 전 화면에 디자인처럼 보여주기위한 js 입니다. */
		if ($("body").hasClass("searchindex")){
			$("#searchbar").removeClass("searchbar-default").addClass("searchbar-inverse");
			$("#mask").on("click",function () {
				$(this).hide();
				$("#searchbar").removeClass("searchbar-default").addClass("searchbar-inverse");
				$("body").css({"padding-top":"0"});
			});
		}

		/* searchbar focus */
		$("#searchbar input").on("focus", function(){
			$("#searchbar").removeClass("searchbar-inverse").addClass("searchbar-default");
			$("#recentSearch").show();
			$("#mask").show();
			$(".btn-reset").show();
			if ($("body").hasClass("searchindex")){
				$("body").css({"padding-top":"4.52rem"});
			}
		});

		/* iphone, ipad, ipod */
		var userAgent = navigator.userAgent.toLowerCase();
		function iosSearch(){
			if(userAgent.match("ipad") || userAgent.match("iphone") || userAgent.match("ipod")) {
				$("#searchbar input").on("focus","keyup", function(){
					$("#searchbar").css("position", "absolute");
					$("#recentSearch").css("position", "absolute");
					$("#searchAutoComplete").css("position", "absolute");
				});
			}
		}
		iosSearch();

		/* searchbar keyup */
		$("#searchbar").on("keyup", function(){
			$(".btn-reset").show();
			$("#recentSearch").hide();
			$("#searchAutoComplete").show();
		});

		/* cancle button */
		$("#searchbar .btn-cancle").on("click", function(){
			if ($("body").hasClass("searchindex")){
				$("#searchbar").removeClass("searchbar-default").addClass("searchbar-inverse");
				$("body").css({"padding-top":"0"});
			}
			$("#searchbar input").val('');
			$("#recentSearch").hide();
			$("#searchAutoComplete").hide();
			$("#mask").hide();
		});

		/* reset button */
		$("#searchbar .btn-reset").on("click", function(){
			searchForm.rect.value = "";
			$(this).hide();
		});

		/* recent keyword */
		$("#recentSearch .btn-del").on("click", function(){
			$(this).parent().remove();
			$("#recentSearch ul").each(function(){
				var checkItem = $(this).children().length;
				if (checkItem == 0) {
					$("#recentSearch").remove();
				}
			});
		});

		$("#recentSearch .btn-del-all").on("click", function(){
			$("#recentSearch").remove();
		});
		
		$("#mask").on("click",function () {
			$(this).hide().css({"z-index":"10"});
			$("#searchAutoComplete").hide();
			$("#recentSearch").hide();
			$("#quickview").empty().hide();
		});
	});
	
	/* android and ios check */
	function checkOS(){
		if(userAgent.match("ipad") || userAgent.match("iphone") || userAgent.match("ipod")) {
			$("body").addClass("ios");
		} else {
			$("body").addClass("android");
		}
	}
	
	// 최근 검색기록 전체 삭제
	function delMyKeywordAll() {
		$.ajax({
			url: "/search/act_mySearchKeyword2017.asp?mode=all",
			cache: false,
			async: false,
			success: function(message) {
				if(message!="") {
					$("#recent").empty().html(message);	
				} else {
					$("#recentSearch").hide();
				}
				$("#mask").show();
			}
			,error: function(err) {
				alert(err.responseText);
			}
		});
	}

	//최근 검색어 선택 삭제
	function delMyKeyword(kwd) {
		$.ajax({
			url: "/search/act_mySearchKeyword2017.asp?mode=del&kwd="+kwd,
			cache: false,
			async: false,
			success: function(message) {
				if(message!="") {
					$("#recent").empty().html(message);	
				} else {
					$("#recentSearch").hide();
			    }
			}
			,error: function(err) {
				alert(err.responseText);
			}
		});
	}
	</script>