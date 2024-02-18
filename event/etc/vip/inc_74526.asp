<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : VIP - 마이 리틀 트리
' History : 2016-11-23 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, currenttime, subscriptcoun, subscriptcount, systemok, sqlstr, totalprice
dim arrList
	IF application("Svr_Info") = "Dev" THEN
		eCode = "66214"
	Else
		eCode = "74526"
	end if

currenttime = now()

userid = GetEncLoginUserID()
totalprice = 0
subscriptcount=0

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "" ,"")
end if

if userid <> "" then
	sqlstr = sqlstr & " select isnull(sum(subtotalprice),0) as totalprice"
	sqlstr = sqlstr & " from db_order.dbo.tbl_order_master m"
	sqlstr = sqlstr & " where convert(varchar(10),regdate,21) between '2016-11-28' and '2016-12-02' "
	sqlstr = sqlstr & " and m.jumundiv not in (6,9)"
	sqlstr = sqlstr & " and m.ipkumdiv>3 and cancelyn='N'"
	sqlstr = sqlstr & " and m.userid='"& userid &"'"
	
'	response.write sqlstr & "<Br>"
'	Response.end
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		totalprice = rsget("totalprice")
	else
		totalprice = 0
	END IF
	rsget.close
end if
	

'GetLoginUserLevel() = 6
%>
<style type="text/css">
img {vertical-align:top;}

.tree {display:block; position:relative;}
.tree p.itemName {position:absolute; top:48.04%; left:13.28%; z-index:10; width:19.53%; animation:bounce 1s infinite;}
@keyframes bounce { from to {transform:translateY(0); animation-timing-function:ease-out;} 50% {transform:translateY(-10px); animation-timing-function:ease-in;} }

.shoppingPrice {position:relative;}
.shoppingPrice p span {position:absolute; bottom:15.03%; }
.shoppingPrice p span.price01 {left:24.21%; width:14.68%;}
.shoppingPrice p span.price02 {left:49.06%; width:21.875%; font-size:1.6rem; color:#5c7c3d; font-weight:bold; line-height:1rem; text-align:right;}
.shoppingPrice p span.price03 {right:25.21%; width:3.28%;}

.eventNotice {background:url(http://webimage.10x10.co.kr/eventIMG/2016/74526/m/bg_brown.jpg) 0 0;}
.eventNotice .noticeContent {padding:1.9rem 1rem 2.4rem 1.4rem;}
.eventNotice .noticeContent h3 {width:35.78%;}
.eventNotice .noticeContent ul {margin-top:1.7rem;}
.eventNotice .noticeContent ul li {position:relative; margin-top:0.6rem; padding-left:1.6rem; color:#ffffff; font-size:1rem; line-height:1.25rem;}
.eventNotice .noticeContent ul li:after {content:' '; display:block; position:absolute; top:0.4rem; left:0; width:0.6rem; height:0.1rem; background-color:#ffffff;}
</style>
<script>
function jsevtgo(){
<% If IsUserLoginOK() Then %>
	<% if IsVIPUser() then 'vip %>
		<% If not(left(currenttime,10)>="2016-11-28" and left(currenttime,10)<"2016-12-03" ) then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if subscriptcount > 0 then %>
				alert('이미 응모 하셨습니다.\n당첨자 발표일을 기다려 주세요');
				return;
			<% else %>
				<% if totalprice < 1 then %>
					alert('본 이벤트는\n이벤트 기간 내 구매 이력이 있어야\n참여할 수 있어요');
					return false;
				<% else %>
					var str = $.ajax({
						type: "POST",
						url: "/event/etc/doeventsubscript/doEventSubscript74526.asp",
						data: "mode=evtgo",
						dataType: "text",
						async: false
					}).responseText;
					var str1 = str.split("||")
					if (str1[0] == "11"){
						alert('응모가 완료되었습니다!\n당첨자 발표일을 기다려 주세요');
						return false;
					}else if (str1[0] == "01"){
						alert('잘못된 접속입니다.');
						return false;
					}else if (str1[0] == "02"){
						alert('로그인을 해야\n이벤트에 참여할 수 있어요.');
						return false;
					}else if (str1[0] == "03"){
						alert('이벤트 기간이 아닙니다.');
						return false;		
					}else if (str1[0] == "04"){
						alert('본 이벤트는\nID당 한 번씩만 참여할 수 있어요');
						return false;
					}else if (str1[0] == "00"){
						alert('정상적인 경로가 아닙니다.');
						return false;
					}else{
						alert('오류가 발생했습니다.');
						return false;
					}
				<% end if %>
			<% end if %>
		<% end if %>
	<% else %>
		alert('본 이벤트는\nVIP 등급 이상 고객님들을 위한\n이벤트입니다.');
		return false;
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

</script>
<div class="mEvt74526">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/74526/m/tit_little_tree.jpg" alt="VIP LOUNGE EVENT 마이 리틀 트리 이벤트 기간 내 구매 이력이 있는 분들 중 50분을 추첨하여 크리스마스트리를 드립니다 당첨자 발표 : 2016년 12월 5일" /></h2>
	<a href="/category/category_itemPrd.asp?itemid=1602684&pEtr=74526" class="mWeb tree">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/74526/m/img_tree.jpg" alt="" /></p>
		<p class="itemName"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74526/m/txt_item01.png" alt="로즈골드 별 트리풀 세트" /></p>
	</a>
	<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1602684&pEtr=74526" onclick="fnAPPpopupProduct('1602684&pEtr=74526');return false;" class="mApp tree">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/74526/m/img_tree.jpg" alt="" /></p>
		<p class="itemName"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74526/m/txt_item01.png" alt="로즈골드 별 트리풀 세트" /></p>
	</a>
	<div class="shoppingPrice">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/74526/m/txt_shopping_list.jpg" alt="이주의 쇼핑 활동 2016년 11월 28일 ~ 12월 02일 VIP등급에게만 드리는 기회" /></p>
		<p>
			<span class="price01"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74526/m/txt_price.png" alt="구매금액" /></span>
			<span class="price02"><% If IsUserLoginOK() Then %><%= FormatNumber(totalprice,0) %><% Else %>***,***<% End If %></span>
			<span class="price03"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74526/m/txt_price02.png" alt="원" /></span>
		</p>
	</div>
	<a href="" onclick="jsevtgo(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74526/m/btn_go_evnt.jpg" alt="응모하기" /></a>
	<div class="eventNotice">
		<div class="noticeContent">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/74526/m/txt_evnt_noti.png" alt="이벤트유의사항" /></h3>
			<ul>
				<li>본 이벤트는 VIP Silver, VIP Gold, VVIP 등급 고객님을 위한 이벤트입니다.</li>
				<li>이벤트 기간 내 구매 이력이 있어야 응모가 가능합니다.</li>
				<li>ID 당 1회만 참여할 수 있습니다.</li>
				<li>당첨된 경품의 색상 및 옵션은 랜덤으로 배송됩니다.</li>
			</ul>
		</div>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->