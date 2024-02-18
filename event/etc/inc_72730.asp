<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 페이스백2
' History : 2016-08-24 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
dim eCode, userid, currenttime, subscriptcoun, subscriptcount, systemok, sqlstr, totalprice , chkyn , chkcnt
dim arrList
	IF application("Svr_Info") = "Dev" THEN
		eCode = "66189"
	Else
		eCode = "72730"
	end if

currenttime = now()
userid = GetEncLoginUserID()
totalprice = 0
subscriptcount=0
chkyn = False
chkcnt = 0

If Not(IsUserLoginOK()) Then
	if isApp=1 then
		Response.write "<script>calllogin();return false;</script>"
	else
		Response.write "<script>jsChklogin_mobile('','"& Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")&"');return false;</script>"
	end if
End If 

'select * from db_temp.dbo.tbl_event_72730 ID체크 있는 애들만 응모가능하도록 추가
if userid <> "" Then
	sqlstr = "select count(userid) as cnt from db_temp.dbo.tbl_event_72730 where userid = '"& userid &"' "
	rsget.Open sqlstr,dbget,1
		chkcnt = rsget("cnt")
	rsget.Close
End If

If chkcnt > 0 Then
	chkyn = True
Else
	chkyn = False
	if userid <> "" Then
		Call Alert_Return("죄송합니다 응모 대상자가 아닙니다.")
	End If 
End If 

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", left(currenttime,10))
end if

systemok="O"
'//시작전 테스트 장치?
if left(currenttime,10)<"2016-08-29" then
	systemok="X"
	if userid = "motions" or userid = "greenteenz" then
		systemok="O"
	end if
end if

if userid <> "" Then
	sqlstr = ""
	sqlstr = sqlstr & " select isnull(sum(subtotalprice),0) as totalprice"
	sqlstr = sqlstr & " from db_order.dbo.tbl_order_master m"
	sqlstr = sqlstr & " where convert(varchar(10),regdate,21)='"&date()&"' "
	sqlstr = sqlstr & " and m.jumundiv not in (6,9)"
	sqlstr = sqlstr & " and m.ipkumdiv>3 and cancelyn='N'"
	sqlstr = sqlstr & " and m.userid='"& userid &"'"

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		totalprice = rsget("totalprice")
	else
		totalprice = 0
	END IF
	rsget.close
end if

	dim rsMem
	sqlstr = ""
	sqlstr = sqlstr & " select top 18 d.itemid, d.itemname, i.listimage, i.basicimage "
	sqlstr = sqlstr & " 	from db_order.dbo.tbl_order_detail as d "
	sqlstr = sqlstr & " 	join db_item.dbo.tbl_item as i "
	sqlstr = sqlstr & " 		on d.itemid = i.itemid "
	sqlstr = sqlstr & " where d.itemid <> 0 and d.itemid <> 100 "
	sqlstr = sqlstr & " order by orderserial desc "

	set rsMem = getDBCacheSQL(dbget,rsget,"72730EVT",sqlstr,60*5)
	IF Not (rsMem.EOF OR rsMem.BOF) THEN
		arrList = rsMem.getRows()
	END IF
	rsMem.close
%>
<style type="text/css">
img {vertical-align:top;}
.myShopping {padding-top:3.3rem; background:#fff;}
.myShopping h3 {width:48.75%; margin:0 auto;}
.myShopping .price {position:relative; padding:2.9rem 4rem 3rem 14rem;}
.myShopping .price:after {content:''; display:block; position:absolute; left:3.5rem; top:2rem; width:7.3rem; height:7.3rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/71025/m/ico_member.png) no-repeat 0 0; background-size:100% auto;}
.myShopping .price dl {position:relative; overflow:hidden; padding:2.1rem 0 2rem; font-size:1.2rem; font-weight:bold; border-top:0.15rem solid #cad5e7; border-bottom:0.15rem solid #cad5e7;}
.myShopping .price dt {float:left;}
.myShopping .price dd {float:right; text-align:right;}
.myShopping .price dd strong {color:#fe3b18;}
.myShopping .btnApply {display:block; width:80.78%; margin:0 auto;}
.saleNow {background:#e9ebee;}
.saleNow .itemRolling {position:relative; padding:0 3.125% 5.5rem;}
.saleNow .itemRolling .swiper-container {background:#fff; border-radius:0.3rem; box-shadow:1px 1px 0.1rem 0 #d5d6d9;}
.saleNow .itemRolling ul {overflow:hidden; padding:1.2rem 1.2rem 2rem;}
.saleNow .itemRolling li {float:left; width:33.33333%; height:12.9rem; text-align:center; padding:1.2rem 0.8rem 0; border-top:1px solid #e1e1e1; border-right:1px solid #e1e1e1;}
.saleNow .itemRolling li:nth-child(1),
.saleNow .itemRolling li:nth-child(2),
.saleNow .itemRolling li:nth-child(3) {padding-top:0; border-top:0;}
.saleNow .itemRolling li:nth-child(3),
.saleNow .itemRolling li:nth-child(6) {border-right:0;}
.saleNow .itemRolling li img {width:8rem; height:8rem;}
.saleNow .itemRolling li p {overflow:hidden; margin-top:1.1rem; padding:0 0.5rem; font-size:1rem; line-height:1.2; color:#888; font-weight:600; text-overflow:ellipsis; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; word-wrap:break-word; height:2.4rem;}
.saleNow .itemRolling .pagination {position:absolute; bottom:3.2rem; left:0; z-index:10; width:100%; height:auto; padding-top:0; text-align:center;}
.saleNow .itemRolling .pagination .swiper-pagination-switch {display:inline-block; width:0.8rem; height:0.8rem; margin:0 0.5rem; border:0; background-color:#cfd1d3; cursor:pointer;}
.saleNow .itemRolling .pagination .swiper-active-switch {background-color:#3b579d;}
.evtNoti {padding:2.4rem 4.68% 0;}
.evtNoti h3 {padding-bottom:1.5rem; font-size:1.3rem;}
.evtNoti h3 strong {display:inline-block; height:1.5rem; border-bottom:0.2rem solid #000;}
.evtNoti li {position:relative; color:#666; font-size:1rem; line-height:1.3; padding:0 0 0.2rem 0.7rem;}
.evtNoti li:after {content:''; position:absolute; left:0; top:0.4rem; width:0.2rem; height:0.2rem; background:#3b579d; border-radius:50%;}
</style>
<script>
$(function(){
	// 방금판매된상품
	mySwiper2 = new Swiper(".itemRolling .swiper-container",{
		loop:false,
		autoplay:false,
		speed:600,
		pagination:".itemRolling .pagination",
		paginationClickable:true
	});
});

function jsevtgo(){
<% if systemok = "O" then %>
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-08-26" and left(currenttime,10)<"2016-09-01" ) then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if subscriptcount > 0 then %>
				alert('오늘은 이미 응모 하셨습니다.');
				return;
			<% else %>
				<% if totalprice < 1 then %>
					alert('당일 결제 총액 5만원 이상시 응모할 수 있습니다.');
					return false;
				<% elseif totalprice > 0 and totalprice < 50000 then %>
					alert('당일 결제 총액 5만원 이상시 응모할 수 있습니다.');
					return false;
				<% else %>
					var str = $.ajax({
						type: "POST",
						url: "/event/etc/doeventsubscript/doEventSubscript72730.asp",
						data: "mode=evtgo",
						dataType: "text",
						async: false
					}).responseText;
					var str1 = str.split("||")
					if (str1[0] == "11"){
						alert('응모가 완료 되었습니다.\n마일리지는 9월 19일에 지급될 예정입니다.');
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
						alert('오늘은 이미 응모 하셨습니다.');
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
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
<% else %>
	alert('로그인후 이용 하실 수 있습니다.');
	return;
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
</script>

<div class="mEvt72730">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/72730/m/tit_pay_back.png" alt="페이스백" /></h2>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72730/m/txt_step.png" alt="텐바이텐에서 5만원 이상 구매하고 마일리지 신청하면 9월 19일 마일리지 지급!" /></p>

	<%' 오늘 MY 쇼핑활동 %>
	<div class="myShopping">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/72730/m/tit_my_shopping.png" alt="오늘 MY 쇼핑활동" /></h3>
		<div class="price">
			<dl>
				<dt>구매금액 :</dt>
				<dd><strong><%= FormatNumber(totalprice,0) %></strong>원</dd>
			</dl>
		</div>
		<button type="button" class="btnApply" onclick="jsevtgo(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72730/m/btn_apply.png" alt="마일리지 신청하기" /></button>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72730/m/txt_tip.png" alt="※ 구매금액은 당일 결제 완료건에 대해서 합산된 금액입니다./※ 마일리지는 9월 19일 지급될 예정입니다." /></p>
	</div>

	<%' 방금 전 판매된 상품 %>
	<div class="saleNow">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/72730/m/tit_sell.png" alt="방금 전 판매된 상품" /></h3>
		<div class="itemRolling">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<ul>
						<%
						dim numcols, numrows, rowcounter, colcounter, thisfield
						numcols=ubound(arrList,1)
						numrows=ubound(arrList,2)
							FOR rowcounter= 0 TO numrows
								 thisfield=arrList(colcounter,rowcounter)
							%>
							<li>
								<a href="" onclick="jsViewItem('<%= arrList(0,rowcounter) %>'); return false;">
									<img src="http://webimage.10x10.co.kr/image/basic/<%= GetImageSubFolderByItemid(arrList(0,rowcounter)) %>/<%= arrList(3,rowcounter) %>" alt="<%= arrList(1,rowcounter) %>" />
									<p><%= arrList(1,rowcounter) %></p>
								</a>
							</li>
						<% if rowcounter = 5 or rowcounter = 11 then %>
						</ul>
					</div>
					<div class="swiper-slide">
						<ul>
						<% end if %>
							<%
								NEXT
							%>
						</ul>
					</div>
				</div>
			</div>
			<div class="pagination"></div>
		</div>
	</div>
	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>본 이벤트는 당일 결제 총액 5만원 이상 결제이력이 있는 고객 대상으로 응모가 가능합니다.</li>
			<li>마일리지는 9월 19일 지급될 예정입니다.</li>
			<li>구매금액은 당일 결제 완료건에 대해서 합산된 금액입니다.</li>
			<li>본 이벤트는 신청 후 결제취소 및 환불하게 되면<br />마일리지 지급 대상에서 제외됩니다.</li>
		</ul>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->