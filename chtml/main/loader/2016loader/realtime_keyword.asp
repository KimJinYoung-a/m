<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<%
response.charset = "utf-8"
'#######################################################
' Discription : today _ 실시간 급상승 검색어
' History : 2017-04-24 이종화 생성
'#######################################################

Dim gaParam : gaParam = "&gaparam=today_searchkeyword_" '//GA 체크 변수
dim chkMyKeyword : chkMyKeyword=True '나의 검색어
	dim arrMyKwd, mykeywordloop
	dim retUrl
	retUrl = request.ServerVariables("HTTP_REFERER")

	'//검색어
	DIM oPpkDoc, arrPpk
	Dim arrRtp , arrRTg 
	SET oPpkDoc = New SearchItemCls
		oPpkDoc.FPageSize = 15
'		oPpkDoc.getPopularKeyWords2 arrRtp,arrRTg		'순위정보 포함
		oPpkDoc.getRealtimePopularKeyWords arrRtp,arrRTg		'순위정보 포함
	SET oPpkDoc = NOTHING 


on Error Resume Next
If isArray(arrRtp)  THEN
%>
<script>
var keywordRank;
$(function(){
	/* keyword rank */
	keywordRank = new Swiper(".slidingVertical .swiper-container", {
		direction:"vertical",
		autoplay:2000,
		loop:true,
		speed:800,
		noSwipingClass:".noswiping",
		noSwiping:true
	});
	<% if isapp="1" then '//앱에선 기존 %>
	$(".slidingVertical .btnClose").hide();
	<% else '//모바일에서만 열림 %>
	$(".slidingVertical .btnOpen").show();
		$(".slidingVertical").addClass("slideDown");
		keywordRank.destroy(true,true);
	<% end if %>
	$(".slidingVertical .btnOpen").on("click", function(e){
		$(this).hide();
		$(".slidingVertical .btnClose").show();
		$(this).parent().addClass("slideDown");
		keywordRank.destroy(true,true);
	});
	$(".slidingVertical .btnClose").on("click", function(e){
		$(this).hide();
		$(".slidingVertical .btnOpen").show();
		$(this).parent().removeClass("slideDown");
		keywordRank = new Swiper(".slidingVertical .swiper-container", {
			direction:"vertical",
			initialSlide:keywordRank.activeIndex,
			autoplay:2000,
			loop:true,
			speed:800,
			noSwipingClass:".noswiping",
			noSwiping:true
		});
	});
});
</script>
<section id="keywordRank" class="keywordRank">
	<div class="slidingVertical">
		<h2>급상승 <span>인기 검색어</span></h2>
		<div class="swiper-container">
			<ul class="swiper-wrapper">
		<%
			dim vArwhtml , t_keyword 
			Dim ii : ii = 0
			If Ubound(arrRtp)>0 then
				For mykeywordloop=0 To UBOUND(arrRtp)
					If arrRtp(mykeywordloop) <> t_keyword Then
						If ii > 9 Then Exit For 
						if trim(arrRtp(mykeywordloop))<>"" Then

						'등락표시
						if cStr(arrRTg(mykeywordloop))="new" then
							vArwhtml = "<i class=""tag new"">NEW</i>"
						elseif arrRTg(mykeywordloop)="0" or arrRTg(mykeywordloop)="" then
							vArwhtml = "<i class=""tag keep"">유지</i>"
						elseif arrRTg(mykeywordloop)>0 then
							vArwhtml = "<i class=""tag up"">상승</i>"
						else
							vArwhtml = ""
						end if
		%>
			<li class="swiper-slide">
				<% If isapp = "1" Then %>
				<a href="" onclick="fnAPPpopupSearch('<%=arrRtp(mykeywordloop) %>');return false;"><span class="no"><%=ii+1%></span> <span class="word"><%=arrRtp(mykeywordloop) %></span> <%=vArwhtml%></a>
				<% Else %>
				<a href="/search/search_item.asp?rect=<%=Server.URLEncode(arrRtp(mykeywordloop)) %>&burl=<%=Server.URLEncode(retUrl)%><%=gaParam%><%=Server.URLEncode(arrRtp(mykeywordloop)) %>"><span class="no"><%=ii+1%></span> <span class="word"><%=arrRtp(mykeywordloop) %></span> <%=vArwhtml%></a>
				<% End If %>
			</li>
		<%				End If
					ii = ii + 1
					end If
				t_keyword = arrRtp(mykeywordloop)
				Next
			End If
		%>
		</ul>
	</div>
		<button type="button" class="btnOpen"><span>열기</span></button>
		<button type="button" class="btnClose"><span>닫기</span></button>
	</div>
</section>
<%
End If 
on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->