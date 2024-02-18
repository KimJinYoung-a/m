<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : MKT 2021 4월 정기세일
' History : 2021-03-24 임보라
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
	Dim currentDate, evtStartDate, evtEndDate, eCode, userid
	Dim eventCoupons, isCouponShow, vQuery

	currentDate = date()
	evtStartDate = Cdate("2021-03-29")
	evtEndDate = Cdate("2021-04-26")

	'test
	' currentDate = Cdate("2021-04-23")

	IF application("Svr_Info") = "Dev" THEN
		eCode = 104336
		eventCoupons = "22270,22269,22268,22267,22271,22265"
	Else
		eCode = 110211
		eventCoupons = "135989,135988,135987,135986,135985,135984"
	End If

	userid = GetEncLoginUserID()

	isCouponShow = True

	If IsUserLoginOK Then
		vQuery = "select count(1) from [db_item].[dbo].[tbl_user_item_coupon] where userid = '" & getencLoginUserid() & "'"
		vQuery = vQuery + " and itemcouponidx in ("&eventCoupons&") "
		vQuery = vQuery + " and usedyn = 'N' "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
		If rsget(0) = 6 Then	' 
			isCouponShow = False
		Else
			isCouponShow = True
		End IF
		rsget.close
	End If
%>
<script>
	// 앱 여부
	const is_app = location.pathname.toLowerCase().indexOf('/apps/appcom/wish/web2014') > -1;
</script>
<style>
.sale2021 {position:relative; overflow:hidden; padding-bottom:10%; background:#fff; -webkit-tap-highlight-color:rgba(0,0,0,0);}
.sale2021 .topic {position:relative; overflow:hidden; min-height:100vw; }
.sale2021 .topic h2 {position:absolute; left:0; top:0; transform-origin:10% 10%; opacity:0;}
.sale2021 .topic.on h2 {animation:titAni .7s both ease-in; opacity:1;}
.sale2021 .topic .txt-day {position:absolute; left:0; bottom:0; z-index:10; width:100%;}
.sale2021 .sale-links {display:inline-block; position:absolute; left:0; bottom:2%; width:44vw; height:44vw;}
.sale2021 .btn-coupon {display:block; width:100%;}
.sale2021 .pop-coupon {position:fixed; z-index:10020;}
.sale2021 .pop-coupon .pop-mask {position:fixed; left:0; top:100%; z-index:10021; width:100%; height:100%; background:rgba(0,0,0,.7);}
.sale2021 .pop-coupon .pop-inner {position:fixed; left:0; bottom:0; z-index:10022; width:100%; transform:translateY(100%); transition:all .2s;}
.sale2021 .pop-coupon.show .pop-mask {top:0;}
.sale2021 .pop-coupon.show .pop-inner {transform:translateY(0);}
.sale2021 .pop-coupon .link {display:block; padding:6% 0; text-align:center; font-family:var(--md); font-size:5vw; color:#fff; background:#ff2929; padding-bottom:calc(6% + constant(safe-area-inset-bottom)); padding-bottom:calc(6% + env(safe-area-inset-bottom));}
.sale2021 .pop-coupon .btn-close {position:absolute; left:0; top:0; width:16vw; height:16vw; font-size:0; color:transparent; background:none;}
.sale2021 .links-area {padding-top:3.47rem;}
@keyframes titAni {
	0% {opacity:0; transform:scale(.8);}
	80% {transform:scale(1.03);}
	100% {opacity:1; transform:scale(1);}
}
</style>
<script>
	$(function() {
		$('.sale2021 .topic').addClass('on');

		// 상단 배경 GIF이미지 랜덤 노출
		<% If currentDate < #04/16/2021 00:00:00# Then %>
			var num = Math.floor(Math.random()*2)+1;
			if (num === 1) {
				$('.sale2021 .topic h2 img').attr('src', '//webimage.10x10.co.kr/fixevent/event/2021/110211/m/tit_sale_03.png');
				$('.sale2021 .topic > img').attr('src', '//webimage.10x10.co.kr/fixevent/event/2021/110211/m/bg_sale_03.gif?v=2');
			} else {
				$('.sale2021 .topic h2 img').attr('src', '//webimage.10x10.co.kr/fixevent/event/2021/110211/m/tit_sale_04.png');
				$('.sale2021 .topic > img').attr('src', '//webimage.10x10.co.kr/fixevent/event/2021/110211/m/bg_sale_04.gif?v=2');
			}
		<% End If %>

		// 디데이
		<% if currentDate >= "2021-04-23" and currentDate <= "2021-04-26" then %>
			var today = new Date();
			// var today = new Date('April 26, 2021');
			var day = today.getDate();
			$('.txt-day img').attr('src', '//webimage.10x10.co.kr/fixevent/event/2021/110211/m/txt_day_'+day+'.png');
		<% End If %>

		// 팝업 닫기
		$('.sale2021 .pop-coupon').on('click', function(e) {
			if ($(e.target).is('.pop-mask') || $(e.target).is('.btn-close')) {
				$(e.currentTarget).removeClass('show');
			}
		});
	});

	function chkLogin(){
		<% If not IsUserLoginOK() Then %>
			<% if isApp=1 then %>
				calllogin();
				return false;
			<% else %>			
				jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
				return false;
			<% end if %>
		<% end if %>
		return true
	}

	function jsDownCoupon2(stype,idx){
		<% if not ( currentDate >= evtStartDate and currentDate <= evtEndDate ) then %>
			alert("이벤트 참여기간이 아닙니다.");
			return false;
		<% end if %>
		if(!chkLogin()) return false;
		$.ajax({
			type: "post",
			url: "/shoppingtoday/act_couponshop_process.asp",
			data: "idx="+idx+"&stype="+stype,
			cache: false,
			success: function(message) {
				if(typeof(message)=="object") {
					if(message.response=="Ok") {
						$('.sale2021 .pop-coupon').addClass('show');
					} else {
						alert(message.message);
					}
				} else {
					alert("처리중 오류가 발생했습니다.");
				}
			},
			error: function(err) {
				console.log(err.responseText);
			}
		});
	}
</script>
<!-- MKT 정기세일 : 메인 (M/A) 110211 -->
<div class="mEvt110211 sale2021">
	<% If currentDate < #04/16/2021 00:00:00# Then %>
		<div class="topic">
			<h2><img src="" alt="텐바이텐 2021 봄 정기세일"></h2>
			<img src="" alt="">
			<!-- 구매사은품 -->
			<a href="/event/eventmain.asp?eventid=110264" class="mWeb sale-links"></a>
			<a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110264');return false;" class="mApp sale-links"></a>
		</div>
	<% Else %>
		<div class="topic">
			<h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/110211/m/tit_sale_04.png" alt="텐바이텐 2021 봄 정기세일"></h2>
			<img src="//webimage.10x10.co.kr/fixevent/event/2021/110211/m/bg_sale_v3.gif" alt="30%">
			<% if currentDate >= "2021-04-23" and currentDate <= "2021-04-26" then %>
				<div class="txt-day"><img src="" alt=""></div>
			<% End If %>
		</div>
	<% End If %>

	<button class="btn-coupon" onclick="jsDownCoupon2('prd,prd,prd,prd,prd,prd,prd','<%=eventCoupons%>');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110211/m/btn_coupon.jpg?v=1.0" alt="쿠폰 다운받기"></button>
	<div class="links-area">
		<a href="/event/eventmain.asp?eventid=110546" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110211/m/img_link01.jpg" alt="지금,놓쳐서는 안될 브랜드"></a>
		<a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110546');return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110211/m/img_link01.jpg" alt="지금,가장 인기있는 텐텐템"></a>
		<a href="/event/eventmain.asp?eventid=110547" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110211/m/img_link02.jpg" alt="지금,놓쳐서는 안될 브랜드"></a>
		<a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110547');return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110211/m/img_link02.jpg" alt="지금,가장 인기있는 텐텐템"></a>
	</div>

	<!-- for dev msg : 쿠폰 발급 시 팝업 ( 클래스 show 추가/제거 ) -->
	<div class="pop-coupon">
		<div class="pop-mask"></div>
		<div class="pop-inner">
			<button class="btn-close">닫기</button>
			<p><img src="//webimage.10x10.co.kr/fixevent/event/2021/110211/m/pop_coupon.png" alt="쿠폰이 발급 되었습니다."></p>
			<a href="/my10x10/couponbook.asp" class="link mWeb">쿠폰 확인 하러 가기</a>
			<a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '쿠폰북', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp');return false;" class="link mApp">쿠폰 확인 하러 가기</a>
		</div>
	</div>
</div>
<!-- //MKT 정기세일 : 메인 (M/A) 110211 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->