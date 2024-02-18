<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'###########################################################
' Description : 기프트Talk
' History : 2015.02.10 유태욱 생성
'			2015.02.26 한용민 수정(휴대폰 빽버튼 클릭시 히스토리 처리, 해시 처리후 페이징 다시 계산)
'			2020.10.07 정태훈 19th 선물의참견 이벤트 수정
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemOptionCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/gift/giftCls.asp" -->
<!-- #include virtual="/lib/classes/wish/WishCls.asp" -->
<!-- #include virtual="/gift/Underconstruction_gift.asp" -->
<%
Dim vSort , vKey1, vCurrPage, PageSize, vGnbFlag
	vCurrPage = requestCheckVar(Request("cpg"),5)
	vSort = requestCheckVar(Request("sort"),1)
	vGnbFlag = requestCheckVar(Request("gnbflag"),1)

If vCurrPage = "" Then vCurrPage = 1
PageSize=10

	If isNumeric(vCurrPage) = False Then
		Response.Write "<script>alert('잘못된 경로입니다.');location.href='/';</script>"
		dbget.close()
		Response.End
	End If

	If vGnbFlag <> "1" Then
		strHeadTitleName = "선물가이드"
	End If

	'19th 마일리지 이벤트 추가 
	dim currentDate, userid
	currentDate = now()
	userid = GetLoginUserID()
	if userid="ley330" or userid="greenteenz" or userid="rnldusgpfla" or userid="cjw0515" or userid="thensi7" or userid = "motions" or userid = "jj999a" or userid = "phsman1" or userid = "jjia94" or userid = "seojb1983" or userid = "kny9480" or userid = "bestksy0527" or userid = "mame234" or userid = "corpse2" or userid = "starsun726" or userid = "bora2116" then
		If application("Svr_Info")="staging" Then
			currentDate = #09/20/2021 09:00:00#
		end if
	end if
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style>
.gift-topicV20 {position:relative; height:149.33vw; overflow:hidden;}
.gift-topicV20 .main-bg-area {position:absolute; left:0; top:0;}
.gift-topicV20 .tit-area {position:absolute; left:0; top:0; width:100%; z-index:2;}
.gift-topicV20 .tit-area h2 {width:76.53vw; padding-top:2.90rem; margin:0 auto; animation:fadeDown 1s both;}
.gift-topicV20 .tit-area p {width:51.07vw; padding-top:0.70rem; margin:0 auto; animation:fadeDown 1s .5s both;}
.gift-topicV20 .tit-area .icon-01 {width:14.40vw; position:absolute; left:6%; top:67%; animation:updown 1s .3s linear alternate infinite;}
.gift-topicV20 .tit-area .icon-02 {width:25.20vw; position:absolute; right:-6%; top:106%; animation:updown 1s linear alternate infinite;}
.gift-topicV20 .btn-group {position:absolute; left:0; top:116%;}
@keyframes fadeDown {
	from {transform:translateY(-1rem); opacity:0;}
	to {transform:translateY(0); opacity:1;}
}
@keyframes updown {
    0% {transform:translateY(.5rem);}
    100% {transform:translateY(0);}
}
.gift-topicV20 .btn-area {position:absolute; left:0; bottom:0; width:100%; height:60%; z-index:2;}
.gift-topicV20 .btn-area ul {display:flex; height:30%; margin-top:37%; padding:0 5%;}
.gift-topicV20 .btn-area ul:last-child {height:23%; margin-top:3%;}
.gift-topicV20 .btn-area li {flex:1; width:100%;}
.gift-topicV20 .btn-area li a {display:block; height:100%; font-size:0; color:transparent; -webkit-tap-highlight-color:transparent;}
</style>
<script type="text/javascript">
<!-- #include file="./inc_Javascript.asp" -->

var isloading=true;
$(function(){
	/* $( ".giftTopicV19" ).each(function() {
		var random1 = Math.floor(Math.random() * 3) + 1;
		$(this).css({'background-image': 'url(//fiximage.10x10.co.kr/m/2019/gift/1913/bg_slide_'+ random1 +'.jpg)' })
	}); */
	// 저장된 해쉬 값을 불러와 셋팅
	 if(document.location.hash){
	 	//alert( document.location.hash );
		var str_hash = document.location.hash;
		str_hash = str_hash.replace("#","");
		var varr_curpage=str_hash.split("^");
		var vTsn=varr_curpage[0];
		var vPsz=varr_curpage[1];
		$("#cpg").val("1");
		$("#psz").val(vPsz);
		getList();
		$('body, html').delay(500).animate({ scrollTop: vTsn }, 50);
	 }else{
		//첫페이지 접수
		getList();
	}

	//스크롤 이벤트 시작
	//$(window).unbind("scroll");
	$(window).scroll(function() {
      if ($(window).scrollTop() >= $(document).height() - $(window).height() - 400){
          if (isloading==false){
            isloading=true;
			var pg = $("#mygiftfrm input[name='cpg']").val();
			pg++;
			$("#mygiftfrm input[name='cpg']").val(pg);

            setTimeout("getList()",150);
          }
      }
    });
});

function getList() {
	var str = $.ajax({
			type: "GET",
	        url: "/gift/gifttalk/index_act.asp",
	        data: $("#mygiftfrm").serialize(),
	        dataType: "text",
			async: false,
			error: function(){				
				$(window).unbind("scroll");				
			}
	}).responseText;

	if(str!="") {
    	if($("#mygiftfrm input[name='cpg']").val()=="1") {
        	$('#giftArticle').html(str);

			//$(".giftArticle").masonry({
			//	itemSelector: ".box"
			//	,isAnimatedFromBottom: true
			//});
        } else {
       		//$('#giftArticle .box1').last().after(str);
       		$('#giftArticle').append(str);
       		//$str = $(str)
       		//$('.giftArticle').append($str).masonry('appended',$str);

        }
        isloading=false;
    } else {
    	$(window).unbind("scroll");
    }
	
	$('#giftArticle .cmtWrap').hide();
}

$("#Hlink1").live("click", function(e) {
	var tpsz;
	//tpsz = (Number($("#cpg").val())+1)*Number($("#psz").val());
	tpsz = (Number($("#cpg").val()))*Number($("#psz").val());
	document.location.hash=document.body.scrollTop+"^"+tpsz

});

$("#Hlink2").live("click", function(e) {
	var tpsz2;
	//tpsz2 = (Number($("#cpg").val())+1)*Number($("#psz").val());
	tpsz2 = (Number($("#cpg").val()))*Number($("#psz").val());
	document.location.hash=document.body.scrollTop+"^"+tpsz2
});

//코맨트리스트 아작스 호출
function getcommentlist_act(talkidx){
	var str = $.ajax({
			type: "GET",
	        url: "/gift/gifttalk/index_comment_act.asp",
	        data: "talkidx="+talkidx,
	        dataType: "text",
	        async: false
	}).responseText;
	$('#comment'+talkidx).html(str);

	$('#comment'+talkidx).toggle();
	$('#commenttotal'+talkidx).toggleClass('on');
	return false;	
}

//코맨트 삭제
function DelComments(talkidx,cmtidx){
	<% IF not(IsUserLoginOK) THEN %>
		if(confirm("로그인을 하셔야 삭제할 수 있습니다.\n로그인 하시겠습니까?") == true) {
			parent.location.href = "<%=M_SSLUrl%>/login/login.asp?backpath=/gifttalk/index.asp";
			return true;
		} else {
			return false;
		}
	<% end if %>

	if(confirm("선택한 글을 삭제하시겠습니까?") == true) {
		//'코멘트 idx 추가
		document.delfrm.gubun.value = "d";
		document.delfrm.idx.value = cmtidx;
		document.delfrm.talkidx.value = talkidx;
	
		var str = $.ajax({
			type: "GET",
	        url: "/gift/gifttalk/iframe_talk_comment_proc.asp",
	        data: $("#delfrm").serialize(),
	        dataType: "text",
	        async: false
		}).responseText;
		
		if (str.length=='2'){
			if (str=='d1'){
				location.href = "/gift/gifttalk/index.asp";
			}else if (str=='99'){
				alert('로그인을 해주세요.');
				return;
			}
		}else{
			alert('정상적인 경로가 아닙니다.');
			return;
		}
	} else {
		return false;
	}
}
</script>

</head>
<body class="body-<%=chkiif(vGnbFlag="1","main","sub")%>">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<!-- contents -->
	<div id="content" class="content giftV15a" style="background-color:#e7eaea;">
		<h2 class="hidden">GIFT TALK</h2>
			<!-- # include virtual="/gift/inc_gift_menu.asp" --> <!-- 기프트 탭 삭제 20181116-->
		<form id="mygiftfrm" name="mygiftfrm" method="get" style="margin:0px;">
		<input type="hidden" name="cpg" id="cpg" value="<%= vCurrPage %>" />
		<input type="hidden" name="psz" id="psz" value="<%=PageSize%>">
		<input type="hidden" name="sort" value="<%=vSort%>" />
		<input type="hidden" name="beforepageminidx" />
		</form>
		<% If (currentDate >= "2020-10-12" And currentDate < "2020-10-30") Then %>
		<%'<!-- for dev msg : 19주년 선물의 참견 이벤트 -->%>
		<style>
		.giftTopic19th {position:relative; background:#ffd544 url(//webimage.10x10.co.kr/fixevent/event/2020/19th/gifttalk/m/bg_pat.jpg) repeat center top / 100% auto;}
		.giftTopic19th .tit-area,.giftTopic19th .tit-area h2 {position:relative;}
		.giftTopic19th .tit-area::before,
		.giftTopic19th .tit-area::after,
		.giftTopic19th .tit-area h2::before,
		.giftTopic19th .tit-area h2::after {content:' '; display:block; position:absolute; z-index:5; width:12vw; height:12vw; background:no-repeat center / contain;}
		.giftTopic19th .tit-area::before {left:0; top:0; width:17.3vw; height:30vw; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/gifttalk/m/img_character_01.png);}
		.giftTopic19th .tit-area::after {right:-2.7vw; top:13.3vw; width:20vw; height:28.7vw; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/gifttalk/m/img_character_02.png);}
		.giftTopic19th .tit-area h2::before {top:2.7vw; left:13.3vw; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/gifttalk/m/img_deco_01.png); animation:star 1.5s 1s ease-in-out infinite;}
		.giftTopic19th .tit-area h2::after {right:13.3vw; top:30vw; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/gifttalk/m/img_deco_02.png); animation:star 2s ease-in-out infinite;}
		.giftTopic19th .btn-info {display:block; width:100%; padding-top:38.7%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/gifttalk/m/btn_unfold.png) no-repeat center / 100% auto; outline:none;}
		.giftTopic19th .btn-info.on {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/gifttalk/m/btn_fold.png);}
		.giftTopic19th .txt-info {display:none;}
		@keyframes star {
			0%,100% {opacity:1;}
			50% {opacity:0;}
		}
		.giftTopic19th .btn-area {position:relative;}
		.giftTopic19th .btn-list {display:flex; flex-wrap:wrap; justify-content:center; position:absolute; top:0; left:0; width:100%; height:100%; padding:0 8.5%;}
		.giftTopic19th .btn-list li {position:relative; float:left; width:50%; height:50%;}
		.giftTopic19th .btn-list li a {display:block; position:absolute; top:0; left:0; width:100%; height:100%; font-size:0; color:transparent;}
		.giftTopic19th .popup {display:none; position:fixed; left:0; top:0; z-index:30; width:100%; height:100%; background:rgba(255,255,255,.95);}
		.giftTopic19th .popup .inner {position:absolute; top:50%; left:50%; width:28.6rem; transform:translate(-50%, -50%);}
		.giftTopic19th .popup .btn-close {position:absolute; top:0; right:0; width:5rem; height:5rem; font-size:0; color:transparent; background:none;}
		.giftTopic19th .popup .link {position:absolute; left:0; top:50%; width:100%; height:23%; font-size:0; color:transparent;}
		.giftTopic19th .btn-info,.giftTopic19th .btn-list li a {-webkit-tap-highlight-color:transparent;}
		</style>
		<script>
		$(function() {
			$(".giftTopic19th .btn-info").on('click', function() {
				$(this).toggleClass('on');
				$(this).next(".txt-info").slideToggle();
			});
			$(".giftTopic19th .btn-close").on('click', function() {
				$(this).closest(".popup").fadeOut();
			});
			$('.giftTopic19th .popup').on('click', function(e) {
				if ($(e.target).hasClass('popup')) $(e.target).fadeOut();
			});
		});
		</script>
		<div class="giftTopic19th">
			<div class="tit-area">
				<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/gifttalk/m/tit_gifttalk_v2.png" alt="선물의 참견"></h2>
				<button type="button" class="btn-info" title="자세히 보기"></button>
				<div class="txt-info"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/gifttalk/m/txt_info_v2.png" alt="이벤트 내용"></div>
			</div>
			<div class="btn-area">
				<img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/gifttalk/m/txt_bot_v3.jpg" alt="선물 준비할 때">
				<ul class="btn-list">
					<li>
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/gifttalk/m/btn_01.png" alt="">
						<a href="/gift/gifttalk/mytalk.asp" class="mWeb">내가 쓴 톡</a>
						<a href="" onClick="jsMyTalkList(); return false;" class="mApp">내가 쓴 톡</a>
					</li>
					<li>
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/gifttalk/m/btn_02.png" alt="">
						<a href="" onClick="writeShoppingTalkNew(); return false;">기프트 톡 쓰기</a>
					</li>
					<!-- 임시제거 20201020
					<li>
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/gifttalk/m/btn_03.png" alt="">
						<a href="/shoppingtoday/gift_recommend.asp?gaparam=today_banner_packaging" class="mWeb">선물포장 서비스</a>
						<a href="" onclick="fnAPPpopupBrowserURL('선물포장 서비스','http://m.10x10.co.kr/apps/appCom/wish/web2014//shoppingtoday/gift_recommend.asp?gaparam=today_banner_packaging','right','','sc');return false;" class="mApp">선물포장 서비스</a>
					</li>
					-->
					<li>
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/gifttalk/m/btn_04.png" alt="">
						<a href="/giftcard/?gaparam=today_banner_giftcard" class="mWeb">텐텐 기프트카드</a>
						<a href="" onclick="fnAPPpopupBrowserURL('기프트카드','http://m.10x10.co.kr/apps/appCom/wish/web2014/giftcard/index.asp?gaparam=today_banner_giftcard','right','','sc');return false;" class="mApp">텐텐 기프트카드</a>
					</li>
				</ul>
			</div>
			<!-- for dev msg : 3개 참여시 팝업 -->
			<div class="popup" id="sucessPop" style="display:none">
				<div class="inner">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/gifttalk/m/popup.png" alt="완료">
					<a href="/offshop/point/mileagelist.asp" class="link mWeb">마일리지 확인하기</a>
					<a href="" onclick="fnAPPpopupBrowserURL('마일리지 내역', 'http://m.10x10.co.kr/apps/appCom/wish/web2014/offshop/point/mileagelist.asp'); return false;" class="link mApp">마일리지 확인하기</a>
					<button type="button" class="btn-close">닫기</button>
				</div>
			</div>
		</div>
		<%'<!-- //19주년 선물의 참견 이벤트 -->%>
		<% else %>
		<div class="gift-topicV20">
			<img src="//fiximage.10x10.co.kr/m/2021/gifttalk/bg_guide_new03.png?v=2.1" alt="">
			<div class="tit-area">
				<h2><img src="//fiximage.10x10.co.kr/m/2021/gifttalk/tit_txt_new03.png?v=2.1" alt="선물의 참견"></h2>
				<p><img src="//fiximage.10x10.co.kr/m/2021/gifttalk/tit_sub_new03.png?v=2.1" alt="선물이 고민된다면 텐텐이들의 참견을 받아보세요."></p>
                <div class="icon-01"><img src="//fiximage.10x10.co.kr/m/2021/gifttalk/icon_item03.png?v=2.1" alt=""></div>
			</div>
			<div class="btn-area">
				<ul>
					<li>
						<a href="/shoppingtoday/gift_recommend.asp?gaparam=today_banner_packaging" class="mWeb">선물포장 상품</a>
						<a href="" onclick="fnAPPpopupBrowserURL('선물포장 서비스','http://m.10x10.co.kr/apps/appCom/wish/web2014//shoppingtoday/gift_recommend.asp?gaparam=today_banner_packaging','right','','sc');return false;" class="mApp">선물포장 상품</a>
					</li>
                    <li>
						<a href="/giftcard/?gaparam=today_banner_giftcard" class="mWeb">텐텐 기프트카드</a>
						<a href="" onclick="fnAPPpopupBrowserURL('기프트카드','http://m.10x10.co.kr/apps/appCom/wish/web2014/giftcard/index.asp?gaparam=today_banner_giftcard','right','','sc');return false;" class="mApp">텐텐 기프트카드</a>
					</li>
                    <li>
						<a href="/gift/gifttalk/mytalk.asp" class="mWeb">내가 쓴 톡</a>
						<a href="" onClick="jsMyTalkList(); return false;" class="mApp">내가 쓴 톡</a>
					</li>
				</ul>
				<ul>
					<li>
						<a href="" onClick="writeShoppingTalkNew(); return false;">기프트 톡 쓰기</a>
					</li>
				</ul>
			</div>
		</div>
		<% end if %>
        <!-- 마일리지 배너 추가 9/20 ~ 9/24 까지 노출 -->
        <style>
            .gift-eventbnr-area .gift-bnr-info {display:none;}
            .gift-eventbnr-area .gift-bnr-info.on {display:block; margin-top:-1px;}
            .gift-eventbnr-area button {position:relative;}
            .gift-eventbnr-area .arrow {display:inline-block; width:1.15rem; height:0.64rem; position:absolute; left:50%; top:45%; margin-left:13.43rem;}
            .gift-eventbnr-area .arrow.on {transform:rotate(180deg);}
        </style>
        <script>
            $(function() {
                $(".gift-eventbnr-area button").on("click",function(){
                    $(this).find("span").toggleClass("on");
                    $(this).next(".gift-bnr-info").toggleClass("on");
                });
            });
        </script>
        <% If currentDate >= #09/20/2021 00:00:00# and currentDate < #09/24/2021 23:59:59# Then %>
        <div class="gift-eventbnr-area">
            <button type="button"><span class="arrow"><img src="//fiximage.10x10.co.kr/m/2021/gifttalk/icon_arrow_down.png" alt="arrow"></span><img src="//fiximage.10x10.co.kr/m/2021/gifttalk/btn_bnr.jpg" alt="최대 10,000p를 받으세요."></button>
            <div class="gift-bnr-info"><img src="//fiximage.10x10.co.kr/m/2021/gifttalk/bnr_info.jpg" alt="마일리지 받는법"></div>
        </div>
        <% end if %>
		<div id="giftArticle" class="giftArticle"></div>
		<p id="nodata" style="display:none;" class="noArticle">해당되는 GIFT TALK이 없습니다.</p>
		<p id="nodata_act" style="display:none;" class="noArticle">해당되는 GIFT TALK이 없습니다.</p>
		<!-- for dev msg : 기프트 톡 쓰기 페이지로 이동 -->
		<div class="btnGift" style="display:none"><a href="" onClick="writeShoppingTalkNew(); return false;">쓰기</a></div>
		<%'=fnDisplayPaging_New(vCurrPage,cTalk.FTotalCount,5,4,"goPage")%>
		<form name="delfrm" id="delfrm" action="/gift/gifttalk/iframe_talk_comment_proc.asp" method="post" target="iframeproc">
			<input type="hidden" name="gubun" id="gubun" value="">
			<input type="hidden" name="talkidx" id="talkidx" value="">
			<input type="hidden" name="idx" value="">
			<input type="hidden" name="useyn" value="N">
		</form>
		<form name="frm1" action="/gift/gifttalk/mytalk_proc.asp" method="post">
			<input type="hidden" name="gubun" id="gubun" value="">
			<input type="hidden" name="userid" id="userid" value="<%=GetLoginUserID()%>">
			<input type="hidden" name="talkidx" id="talkidx" value="">
			<input type="hidden" name="mydell" value="i">
		</form>
		<iframe src="about:blank" name="iframeproc" frameborder="0" width="0" height="0"></iframe>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->