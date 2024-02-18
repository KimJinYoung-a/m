<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	currentdate = date()
	'currentdate = "2016-10-24"
	
	'response.write currentdate

'#######################################################################
'	작업자 전달 사항
'
'	* 어드민에 소스 넣을때 뭐뭐뭐.asp 뒤에 ?eventid=코드 꼭 넣으세요!!
'
'#######################################################################
	Dim vEventID, vStartNo, appevturl
	vEventID = requestCheckVar(Request("eventid"),9)

	If vEventID = "73797" Then
		vStartNo = "0"
	ElseIf vEventID = "73827" Then
		vStartNo = "0"
	ElseIf vEventID = "73828" Then
		vStartNo = "0"
	ElseIf vEventID = "73829" Then
		vStartNo = "2"
	ElseIf vEventID = "73830" Then
		vStartNo = "3"
	ElseIf vEventID = "73832" Then
		vStartNo = "4"
	ElseIf vEventID = "73833" Then
		vStartNo = "5"
	ElseIf vEventID = "73834" Then
		vStartNo = "5"
	else
		vStartNo = "0"
	End IF

	If isapp = "1" Then
		appevturl = "/apps/appcom/wish/web2014/event/eventmain.asp?"
	Else
		appevturl = "/event/eventmain.asp?"
	End If 
%>
<!-- #include virtual="/lib/inc/head.asp" -->

<!-- iframe area -->
<style type="text/css">
img {vertical-align:top;}
.newBrandNav {position:relative; width:100%; height:3.75rem; z-index:10;}
.newBrandNav .swiper-container {width:88%; height:3.75rem; margin:0 auto;}
.newBrandNav li {position:relative; display:table; float:left; height:3.75rem;}
.newBrandNav li span {display:table-cell; width:100%; height:3.7rem; margin:0 auto; border-radius:0.4rem; background-color:#fff; font-size:1rem; line-height:1.2; color:#949393; text-align:center; vertical-align:middle;}
.newBrandNav li a {position:absolute; left:0; top:0; display:none; width:100%; height:3.75rem;}
.newBrandNav li.current span {background-color:#373737; font-weight:600; color:#fff;}
.newBrandNav li.open a {display:block;}
.newBrandNav .slideNav {overflow:hidden; position:absolute; top:0; width:5.5%; height:3.75rem; background-position:50% 50%; background-repeat:no-repeat; background-color:transparent; text-indent:-999em; outline:none;}
.newBrandNav .btnPrev {left:0; background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/73797/m/btn_nav_prev.png); background-size:0.55rem auto;}
.newBrandNav .btnNext {right:0; background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/73797/m/btn_nav_next.png); background-size:0.55rem auto;}
</style>
<script type="text/javascript">
$(function(){
    newBrSwiper = new Swiper('.newBrandNav .swiper-container',{
        initialSlide:<%=vStartNo%>, /* 변경가능하도록 해주세요 */
        loop:false,
        autoplay:false,
        speed:500,
        slidesPerView:3,
        pagination:false,
        spaceBetween:10,
        nextButton:'.newBrandNav .btnNext',
        prevButton:'.newBrandNav .btnPrev'
    });
});
</script>
</head>
<body>
    <div class="newBrandNav">
        <div class="swiper-container">
            <ul class="swiper-wrapper">
                <li class="swiper-slide nav1 open <%=CHKIIF(vEventID="73797"," current","")%>"><span>10.24 (월)</span><a href="<%=appevturl%>eventid=73797" target="_top"></a></li>

				<% if currentdate < "2016-10-25" then %>
					<li class="swiper-slide nav2"><span>10.25 (화)</span></li>
				<% Else %>
	                <li class="swiper-slide nav2 open <%=CHKIIF(vEventID="73827"," current","")%>"><span>10.25 (화)</span><a href="<%=appevturl%>eventid=73827" target="_top"></a></li>
	            <% end if %>

				<% if currentdate < "2016-10-26" then %>
					<li class="swiper-slide nav3"><span>10.26 (수)</span></li>
				<% Else %>
	                <li class="swiper-slide nav3 open <%=CHKIIF(vEventID="73828"," current","")%>"><span>10.26 (수)</span><a href="<%=appevturl%>eventid=73828" target="_top"></a></li>
	            <% end if %>

				<% if currentdate < "2016-10-27" then %>
					<li class="swiper-slide nav4"><span>10.27 (목)</span></li>
				<% Else %>
	                <li class="swiper-slide nav4 open <%=CHKIIF(vEventID="73829"," current","")%>"><span>10.27 (목)</span><a href="<%=appevturl%>eventid=73829" target="_top"></a></li>
	            <% end if %>

				<% if currentdate < "2016-10-28" then %>
					<li class="swiper-slide nav5"><span>10.28 (금)</span></li>
				<% Else %>
	                <li class="swiper-slide nav5 open <%=CHKIIF(vEventID="73830"," current","")%>"><span>10.28 (금)</span><a href="<%=appevturl%>eventid=73830" target="_top"></a></li>
	            <% end if %>

				<% if currentdate < "2016-10-31" then %>
					<li class="swiper-slide nav6"><span>10.31 (월)</span></li>
				<% Else %>
	                <li class="swiper-slide nav6 open <%=CHKIIF(vEventID="73832"," current","")%>"><span>10.31 (월)</span><a href="<%=appevturl%>eventid=73832" target="_top"></a></li>
	            <% end if %>

				<% if currentdate < "2016-11-01" then %>
					<li class="swiper-slide nav7"><span>11.1 (화)</span></li>
				<% Else %>
	                <li class="swiper-slide nav7 open <%=CHKIIF(vEventID="73833"," current","")%>"><span>11.1 (화)</span><a href="<%=appevturl%>eventid=73833" target="_top"></a></li>
	            <% end if %>

				<% if currentdate < "2016-11-02" then %>
					<li class="swiper-slide nav8"><span>11.2 (수)</span></li>
				<% Else %>
	                <li class="swiper-slide nav8 open <%=CHKIIF(vEventID="73834"," current","")%>"><span>11.2 (수)</span><a href="<%=appevturl%>eventid=73834" target="_top"></a></li>
	            <% end if %>
            </ul>
        </div>
        <button type="button" class="slideNav btnPrev">이전</button>
        <button type="button" class="slideNav btnNext">다음</button>
    </div>
    <!--// iframe area -->
          
</body>
</html>