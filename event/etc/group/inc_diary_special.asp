<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/diarystory2016/lib/classes/diary_class_B.asp" -->
<%
'####################################################
' Description : 다이어리 스페셜
' History : 2015-10-13 유태욱 생성
'####################################################
Dim oEventid : oEventid = requestCheckVar(Request("eventid"),10)

Dim diaryidx '//어드민 [ON]다이어리관리>>스페셜 다이어리 관리 의 idx(번호)
Dim preEcode , nextEcode
Dim evturl

If isapp = "1" Then
	evturl = "/apps/appcom/wish/web2014/event/eventmain.asp?eventid="
Else
	evturl = "/event/eventmain.asp?eventid="
End If 

If oEventid = "66819" Then
	diaryidx = "7"
	preEcode = evturl & "67912"  '//이전이벤트
	nextEcode = evturl & "66822"   '//다음이벤트
ElseIf oEventid = "66822" Then
	diaryidx = "8"
	preEcode = evturl & "66819"  '//이전이벤트
	nextEcode = evturl & "66823"   '//다음이벤트
ElseIf oEventid = "66823" Then
	diaryidx = "9"
	preEcode = evturl & "66822"  '//이전이벤트
	nextEcode = evturl & "66824"   '//다음이벤트
ElseIf oEventid = "66824" Then
	diaryidx = "10"
	preEcode = evturl & "66823"  '//이전이벤트
	nextEcode = evturl & "66825"   '//다음이벤트
ElseIf oEventid = "66825" Then
	diaryidx = "11"
	preEcode = evturl & "66824"  '//이전이벤트
	nextEcode = evturl & "66826"   '//다음이벤트
ElseIf oEventid = "66826" Then
	diaryidx = "12"
	preEcode = evturl & "66825"  '//이전이벤트
	nextEcode = evturl & "67340"   '//다음이벤트

ElseIf oEventid = "67340" Then
	diaryidx = "13"
	preEcode = evturl & "66826"  '//이전이벤트
	nextEcode = evturl & "67341"   '//다음이벤트
ElseIf oEventid = "67341" Then
	diaryidx = "14"
	preEcode = evturl & "67340"  '//이전이벤트
	nextEcode = evturl & "67342"   '//다음이벤트
ElseIf oEventid = "67342" Then
	diaryidx = "15"
	preEcode = evturl & "67341"  '//이전이벤트
	nextEcode = evturl & "67343"   '//다음이벤트
ElseIf oEventid = "67343" Then
	diaryidx = "16"
	preEcode = evturl & "67342"  '//이전이벤트
	nextEcode = evturl & "67344"   '//다음이벤트
ElseIf oEventid = "67344" Then
	diaryidx = "17"
	preEcode = evturl & "67343"  '//이전이벤트
	nextEcode = evturl & "67909"   '//다음이벤트

ElseIf oEventid = "67909" Then
	diaryidx = "18"
	preEcode = evturl & "67344"  '//이전이벤트
	nextEcode = evturl & "67910"   '//다음이벤트
ElseIf oEventid = "67910" Then
	diaryidx = "19"
	preEcode = evturl & "67909"  '//이전이벤트
	nextEcode = evturl & "67911" '//다음이벤트
ElseIf oEventid = "67911" Then
	diaryidx = "20"
	preEcode = evturl & "67910"  '//이전이벤트
	nextEcode = evturl & "67912" '//다음이벤트
ElseIf oEventid = "67912" Then
	diaryidx = "21"
	preEcode = evturl & "67911"  '//이전이벤트
	nextEcode = evturl & "67913" '//다음이벤트

ElseIf oEventid = "67913" Then
	diaryidx = "22"
	preEcode = evturl & "67912"  '//이전이벤트
	nextEcode = evturl & "66819" '//다음이벤트
	
else
	oEventid = "66819"
	diaryidx = "7"
	preEcode = evturl & "67912"  '//이전이벤트
	nextEcode = evturl & "66822"   '//다음이벤트
End If 

Dim cSpecial, vCurrPage, i, j, dCnt, LoginUserid

'vCurrPage = RequestCheckVar(Request("cpg"),5)
LoginUserid = GetencLoginUserID()

dCnt = 1

If vCurrPage = "" Then vCurrPage = 1

SET cSpecial = New cdiary_list
cSpecial.FPageSize = 5
cSpecial.FRectIdx = diaryidx
'cSpecial.Fuserid = LoginUserid
cSpecial.FCurrpage = vCurrPage
cSpecial.fnspecialList

%>
<script type='text/javascript'>

$(function(){
<% if isapp then %>
	fnAPPchangPopCaption("스페셜 다이어리");
<% end if %>
});	

	function chgBA(v){
		var chkapp = navigator.userAgent.match('tenapp');
		if ( chkapp ){
			parent.location.href="/apps/appcom/wish/web2014/event/eventmain.asp?eventid="+v;	//앱영역 스크립트
		}else{
			parent.location.href="/event/eventmain.asp?eventid="+v;	//모바일영역 스크립트
		}
	}

	$(function(){
		var tmpnum 
		tmpnum = $('select').find('option').length; 
		$(".numbering .total img").attr("src","http://webimage.10x10.co.kr/eventIMG/2015/65469/txt_num_total"+tmpnum+".png");
	});

	//상품 상세
	function jsViewItem(i){
		<% if isApp=1 then %>
			parent.fnAPPpopupProduct(i);
			return false;
		<% else %>
			top.location.href = "/category/category_itemprd.asp?itemid="+i+"";
			return false;
		<% end if %>
	}

	//메인 이미지 링크
	function fnmainbnlink(linkgubun,linkcode) {
		if(linkcode=='0'){
			return;
		}else{
			if (linkgubun=='i'){
				<% if isApp=1 then %>
					parent.fnAPPpopupProduct(linkcode);
					return false;
				<% else %>
					top.location.href = "/category/category_itemprd.asp?itemid="+linkcode+"";
					return false;
				<% end if %>
			}else{
				<% if isApp=1 then %>
					parent.location.href="/apps/appcom/wish/web2014/event/eventmain.asp?eventid="+linkcode;
				<% else %>
					parent.location.href='/event/eventmain.asp?eventid='+linkcode;
				<% end if %>
			}
		}
	}
</script>
<link rel="stylesheet" type="text/css" href="/lib/css/diary2016.css" />
<link rel="stylesheet" type="text/css" href="/lib/css/newV15a.css" />
<!-- content area -->
<div class="content diarySpecial" id="contentArea">
<% If (cSpecial.FResultCount > 0) Then %>
	<% For i = 0 To cSpecial.FResultCount-1 %>
	<%
		if dCnt > 5 then
			dCnt = 1
		end if
	%>
		<% if dCnt = 1 then %>
			<div class="specialCont">
				<div><a href="" onclick="fnmainbnlink('<%=cSpecial.FItemList(i).Flinkgubun%>','<%=cSpecial.FItemList(i).Flinkcode%>'); return false;"><img src="<%= cSpecial.FItemList(i).Fmomileimage %>" alt="" /></a></div><!-- 모바일 메인 이미지사이즈 640x888 -->
				<span class="spcTag"><img src="http://fiximage.10x10.co.kr/m/2015/diarystory2016/ico_10x10_special02.png" alt="" /></span>
				<a href="<%=preEcode%>" class="btnNav prev"><img src="http://fiximage.10x10.co.kr/m/2015/diarystory2016/btn_prev_special.png" alt="이전" /></a>
				<a href="<%=nextEcode%>" class="btnNav next"><img src="http://fiximage.10x10.co.kr/m/2015/diarystory2016/btn_next_special.png" alt="다음" /></a>
				<div class="selectBrd">
					<select onchange="chgBA(this.value);">
						<option value="66826" <% if oEventid = "66826" then response.write "selected" end if %>>꽃 향기로 가득한 당신의 일상, 라이플 페이퍼</option>
						<option value="66825" <% if oEventid = "66825" then response.write "selected" end if %>>오랜친구 아이코닉과 함께, 더 플래너 2016</option>
						<option value="66824" <% if oEventid = "66824" then response.write "selected" end if %>>조금 더 특별한,무민 다이어리</option>
						<option value="66823" <% if oEventid = "66823" then response.write "selected" end if %>>메모와 수납을 동시에,미도리 포켓 다이어리</option>
						<option value="66822" <% if oEventid = "66822" then response.write "selected" end if %>>2016년 우리만의 축제를,카니발 포켓다이어리</option>
						<option value="66819" <% if oEventid = "66819" then response.write "selected" end if %>>미도리의 오랜친구,오지상 포켓다이어리</option>
						
						<option value="67342" <% if oEventid = "67342" then response.write "selected" end if %>>다이어리에 자수를 새기다.</option>
						<option value="67341" <% if oEventid = "67341" then response.write "selected" end if %>>아이우에오의 유쾌함을 담아.</option>
						<option value="67340" <% if oEventid = "67340" then response.write "selected" end if %>>늑대와 함께 하는 2016년</option>
						<option value="67343" <% if oEventid = "67343" then response.write "selected" end if %>>단 1초도 소홀하지 않은 당신에게</option>
						<option value="67344" <% if oEventid = "67344" then response.write "selected" end if %>>팝 아트의 거장 Andy warhol</option>

						<option value="67909" <% if oEventid = "67909" then response.write "selected" end if %>>2016 DIARY BIANCA CASH (하드커버)</option>
						<option value="67910" <% if oEventid = "67910" then response.write "selected" end if %>>2016 DIARY FUTURE (하드커버)</option>
						<option value="67911" <% if oEventid = "67911" then response.write "selected" end if %>>2016 DIARY GOLD FOIL (소프트커버) - 2colors</option>
						<option value="67912" <% if oEventid = "67912" then response.write "selected" end if %>>2016 DIARY BIANCA CASH (소프트커버) - 2colors</option>
						<% if date >= "2015-12-08" then %>
							<option value="67913" <% if oEventid = "67913" then response.write "selected" end if %>>imagine 04_friends</option>
						<% end if %>
					</select>
				</div>
			</div>
			<div class="pdtListWrapV15a">
				<ul class="pdtListV15a">
		<% end if %>
			<% if cSpecial.FItemList(i).Fitemid <> "0" then %>
				<li onclick="jsViewItem('<%=cSpecial.FItemList(i).FItemid%>'); return false;" <% if cSpecial.FItemList(i).IsSoldOut then %>class="soldOut"<% end if %>>
					<div class="pPhoto">
						<p><span><em>품절</em></span></p>
						<img src="<%= cSpecial.FItemList(i).Fdetailitemimage %>" alt="<%= cSpecial.FItemList(i).Fitemname %>">
					</div>
					<div class="pdtCont">
							<p class="pName"><%= cSpecial.FItemList(i).Fitemname %></p>
							<% if cSpecial.FItemList(i).IsSaleItem or cSpecial.FItemList(i).isCouponItem Then %>
								<% IF cSpecial.FItemList(i).IsSaleItem then %>
									<p class="price"><span class="finalP"><%=FormatNumber(cSpecial.FItemList(i).getRealPrice,0)%>원</span> <strong class="cRd1">[<%=cSpecial.FItemList(i).getSalePro%>]</strong></p>
								<% End If %>
								<% IF cSpecial.FItemList(i).IsCouponItem Then %>
									<p class="price"><span class="finalP"><%=FormatNumber(cSpecial.FItemList(i).GetCouponAssignPrice,0)%>원</span> <strong class="cGr1">[<%=cSpecial.FItemList(i).GetCouponDiscountStr%>]</strong></p>
								<% end if %>
							<% else %>
								<p class="price"><span class="finalP"><%=FormatNumber(cSpecial.FItemList(i).getRealPrice,0) & chkIIF(cSpecial.FItemList(i).IsMileShopitem,"Point","원")%></span></p>
							<% end if %>
						<p class="pShare">
							<span class="cmtView" onclick="popEvaluate('<%=cSpecial.FItemList(i).FItemid %>');"><%= FormatNumber(cSpecial.FItemList(i).FEvalcnt,0) %></span>
							<span class="wishView" onclick="" onclick="goWishPop('<%= cSpecial.FItemList(i).FItemID %>');"><%= FormatNumber(cSpecial.FItemList(i).FFavCount,0) %></span>
						</p>
					</div>
				</li>
			<% end if %>
		<% if dCnt = 5 then %>
				</ul>
			</div>
		<% end if %>
	<% dCnt = dCnt + 1 %>
	<% Next %>
<%
End If
SET cSpecial = Nothing
%>
			<p><img src="http://fiximage.10x10.co.kr/m/2015/diarystory2016/txt_10x10_special.png" alt="텐바이텐에서만 만나는 스페셜 에디션 - 시간을 거슬러 가고 싶을 만큼 소중한 순간들을 특별한 곳에 담아주세요. 그 특별함을 위해 텐바이텐에서만 만날 수 있는 2016 다이어리를 소개합니다." /></p>
</div>
<!-- //content area -->
<!-- #include virtual="/lib/db/dbclose.asp" -->