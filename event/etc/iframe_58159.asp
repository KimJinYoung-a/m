<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 2015년의 시작, 소원을 빌어요 
' History : 2014.12.30 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event58159Cls.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->

<%
Dim eCode, sqlstr, totalsum, cnt, mode
	eCode=getevt_code

	If Not(GetLoginUserID()="" or isNull(GetLoginUserID())) Then
		sqlstr = "Select count(sub_idx) as totcnt" &_
				"  ,count(case when convert(varchar(10),regdate,120) = '" & Left(now(),10) & "' then sub_idx end) as daycnt" &_
				" From db_event.dbo.tbl_event_subscript" &_
				" WHERE evt_code='" & eCode & "' and userid='" & GetLoginUserID() & "'"
				'response.write sqlstr
		rsget.Open sqlStr,dbget,1
			totalsum = rsget(0)
			cnt = rsget(1)
		rsget.Close
	End if

	If mode = "" then mode="result58159"
%>
<style type="text/css">
img {vertical-align:top;}
.makewish {background-color:#fff;}
.want {overflow:hidden; padding:0 0.5% 6%;}
.want a {overflow:hidden; float:left; width:33.333%; padding:0 0.5%;}
.present ul {overflow:hidden;}
.present ul li {float:left; width:50%;}
/* layer */
.layer {display:none; position:absolute; top:18%; left:50%; z-index:100; width:80%; margin-left:-40%;}
.layerin {position:relative;}
.layerin .btngo {position:absolute; bottom:7%; left:50%; width:50%; margin-left:-25%;}
.layerin .btnmy {position:absolute; bottom:18%; left:50%; width:64%; margin-left:-32%;}
.mask {display:none; position:absolute; top:0; left:0; z-index:50; width:100%; height:100%; background:rgba(0,0,0,.60);}

.today {padding-bottom:9.9%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/58159/bg_btm.gif) no-repeat 50% 100%; background-size:100% auto;}
.today ol {overflow:hidden;}
.today ol li {float:left; position:relative; width:50%;}
.today ol .on {position:absolute; top:5%; left:2%; width:36.25%;}

.social {position:relative;}
.social ul {overflow:hidden; position:absolute; top:15%; right:3%; width:54%;}
.social ul li {float:left; width:33.333%;}
.social ul li a {display:block; margin:0 5%;}
.noti .cont {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}
</style>
<script type="text/javascript">
$(function() {
	$(".mask").click(function(){
		$(".layer").hide();
		$(".mask").hide();
	});
});

function StartGame(){
	<% If Now() < #01/05/2015 00:00:00# Then %>
		<% If IsUserLoginOK Then %>
			<% if cnt >= 1 then %>
				alert('하루에 1번 응모 가능합니다.\n\n내일 다시 응모해주세요.');
			<% else %>
				var str = $.ajax({
					type: "GET",
					url: "/event/etc/doEventSubscript58159.asp",
					data: "mode=result58159",
					dataType: "text",
					async: false
				}).responseText;

				if (str==''){
					alert('정상적인 경로가 아닙니다');
					return;
				}else if (str=='99'){
					alert('로그인을 하셔야 참여가 가능 합니다.');
					return;
				}else if (str=='02'){
					alert('이벤트 응모 기간이 아니거나 유효한 이벤트가 아닙니다.');
					return;
				}else if (str=='03'){
					$("#layerwin").show();
					$(".mask").show();
					return;
				}else if (str=='04'){
					$("#layerlose").show();
					$(".mask").show();
					return;
				}else if (str=='05'){
					alert('데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해 주십시오.');
					return;
				}else if (str=='06'){
					alert('하루에 한번 참여 가능합니다.');
					return;
				}else{
					alert('정상적인 경로가 아닙니다');
					return;
				}
			<% end if %>
		<% Else %>
			<% if isApp=1 then %>
				parent.calllogin();
			<% else %>
				parent.jsevtlogin();
			<% end if %>
		<% End If %>
	<% else %>
		alert('이벤트가 종료되었습니다.');
	<% end if %>
}

function jsViewItem(i){
	<% if isApp=1 then %>
		parent.fnAPPpopupProduct(i);
		return false;
	<% else %>
		top.location.href = "/category/category_itemprd.asp?itemid="+i+"";
		return false;
	<% end if %>
}

function jsmytenbyten(){
	<% if isApp=1 then %>
		parent.fnAPPpopupBrowserURL('마이텐바이텐','<%=wwwUrl%>/<%=appUrlPath%>/my10x10/mymain.asp');
		return false;
	<% else %>
		top.location.href = "/my10x10/mymain.asp";
		return false;
	<% end if %>
}

</script>
</head>
<body>
<div class="mEvt58159">
	<div class="makewish">
		<h1><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/tit_make_wish.gif" alt="2015년 시작은 텐바이텐에서 소원을 빌어요" /></h1>
		<form name="frm" method="POST" style="margin:0px;" target="evtFrmProc">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
		<input type="hidden" name="mode" value="<%=mode%>">
		<div class="choosewrap">
		<% If getnowdate <= "2015-01-01" then %>
			<div class="choose">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/tit_date_01.gif" alt="1월 1일 승승장구운 백점 만점의 당신, 화이팅!" /></h2>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/txt_select_wish.gif" alt="아래 세 가지 중에서 원하는 소원을 선택하세요!" /></p>
				<div class="want">
					<a href="" onclick="StartGame(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/btn_wish_01_01.gif" alt="요행을 바라고 싶을 때 실행을 하는 뚝심 소원빌기" /></a>
					<a href="" onclick="StartGame(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/btn_wish_01_02.gif" alt="오늘 일을 내일로 미룰 수 있는 용기와 가능성 소원빌기" /></a>
					<a href="" onclick="StartGame(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/btn_wish_01_03.gif" alt="쏟은 노력만큼의 감사하고 정직한 결과 소원빌기" /></a>
				</div>

				<div class="present">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/txt_win.gif" alt="두 가지 중 한 가지 오늘의 선물에 당첨됩니다." /></p>
					<ul>
						<li><a href="" onClick="jsViewItem('848252'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/img_present_01_ver2.jpg" alt="타이맥스 미니 30분에게 증정" /></a></li>
						<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/img_present_coupon_01.gif" alt="20,000원 이상 구매시 사용 가능한 3천원 할인 쿠폰, 전원 증정" /></li>
					</ul>
				</div>
			</div>
		<% End if %>

		<% If getnowdate = "2015-01-02" then %>
			<div class="choose">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/tit_date_02.gif" alt="1월 2일 로맨스운 셀렘은 늘 가까이에 있어요!" /></h2>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/txt_select_wish.gif" alt="아래 세 가지 중에서 원하는 소원을 선택하세요!" /></p>
				<div class="want">
					<a href="" onclick="StartGame(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/btn_wish_02_01.gif" alt="지금은 혼자이지만 익숙해지지는 않을래요 인연 소원빌기" /></a>
					<a href="" onclick="StartGame(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/btn_wish_02_02.gif" alt="말하지 않으면 모르는 그 사람의 센스 폭발 센스 소원빌기" /></a>
					<a href="" onclick="StartGame(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/btn_wish_02_03.gif" alt="늦게 나타나는 당신 꼴값 보다는 얼굴깞 얼굴 소원빌기" /></a>
				</div>

				<div class="present">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/txt_win.gif" alt="두 가지 중 한 가지 오늘의 선물에 당첨됩니다." /></p>
					<ul>
						<li><a href="" onClick="jsViewItem('1162994'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/img_present_02_ver2.jpg" alt="Deer Face 30분에게 증정" /></a></li>
						<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/img_present_coupon_02.gif" alt="30,000원 이상 구매시 사용 가능한 5천원 할인 쿠폰, 전원 증정" /></li>
					</ul>
				</div>
			</div>
		<% End if %>

		<% If getnowdate = "2015-01-03" then %>
			<div class="choose">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/tit_date_03.gif" alt="1월 3일 금은보화운 작은 것 부터 시작해요!" /></h2>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/txt_select_wish.gif" alt="아래 세 가지 중에서 원하는 소원을 선택하세요!" /></p>
				<div class="want">
					<a href="" onclick="StartGame(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/btn_wish_03_01.gif" alt="오늘의 커피로 주세요! 저렴한 것을 선택하는 지혜 소원빌기" /></a>
					<a href="" onclick="StartGame(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/btn_wish_03_02.gif" alt="더 이상 술에 취해 카드를 긁고 싶지 않아! 맨정신 소원빌기" /></a>
					<a href="" onclick="StartGame(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/btn_wish_03_03.gif" alt="가끔은 로또도 괜찮아 연금복권은 더 좋아! 당첨운소원빌기" /></a>
				</div>

				<div class="present">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/txt_win.gif" alt="두 가지 중 한 가지 오늘의 선물에 당첨됩니다." /></p>
					<ul>
						<li><a href="" onClick="jsViewItem('1186773'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/img_present_03_ver2.jpg" alt=" Fennec Mini Wallet 30분에게 증정" /></a></li>
						<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/img_present_coupon_03.gif" alt="50,000원 이상 구매시 사용 가능한 만원 할인 쿠폰, 전원 증정" /></li>
					</ul>
				</div>
			</div>
		<% End if %>

		<% If getnowdate = "2015-01-04" then %>
			<div class="choose">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/tit_date_04.gif" alt="1월 4일 건강운 활기 넘치는 일상의 시작!" /></h2>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/txt_select_wish.gif" alt="아래 세 가지 중에서 원하는 소원을 선택하세요!" /></p>
				<div class="want">
					<a href="" onclick="StartGame(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/btn_wish_04_01.gif" alt="새벽에 먹는 치킨 0Kcal로 산화! 뿅! 마법 소원빌기" /></a>
					<a href="" onclick="StartGame(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/btn_wish_04_02.gif" alt="잔병치레 댓츠 노노! 아픔 따위 반나절이면 극뽁 건강 소원빌기" /></a>
					<a href="" onclick="StartGame(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/btn_wish_04_03.gif" alt="5분 숨쉬기 운동으로 1시간 달리기 효과! 에너지 소원빌기" /></a>
				</div>
			
				<div class="present">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/txt_win.gif" alt="두 가지 중 한 가지 오늘의 선물에 당첨됩니다." /></p>
					<ul>
						<li><a href="" onClick="jsViewItem('1186670'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/img_present_04_ver2.jpg" alt="오늘의 즙 30분에게 증정" /></a></li>
						<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/img_present_coupon_04.gif" alt="70,000원 이상 구매시 사용 가능한 15프로 할인 쿠폰, 전원 증정" /></li>
					</ul>
				</div>
			</div>
		<% End if %>
		</div>
		</form>
		
		<% '레이어팝업  %>
		<% If getnowdate <= "2015-01-01" then %>
			<div id="layerwin" class="layer">
				<div class="layerin">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/txt_congratulation_01_ver3.png" alt="승승장구운이 듬뿍! 축하합니다. 타이맥스 위켄더 세트와 함께 백점 만점의 2015년을 보내세요. 2015년 1월 8일 목요일 텐바이텐에서 배송지 주소를 확인해주세요." /></p>
					<div class="btngo"><a href="" onClick="jsViewItem('848252'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/btn_product.gif" alt="상품 보러가기" /></a></div>
				</div>
			</div>

			<div id="layerlose" class="layer">
				<div class="layerin">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/txt_congratulation_coupon_01.png" alt="승승장구운이 듬뿍! 축하합니다. 삼천원 쿠폰이 발급되었습니다. 마이텐바이텐에서 확인해주세요" /></p>
					<div class="btnmy"><a href="" onClick="jsmytenbyten(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/btn_my.gif" alt="마이텐바이텐 바로가기" /></a></div>
				</div>
			</div>
		<% End if %>

		<% If getnowdate = "2015-01-02" then %>
			<div id="layerwin" class="layer">
				<div class="layerin">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/txt_congratulation_02.png" alt="로맨스운이 듬뿍! 축하합니다. NPW 디자인 핫백과 함께 설레는 2015년을 보내세요. 2015년 1월 8일 목요일 텐바이텐에서 배송지 주소를 확인해주세요." /></p>
					<div class="btngo"><a href="" onClick="jsViewItem('1162994'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/btn_product.gif" alt="상품 보러가기" /></a></div>
				</div>
			</div>

			<div id="layerlose" class="layer">
				<div class="layerin">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/txt_congratulation_coupon_02.png" alt="로맨스운이 듬뿍! 축하합니다. 오천원 쿠폰이 발급되었습니다. 마이텐바이텐에서 확인해주세요" /></p>
					<div class="btnmy"><a href="" onClick="jsmytenbyten(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/btn_my.gif" alt="마이텐바이텐 바로가기" /></a></div>
				</div>
			</div>
		<% End if %>

		<% If getnowdate = "2015-01-03" then %>
			<div id="layerwin" class="layer">
				<div class="layerin">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/txt_congratulation_03.png" alt="금은보화운이 듬뿍! 축하합니다. Fennec 미니 지갑과 함께 절약하는 2015년을 보내세요. 2015년 1월 8일 목요일 텐바이텐에서 배송지 주소를 확인해주세요." /></p>
					<div class="btngo"><a href="" onClick="jsViewItem('1186773'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/btn_product.gif" alt="상품 보러가기" /></a></div>
				</div>
			</div>

			<div id="layerlose" class="layer">
				<div class="layerin">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/txt_congratulation_coupon_03.png" alt="금은보화운이 듬뿍! 축하합니다. 만원 쿠폰이 발급되었습니다. 마이텐바이텐에서 확인해주세요" /></p>
					<div class="btnmy"><a href="" onClick="jsmytenbyten(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/btn_my.gif" alt="마이텐바이텐 바로가기" /></a></div>
				</div>
			</div>
		<% End if %>

		<% If getnowdate = "2015-01-04" then %>
			<div id="layerwin" class="layer">
				<div class="layerin">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/txt_congratulation_04.png" alt="건강운이 듬뿍! 축하합니다. 투데이즈 스페셜 오늘의 즙과 함께 활기넘치는 2015년을 보내세요. 2015년 1월 8일 목요일 텐바이텐에서 배송지 주소를 확인해주세요." /></p>
					<div class="btngo"><a href="" onClick="jsViewItem('1186670'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/btn_product.gif" alt="상품 보러가기" /></a></div>
				</div>
			</div>

			<div id="layerlose" class="layer">
				<div class="layerin">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/txt_congratulation_coupon_04.png" alt="건강운이 듬뿍! 축하합니다. 15프로 할인 쿠폰이 발급되었습니다. 마이텐바이텐에서 확인해주세요" /></p>
					<div class="btnmy"><a href="" onClick="jsmytenbyten(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/btn_my.gif" alt="마이텐바이텐 바로가기" /></a></div>
				</div>
			</div>
		<% End if %>

		<div class="today">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/tit_present_check.gif" alt="매일의 선물을 확인하세요!" /></h2>
			<ol>
				<li>
					<a href="" onClick="jsViewItem('848252'); return false;">
						<span class="on" style="display:<% If getnowdate = "2015-01-01" Then response.write "block" Else response.write "none" %>;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/ico_on.png" alt="오늘" /></span>
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/tab_today_01<% If getnowdate > "2015-01-01" Then response.write "_end" %>.jpg" alt="1월 1일 승승장구운" />
					</a>
				</li>
				<li>
					<a href="" onClick="jsViewItem('1162994'); return false;">
						<span class="on" style="display:<% If getnowdate = "2015-01-02" Then response.write "block" Else response.write "none" %>;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/ico_on.png" alt="오늘" /></span>
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/tab_today_02<% If getnowdate > "2015-01-02" Then response.write "_end" %>.jpg" alt="1월 2일 로맨스운" />
					</a>
				</li>
				<li>
					<a href="" onClick="jsViewItem('1186773'); return false;">
						<span class="on" style="display:<% If getnowdate = "2015-01-03" Then response.write "block" Else response.write "none" %>;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/ico_on.png" alt="오늘" /></span>
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/tab_today_03<% If getnowdate > "2015-01-03" Then response.write "_end" %>.jpg" alt="1월 3일 금은보화운" />
					</a>
				</li>
				<li>
					<a href="" onClick="jsViewItem('1186670'); return false;">
						<span class="on" style="display:<% If getnowdate = "2015-01-04" Then response.write "block" Else response.write "none" %>;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/ico_on.png" alt="오늘" /></span>
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/tab_today_04<% If getnowdate > "2015-01-04" Then response.write "_end" %>.jpg" alt="1월 4일 건강운" />
					</a>
				</li>
			</ol>
		</div>
		<%
			'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
			Dim vTitle, vLink, vPre, vImg
			
			dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
			snpTitle = Server.URLEncode("2015년의 시작, 소원을 빌어요")
			snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
			snpPre = Server.URLEncode("10x10 이벤트")

			'기본 태그
			snpTag = Server.URLEncode("텐바이텐 " & Replace("2015년의 시작, 소원을 빌어요"," ",""))
			snpTag2 = Server.URLEncode("#10x10")

			'// 카카오링크 변수
			Dim kakaotitle : kakaotitle = "[텐바이텐] 2015년의 시작, 소원을 빌어요"
			Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2014/58159/tit_make_wish.gif"
			Dim kakaoimg_width : kakaoimg_width = "200"
			Dim kakaoimg_height : kakaoimg_height = "150"
			Dim kakaolink_url
				If isapp = "1" Then '앱일경우
					kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
				Else '앱이 아닐경우
					kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
				end if 
		%>
		<!-- sns -->
		<div class="social">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/tit_sns.gif" alt="SNS에서 소문내기 친구야, 함께 소원 빌자!" /></h2>
			<ul>
				<li><a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/ico_twitter.gif" alt="트위터" /></a></li>
				<li><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','',''); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/ico_facebook.gif" alt="페이스북" /></a></li>
				<li><a href="" onclick="parent.parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>'); return false;" id="kakao-link-btn"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/ico_kakao.gif" alt="카카오톡" /></a></li>
			</ul>
		</div>
		<div class="noti">
			<img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/img_noti.gif" alt="" />
			<div class="cont">
				<h2>이벤트 유의사항</h2>
				<ul>
					<li>텐바이텐 고객을 위한 이벤트이므로, 로그인 후 참여해주세요.</li>
					<li>한 ID당 매일 1회 참여 가능합니다.</li>
					<li>당첨 발표 당시의 재고 수량에 따라 상품이 변경될 수 있습니다.</li>
					<li>당첨 상품은 1개씩 발송되며, 컬러 및 옵션은 랜덤입니다.</li>
					<li>당첨 시 상품 수령 및 세무신고를 위해 개인정보를 요청할 수 있습니다.</li>
					<li>이벤트 종료 후 당첨자에 한해 1월 6일부터 3일간 주소확인 기간을 거쳐 경품을 보내드립니다.</li>
				</ul>
			</div>
		</div>
	</div>
	<div class="mask"></div>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->