<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'###########################################################
' Description :  SBS DramaZone (index)
' History : 2018-05-03 이종화 생성 - 모바일
'			2018.06.01 한용민 수정
'###########################################################
Dim sqlStr , arrList , jcnt , idx , dramatitle

idx = getNumeric(requestCheckVar(Request("idx"),10))
If idx = "" Then idx = 0

'// sbs 드라마존 서비스 종료
If date() > "2019-03-31" and GetLoginUserLevel <> "7"  Then
	response.write "<script>alert('종료된 서비스 입니다.'); location.href='/'</script>"
	dbget.close()	:	response.End
End If

'// query
sqlStr = "[db_sitemaster].[dbo].[usp_WWW_SBSvShop_Drama_Get]"
rsget.CursorLocation = adUseClient
rsget.Open sqlStr,dbget,1
IF Not (rsget.EOF OR rsget.BOF) THEN
	arrList = rsget.GetRows
END If
rsget.close

%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style>
.player .rounded-box {background:#0085cd;}
[v-cloak] { display: none; }
</style>
</head>
<body class="default-font body-main">
<!-- #include virtual="/lib/inc/incheader.asp" -->
<script type="text/javascript">
$(function() {
	fnAmplitudeEventAction("view_dramazone","","");
	// sbs drama zone main banner
	if ($('.bnr-sbs .swiper-slide').length > 1) {
		dramaSlideMain = new Swiper('.bnr-sbs .swiper-container',{
			loop:true,
			autoplay:3000,
			autoplayDisableOnInteraction:false,
			speed:800,
			pagination:".bnr-sbs .pagination",
			paginationClickable:true,
			effect:'fade'
		});
		$('.bnr-sbs').addClass('on')
	}
});
</script>
	<%'!-- contents --%>
	<div id="content" class="content sbsDrama">

		<%'// searchbar %>
		<div class="sbs-top">
			<h2 class="ftLt"><img src="http://fiximage.10x10.co.kr/m/2018/sbs/img_logo.png" alt="SBS Dramazone" /></h2>
			<div class="sortingbar ftRt">
				<div class="option-right ellipsis"></div>
			</div>
			<ul>
				<li class="<%=chkiif(idx = 0 ,"on","")%>"><a href="/dramazone/" onclick=fnAmplitudeEventAction("click_dramazonetop","idx","0");>ALL</a></li>
				<%
					if isarray(arrList) Then
						For jcnt = 0 To ubound(arrList,2)
							If clng(idx) = clng(arrList(0,jcnt)) Then dramatitle = arrList(2,jcnt) End If
							Response.write  "<li class='"& chkiif(clng(idx) = clng(arrList(0,jcnt)),"on","") &"'><a href='/dramazone/?idx="& arrList(0,jcnt) &"' onclick=fnAmplitudeEventAction('click_dramazonetop','idx','"&arrList(0,jcnt)&"');>"& arrList(2,jcnt) &"</a></li>"
						Next
					End If
				%>
			</ul>
			<div id="mask"></div>
		</div>
		<%'// searchbar %>
<% if idx = 0 then %>
		<div class="bnr-sbs">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<a href="/event/eventmain.asp?eventid=91346" onclick="jsEventlinkURL(91346);return false;">
							<img src="http://webimage.10x10.co.kr/eventIMG/2018/91346/banMoList20181219120233.JPEG" border="0">
							<div>
								<h3>텐바이텐 x 황후의품격</h3>
								<p>색다른 황실 로맨스 속, 색다른 인테리어<span>~66%</span></p>
							</div>
						</a>
					</div>
					<div class="swiper-slide">
						<a href= "/event/eventmain.asp?eventid=90398" onclick="jsEventlinkURL(90398);return false;">
							<img src="http://webimage.10x10.co.kr/eventIMG/2018/90398/banMoList20181112144955.JPEG" border="0">
							<div>
								<h3>한겨울에도 따스한 집</h3>
								<p>여우각시별 속 따스한 한여름의 방 인테리어<span>~58%</span></p>
							</div>
						</a>
					</div>
				</div>
			</div>
			<div class="pagination"></div>
		</div>
<% end if %>		
		<div id="dramalist" v-if="show" v-cloak>
			<div class="section" v-for="(item,dindex) in sliced" :item="item" :key="item.id" v-if="sliced" >
				<%'스와이퍼 영역%>
				<div class="rolling" v-if="item.videoYN ==0">
					<div class="drama-rolling">
						<div class="swiper-container">
							<div class="swiper-wrapper">
								<image-list v-for="sub in item.dramaimages" :sub="sub"></image-list>
							</div>
						</div>
						<div class="pagination"></div>
						<button type="button" class="slide-nav btn-prev icon">이전</button>
						<button type="button" class="slide-nav btn-next icon">다음</button>
					</div>
				</div>

				<%'비디오 영역%>
				<div class="vod" v-if="item.videoYN == 1">
					<iframe class="vod-player" :src="item.videourl" frameborder="0" allowfullscreen></iframe>
					<div class="prev-thumb" @click="videoplay($event);">
						<img :src="item.mainimage" :alt="item.title" />
					</div>
				</div>

				<div class="info">
					<span class="thumb-chn"><img :src="item.posterimage" :alt="item.title" /></span><%'로고%>
					<div class="tit">
						<h3>{{item.title}}</h3>
						<p class="date">{{item.regdate}}</p>
					</div>
					<a :href="item.dramaurl" class="icon-share-wht icon"></a>
				</div>
				<div class="desc" v-html="item.contents"></div>
				<ul>
					<item-list v-for="(sub, index) in item.dramaitem" :sub="sub" :idx="index" :isapp="0" :limit="item.rowLimit"></item-list>					
				</ul>					
				<p class="more" @click="viewMore(item.dramaitem.length, dindex)" v-if="item.dramaitem.length > 4 && item.viewFlag == 1">상품 더보기...</p>	
				<a :href="`/event/eventmain.asp?eventid=${item.evtcode}`" v-if="isDateValid(item.evtsdt, item.evtedt)">
					<drama-bnr :item="item" v-bind:class="[item.bannerimage=='' ? 'full' : '' ,item.bannersaleper==0 ? 'no-sale' : '']" v-if="item.bannerisusing == 'Y'" :evtcode="item.evtcode"></drama-bnr>				
				</a>							
			</div>
		</div>
	</div>
	<script>
	// json - apiurl
	var dataurl = "/dramazone/";
	var json_data2 = dataurl+"json_data2.asp?dramaidx=<%=idx%>";
	</script>
	<script src="/vue/vue.min.js"></script>
	<script src="/vue/dramazone.js?v=1.02"></script>
	<script>
	$(function(){
		// dramatitle
		<% if idx = 0 then  %>
		$('.option-right').text('ALL');
		<% else %>
		$('.option-right').text('<%=dramatitle%>');
		<% end if %>
	});
	</script>
	<!-- #include virtual="/lib/inc/incfooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->