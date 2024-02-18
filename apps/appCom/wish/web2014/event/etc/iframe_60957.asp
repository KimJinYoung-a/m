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
' Description : 스텝 바이 스텝
' History : 2015.04.02 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/event/etc/event60957Cls.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/wishCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->

<%
'Dim , ordercount
dim eCode, userid, oItem, arritem
eCode=getevt_code
userid = getloginuserid()

'ordercount=0
arritem = getitem("1") & "," & getitem("2") & "," & getitem("3") & "," & getitem("4") & "," & getitem("5") & "," & getitem("6")

'if userid <> "" then
'	ordercount = get10x10onlineorderdetailcount60957(userid, "2015-04-06", "2015-04-08", "", "", "", "N", "Y", arritem, "")
'end if

'ordercount=0
%>

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->

<style type="text/css">
img {vertical-align:top;}
.topic h1 {visibility:hidden; width:0; height:0;}
.item {padding-bottom:10%; background-color:#fff5c4;}
.item ul {overflow:hidden; padding:2% 2% 0;}
.item ul li {float:left; width:50%; margin-top:3%; padding:0 1%;}
.item ul li div {position:relative;}
.item ul li .soldout {display:none; position:absolute; top:0; left:0; width:100%; height:100%; background:rgba(000,000,000,0.65); box-shadow:5px 5px 5px 0px rgba(255,233,137,0.70);}
.item ul li .soldout img {margin-top:73%;}
.bonus {position:relative;}
.bonus .giftcon {position:absolute; top:23%; left:50%; width:74%; margin-left:-37%;}

.noti {padding:20px 10px;}
.noti h2 {color:#222; font-size:14px;}
.noti h2 strong {padding-bottom:2px; border-bottom:2px solid #000;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; padding-left:10px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:8px; left:0; width:4px; height:1px; background-color:#444;}
@media all and (min-width:480px){
	.noti {padding:25px 15px;}
	.noti ul {margin-top:16px;}
	.noti h2 {font-size:17px;}
	.noti ul li {margin-top:2px; font-size:13px;}
	.noti ul li:after {top:8px;}
}
@media all and (min-width:768px){
	.noti h2 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:4px; font-size:16px;}
	.noti ul li:after {top:12px;}
}
</style>
<script type="text/javascript">
//주문Process
function TnAddShoppingBag60957(itemid){
	<% If IsUserLoginOK Then %>
		<% if not(left(currenttime,10)>="2015-04-06" and left(currenttime,10)<"2015-04-09") then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
				alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
				return;
			<% else %>
				var rstStr = $.ajax({
					type: "POST",
					url: "<%= appUrlPath %>/event/etc/doEventSubscript60957.asp",
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
<div class="mEvt60957">
	<div class="topic">
		<h1>스텝 바이 스텝</h1>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60957/txt_step_by_step.png" alt="텐바이텐 처음이지? 텐텐 스텝들이 추천하는 인기 아이템들을 특가로 구매하고 보너스혜택까지 잡으세요!" /></p>
	</div>

	<div class="item">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60957/txt_item.png" alt="스텝 강력추천 아이템! 상품 가격은 해당 이벤트에서만 판매되는 특별 할인가격입니다." /></p>
		<ul>
			<%
			set oItem = new CatePrdCls
			
				if getitem("1") <> "" then
					oItem.GetItemData getitem("1")
				end if
			%>
			<li>
				<div>
					<a href="" onclick="parent.fnAPPpopupProduct('1234644');return false;" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60957/img_item_01.jpg" alt="배달의민족 안대 깨우면안대" /></a>
					<a href="" onclick="TnAddShoppingBag60957('<%= getitem("1") %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60957/btn_get.png" alt="상품 구매하기" /></a>
					<strong class="soldout" <% if oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem then %> style='display:block;'<% end if %>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60957/txt_sold_out.png" alt="솔드아웃" /></strong>
				</div>
			</li>
			<% Set oItem = Nothing %>

			<%
			set oItem = new CatePrdCls
			
				if getitem("2") <> "" then
					oItem.GetItemData getitem("2")
				end if
			%>
			<li>
				<div>
					<a href="" onclick="parent.fnAPPpopupProduct('1234646');return false;" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60957/img_item_02.jpg" alt="비밀의 정원" /></a>
					<a href="" onclick="TnAddShoppingBag60957('<%= getitem("2") %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60957/btn_get.png" alt="상품 구매하기" /></a>
					<strong class="soldout" <% if oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem then %> style='display:block;'<% end if %>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60957/txt_sold_out.png" alt="솔드아웃" /></strong>
				</div>
			</li>
			<% Set oItem = Nothing %>

			<%
			set oItem = new CatePrdCls
			
				if getitem("3") <> "" then
					oItem.GetItemData getitem("3")
				end if
			%>
			<li>
				<div>
					<a href="" onclick="parent.fnAPPpopupProduct('1234201');return false;" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60957/img_item_03.jpg" alt="아이스바 비누 컬러 랜덤" /></a>
					<a href="" onclick="TnAddShoppingBag60957('<%= getitem("3") %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60957/btn_get.png" alt="상품 구매하기" /></a>
					<strong class="soldout" <% if oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem then %> style='display:block;'<% end if %>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60957/txt_sold_out.png" alt="솔드아웃" /></strong>
				</div>
			</li>
			<% Set oItem = Nothing %>

			<%
			set oItem = new CatePrdCls
			
				if getitem("4") <> "" then
					oItem.GetItemData getitem("4")
				end if
			%>
			<li>
				<div>
					<a href="" onclick="parent.fnAPPpopupProduct('1234674');return false;" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60957/img_item_04.jpg" alt="야광 달빛스티커" /></a>
					<a href="" onclick="TnAddShoppingBag60957('<%= getitem("4") %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60957/btn_get.png" alt="상품 구매하기" /></a>
					<strong class="soldout" <% if oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem then %> style='display:block;'<% end if %>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60957/txt_sold_out.png" alt="솔드아웃" /></strong>
				</div>
			</li>
			<% Set oItem = Nothing %>

			<%
			set oItem = new CatePrdCls
			
				if getitem("5") <> "" then
					oItem.GetItemData getitem("5")
				end if
			%>
			<li>
				<div>
					<a href="" onclick="parent.fnAPPpopupProduct('1234675');return false;" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60957/img_item_05.jpg" alt="샤오미 보조배터리" /></a>
					<a href="" onclick="TnAddShoppingBag60957('<%= getitem("5") %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60957/btn_get.png" alt="상품 구매하기" /></a>
					<strong class="soldout" <% if oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem then %> style='display:block;'<% end if %>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60957/txt_sold_out.png" alt="솔드아웃" /></strong>
				</div>
			</li>
			<% Set oItem = Nothing %>

			<%
			set oItem = new CatePrdCls
			
				if getitem("6") <> "" then
					oItem.GetItemData getitem("6")
				end if
			%>
			<li>
				<div>
					<a href="" onclick="parent.fnAPPpopupProduct('1234645');return false;" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60957/img_item_06.jpg" alt="아이리버 이어마이크 컬러 랜덤" /></a>
					<a href="" onclick="TnAddShoppingBag60957('<%= getitem("6") %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60957/btn_get.png" alt="상품 구매하기" /></a>
					<strong class="soldout" <% if oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem then %> style='display:block;'<% end if %>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60957/txt_sold_out.png" alt="솔드아웃" /></strong>
				</div>
			</li>
			<% Set oItem = Nothing %>
		</ul>
	</div>

	<div class="bonus">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60957/txt_today_bonus.png" alt="오늘의 보너스 혜택! 인기 아이템을 구매하시는 선착순 50명에게 기프티콘을 드립니다." /></p>
		<p class="giftcon">
			<% If left(currenttime,10)<="2015-04-06" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/60957/img_gift_01.png" alt="오늘의 기프티콘! 스타벅스 아이스 아메리카노 톨사이즈" />
			<% elseif left(currenttime,10)="2015-04-07" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/60957/img_gift_02.png" alt="오늘의 기프티콘! 베스킨라빈스 싱글레귤러 아이스크림" />
			<% elseif left(currenttime,10)="2015-04-08" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/60957/img_gift_03.png" alt="오늘의 기프티콘! 던킨도너츠 커피 &amp; 도넛" />
			<% end if %>
		</p>
	</div>

	<div class="noti">
		<h2><strong>이벤트 유의사항</strong></h2>
		<ul>
			<li>텐바이텐에서 한번만 구매하신 고객님을 위한 시크릿 이벤트입니다.</li>
			<li>본 이벤트는 로그인 후에 참여가 가능합니다.</li>
			<li>보너스혜택은 매일 다른 기프티콘으로 변경됩니다.</li>
			<li>이벤트는 조기 마감 될 수 있습니다.</li>
			<li>이벤트는 즉시결제로만 구매가 가능하며, 배송 후 반품, 교환, 구매취소가 불가능합니다.</li>
			<li>기프티콘은 선착순으로 구매하신 50분에게 당일 18시에 일괄 발송됩니다.</li>
			<li>기프티콘은 1인당 1개씩만 지급됩니다.</li>
			<li>상품의 가격은 해당 이벤트에서만 판매되는 특별 할인가격입니다.</li>
		</ul>
	</div>
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
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->