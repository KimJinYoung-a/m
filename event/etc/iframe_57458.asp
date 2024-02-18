<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  골라보래이션
' History : 2014.12.22 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event57458Cls.asp" -->

<%
dim eCode, userid, i, typeval, cevent57458, sub_opt2
	eCode=getevt_code
	userid = getloginuserid()
	typeval=getNumeric(requestcheckvar(request("typeval"),1))

dim subscriptcount, totalsubscriptcount1, totalsubscriptcount2
	subscriptcount=0
	totalsubscriptcount1=0
	totalsubscriptcount2=0

set cevent57458 = new Cevent_etc_common_list
	cevent57458.frectevt_code=eCode

'//본인 참여 여부
if userid<>"" then
	'//본인참여수
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")

	'//초기값셋팅
	if typeval="" then
		'//처음참여일경우 첫번째탭으로
		if subscriptcount=0 then
			typeval=1
			
		'//참여완료일경우 일곱번째탭으로
		elseif subscriptcount>=6 then
			typeval=7

		'//나머지 그다음탭으로
		else
			typeval=subscriptcount+1
		end if
	end if

	if subscriptcount>0 then
		cevent57458.frectsub_opt1 = typeval
		cevent57458.frectuserid = userid
		cevent57458.event_subscript_one()
		
		if cevent57458.ftotalcount>0 then
			sub_opt2=cevent57458.FOneItem.fsub_opt2
		end if
	end if
end if

if typeval="" then typeval=1
totalsubscriptcount1=getevent_subscripttotalcount(eCode, typeval, "1", "")
totalsubscriptcount2=getevent_subscripttotalcount(eCode, typeval, "2", "")

'response.write subscriptcount & "/" & typeval
%>

<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.take {padding:13% 0 5%; background-color:#f8f6eb;}
.question ol {overflow:hidden; margin:0 5%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/57461/bg_nav_bar.png) no-repeat 50% 55%; background-size:100% auto;}
.question ol li {float:left; width:14.2%;}
.slidewrap {position:relative; padding:5%;}
.slide {box-shadow:5px 5px 5px 5px rgba(219,218,208,0.3);}
.section {padding-bottom:2.4%;}
#section1 {background-color:#fbc729;}
#section2 {background-color:#fc6868;}
#section3 {background-color:#fd9846;}
#section4 {background-color:#a2da34;}
#section5 {background-color:#48cbe2;}
#section6 {background-color:#a16cbd;}
#section7 {background-color:#f66491;}
.prev, .next {position:absolute; top:24%; width:36px; height:36px; background-color:transparent; background-repeat:no-repeat; background-position:50% 50%; background-size:36px auto; text-indent:-999em;}
.prev {right:20%; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/57461/btn_nav_prev.png);}
.next {right:8%; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/57461/btn_nav_next.png);}
.article {position:relative;}
.article .item {overflow:hidden; margin:0 2.4%; padding-top:10%; background:#fff url(http://webimage.10x10.co.kr/eventIMG/2014/57461/bg_ab.gif) no-repeat 50% 0; background-size:100% auto;}
.article .item li {float:left; width:50%; padding:6.5%; text-align:center;}
.article .or {position:absolute; bottom:8%; left:50%; width:27px; margin-left:-13px;}
.selectwrap {position:relative; width:85px; margin:35px auto 0;}
.selectwrap button {width:85px; padding:10px 0; border-radius:20px; webkit-border-radius:20px; background-color:#818181; color:#fff; font-size:11px; line-height:1.25em;}
.selectwrap button.on {background-color:#d60000; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/57461/ico_check.png); background-repeat:no-repeat; background-position:0 50%; background-size:23px auto;}
.selectwrap .count {position:absolute; top:-10px; right:-5px; padding:2px 5px 0; border:1px solid #eaeaea; border-radius:20px; webkit-border-radius:20px; box-shadow:0 0 2px 2px rgba(219,218,208,0.3);background-color:#fff; color:#000; font-size:11px; line-height:1.25em; text-align:right;}
.noti {background-color:#d9d4ce;}
.noti ul {padding:3% 6.25% 5%;}
.noti ul li {margin-top:3px; padding-left:12px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/57461/blt_arrow.gif); background-repeat:no-repeat; background-position:0 0; background-size:6px 7px; font-size:11px; line-height:1.25em;}
@media all and (min-width:480px){
	.prev, .next {width:54px; height:54px; background-size:54px auto;}
	.article .or {width:40px; margin-left:-20px;}
	.selectwrap button {width:126px; padding:15px 0; border-radius:25px; font-size:17px;}
	.selectwrap button.on {background-size:34px auto;}
	.selectwrap {width:126px; margin:52px auto 0;}
	.selectwrap .count {font-size:17px;}
	.noti ul li {padding-left:18px; background-size:9px auto; background-position:0 3px; font-size:17px; font-weight:normal;}
}
</style>
<script type="text/javascript">

function jsSubmit(v1,v2){
	if (v1==''){
		alert('진행상황이 잘돗 되었습니다.');
		return;
	}
	if (v2==''){
		alert('선물을 선택해 주세요.');
		return;
	}

	<% If IsUserLoginOK() Then %>
		<% If getnowdate>="2014-12-26" and getnowdate<"2015-01-01" Then %>
			<% if subscriptcount>=7 then %>
				alert("모두 참여 하셨습니다.");
				return;
			<% else %>
				<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
					alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
					return;
				<% else %>
					if (v1<= '<%= subscriptcount %>'){
						alert("이전 단계[<%= subscriptcount+1 %>]를 먼저 참여 하셔야 합니다.");
						return;
					}
					
					evtFrm1.typeval.value=v1;
					evtFrm1.sub_opt2.value=v2;
					evtFrm1.action="/event/etc/doEventSubscript57458.asp";
					evtFrm1.target="evtFrmProc";
					evtFrm1.mode.value='valinsert';
					evtFrm1.submit();
				<% end if %>
			<% end if %>
		<% else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&getevt_codedisp)%>');
			return false;
		<% end if %>
	<% End IF %>
}

function changetype(typeval){
	location.href='/event/etc/iframe_57458.asp?typeval='+typeval;
}

<% if subscriptcount>=1 then %>
	$(function(){
		window.parent.$('html,body').animate({scrollTop:600}, 100)
		//setTimeout(window.parent.$('html,body').animate({scrollTop:700}, 100),500)
	});
<% end if %>

</script>
</head>
<body>
<div class="mEvt57461">
	<div class="choose">
		<div class="topic">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/txt_choose.gif" alt ="골라 보래이션 선물, 더이상 고민하지 말고 일단 골라보세요!" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/txt_gift.gif" alt ="이벤트에 응모하신 분들 중 50분을 선정해 기프트 카드 10만원 권를 드립니다. 이벤트 기간은 2014년 12월 26일부터 31일까지입니다." /></p>
		</div>

		<!-- 참여 -->
		<div class="take">
			<div class="question">
				<ol>
					<!-- for dev msg : 현재 보고 있는 상황에는 _on.png, 선택 완료시에는_ end.png로 이미지명을 바꿔주세요. -->
					<li class="q1">
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/tab_01_<% if typeval=1 then %>on<% else %><% if subscriptcount>=1 then %>end<% else %>off<% end if %><% end if %>.png" alt="여친" />
					</li>
					<li class="q2">
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/tab_02_<% if typeval=2 then %>on<% else %><% if subscriptcount>=2 then %>end<% else %>off<% end if %><% end if %>.png" alt="동료" />
					</li>
					<li class="q3">
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/tab_03_<% if typeval=3 then %>on<% else %><% if subscriptcount>=3 then %>end<% else %>off<% end if %><% end if %>.png" alt="펫" />
					</li>
					<li class="q4">
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/tab_04_<% if typeval=4 then %>on<% else %><% if subscriptcount>=4 then %>end<% else %>off<% end if %><% end if %>.png" alt="나" />
					</li>
					<li class="q5">
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/tab_05_<% if typeval=5 then %>on<% else %><% if subscriptcount>=5 then %>end<% else %>off<% end if %><% end if %>.png" alt="동생" />
					</li>
					<li class="q6">
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/tab_06_<% if typeval=6 then %>on<% else %><% if subscriptcount>=6 then %>end<% else %>off<% end if %><% end if %>.png" alt="솔로" />
					</li>
					<li class="q7">
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/tab_07_<% if typeval=7 then %>on<% else %><% if subscriptcount>=7 then %>end<% else %>off<% end if %><% end if %>.png" alt="베프" />
					</li>
				</ol>

				<div class="slidewrap">
					<div class="slide">
						<% if typeval=1 then %>
							<!-- scene1 -->
							<div id="section1" class="section" style="display:;">
								<div class="article">
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/txt_question_01.gif" alt ="검색하기도 지겹다.. 여자친구가 어떤 걸 더 좋아할까요? from 남자친구" /></p>
									<ul class="item">
										<li>
											<% if isApp=1 then %>
												<a href="" onclick="parent.fnAPPpopupBrowserURL('상품정보','<%=wwwUrl%>/apps/appcom/wish/web2014/category/category_itemPrd.asp?itemid=1170368'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_01_a.jpg" alt ="마크제이콥스 베를로" /></a>
											<% else %>
												<a href="/category/category_itemPrd.asp?itemid=1170368" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_01_a.jpg" alt ="마크제이콥스 베를로" /></a>
											<% end if %>
											
											<div class="selectwrap">
												<button type="button" <% if sub_opt2="1" then %>class='on'<% end if %> onclick="jsSubmit('1','1');"><strong>A</strong> 선택</button>
												<strong class="count"><%= totalsubscriptcount1 %></strong>
											</div>
										</li>
										<li>
											<% if isApp=1 then %>
												<a href="" onclick="parent.fnAPPpopupBrowserURL('상품정보','<%=wwwUrl%>/apps/appcom/wish/web2014/category/category_itemPrd.asp?itemid=731102'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_01_b.jpg" alt ="레더 샤체백 15인치 Patent Oxblood Red" /></a>
											<% else %>
												<a href="/category/category_itemPrd.asp?itemid=731102" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_01_b.jpg" alt ="레더 샤체백 15인치 Patent Oxblood Red" /></a>
											<% end if %>
											
											<div class="selectwrap">
												<!-- for dev msg : 선택시 클래스 on 넣어주세요 -->
												<button type="button" <% if sub_opt2="2" then %>class='on'<% end if %> onclick="jsSubmit('1','2');"><strong>B</strong> 선택</button>
												<strong class="count"><%= totalsubscriptcount2 %></strong>
											</div>
										</li>
									</ul>
									<span class="or"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/txt_or.gif" alt ="" /></span>
								</div>
							</div>
						<% end if %>

						<% if typeval=2 then %>
							<!-- scene2 -->
							<div id="section2" class="section" style="display:;">
								<div class="article">
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/txt_question_02.gif" alt ="회사동료 선물 남들 다 챙긴다던데...어떤 선물이 좋을까요?" /></p>
									<ul class="item">
										<li>
											<% if isApp=1 then %>
												<a href="" onclick="parent.fnAPPpopupBrowserURL('상품정보','<%=wwwUrl%>/apps/appcom/wish/web2014/category/category_itemPrd.asp?itemid=1174965'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_02_a.jpg" alt ="양말 Mix Match 5PACK" /></a>
											<% else %>
												<a href="/category/category_itemPrd.asp?itemid=1174965" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_02_a.jpg" alt ="양말 Mix Match 5PACK" /></a>
											<% end if %>
																						
											<div class="selectwrap">
												<button type="button" <% if sub_opt2="1" then %>class='on'<% end if %> onclick="jsSubmit('2','1');"><strong>A</strong> 선택</button>
												<strong class="count"><%= totalsubscriptcount1 %></strong>
											</div>
										</li>
										<li>
											<% if isApp=1 then %>
												<a href="" onclick="parent.fnAPPpopupBrowserURL('상품정보','<%=wwwUrl%>/apps/appcom/wish/web2014/category/category_itemPrd.asp?itemid=1081993'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_02_b.jpg" alt ="꽃보다 누나 The Myths nuts" /></a>
											<% else %>
												<a href="/category/category_itemPrd.asp?itemid=1081993" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_02_b.jpg" alt ="꽃보다 누나 The Myths nuts" /></a>
											<% end if %>
																						
											<div class="selectwrap">
												<button type="button" <% if sub_opt2="2" then %>class='on'<% end if %> onclick="jsSubmit('2','2');"><strong>B</strong> 선택</button>
												<strong class="count"><%= totalsubscriptcount2 %></strong>
											</div>
										</li>
									</ul>
									<span class="or"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/txt_or.gif" alt ="" /></span>
								</div>
							</div>
						<% end if %>

						<% if typeval=3 then %>
							<!-- scene3 -->
							<div id="section3" class="section" style="display:;">
								<div class="article">
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/txt_question_03.gif" alt ="아무거나 입어도 잘 어울리는 마이펫, 더 잘 어울리는 옷은?" /></p>
									<ul class="item">
										<li>
											<% if isApp=1 then %>
												<a href="" onclick="parent.fnAPPpopupBrowserURL('상품정보','<%=wwwUrl%>/apps/appcom/wish/web2014/category/category_itemPrd.asp?itemid=768763'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_03_a.jpg" alt ="눈꽃요정" /></a>
											<% else %>
												<a href="/category/category_itemPrd.asp?itemid=768763" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_03_a.jpg" alt ="눈꽃요정" /></a>
											<% end if %>
											
											<div class="selectwrap">
												<button type="button" <% if sub_opt2="1" then %>class='on'<% end if %> onclick="jsSubmit('3','1');"><strong>A</strong> 선택</button>
												<strong class="count"><%= totalsubscriptcount1 %></strong>
											</div>
										</li>
										<li>
											<% if isApp=1 then %>
												<a href="" onclick="parent.fnAPPpopupBrowserURL('상품정보','<%=wwwUrl%>/apps/appcom/wish/web2014/category/category_itemPrd.asp?itemid=777745'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_03_b.jpg" alt ="크리스마스 망또" /></a>
											<% else %>
												<a href="/category/category_itemPrd.asp?itemid=777745" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_03_b.jpg" alt ="크리스마스 망또" /></a>
											<% end if %>
											
											<div class="selectwrap">
												<button type="button" <% if sub_opt2="2" then %>class='on'<% end if %> onclick="jsSubmit('3','2');"><strong>B</strong> 선택</button>
												<strong class="count"><%= totalsubscriptcount2 %></strong>
											</div>
										</li>
									</ul>
									<span class="or"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/txt_or.gif" alt ="" /></span>
								</div>
							</div>
						<% end if %>

						<% if typeval=4 then %>
							<!-- scene4 -->
							<div id="section4" class="section" style="display:;">
								<div class="article">
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/txt_question_04.gif" alt ="2014년 동안 고생한 나에게 선물을 주고 싶어요!" /></p>
									<ul class="item">
										<li>
											<% if isApp=1 then %>
												<a href="" onclick="parent.fnAPPpopupBrowserURL('상품정보','<%=wwwUrl%>/apps/appcom/wish/web2014/category/category_itemPrd.asp?itemid=864470'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_04_a.jpg" alt ="Organic Soy Candle" /></a>
											<% else %>
												<a href="/category/category_itemPrd.asp?itemid=864470" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_04_a.jpg" alt ="Organic Soy Candle" /></a>
											<% end if %>
											
											<div class="selectwrap">
												<button type="button" <% if sub_opt2="1" then %>class='on'<% end if %> onclick="jsSubmit('4','1');"><strong>A</strong> 선택</button>
												<strong class="count"><%= totalsubscriptcount1 %></strong>
											</div>
										</li>
										<li>
											<% if isApp=1 then %>
												<a href="" onclick="parent.fnAPPpopupBrowserURL('상품정보','<%=wwwUrl%>/apps/appcom/wish/web2014/category/category_itemPrd.asp?itemid=1173084'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_04_b.jpg" alt ="Snow globe music box" /></a>
											<% else %>
												<a href="/category/category_itemPrd.asp?itemid=1173084" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_04_b.jpg" alt ="Snow globe music box" /></a>
											<% end if %>
											
											<div class="selectwrap">
												<button type="button" <% if sub_opt2="2" then %>class='on'<% end if %> onclick="jsSubmit('4','2');"><strong>B</strong> 선택</button>
												<strong class="count"><%= totalsubscriptcount2 %></strong>
											</div>
										</li>
									</ul>
									<span class="or"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/txt_or.gif" alt ="" /></span>
								</div>
							</div>
						<% end if %>

						<% if typeval=5 then %>
							<!-- scene5 -->
							<div id="section5" class="section" style="display:;">
								<div class="article">
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/txt_question_05.gif" alt ="한 살 더 먹는 막내 동생 어떤 선물이 좋을까요?" /></p>
									<ul class="item">
										<li>
											<% if isApp=1 then %>
												<a href="" onclick="parent.fnAPPpopupBrowserURL('상품정보','<%=wwwUrl%>/apps/appcom/wish/web2014/category/category_itemPrd.asp?itemid=1141275'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_05_a.jpg" alt ="2015 데일리로그 다이어리" /></a>
											<% else %>
												<a href="/category/category_itemPrd.asp?itemid=1141275" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_05_a.jpg" alt ="2015 데일리로그 다이어리" /></a>
											<% end if %>
											
											<div class="selectwrap">
												<button type="button" <% if sub_opt2="1" then %>class='on'<% end if %> onclick="jsSubmit('5','1');"><strong>A</strong> 선택</button>
												<strong class="count"><%= totalsubscriptcount1 %></strong>
											</div>
										</li>
										<li>
											<% if isApp=1 then %>
												<a href="" onclick="parent.fnAPPpopupBrowserURL('상품정보','<%=wwwUrl%>/apps/appcom/wish/web2014/category/category_itemPrd.asp?itemid=830847'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_05_b.jpg" alt ="Lamy Safari 만년필" /></a>
											<% else %>
												<a href="/category/category_itemPrd.asp?itemid=830847" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_05_b.jpg" alt ="Lamy Safari 만년필" /></a>
											<% end if %>
											
											<div class="selectwrap">
												<button type="button" <% if sub_opt2="2" then %>class='on'<% end if %> onclick="jsSubmit('5','2');"><strong>B</strong> 선택</button>
												<strong class="count"><%= totalsubscriptcount2 %></strong>
											</div>
										</li>
									</ul>
									<span class="or"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/txt_or.gif" alt ="" /></span>
								</div>
							</div>
						<% end if %>

						<% if typeval=6 then %>
							<!-- scene6 -->
							<div id="section6" class="section" style="display:;">
								<div class="article">
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/txt_question_06.gif" alt ="솔로인 친구에게 친구를 선물하고 싶어요 어떤 상품이 좋을까요?" /></p>
									<ul class="item">
										<li>
											<% if isApp=1 then %>
												<a href="" onclick="parent.fnAPPpopupBrowserURL('상품정보','<%=wwwUrl%>/apps/appcom/wish/web2014/category/category_itemPrd.asp?itemid=934792'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_06_a.jpg" alt ="허니쿠션 남자친구팔쿠션" /></a>
											<% else %>
												<a href="/category/category_itemPrd.asp?itemid=934792" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_06_a.jpg" alt ="허니쿠션 남자친구팔쿠션" /></a>
											<% end if %>
											
											<div class="selectwrap">
												<button type="button" <% if sub_opt2="1" then %>class='on'<% end if %> onclick="jsSubmit('6','1');"><strong>A</strong> 선택</button>
												<strong class="count"><%= totalsubscriptcount1 %></strong>
											</div>
										</li>
										<li>
											<% if isApp=1 then %>
												<a href="" onclick="parent.fnAPPpopupBrowserURL('상품정보','<%=wwwUrl%>/apps/appcom/wish/web2014/category/category_itemPrd.asp?itemid=1152801'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_06_b.jpg" alt ="태양의 라마 바디필로우" /></a>
											<% else %>
												<a href="/category/category_itemPrd.asp?itemid=1152801" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_06_b.jpg" alt ="태양의 라마 바디필로우" /></a>
											<% end if %>
											
											<div class="selectwrap">
												<button type="button" <% if sub_opt2="2" then %>class='on'<% end if %> onclick="jsSubmit('6','2');"><strong>B</strong> 선택</button>
												<strong class="count"><%= totalsubscriptcount2 %></strong>
											</div>
										</li>
									</ul>
									<span class="or"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/txt_or.gif" alt ="" /></span>
								</div>
							</div>
						<% end if %>

						<% if typeval=7 then %>
							<!-- scene7 -->
							<div id="section7" class="section" style="display:;">
								<div class="article">
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/txt_question_07.gif" alt ="고민 많은 내 베프, 선물은 뭐가 좋을까요?" /></p>
									<ul class="item">
										<li>
											<% if isApp=1 then %>
												<a href="" onclick="parent.fnAPPpopupBrowserURL('상품정보','<%=wwwUrl%>/apps/appcom/wish/web2014/category/category_itemPrd.asp?itemid=490208'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_07_a.jpg" alt ="걱정인형" /></a>
											<% else %>
												<a href="/category/category_itemPrd.asp?itemid=490208" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_07_a.jpg" alt ="걱정인형" /></a>
											<% end if %>
											
											<div class="selectwrap">
												<button type="button" <% if sub_opt2="1" then %>class='on'<% end if %> onclick="jsSubmit('7','1');"><strong>A</strong> 선택</button>
												<strong class="count"><%= totalsubscriptcount1 %></strong>
											</div>
										</li>
										<li>
											<% if isApp=1 then %>
												<a href="" onclick="parent.fnAPPpopupBrowserURL('상품정보','<%=wwwUrl%>/apps/appcom/wish/web2014/category/category_itemPrd.asp?itemid=1161897'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_07_b.jpg" alt ="인생독학" /></a>
											<% else %>
												<a href="/category/category_itemPrd.asp?itemid=1161897" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_present_07_b.jpg" alt ="인생독학" /></a>
											<% end if %>
											
											<div class="selectwrap">
												<button type="button" <% if sub_opt2="2" then %>class='on'<% end if %>" onclick="jsSubmit('7','2');"><strong>B</strong> 선택</button>
												<strong class="count"><%= totalsubscriptcount2 %></strong>
											</div>
										</li>
									</ul>
									<span class="or"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/txt_or.gif" alt ="" /></span>
								</div>
							</div>
						<% end if %>

					</div>

					<% ' for dev msg : 좌우 화살표 네비게이션 %>
					<% if subscriptcount>=7 then %>
						<% if typeval>1 then %>
							<button type="button" onclick="changetype('<%= typeval-1 %>');" class="prev">이전</button>
						<% end if %>
						
						<% if typeval<7 then %>
							<button type="button" onclick="changetype('<%= typeval+1 %>');" class="next">다음</button>
						<% end if %>
					<% end if %>
				</div>
			</div>

			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/txt_end.gif" alt ="※ 응모 완료 시 내 투표 결과를 확인할 수 있습니다." /></p>
		</div>

		<div class="noti">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/tit_noti.gif" alt ="이벤트 유의사항" /></h3>
			<ul>
				<li>7가지의 고민을 모두 해결한 후 응모가 가능합니다.</li>
				<li>텐바이텐 로그인 후, 이벤트 참여가 가능합니다.</li>
				<li>당첨자의 제세공과금은 텐바이텐 부담이며, 세무신고를 위해 개인정보를 요청할 수 있습니다.</li>
				<li>한 개의 ID 당 한번만 참여가 가능합니다.</li>
			</ul>
			<div class="btn-gift-talk">
				<% if isApp=1 then %>
					<a href="" onclick="parent.fnAPPpopupBrowserURL('기프트','<%=wwwUrl%>/apps/appcom/wish/web2014/gift/gifttalk/'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_bnr_gift_talk.gif" alt ="텐바이텐의 다양한 고민을 만나보세요! 톡! 엔젤 배지를 받을 수 있는 절호의 찬스! 기프트 톡 바로가기" /></a>
				<% else %>
					<a href="/gift/gifttalk/" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57461/img_bnr_gift_talk.gif" alt ="텐바이텐의 다양한 고민을 만나보세요! 톡! 엔젤 배지를 받을 수 있는 절호의 찬스! 기프트 톡 바로가기" /></a>
				<% end if %>
			</div>
		</div>
	</div>

	<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
	<input type="hidden" name="typeval">
	<input type="hidden" name="sub_opt2">
	</form>
	<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>	
</div>
</body>
</html>

<%
set cevent57458=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->