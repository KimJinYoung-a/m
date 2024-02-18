<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : only for you
' History : 2014.09.05 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/etc/event54791Cls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode, userid
	eCode=getevt_code
	userid = getloginuserid()

dim onlineordercount, subscriptcount
	onlineordercount=0
	subscriptcount=0

If IsUserLoginOK() Then
	onlineordercount = getorderdetailcount(userid, "2014-09-10", "2014-10-06", "N", "Y")

	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
end if
%>

<!-- #include virtual="/lib/inc/head.asp" -->

<title>생활감성채널, 텐바이텐 > 이벤트 > Thank you &amp; Present for you</title>
<style type="text/css">
.mEvt54792 {}
.mEvt54792 img {vertical-align:top; width:100%;}
.mEvt54792 p {max-width:100%;}
.onlyfor .section, .onlyfor .section h3 {margin:0; padding:0;}
.way {position:relative;}
.way a {display:block; width:44%; height:13%; position:absolute; left:48%; top:58%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/54792/blank.png);}
</style>
<script type="text/javascript">

	function jsSubmitorder(frm){
		<% If IsUserLoginOK() Then %>
			<% If getnowdate>="2014-09-10" and getnowdate<"2014-10-06" Then %>
				<% if subscriptcount < 1 then %>
					<% if onlineordercount > 0 then %>
				   		frm.mode.value="ordereg";
						frm.action="/event/etc/doEventSubscript54791.asp";
						frm.target="evtFrmProc";
						frm.submit();
						return;
					<% else %>
						alert("웨딩기획전 둘러 보셨나요?\n기획전 상품 구매후 다시 응모하러 와주세요.!");
						return;
					<% end if %>						
				<% else %>
					alert("이미 응모 하셨습니다.");
					return;
				<% end if %>
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>
		<% Else %>
			parent.jsevtlogin();
			return;
		<% End IF %>
	}

</script>
</head>
<body>

<!-- Only for you -->
<div class="mEvt54792">
	<div class="onlyfor">
		<div class="section heading">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54792/txt_only_for_u.gif" alt="Only For You" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54792/txt_drama.gif" alt="지금 이 순간만을 꿈꿔온 신부의 로맨틱한 Drama 텐바이텐과 함께 해요!" /></p>
		</div>

		<div class="section benefit1">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54792/tit_benefit_01.gif" alt="혜택 하나, 당신의 빛나는 순간을 텐바이텐과 함께 하셨나요?" /></h3>
			<div><a href="/category/category_itemPrd.asp?itemid=1107992" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54792/btn_present.gif" alt="웨딩 기획전 상품을 구매 하신 분들 중, 한분을 선정하여 100만원 상당의 60s 고밀도메모리폼 SETQ를 선물로 드립니다. 선물 자세히 보기" /></a></div>
			<p class="way">
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/54792/txt_way.gif" alt="응모방법은 텐바이텐에서 준비한 웨딩기획전 상품 주문하기 결제 완료후 응모하기 버튼 클릭" />
				<a href="/event/eventmain.asp?eventid=54872" target="_top"></a>
			</p>
			<%' for dev msg : 응모하기 %>
			<div class="btnSubmit"><a href="" onclick="jsSubmitorder(evtFrm1); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54792/btn_submit.gif" alt="응모하기" /></a></div>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54792/txt_noti_01.gif" alt="이벤트 유의사항 웨딩 기획전 상품을 구매하신 분들만 응모가 가능합니다. 이벤트 기간동안 ID당 1회만 응모할 수 있습니다. 웨딩 기획전 상품을 구매하신 분들 중 누적금액이 높은 분이 당첨에 유리합니다. 당첨자 발표는 10월 13일입니다. 당첨 시 상품수령 및 세무신고를 위해 개인정보를 요청할 수 있습니다. 당첨자에게는 10월 13일 개별 연락드립니다." /></p>
		</div>

		<div class="section benefit2">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54792/tit_benefit_02.gif" alt="혜택 둘, 텐바이텐과 함께하는 9월의 카드 혜택이예요!" /></h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54792/txt_card.gif" alt="카드사별 할부내용과 행사기간이 상이합니다. 카드 결제 시 유의해주세요" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54792/txt_noti_02.gif" alt="하나/삼성/롯데/국민/현대/신한/비씨/농협카드 부분 무이자 할부도 진행 중입니다. (결제 시, 확인 가능) 카드사 행사기간이 상이합니다. 행사기간에 유의해주세요! 본 행사는 카드사 사정에 따라 변경 또는 중단될 수 있습니다. 무이자 할부 결제 시 각 카드사의 포인트, 마일리지는 적립에서 제외됩니다." /></p>
		</div>

		<div class="section event-link">
			<div><a href="/event/eventmain.asp?eventid=54872" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54792/btn_go_wedding.gif" alt="웨딩 기획전 메인 보러가기" /></a></div>
			<img src="http://webimage.10x10.co.kr/eventIMG/2014/54792/img_race.gif" alt="" />
		</div>
	</div>
</div>
<!-- //Only for you -->
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
<form name="evtFrm1" action="/event/etc/doEventSubscript54791.asp" method="post" target="evtFrmProc" style="margin:0px;">
	<input type="hidden" name="mode">
</form>
</body>
</html>