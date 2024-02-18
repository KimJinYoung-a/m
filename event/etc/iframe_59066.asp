<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  구매금액별 사은이벤트 선물 못받을까바 오빠가 오다 주웠다
' History : 2015.01.30 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event59066Cls.asp" -->

<%
dim eCode, userid, i, v10x10onlineorder
	eCode=getevt_code
	userid = getloginuserid()

if userid<>"" then
	v10x10onlineorder = get10x10onlineorder(userid, "2015-02-02", "2015-02-13", "", "", "", "N")
end if

%>

<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {width:100%; vertical-align:top;}
.item {padding-bottom:10%; background-color:#dd1515; }
.item ul {overflow:hidden; background-image:url("http://webimage.10x10.co.kr/eventIMG/2015/59067/bg_item.png"); background-repeat:no-repeat; background-position:0 0; background-size:100% auto;}
.item ul li {float:left; width:50%; margin-top:3%;}
.item ul li:first-child {width:100%; margin-top:0;}
.item ul li a {display:block; position:relative; margin:0 3%; box-shadow:0 0 10px rgba(000,000,000,0.2);}
.item ul li:first-child a {margin:0 6%;}
.item ul li:nth-child(2) a {margin-left:12%;}
.item ul li:nth-child(3) a {margin-right:12%;}
.item ul strong {position:absolute; top:0; left:0; width:100%;}
.item2 ul {background-image:none;}
.take {padding-bottom:10%; background:#efe2d4 url("http://webimage.10x10.co.kr/eventIMG/2015/59067/bg_con.png") repeat-y 50% 0; background-size:100% auto;}
.take legend {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}
.selectwrap {margin:0 7%; padding:5%; background-color:#dfceba;}
.selectwrap select {width:100%; border:1px solid #939393; border-radius:0; color:#4b4b4b;}
.submit {width:78%; margin:4% auto 0;}
.submit input {width:100%;}
.music {background:#efe2d4 url("http://webimage.10x10.co.kr/eventIMG/2015/59067/bg_con.png") repeat-y 50% 0; background-size:100% auto;}
.movie {padding:7% 5% 0;}
.youtube {overflow:hidden; position:relative; height:0; padding-bottom:56.25%; border:1px solid #706963; background:#000;}
.youtube iframe {position:absolute; top:0; left:0; width:100%; height:100%;}
.noti {padding:30px 15px; background-color:#fff;}
.noti h2 {color:#222; font-size:14px; font-weight:bold; line-height:1.5em;}
.noti h2 span {display:inline-block; padding-bottom:1px; border-bottom:2px solid #222;}
.noti ul {margin-top:15px;}
.noti ul li {position:relative; padding-left:12px; color:#434444; font-size:11px; line-height:1.375em;}
.noti ul li em {color:#d60703;}
.noti ul li:after {content:' '; position:absolute; top:4px; left:0; z-index:5; width:0; height:0; border-top:6px solid #5c5c5c; border-left:6px solid transparent; transform:rotate(45deg); -moz-transform:rotate(45deg);-webkit-transform:rotate(45deg);}
@media all and (min-width:480px){
	.wish-swiper .pagination span {width:16px; height:16px; margin:0 9px;}
	.wish-swiper button {width:60px; height:61px; background-size:60px auto;}
	.noti {padding:45px 22px;}
	.noti h2 {font-size:21px;}
	.noti ul {margin-top:22px;}
	.noti ul li {padding-left:18px; font-size:16px; }
	.noti ul li:after {top:6px; border-top:9px solid #5c5c5c; border-left:9px solid transparent;}
}
</style>
<script type="text/javascript">

function chorderserial(orderserial){
	evtFrm1.orderserial.value=orderserial;
}

function jsSubmit(){
	<% If IsUserLoginOK() Then %>
		if (evtFrm1.orderserial.value==''){
			alert('선택하신 주문이 없습니다.');
			return;
		}

		<% If getnowdate>="2015-02-02" and getnowdate<"2015-02-13" Then %>
			<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
				alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
				return;
			<% else %>
				evtFrm1.action="/event/etc/doEventSubscript59066.asp";
				evtFrm1.target="evtFrmProc";
				evtFrm1.mode.value='valinsert';
				evtFrm1.submit();
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

</script>
</head>
<body>

<div class="mEvt59067">
	<div class="topic">
		<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/tit_gift_event.png" alt ="선물 못 받을까봐 오빠가 오다 주웠다" /></h1>
		<div class="item">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/tit_gift_01.png" alt ="7만원 이상 구매시 택1" /></h2>
			<ul>
				<% if isApp=1 then %>
					<li>
						<a href="" onclick="parent.fnAPPpopupProduct('1198446'); return false;">
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/img_item_01.jpg" alt ="[곽명주x에이미] 초콜릿" />
							<strong style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/txt_soldout_big.png" alt ="솔드아웃" /></strong>
						</a>
					</li>
					<li>
						<a href="" onclick="parent.fnAPPpopupProduct('1133680'); return false;">
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/img_item_02.jpg" alt ="SMILES SWITCH LIGHT" />
							<strong style="display:block;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/txt_soldout_small.png" alt ="솔드아웃" /></strong>
						</a>
					</li>
					<li>
						<a href="" onclick="parent.fnAPPpopupProduct('1195675'); return false;">
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/img_item_03.jpg" alt ="디스펜서 + 마스킹테이프" />
							<strong style="display:block;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/txt_soldout_small.png" alt ="솔드아웃" /></strong>
						</a>
					</li>
				<% else %>
					<li>
						<a href="/category/category_itemPrd.asp?itemid=1198446" target="_top">
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/img_item_01.jpg" alt ="[곽명주x에이미] 초콜릿" />
							<strong style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/txt_soldout_big.png" alt ="솔드아웃" /></strong>
						</a>
					</li>
					<li>
						<a href="/category/category_itemPrd.asp?itemid=1133680" target="_top">
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/img_item_02.jpg" alt ="SMILES SWITCH LIGHT" />
							<strong style="display:block;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/txt_soldout_small.png" alt ="솔드아웃" /></strong>
						</a>
					</li>
					<li>
						<a href="/category/category_itemPrd.asp?itemid=1195675" target="_top">
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/img_item_03.jpg" alt ="디스펜서 + 마스킹테이프" />
							<strong style="display:block;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/txt_soldout_small.png" alt ="솔드아웃" /></strong>
						</a>
					</li>
				<% end if %>
			</ul>
		</div>
		<div class="item item2">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/tit_gift_02.png" alt ="15만원 이상 구매시 택1" /></h2>
			<ul>
				<% if isApp=1 then %>
					<li>
						<a href="" onclick="parent.fnAPPpopupProduct('1195460'); return false;">
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/img_item_04.jpg" alt ="샤오미 보조배터리" />
							<strong style="display:block;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/txt_soldout_big.png" alt ="솔드아웃" /></strong>
						</a>
					</li>
					<li>
						<a href="" onclick="parent.fnAPPpopupProduct('1171539'); return false;">
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/img_item_05.jpg" alt ="써모머그 엄브렐러 보틀" />
							<strong style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/txt_soldout_small.png" alt ="솔드아웃" /></strong>
						</a>
					</li>
					<li>
						<a href="" onclick="parent.fnAPPpopupProduct('961666'); return false;">
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/img_item_06.jpg" alt ="Table talk WALLET" />
							<strong style="display:block;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/txt_soldout_small.png" alt ="솔드아웃" /></strong>
						</a>
					</li>
				<% else %>
					<li>
						<a href="/category/category_itemPrd.asp?itemid=1195460" target="_top">
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/img_item_04.jpg" alt ="샤오미 보조배터리" />
							<strong style="display:block;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/txt_soldout_big.png" alt ="솔드아웃" /></strong>
						</a>
					</li>
					<li>
						<a href="/category/category_itemPrd.asp?itemid=1171539" target="_top">
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/img_item_05.jpg" alt ="써모머그 엄브렐러 보틀" />
							<strong style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/txt_soldout_small.png" alt ="솔드아웃" /></strong>
						</a>
					</li>
					<li>
						<a href="/category/category_itemPrd.asp?itemid=961666" target="_top">
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/img_item_06.jpg" alt ="Table talk WALLET" />
							<strong style="display:block;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/txt_soldout_small.png" alt ="솔드아웃" /></strong>
						</a>
					</li>
				<% end if %>
			</ul>
		</div>
	</div>

	<!-- for dev msg : 응모 -->
	<div class="take">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/txt_sign.png" alt ="싸인 CD 받을래? 오빠 마음을 담은 노래야 오빠가 이지형이랑 좀 친한데, 싸인 CD 받아줄까? 이벤트 기간 동안 쇼핑을 했다면 응모 버튼을 눌러봐. 딱10명만 뽑을게!" /></p>
		<fieldset>
			<legend>이지형 싸인 받기에 응모하기</legend>
			<div class="selectwrap">
				<select onchange="chorderserial(this.value);" class="select" title="2015년 2월 2일 이후 주문 내역">
					<option>2015년 2월 2일 이후 주문 내역</option>
					
					<% if isarray(v10x10onlineorder) then %>
						<% for i = 0 to ubound(v10x10onlineorder,2) %>
						<option value="<%= v10x10onlineorder(0,i) %>">주문번호 <%= v10x10onlineorder(0,i) %> (구매금액 <%= CurrFormat( v10x10onlineorder(1,i) ) %>)</option>
						<% next %>
					<% else %>
						<option value="">주문 내역이 없습니다.</option>
					<% end if %>
				</select>
			</div>
			<div class="submit"><input type="image" onclick="jsSubmit(); return false;" src="http://webimage.10x10.co.kr/eventIMG/2015/59067/btn_submit.png" alt="응모하기" /></div>
		</fieldset>
	</div>

	<div class="music">
		<img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/bg_line.png" alt ="" />
		<div class="movie">
			<div class="youtube">
				<iframe src="https://www.youtube.com/embed/LmjMHrmNWqY" frameborder="0" allowfullscreen="" title="로맨틱 보이스 이지형 유희열의 뮤즈 권진아의 설탕 케미 커플송 DUET"></iframe>
			</div>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/txt_music.png" alt ="로맨틱 보이스 이지형 유희열의 뮤즈 권진아의 설탕 케미 커플송 DUET" /></p>
	</div>

	<div class="noti">
		<h2><span>이벤트 유의사항</span></h2>
		<ul>
			<li>텐바이텐 사은 이벤트는 텐바이텐 회원님을 위한 헤택입니다. (비회원 구매 증정 불가)</li>
			<li><em>텐바이텐 배송상품을 포함해야 사은품 선택이 가능합니다.</em></li>
			<li>상품쿠폰, 보너스쿠폰, 할인카드 등의 사용 후 구매확정 금액이 7만원 / 15만원 이상 이어야 선택 가능 합니다.</li>
			<li>마일리지, 예치금, 기프트카드를 사용하신 경우는 구매확정 금액에 포함되어 사은품을 받으 실 수 있습니다.</li>
			<li>SMILES SWITCH LIGHT와 써모머그 엄브렐러 보틀은 옵션선택이 가능하며, 이외의 상품은 랜덤으로 발송됩니다.</li>
			<li>각 상품 별 한정 수량이므로, 조기에 소진 될 수 있습니다.</li>
			<li>텐바이텐 기프트카드를 구매하신 경우는 사은품 증정이 되지 않습니다.</li>
			<li>사은품은 텐바이텐 배송 상품과 함께 배송됩니다.</li>
			<li>환불이나 교환 시 최종 구매 가격이 사은품 수령 가능금액 미만이 될 경우, 사은품과 함께 반품해야 합니다.</li>
			<li>이벤트는 조기종료 될 수 있습니다.</li>
		</ul>
	</div>

	<div class="bnr">
		<% if isApp=1 then %>
			<a href="" onclick="parent.fnAPPpopupEvent('57669'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/img_bnr_event.png" alt ="뭐 담아야할지 모르겠으면 오빠 따라와 텐바이텐 배송상품 보러가기" /></a>
		<% else %>
			<a href="/event/eventmain.asp?eventid=57669" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59067/img_bnr_event.png" alt ="뭐 담아야할지 모르겠으면 오빠 따라와 텐바이텐 배송상품 보러가기" /></a>
		<% end if %>			
	</div>
	<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
	<input type="hidden" name="orderserial">
	</form>
	<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>	
</div>

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->