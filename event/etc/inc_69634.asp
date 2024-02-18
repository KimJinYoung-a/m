<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 깨긋한 산소방
' History : 2016.03.11 원승현 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<% '<!-- #include virtual="/lib/inc/head.asp" --> %>

<%
dim eCode, userid
	IF application("Svr_Info") = "Dev" THEN
		eCode = "66063"
	Else
		eCode = "69634"
	End If

userid = GetEncLoginUserID()

dim couponidx
	IF application("Svr_Info") = "Dev" THEN
		couponidx = "830"
	Else
		couponidx = "830"
	End If


Dim vPrvOrderCnt, vPrvOrderSumPrice, vEvtOrderCnt, vEvtOrderSumPrice, vMyThisEvtCnt, vMyThisCouponCnt, sqlstr, vQuery
'//이전 구매 내역 체킹 (1월 1일부터 3월 13일까지)
sqlStr = " EXEC [db_order].[dbo].[sp_Ten_MyOrderList_SUM] '" & userid & "', '', '', '2016-01-01', '2016-03-14', '10x10', '', 'issue' "
'response.write sqlStr & "<br>"
rsget.CursorLocation = adUseClient
rsget.CursorType = adOpenStatic
rsget.LockType = adLockOptimistic
rsget.Open sqlStr,dbget,1
	vPrvOrderCnt = rsget("cnt")
	vPrvOrderSumPrice   = CHKIIF(isNull(rsget("tsum")),0,rsget("tsum"))
'	vPrvOrderCnt = 0
'	vPrvOrderSumPrice   = 0
rsget.Close


'// 이벤트 기간 구매 내역 체킹(3월 14일부터 3월 20일까지)
sqlStr = " EXEC [db_order].[dbo].[sp_Ten_MyOrderList_SUM] '" & userid & "', '', '', '2016-03-14', '2016-03-21', '10x10', '', 'issue' "
'response.write sqlStr & "<br>"
rsget.CursorLocation = adUseClient
rsget.CursorType = adOpenStatic
rsget.LockType = adLockOptimistic
rsget.Open sqlStr,dbget,1
	vEvtOrderCnt = rsget("cnt")
	vEvtOrderSumPrice   = CHKIIF(isNull(rsget("tsum")),0,rsget("tsum"))
'	vEvtOrderCnt = 1
'	vEvtOrderSumPrice   = 1000
rsget.Close

' 현재 이벤트 본인 참여수
vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' And userid='"&userid&"' And sub_opt3='event' "
rsget.CursorLocation = adUseClient
rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.Eof Then
	vMyThisEvtCnt = rsget(0)
End IF
rsget.close

' 현재 이벤트 본인 쿠폰발급여부
vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' And userid='"&userid&"' And sub_opt3='coupon' "
rsget.CursorLocation = adUseClient
rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.Eof Then
	vMyThisCouponCnt = rsget(0)
End IF
rsget.close


%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}

.mEvt69634 {position:relative;}

.mEvt69634 button {background-color:transparent;}

.get {position:relative;}
.get ul {position:absolute; top:34.3%; right:10.93%; width:43.75%;}
.get ul li {overflow:hidden; margin-bottom:3%;}
.get ul li .area {float:left; width:50%; color:#fff; font-size:1.2rem; font-weight:bold; line-height:1.5em; text-align:right;}
.get ul li .area:first-child {text-align:left;}
.get ul li span b {color:#ffed89;}
.get .btnCheck {position:absolute; top:29%; left:10%; width:27.5%;}

.gift #app {display:none;}

.gift {position:relative;}
.gift .btnEnter {position:absolute; bottom:7%; left:50%; width:75%; margin-left:-37.5%;}

.lyBox {display:none; position:absolute; top:8%; left:50%; z-index:60; width:88.12%; margin-left:-44.06%;}
.lyBox p {padding-top:10%;}
.lyBox button {/*background-color:#000; opacity:0.3;*/ text-indent:-9999em;}
.lyBox .btnDown {position:absolute; bottom:7.6%; left:50%; width:67.20%; height:12%; margin-left:-33.6%;}
.lyBox .btnClose {position:absolute; top:11%; right:4%; width:13%; height:11%;}

#mask {display:none; position:absolute; top:0; left:0; z-index:55; width:100%; height:100%; background:rgba(0,0,0,.6);}

.noti {padding-bottom:7%; background-color:#465755;}
.noti ul {padding:0 4.375%;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#fff; font-size:1.1rem; line-height:1.5em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.5rem; left:0; width:0.4rem; height:0.1rem; background-color:#fff;}
</style>
<script type="text/javascript">

$(function(){

	window.$('html,body').animate({scrollTop:$(".mEvt69634").offset().top}, 0);

	$("#lyBox .btnClose, #dimmed").click(function(){
		$("#lyBox").hide();
		$("#mask").fadeOut();
	});

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$(".gift #app").show();
			$(".gift #mo").hide();
	}else{
			$(".gift #app").hide();
			$(".gift #mo").show();
	}
});



function jsSubmit(){
	<% If IsUserLoginOK() Then %>
		<% If not( left(now(),10)>="2016-03-14" and left(now(),10)<"2016-03-21" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			if ($("#orderchkval").val()!="1")
			{	
				alert("구매내역을 확인하셔야 이벤트에 참여하실 수 있습니다.");
				return false;
			}
			<% if vPrvOrderCnt > 0 And vEvtOrderCnt < 1 then '// 이전 구매내역은 있지만 이벤트 기간 내 구매내역이 없을경우 %>
				alert("이벤트 기간 내 구매내역이 없습니다.\n먼저 구매 후 응모해주세요!");
				return;
			<% elseif vPrvOrderCnt < 1 then '// 이전 구매내역이 없을경우는 이벤트 기간내 구매내역이 있어도 1회 쿠폰발급 %>
				<% if vMyThisCouponCnt > 0 then '// 쿠폰 발급내역이 있으면 %>
					alert("쿠폰을 이미 다운받으셨습니다.");
					return;
				<% end if %>
				$("#lyBox").show();
				$("#mask").fadeIn();
				var val = $("#lyBox").offset();
				$("html,body").animate({scrollTop:val.top},100);
			<% elseif vPrvOrderCnt > 0 And vEvtOrderCnt > 0 then '// 두개다 구매내역이 있을경우엔 응모시킴 %>
				<% if vMyThisEvtCnt > 0 then '// 1회만 응모되기때문에 응모내역이 있으면 튕김 %>
					alert("이미 응모가 완료되었습니다.");
					return;
				<% end if %>

				$.ajax({
					type:"GET",
					url:"/event/etc/doEventSubscript69634.asp?mode=ins",
					dataType: "text",
					async:false,
					cache:true,
					success : function(Data, textStatus, jqXHR){
						if (jqXHR.readyState == 4) {
							if (jqXHR.status == 200) {
								if(Data!="") {
									var str;
									for(var i in Data)
									{
										 if(Data.hasOwnProperty(i))
										{
											str += Data[i];
										}
									}
									str = str.replace("undefined","");
									res = str.split("|");
									if (res[0]=="OK")
									{
										alert("응모가 완료되었습니다.\n당첨자 발표는 3월28일 입니다!");
										document.location.reload();
										return false;
									}
									else
									{
										errorMsg = res[1].replace(">?n", "\n");
										alert(errorMsg );
										return false;
									}
								} else {
									alert("잘못된 접근 입니다.");
									document.location.reload();
									return false;
								}
							}
						}
					},
					error:function(jqXHR, textStatus, errorThrown){
						alert("잘못된 접근 입니다.");
						var str;
						for(var i in jqXHR)
						{
							 if(jqXHR.hasOwnProperty(i))
							{
								str += jqXHR[i];
							}
						}
						alert(str);
						document.location.reload();
						return false;
					}
				});
			<% else %>
				return false;
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}



function evtCouponIns()
{
	<% if vPrvOrderCnt < 1 then '// 이전 구매내역이 없을경우는 이벤트 기간내 구매내역이 있어도 1회 쿠폰발급 %>
		<% if vMyThisCouponCnt > 0 then '// 쿠폰 발급내역이 있으면 %>
			alert("쿠폰을 이미 다운받으셨습니다.");
			return;
		<% else %>
			$.ajax({
				type:"GET",
				url:"/event/etc/doEventSubscript69634.asp?mode=coupon",
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data, textStatus, jqXHR){
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							if(Data!="") {
								var str;
								for(var i in Data)
								{
									 if(Data.hasOwnProperty(i))
									{
										str += Data[i];
									}
								}
								str = str.replace("undefined","");
								res = str.split("|");
								if (res[0]=="OK")
								{
									alert("쿠폰이 발급되었습니다.");
									document.location.reload();
									return false;									
								}
								else
								{
									errorMsg = res[1].replace(">?n", "\n");
									alert(errorMsg );
									return false;
								}
							} else {
								alert("잘못된 접근 입니다.");
								document.location.reload();
								return false;
							}
						}
					}
				},
				error:function(jqXHR, textStatus, errorThrown){
					alert("잘못된 접근 입니다.");
					var str;
					for(var i in jqXHR)
					{
						 if(jqXHR.hasOwnProperty(i))
						{
							str += jqXHR[i];
						}
					}
					alert(str);
					document.location.reload();
					return false;
				}
			});		
		<% end if %>		
	<% end if %>
}


function evtOrderChk()
{
	<% If IsUserLoginOK() Then %>
		<% If not( left(now(),10)>="2016-03-14" and left(now(),10)<"2016-03-21" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			$.ajax({
				type:"GET",
				url:"/event/etc/doEventSubscript69634.asp?mode=orderchk",
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data, textStatus, jqXHR){
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							if(Data!="") {
								var str;
								for(var i in Data)
								{
									 if(Data.hasOwnProperty(i))
									{
										str += Data[i];
									}
								}
								str = str.replace("undefined","");
								res = str.split("|");
								if (res[0]=="OK")
								{
									$("#ordercntval").empty().html(res[1]);
									$("#orderpriceval").empty().html(res[2]);
									$("#orderchkval").val("1");
									return false;									
								}
								else
								{
									errorMsg = res[1].replace(">?n", "\n");
									alert(errorMsg );
									return false;
								}
							} else {
								alert("잘못된 접근 입니다.");
								document.location.reload();
								return false;
							}
						}
					}
				},
				error:function(jqXHR, textStatus, errorThrown){
					alert("잘못된 접근 입니다.");
					var str;
					for(var i in jqXHR)
					{
						 if(jqXHR.hasOwnProperty(i))
						{
							str += jqXHR[i];
						}
					}
					alert(str);
					document.location.reload();
					return false;
				}
			});		
		<% end if %>		
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% end if %>
}

</script>

<%' [M/A] 69634 깨끗한 산소방 %>
<div class="mEvt69634">
	<article>
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/69634/m/tit_spring_v2.gif" alt="이전 구매 내역을 확인하세요! 산뜻 산뜻 봄바람" /></h2>

		<div class="get">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69634/m/txt_get_list_v2.png" alt="이전 구매내역을 확인하세요! 구매 내역이 있다면 이벤트 기간 2016년 1월 1일부터 3월 31일 동안 1회 이상 구매시 사은품에 응모할 수 있어요. 무통장 주문건은 제외됩니다. 당첨자 발표는 3월 28일입니다." /></p>
			<ul>
				<%' for dev msg : 이전 구매내역, 로그인 전에는 * 표시해주세요 %>
				<li>
					<span class="area">구매횟수 : </span>
					<span class="area"><b><span id="ordercntval">*</span></b> 회</span>
				</li>
				<li>
					<span class="area">구매금액 : </span>
					<span class="area"><b><span id="orderpriceval">*</span></b> 원</span>
				</li>
			</ul>
			<button type="button" class="btnCheck" onclick="evtOrderChk();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69634/m/btn_check.png" alt="구매내역 확인하기" /></button>
		</div>

		<div class="gift">
			<p id="mo"><a href="/category/category_itemPrd.asp?itemid=1226544" title="가정용 소형 공기청정기 에어비타 큐 상품 보러가기"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69634/m/txt_gift.jpg" alt="사은품에 응모하세요! 공기청정기 돌리고 황사 조심해방" /></a></p>
			<p id="app"><a href="/category/category_itemPrd.asp?itemid=1226544" onclick="fnAPPpopupProduct('1226544&amp;pEtr=69634');return false;" title="가정용 소형 공기청정기 에어비타 큐 상품 보러가기"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69634/m/txt_gift.jpg" alt="사은품에 응모하세요! 공기청정기 돌리고 황사 조심해방" /></a></p>
			<%' for dev msg : 응모하기 버튼 id="btnEnter"로 레이어팝업 스크립트 제어했어요. %>
			<button type="button" id="btnEnter" class="btnEnter" onclick="jsSubmit();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69634/m/btn_enter.png" alt="응모하기" /></button>
		</div>

		<%' for dev msg : 이전 구매내역이 없는 없을 경우 응모하기 버튼 클릭시 나오는 팝업 %>
		<div id="lyBox" class="lyBox">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69634/m/txt_layer_coupon_v1.png" alt="아쉽게도 이벤트 대상이 아니시네요 ㅠㅠ 하지만 실망하지 마세요! 쇼핑을 즐길 수 있는 할인 쿠폰을 드 립니다!" /></p>
			<%' for dev msg : 쿠폰 다운받기 %>
			<button type="button" class="btnDown" onclick="evtCouponIns();return false;">쿠폰 다운받기</button>
			<button type="button" class="btnClose">닫기</button>
		</div>

		<div class="noti">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/69634/m/tit_noti.png" alt="이벤트 유의사항" /></h3>
			<ul>
				<li>응모하기는 이벤트 기간 중 1회만 가능합니다. </li>
				<li>1월1일~3월13일 구매내역이 있는 고객 중 이벤트 기간 (3월14일 ~ 20일)동안 구매내역이 있는 고객 대상으로 참여가 가능합니다.</li>
				<li>사은품 당첨자는 3월 28일 발표됩니다. </li>
				<li>환불이나 교환으로 인해 구매횟수나 구매금액이 충족되지 않을 경우 응모는 자동 취소 됩니다.</li>
				<li>이벤트는 조기종료 될 수 있습니다.</li>
			</ul>
		</div>

		<div id="mask"></div>
	</article>
</div>
<form name="orderchkfrm" method="get">
	<input type="hidden" name="orderchkval" id="orderchkval">
</form>
<%'// 깨끗한 산소방 %>

<!-- #include virtual="/lib/db/dbclose.asp" -->