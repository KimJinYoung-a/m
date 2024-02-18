<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% 
response.charset = "utf-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'###########################################################
' Description :  비트윈 우편번호찾기
' History : 2014.04.23 이종화
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<%
	Dim stype , strTarget
	If stype = "" Then stype = "road"
	strTarget	= requestCheckVar(Request("target"),32) '//폼이름
%>
<script>
	function searchzip() {
		if ($("#query").val().length < 2) { alert("검색어를 두 글자 이상 입력하세요."); return; }
		//alert("ajax 실행ㄱㄱ");

		var stype = $("#stype").val();
		var searchmsg = escape($("#query").val());
		var sUrl = "/apps/appcom/between/common/searchzip.asp?stype="+stype+"&query="+searchmsg+"&target=<%=strTarget%>";

		$.ajax({
			url: sUrl,
			cache: false,
			success: function(message) {
				$("#resultzip").empty().html(message);
				myScroll.refresh(); //iscroll 초기화 해줘야 가저오는 데이터 높이값 계산이됨
			}
			,error: function(err) {
				alert(err.responseText);
			}
		});
	}

	function chgTab(dv) {
		if(dv=="a") {
			$("#addr").css("display","block");
			$("#road").css("display","none");
			$(".roadcls").removeClass("current");
			$(".addrcls").addClass("current");
			$("#stype").val("addr");
			$("#chkroad").text("지번 주소");
			$("#resultzip").empty().html("<p class='noResult'>검색어를 입력해주세요.</p>")
		} else {
			$("#addr").css("display","none");
			$("#road").css("display","block");
			$(".addrcls").removeClass("current");
			$(".roadcls").addClass("current");
			$("#stype").val("road");
			$("#chkroad").text("도로명 주소");
			$("#resultzip").empty().html("<p class='noResult'>검색어를 입력해주세요.</p>")
		}
	}
</script>
<div class="lyrPop">
	<div class="lyrPopCont zipCode" dd="a">
		<h1>우편번호 찾기</h1>
		<ul class="tabZipcode">
			<li><a href="#" class="roadcls current" onclick="chgTab('r');return false;">도로명 검색</a></li>
			<li><a href="#" class="addrcls" onclick="chgTab('a');return false;">지번 검색</a></li>
		</ul>
		<input type="hidden" name="stype" id="stype" value="<%=stype%>" >
		<fieldset>
			<div class="finderZipcode">
				<p id="road" style="display:block;">
					찾고자 하는 주소의 도로명을 입력하세요.<br />
					<span class="txtCnclGry">(예: 동숭1길, 세종대로)</span>
				</p>
				<!-- 지번 검색일 경우 메시지 -->
				<p id="addr" style="display:none;">
					찾고자 하는 주소의 동/읍/면 이름을 입력하세요.<br />
					<span class="txtCnclGry">(예: 대치동, 곡성읍, 오곡면)</span>
				</p>
				<!-- 지번 검색일 경우 메시지 -->
				<div class="field">
					<input type="text" title="" name="query" id="query"/><input type="button" value="검색" class="btn02 btw" onclick="searchzip();"/>
				</div>
			</div>
		</fieldset>

		<div class="zipecodeList">
			<p>아래 검색결과 중 해당하는 주소를 선택하세요.</p>

			<div class="thead">
				<strong>우편번호</strong> <strong id="chkroad">도로명주소</strong>
			</div>
			<div class="scrollerWrap">
				<div id="scroller">
					<div class="scroll" id="resultzip">
						<p class="noResult">검색어를 입력해주세요.</p>
					</div>
				</div>
			</div>
		</div>
	</div>
	<span class="lyrClose">&times;</span>
</div>
<div class="dimmed"></div>