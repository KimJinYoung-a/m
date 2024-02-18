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
' Description : 지금 뭐해 ?
' History : 2015.03.17 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/event/etc/event60220Cls.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/wishCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->

<%
dim eCode, userid, oItem, ordercount, arritem
eCode=getevt_code
userid = getloginuserid()

ordercount=0
arritem = getitem("1") & "," & getitem("2") & "," & getitem("3") & "," & getitem("4") & "," & getitem("5") & "," & getitem("6")

if userid <> "" then
	ordercount = get10x10onlineorderdetailcount60220(userid, "2015-03-19", "2015-03-24", "", "", "", "N", "Y", arritem, "")
end if

'ordercount=0
%>

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->

<style type="text/css">
.mEvt60220 .selectLife {padding:0 4% 15px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/60220/bg_select.gif) left top repeat-y; background-size:100% auto;}
.mEvt60220 .selectLife ul {overflow:hidden;}
.mEvt60220 .selectLife li {position:relative; float:left; width:50%; }
.mEvt60220 .selectLife li span {display:none; position:absolute; left:0; top:0; width:100%;}
.mEvt60220 .selectLife li.soldout span {display:block;}
.mEvt60220 .giftLayer {display:none; position:absolute; left:0; top:0; width:100%; height:100%; padding:12% 3% 0; background:rgba(0,0,0,.5);}
.mEvt60220 .giftLayerCont {position:relative;}
.mEvt60220 .giftLayerCont .close {position:absolute; right:-2%; top:-3%; width:16.25%; cursor:pointer;}
.mEvt60220 .giftLayerCont .item {display:none;}
.mEvt60220 {position:relative; margin-bottom:-50px;}
.mEvt60220 img {vertical-align:top;}
.mEvt60220 .evtNoti {padding:20px 10px;}
.mEvt60220 .evtNoti dt {display:inline-block; font-size:14px; padding:6px 0 1px; margin:0 0 10px 10px; font-weight:bold; color:#222; border-bottom:2px solid #222;}
.mEvt60220 .evtNoti li {position:relative; color:#444; font-size:11px; line-height:1.3; padding-left:10px;}
.mEvt60220 .evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:5px; width:3px; height:1px; background:#444;}
@media all and (min-width:480px){
	.mEvt60220 .evtNoti {padding:30px 15px;}
	.mEvt60220 .evtNoti dt {font-size:21px; padding:9px 0 2px; margin:0 0 15px 15px; border-bottom:3px solid #222;}
	.mEvt60220 .evtNoti li {font-size:17px; padding-left:15px;}
	.mEvt60220 .evtNoti li:after {top:8px; width:5px; height:2px;}
}
</style>
<script type="text/javascript">

$(function(){
	$('.selectLife li a').click(function(){
		<% If IsUserLoginOK Then %>
			<% if not(left(currenttime,10)>="2015-03-19" and left(currenttime,10)<"2015-03-24") then %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% else %>
				<% if ordercount > 0 then %>
					alert("이미 구매 하셨습니다.");
					return;
				<% else %>
					<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
						alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
						return;
					<% else %>
						var lifeType = $(this).attr('class');
						$('.giftLayer').show();
						$('.giftLayerCont .item').hide();
						$('.giftLayerCont .item.'+lifeType).show();
				
						window.parent.$('html,body').animate({scrollTop:70}, 400);
					<% end if %>
				<% end if %>
			<% end if %>
		<% Else %>
			<% if isApp=1 then %>
				parent.calllogin();
				return false;
			<% else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
				return false;
			<% end if %>
		<% End If %>
	});
	$('.giftLayerCont .close').click(function(){
		parent.top.location.replace('<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>')
		//$('.giftLayer').hide();
	});
});

//주문Process
function TnAddShoppingBag60220(itemid){
	<% If IsUserLoginOK Then %>
		<% if not(left(currenttime,10)>="2015-03-19" and left(currenttime,10)<"2015-03-24") then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if ordercount>0 then %>
				alert("이미 구매 하셨습니다.");
				return;
			<% else %>
				<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
					alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
					return;
				<% else %>
					var rstStr = $.ajax({
						type: "POST",
						url: "<%= appUrlPath %>/event/etc/doEventSubscript60220.asp",
						data: "mode=add&itemid="+itemid,
						dataType: "text",
						async: false
					}).responseText;

					if (rstStr == "SUCCESS"){
					    var frm = document.sbagfrm;
					    var optCode = "0000";
		
					    if (itemid==''){
							alert('정상적인 상품 경로가 아닙니다.');
							return;
						}
					    if (!frm.itemea.value){
							alert('장바구니에 넣을 수량을 입력해주세요.');
							return;
						}
						frm.itemid.value = itemid;
					    frm.itemoption.value = optCode;
						frm.mode.value = "DO3";  //2014 분기
					    //frm.target = "_self";
					    frm.target = "evtFrmProc"; //2014 변경
						frm.action="<%= appUrlPath %>/inipay/shoppingbag_process.asp";
						frm.submit();
						
						//setTimeout("parent.top.location.replace('<% '= appUrlPath %>/event/eventmain.asp?eventid=<%'= eCode %>')",500)
						return false;
					}else if (rstStr == "STAFF"){
						alert('텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)');
						return false;
					}else if (rstStr == "USERNOT"){
						alert('로그인을 해주세요.');
						return false;
					}else if (rstStr == "DATENOT"){
						alert('이벤트 응모 기간이 아닙니다.');
						return false;
					}else if (rstStr == "ORDERCOUNT"){
						alert('이미 구매 하셨습니다.');
						return false;
					}else if (rstStr == "END"){
						alert('해당 상품이 마감 되었습니다.');
						return false;
					}else if (rstStr == "ITEMNOT"){
						alert('정상적인 상품이 아닙니다.');
						return false;
					}else{
						alert('정상적인 경로가 아닙니다.');
						return false;
					}
					return;
				<% end if %>
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
			return false;
		<% end if %>
	<% End If %>
}

</script>
</head>
<body>

<!-- 지금 뭐해?(APP) -->
<div class="mEvt60220">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/tit_first_buy.gif" alt="지금 뭐해?" /></h2>
	<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/txt_select_type.gif" alt="10X10 SHOP - 당신의 일상을 골라보세요!" /></h3>

	<div class="selectLife">
		<ul>
			<% ' <!-- 소진 시 클래스 soldout 넣어주세요 --> %>
			<%
			set oItem = new CatePrdCls
			
				if getitem("1") <> "" then
					oItem.GetItemData getitem("1")
				end if
			%>
			<li <% if oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem then %> class='soldout'<% end if %>>
				<span><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/txt_mask_0320.png" alt="SOLD OUT" /></span>
				<a href="#giftLayer" class="life01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/img_select01.gif" alt="나 지금 출근하고있어" /></a>
			</li>
			<% Set oItem = Nothing %>

			<%
			set oItem = new CatePrdCls
			
				if getitem("2") <> "" then
					oItem.GetItemData getitem("2")
				end if
			%>
			<li <% if oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem then %> class='soldout'<% end if %>>
				<span><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/txt_mask_0323.png" alt="03.23" /></span>
				<a href="#giftLayer" class="life02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/img_select02.gif" alt="방금 먹었는데 또 배고파" /></a>
			</li>
			<% Set oItem = Nothing %>

			<%
			set oItem = new CatePrdCls
			
				if getitem("3") <> "" then
					oItem.GetItemData getitem("3")
				end if
			%>
			<li <% if oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem then %> class='soldout'<% end if %>>
				<span><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/txt_mask_0324.png" alt="03.24" /></span>
				<a href="#giftLayer" class="life03"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/img_select03.gif" alt="지긋지긋한 스트레스" /></a>
			</li>
			<% Set oItem = Nothing %>

			<%
			set oItem = new CatePrdCls
			
				if getitem("4") <> "" then
					oItem.GetItemData getitem("4")
				end if
			%>
			<li <% if oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem then %> class='soldout'<% end if %>>
				<span><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/txt_mask_0325.png" alt="03.25" /></span>
				<a href="#giftLayer" class="life04"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/img_select04.gif" alt="졸려 죽겠는데 잠이 안와" /></a>
			</li>
			<% Set oItem = Nothing %>

			<%
			set oItem = new CatePrdCls
			
				if getitem("5") <> "" then
					oItem.GetItemData getitem("5")
				end if
			%>
			<li <% if oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem then %> class='soldout'<% end if %>>
				<span><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/txt_mask_0326.png" alt="03.26" /></span>
				<a href="#giftLayer" class="life05"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/img_select05.gif" alt="일상에서 벗어나고 싶어" /></a>
			</li>
			<% Set oItem = Nothing %>

			<%
			set oItem = new CatePrdCls
			
				if getitem("6") <> "" then
					oItem.GetItemData getitem("6")
				end if
			%>
			<li <% if oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem then %> class='soldout'<% end if %>>
				<span><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/txt_mask_0327.png" alt="03.27" /></span>
				<a href="#giftLayer" class="life06"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/img_select06.gif" alt="지쳤어.. 충전하고 싶어" /></a>
			</li>
			<% Set oItem = Nothing %>
		</ul>
	</div>

	<div class="giftLayer" id="giftLayer">
		<div class="giftLayerCont">
			<p class="close"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/btn_layer_close.png" alt="닫기" /></p>
			<div class="itemView">
				<div class="item life01">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/img_gift01.png" alt="출근할 때 만큼은 뉴요커처럼" /></p>
					<a href="" onclick="TnAddShoppingBag60220('<%= getitem("1") %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/btn_buy.gif" alt="아이리버+스타벅스 구매하기" /></a>
				</div>
				<div class="item life02">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/img_gift02_.png" alt="먹지말고 피부에 양보하자" /></p>
					<a href="" onclick="TnAddShoppingBag60220('<%= getitem("2") %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/btn_buy.gif" alt="아이스바+던킨도너츠 구매하기" /></a>
				</div>
				<div class="item life03">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/img_gift03.png" alt="냉정과 열정사이" /></p>
					<a href="" onclick="TnAddShoppingBag60220('<%= getitem("3") %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/btn_buy.gif" alt="비밀의정원+죠스떡볶이 구매하기" /></a>
				</div>
				<div class="item life04">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/img_gift04.png" alt="잠이 안 올땐 쓰던가 보던가!" /></p>
					<a href="" onclick="TnAddShoppingBag60220('<%= getitem("4") %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/btn_buy.gif" alt="배달의 민족 안대+CGV 구매하기" /></a>
				</div>
				<div class="item life05">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/img_gift05.png" alt="나에게로 떠나는 여행" /></p>
					<a href="" onclick="TnAddShoppingBag60220('<%= getitem("5") %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/btn_buy.gif" alt="달빛스티커+베스킨라빈스 구매하기" /></a>
				</div>
				<div class="item life06">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/img_gift06.png" alt="2% 부족할땐" /></p>
					<a href="" onclick="TnAddShoppingBag60220('<%= getitem("6") %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/btn_buy.gif" alt="샤오미+스무디킹 구매하기" /></a>
				</div>
			</div>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60220/txt_send_gifticon.gif" alt="기프티콘은 당일 18시까지 발송됩니다." /></p>
		</div>
	</div>

	<dl class="evtNoti">
		<dt>이벤트 주의사항</dt>
		<dd>
			<ul>
				<li>텐바이텐에서 한번도 구매이력이 없는 고객님을 위한 시크릿 이벤트입니다.</li>
				<li>본 이벤트는 로그인 후에 참여가 가능합니다.</li>
				<li>ID 당 1회만 구매가 가능합니다.</li>
				<li>이벤트는 조기 마감 될 수 있습니다.</li>
				<li>이벤트는 즉시결제로만 구매가 가능하며, 배송 후 반품/교환/구매취소가 불가능합니다.</li>
				<li>구매한 기프티콘과 상품은 별도 발송될 예정입니다.</li>
				<li>상품과 함께 구매한 기프티콘은 당일 18시까지 발송됩니다.</li>
			</ul>
		</dd>
	</dl>
	<form name="sbagfrm" method="post" action="" style="margin:0px;">
	<input type="hidden" name="mode" value="add" />
	<input type="hidden" name="itemid" value="" />
	<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
	<input type="hidden" name="itemoption" value="0000" />
	<input type="hidden" name="userid" value="<%= getloginuserid() %>" />
	<input type="hidden" name="isPresentItem" value="" />
	<input type="hidden" name="itemea" readonly value="1" />
	</form>	
	<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</div>
<!--// 지금 뭐해?(APP) -->

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->