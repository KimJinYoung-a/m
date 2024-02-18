<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
'####################################################
' Description : PLAY for MW
' History : 2019-02-21 이종화
'####################################################
%>
<title>10x10 : PLAY</title>
<style>[v-cloak] { display: none; }</style>
</head>
<body class="default-font body-main playV18">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<!-- contents -->
	<div id="content" class="content">
		<a href="" class="btn-playfilter"><img src="//fiximage.10x10.co.kr/m/2019/play/btn_filter.png" alt="필터"></a>

		<%'!-- 필터 --%>
		<div class="play-filter" style="display:none;" id="playsearch" v-cloak>
			<div>
				<a href="" class="btn-close"><img src="//fiximage.10x10.co.kr/m/2019/play/btn_close.png" alt=""></a>
				<h2>필터</h2>
			</div>
			<div>
				<span class="filter-all">
					<input type="checkbox" name="filter-all" id="filter-all" :checked="checkAll"/>
    				<label for="filter-all" @click="filterAddAll"><svg viewBox="0 0 30 28" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"> <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"> <g id="fillterAllView" transform="translate(-552.000000, -648.000000)" stroke="#FFED51" stroke-width="4"> <g id="컨텐츠필터" transform="translate(0.000000, 254.000000)"> <g id="ico_check_yellow" transform="translate(552.000000, 394.000000)"> <polyline id="Path-2" points="2 11.6543589 11.2716912 24.0139093 28 2"></polyline> </g> </g> </g> </g> </svg> 전체보기</label>
				</span>
				<h3>관심있는 컨텐츠를 <br>골라보세요!</h3>
				<ul>
					<li>
						<input type="checkbox" name="filter" id="filter-master" value="1" v-model="contents_cidx" :checked="checked"/>
    					<label for="filter-master">마스터피스</label> 
					</li>
					<li>
						<input type="checkbox" name="filter" id="filter-day" value="3" v-model="contents_cidx" :checked="checked"/>  
    					<label for="filter-day">DAY.FILM</label> 
					</li>
					<li>
						<input type="checkbox" name="filter" id="filter-badge" value="4" v-model="contents_cidx" :checked="checked"/>  
    					<label for="filter-badge">THING.배지</label> 
					</li>
					<li>
						<input type="checkbox" name="filter" id="filter-tamgu" value="2" v-model="contents_cidx" :checked="checked"/>  
    					<label for="filter-tamgu">탐구생활</label> 
					</li>
					<li>
						<input type="checkbox" name="filter" id="filter-goods" value="5" v-model="contents_cidx" :checked="checked"/>  
    					<label for="filter-goods">PLAY.GOODS</label> 
					</li>
				</ul>
			</div>
			<button class="btn btn-submit" @click="filterSender">확인</button>
		</div>

		<%' 플레이 컨텐츠 안내 %>
		<%' guide list 7일 쿠키 %>
		<% If request.Cookies("playGuideView") <> "x" then %>
		<div class="play-guide swiper-container" id="playcontentsinfo" v-cloak>
			<p>상품에 담긴 다양한 스토리를 소개할게요 <button type="button" class="btn-hide">컨텐츠 안내 제거</button></p>
			<ul class="swiper-wrapper">
                <play-info v-for="item in sorting(items)" :item="item" v-if="item.is_using && item.is_view"></play-info>
			</ul>
		</div>
		<% end if %>

		<div id="playlist" v-cloak>
			<ul class="play-contents">
				<component v-for="(item,index) in openingList" :key="index" :is="currentView(item.ui_number)" :item="item"></component>
				<component v-for="(item,index) in sliced" v-if="sliced"	:key="index" :is="currentView(item.ui_number)" :item="item"></component>
			</ul>
		</div>
	</div>
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
<div id="userid" rel="<%=getloginuserid%>" style="display:none;"></div>
<%' vue 설정 파일 %>
<script src="/vue/vue.min.js"></script>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/play.js?v=1.00"></script>
<%' vue 설정 파일 %>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->