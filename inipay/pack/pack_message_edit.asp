<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/cscenter/cs_aslistcls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
dim i,opackmaster, opackitemlist, userid, guestSessionID, orderserial, message, title, midx, vJong, vGae, vWon
userid       	= getEncLoginUserID()
guestSessionID 	= GetGuestSessionKey
orderserial  	= requestCheckVar(request("idx"),11)
midx			= requestCheckVar(request("midx"),11)

If Not isNumeric(orderserial) Then
	Response.Write "<script>alert('잘못된 경로입니다.1');window.close();</script>"
	dbget.close
	Response.End
End If

If midx <> "" AND Not isNumeric(midx) Then
	Response.Write "<script>alert('잘못된 경로입니다.2');window.close();</script>"
	dbget.close
	Response.End
End If

Dim arr, jj
arr = fnGetOrderDetailStateList(orderserial)
If IsArray(arr) Then
For jj=0 To UBound(arr,2)
	If arr(0,jj) > 6 Then
		Response.Write "<script>alert('이미 출고가 완료되어\n선물포장 메세지를 수정할 수 없습니다.');location.href='/my10x10/order/myorderdetail.asp?idx="&orderserial&"&packopen=packopen';</script>"
		dbget.close
		Response.End
	End If
Next
End If

set opackmaster = new Cpack
	opackmaster.FRectUserID = userid
	opackmaster.FRectSessionID = guestSessionID
	opackmaster.FRectOrderSerial = orderserial
	opackmaster.FRectCancelyn = "N"
	opackmaster.FRectSort = "ASC"
	opackmaster.Getpojang_master()
	
	If opackmaster.FResultCount < 1 Then
		Response.Write "<script>alert('잘못된 경로입니다.3');location.href='/my10x10/order/myorderdetail.asp?idx="&orderserial&"&packopen=packopen';</script>"
		dbget.close
		Response.End
	End If
	
	If midx = "" Then
		midx = opackmaster.FItemList(0).fmidx
	End If
%>
<script>
$(function() {
	$('.orderSummary').click(function(){
		$(this).parent().toggleClass('closeToggle');
		$(this).parent().children('.pdtListWrap').toggle();
	});

	$(".editSentence textarea").each(function() {
		var defaultVal = this.value;
		$(this).focus(function() {

		});
		$(this).blur(function(){
			if(this.value == ''){
				
			}
		});
	});
	function frmCount(val) {
		var len = val.value.length;
		if (len >= 101) {
			val.value = val.value.substring(0, 100);
		} else {
			$("#mmsLen").text(len);
		}
	}
	$(".editSentence textarea").keyup(function() {
		frmCount(this);
	});
	$("#mmsLen").text($(".editSentence textarea").val().length);
});

function jsGoMessageEdit(v){
	$("input[name=midx]").val(v);
	frmgo.submit();
}

function jsSavePMsg(){
	if(frmMsg.message.value == ""){
		alert("선물포장 메세지를 입력해주세요.");
		frmMsg.message.focus();
		return false;
	}
	frmMsg.submit();
}

function jsGoReturnPage(){
	location.href='/my10x10/order/myorderdetail.asp?idx=<%=orderserial%>&packopen=packopen';
}
</script>
<style>
.userInfoEidt .editSentence {position:relative;}
.userInfoEidt .editSentence span {position:absolute; right:3%; bottom:5%; font-size:12px;}
.userInfoEidt .pdtCont .pNum {position:absolute; bottom:5px; font-size:12px;}
@media (min-width:480px) {
	.userInfoEidt .editSentence span {font-size:18px;}
	.userInfoEidt .pdtCont .pNum {bottom:7px; font-size:18px;}
}
</style>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<div class="header">
			<h1>선물포장 상품확인</h1>
			<p class="btnPopClose"><button class="pButton" onclick="jsGoReturnPage();">닫기</button></p>
		</div>

		<div class="content" id="contentArea">
			<form name="frmgo" action="<%=CurrURL()%>" method="post" style="margin:0px;">
			<input type="hidden" name="idx" value="<%=orderserial%>">
			<input type="hidden" name="midx" value="">
			</form>
			<form name="frmMsg" action="/inipay/pack/pack_message_edit_proc.asp" method="post" style="margin:0px;">
			<input type="hidden" name="idx" value="<%=orderserial%>">
			<div class="userInfo userInfoEidt inner10">
				<select title="포장그룹 선택" class="ct" style="width:100%;" name="midx" onChange="jsGoMessageEdit(this.value);">
				<%
					For i=0 To opackmaster.FResultCount-1
						Response.Write "<option value=""" & opackmaster.FItemList(i).fmidx & """"
						If CStr(midx) = CStr(opackmaster.FItemList(i).fmidx) Then
							Response.Write " selected"
							message = opackmaster.FItemList(i).Fmessage
						End If
						Response.Write ">" & opackmaster.FItemList(i).Ftitle & "</option>" & vbCrLf
					Next

					
					opackmaster.frectmidx = midx
					opackmaster.Getpojang_itemlist
				%>
				</select>

				<div class="orderList"><!-- <em class="cGy1">l</em><span class="cRd1" id="won"></span>원 //-->
					<p class="orderSummary box5">상품정보 확인 : <span class="cRd1" id="jong"></span>종 (<span class="cRd1" id="gae"></span>개)</p>
					<div class="pdtListWrap" style="display:none;">
						<ul class="pdtList">

							<%	For i=0 To opackmaster.FResultCount-1 %>
								<li>
									<div class="pPhoto"><img src="<%=opackmaster.FItemList(i).FImageList%>" alt="<%=Replace(opackmaster.FItemList(i).FItemName,chr(34),"")%>" /></div>
									<div class="pdtCont">
										<p class="pBrand">[<%=opackmaster.FItemList(i).FBrandName%>]</p>
										<p class="pName"><%=opackmaster.FItemList(i).FItemName%></p>
										<% If opackmaster.FItemList(i).FItemOptionName <> "" Then %><p class="pBrand">옵션 : <%=opackmaster.FItemList(i).FItemOptionName%></p><% End If %>
										<p class="pNum">수량 : <span class="cRd1"><%=opackmaster.FItemList(i).FItemEa%></span></p>
									</div>
								</li>
							<%
									vJong = vJong + 1
									vGae = vGae + opackmaster.FItemList(i).FItemEa
								Next %>

						</ul>
					</div>
				</div>
				<fieldset>
				<legend>주문제작 문구수정 변경</legend>
					<div class="editSentence">
						<textarea cols="60" rows="50" title="변경할 문구를 입력해주세요" name="message"><%=message%></textarea>
					</div>
					<p class="rt tMar05 fs11"><strong><span id="mmsLen">0</span></strong>/100</p>
				</fieldset>
			</div>

			<div class="btnWrap inner10" style="width:100%;">
				<div class="ftLt w50p" style="padding-right:0.25rem;"><span class="button btB1 btGry2 cWh1 w100p" onClick="jsGoReturnPage();return false;"><button type="button">취소</button></span></div>
				<div class="ftLt w50p" style="padding-left:0.25rem;"><span class="button btB1 btRed cWh1 w100p" onClick="jsSavePMsg();return false;"><button type="submit">수정</button></span></div>
			</div>
			</form>
		</div>

	</div>
</div>
<script>$("#jong").text("<%=vJong%>");$("#gae").text("<%=vGae%>");</script>
</body>
</html>
<% set opackmaster = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->