<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/header.asp" -->
<%
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  20886
Else
	eCode   =  41536			'PC웹 이벤트 번호
End If

dim userid, sql, lp, ordList
userid  = GetLoginUserID

if IsUserLoginOK then
	'// 응모가능 주문번호 목록 접수
	sql = "select m.orderserial " &_
		" 	,m.subtotalPrice as ttPrice " &_
		" 	,min(d.itemname) as itemname " &_
		" from db_order.dbo.tbl_order_master as m " &_
		" 	join db_order.dbo.tbl_order_detail as d " &_
		" 		on m.orderserial=d.orderserial " &_
		" where m.regdate between '2012-04-15 00:00:00.000' and '2013-04-25 00:00:00.000' " &_
		" 	and m.ipkumdiv>3 " &_
		" 	and m.cancelyn='N' " &_
		" 	and m.userid='" & userid & "' " &_
		" 	and d.itemid<>0 " &_
		" 	and d.cancelyn<>'Y' " &_
		" 	and m.jumundiv<>'9' " &_
		" 	and m.orderserial not in ( " &_
		" 		select sub_opt1 " &_
		" 		from db_event.dbo.tbl_event_subscript " &_
		" 		where evt_code='" & eCode & "' " &_
		" 	) " &_
		" group by m.orderserial, m.subtotalPrice"
		rsget.open sql,dbget,1

		if Not(rsget.EOF or rsget.BOF) then
			redim ordList(rsget.RecordCount,3)
			for lp=1 to rsget.RecordCount
				ordList(lp,1) = rsget("orderserial")
				ordList(lp,2) = rsget("ttPrice")
				ordList(lp,3) = rsget("itemname")
				rsget.MoveNext
			next
		else
			redim ordList(0)
		end if
		rsget.Close
else
	redim ordList(0)
end if
%>
<style type="text/css">
  .evt41543 img {vertical-align:top;}
  .evt41543 .orderView {background-color:#f9f9f9;}
  .evt41543 .orderView table {width:100%; border-bottom:2px solid #ebebeb;}
  .evt41543 .orderView table th {background-color:#ebebeb; text-align:center; padding:5px; color:#555; font-size:11px;}
  .evt41543 .orderView table td {border-bottom:1px solid #ebebeb; background-color:#fff; padding:5px; margin:0; font-size:11px; text-align:center; vertical-align:middle; color:#777; font-size:10px;}
  .evt41543 .orderView table td.lt {text-align:left;}
  .evt41543 .orderInput {border:1px solid #d7d7d7; color:#f4664a; text-align:center; font-size:11px; line-height:13px;}
</style>
<script type="text/javascript">
<!--
	//주문번호 선택
	function selOrdNo(ono) {
		document.chkForm.sub_opt1.value = ono;
	}

	//응모
	function subreg(frm){
		if ("<%=IsUserLoginOK%>"=="False") {
			jsChklogin('<%=IsUserLoginOK%>');
			return false;
		}

		if(frm.sub_opt1.value==""||frm.sub_opt1.value=="주문번호"){
			alert('응모하실 주문번호를 선택해주세요.');
			return false;
		}else{
			frm.action = 'subscript_41543_process.asp';
			frm.target = 'ifrProc';
			return true;
		}
	}
//-->
</script>
<div class="evt41543">
  <p><img src="http://webimage.10x10.co.kr/eventIMG/2013/41543/evt_head.png" alt="빵!빵!빵! PROJECT" style="width:100%;" /></p>
  <p><img src="http://webimage.10x10.co.kr/eventIMG/2013/41543/41543_head.jpg" alt="쇼핑하면 선물이 온다" style="width:100%;" /></p>
  <p><img src="http://webimage.10x10.co.kr/eventIMG/2013/41543/41543_cont1.jpg" alt="주문번호를 선택하고 응모하세요" style="width:100%;" /></p>
  <p><img src="http://webimage.10x10.co.kr/eventIMG/2013/41543/41543_cont2.jpg" alt="응모방법" style="width:100%;" /></p>
  <p><img src="http://webimage.10x10.co.kr/eventIMG/2013/41543/41543_cont3.jpg" alt="주문번호 선택" style="width:100%;" /></p>
  <div class="inner orderView">
    <table cellpadding="0" cellspacing="0">
      <colgroup>
        <col width="15px" /><col width="70px" /><col width="" /><col width="70px" />
      </colgroup>
      <thead>
        <tr>
          <th></th>
          <th>주문번호</th>
          <th>주문상품</th>
          <th>결제금액</th>
        </tr>
      </thead>
      <tbody>
		<% if Not(IsUserLoginOK) then %>
        <tr>
          <td colspan="4" height="50px">로그인 해주세요.</td>
        </tr>
	    <%
	    	else
	    		if ubound(ordList)>0 then
	    			for lp=1 to ubound(ordList)
	    %>
        <tr>
			<td><input type="radio" name="rdoOrdNo" id="rdoOrd<%=lp%>" value="<%=ordList(lp,1)%>" onclick="selOrdNo(this.value)" /></td>
			<td><label for="rdoOrd<%=lp%>"><%=ordList(lp,1)%></label></td>
			<td class="lt"><label for="rdoOrd<%=lp%>"><%=ordList(lp,3)%></label></td>
			<td><%=formatNumber(ordList(lp,2),0)%>원</td>
        </tr>
        <%
        			next
        		else
        %>
        <tr>
          <td colspan="4" height="50px">등록된 주문번호가 없습니다.</td>
        </tr>
        <%
        		end if
        	end if
        %>
      </tbody>
    </table>
    <form name="chkForm" method="post" onSubmit="return subreg(this);">
    <p class="overHidden tMar10">
      <span class="ftLt tPad03"><input type="text" name="sub_opt1" class="orderInput" required placeholder="주문번호" readonly /></span>
      <span class="ftRt rt" style="width:52.66666%"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2013/41543/41543_btn.png" alt="응모하기" style="width:158px;" /></span>
    </p>
    </form>
  </div>
  <p><a href="/category/category_itemPrd.asp?itemid=307349" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41543/41543_gift1.jpg" alt="Kaffe duo 커피메이커" style="width:100%;" /></a></p>
  <p><a href="/category/category_itemPrd.asp?itemid=641522" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41543/41543_gift2.jpg" alt="Poster Bag" style="width:100%;" /></a></p>
  <p><a href="/category/category_itemPrd.asp?itemid=677612" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41543/41543_gift3.jpg" alt="Lifestudio 3단 수동우산" style="width:100%;" /></a></p>
  <p><img src="http://webimage.10x10.co.kr/eventIMG/2013/41543/41543_cont4.jpg" alt="이벤트 안내" style="width:100%;" /></p>
  <p><img src="http://webimage.10x10.co.kr/eventIMG/2013/41543/41543_cmt1.png" alt="모바일 리뉴얼 오픈기념 축하 코멘트를 남겨주세요!" style="width:100%;" /></p>
  <p><a href="/event/eventmain.asp?eventid=41542"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41543/41543_cmt2.png" alt="코멘트 남기러 가기" style="width:100%;" /></a></p>
  <p><img src="http://webimage.10x10.co.kr/eventIMG/2013/41543/41543_cmt3.png" alt="" style="width:100%;" /></p>
  <p><a href="/event/eventmain.asp?eventid=41709" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41543/evt_btm.png" alt="20% 쿠폰 다운 받으러 가기" style="width:100%;" /></a></p>
  <iframe name="ifrProc" id="ifrProc" src="about:blank" width="0" height="0" frameborder="0"></iframe>
</div>
<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->