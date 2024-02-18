<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'###########################################################
' Description : 16주년 이벤트 골라보쑈
' History : 2017-09-28 이종화
'###########################################################

Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle	= Server.URLEncode("[텐바이텐] 16주년 골라보쑈")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/16th/")
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/eventIMG/2017/16th/m/kakao_tenshow_main.jpg")

'//핀터레스트용
Dim ptTitle , ptLink , ptImg
ptTitle = "[텐바이텐] 16주년 골라보쑈"
ptLink	= "http://m.10x10.co.kr/event/16th/"
ptImg	= "http://webimage.10x10.co.kr/eventIMG/2017/16th/m/kakao_tenshow_main.jpg"

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "텐바이텐이 벌써 16주년이 되었어요~\n\n16주년 기념 최대 30% 쿠폰쑈와\n다양한 쑈가 당신을 기다립니다.\n\n10월에는 텐바이텐으로 놀러오십쑈!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2017/16th/m/kakao_tenshow_main.jpg"
Dim kakaoimg_width : kakaoimg_width = "400"
Dim kakaoimg_height : kakaoimg_height = "400"
Dim kakaolink_url 
If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/16th/index.asp"
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/event/16th/"
End If

Dim vUserID
vUserID		= GetEncLoginUserID
%>
<script>
$(function(){
	$(".layer").hide();
	$(".layer .btn-close").click(function(){
		$(".layer").hide();
	});
	$(".btn-gift").click(function(){
		$("#lyrGiftList").show();
	});
});

function checkpick(){
	<% If Not(IsUserLoginOK) Then %>
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/16th/")%>');
			return false;
		<% end if %>
	<% else %>
		<%' If Now() > #09/27/2017 23:59:59# And Now() < #10/25/2017 23:59:59# Then '테스트용%>
		<% If Now() > #10/09/2017 23:59:59# And Now() < #10/25/2017 23:59:59# Then %>
			$.ajax({
				type:"GET",
				url:"/event/16th/dailypick_proc.asp",
				data: "mode=add",
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data, textStatus, jqXHR){
					if (jqXHR.readyState == 4) {
						console.log(jqXHR.readyState);
						if (jqXHR.status == 200) {
							if(Data!="") {
								var str;
								for(var i in Data){
									 if(Data.hasOwnProperty(i)){
										str += Data[i];
									}
								}
								str = str.replace("undefined","");
								res = str.split("|");
								//console.log(res[1]);
								if (res[0]=="OK"){
									$("#layerCont").empty().html(res[1]);
									$('#lyrGollabo').show();
									return false;
								} else {
									errorMsg = res[1].replace(">?n", "\n");
									alert(errorMsg);
									document.location.reload();
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
					document.location.reload();
					return false;
				}
			});
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;				
		<% End If %>
	<% End If %>
}

function get_coupon(){
<% If IsUserLoginOK Then %>
	<%' If not(Now() > #09/27/2017 23:59:59# And Now() < #10/25/2017 23:59:59#) Then '테스트용 %>
	<% If not(Now() > #10/09/2017 23:59:59# And Now() < #10/25/2017 23:59:59#) Then %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% else %>
		var rstStr = $.ajax({
			type: "POST",
			url: "/event/16th/dailypick_proc.asp",
			data: "mode=coupon",
			dataType: "text",
			async: false
		}).responseText;
		if (rstStr == "SUCCESS"){
			alert('쿠폰이 발급되었습니다.');
			//location.reload();
			return false;
		}else if (rstStr == "MAXCOUPON"){
			alert('오늘의 쿠폰을 모두 받으셨습니다.');
			return false;
		}else if (rstStr == "NOT1"){
			alert('응모후 다운로드가 가능합니다.');
			return false;
		}else if (rstStr == "DATENOT"){
			alert('이벤트 응모 기간이 아닙니다.');
			return false;
		}else if (rstStr == "USERNOT"){
			alert('로그인을 해주세요.');
			return false;
		}else{
			alert('관리자에게 문의');
			return false;
		}
	<% end if %>
<% Else %>
	<% If isApp="1" or isApp="2" Then %>
		calllogin();
		return false;
	<% else %>
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/16th/")%>');
		return false;
	<% end if %>
<% end if %>
}

function sharesns(snsnum) {
	<% If vUserID = "" Then %>
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/16th/")%>');
			return false;
		<% end if %>
	<% End If %>
	<% If vUserID <> "" Then %>
		var reStr;
		var str = $.ajax({
			type: "GET",
			url:"/event/16th/dailypick_proc.asp",
			data: "mode=snschk&snsnum="+snsnum,
			dataType: "text",
			async: false
		}).responseText;
			reStr = str.split("|");
			console.log(str);
			if(reStr[1] == "tw") {
				popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
			}else if(reStr[1]=="fb"){
				popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
			}else if(reStr[1]=="pt"){
				//pinit('<%=snpLink%>','<%=snpImg%>')
				sharePt('<%=ptLink%>','<%=ptImg%>','<%=ptTitle%>');
			}else if(reStr[1]=="ka"){
				parent_kakaolink('<%=kakaotitle%>', '<%=kakaoimage%>' , '<%=kakaoimg_width%>' , '<%=kakaoimg_height%>' , '<%=kakaolink_url%>' );
				return false;
			}else if(reStr[1] == "none"){
				alert('참여 이력이 없습니다.\n응모후 이용 하세요');
				return false;
			}else if(reStr[1] == "end"){
				alert('공유는 하루에 1회만 가능합니다.');
				return false;
			}else{
				alert('오류가 발생했습니다.');
				return false;
			}
	<% End If %>
}

function mypicklist(){
	<% If IsUserLoginOK Then %>
		<% If Now() > #10/09/2017 23:59:59# And Now() < #10/25/2017 23:59:59# Then %>
			$.ajax({
				type:"GET",
				url:"/event/16th/dailypick_proc.asp",
				data: "mode=mypick",
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data, textStatus, jqXHR){
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							if(Data!="") {
								var str;
								for(var i in Data){
									 if(Data.hasOwnProperty(i)){
										str += Data[i];
									}
								}
								str = str.replace("undefined","");
								res = str.split("|");
								//console.log(res[1]);
								if (res[0]=="OK"){
									$("#mypicklist").empty().html(res[1]);
									viewPoupLayer('modal',$('#lyrResult').html());
									return false;
								} else {
									errorMsg = res[1].replace(">?n", "\n");
									alert(errorMsg);
									document.location.reload();
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
					document.location.reload();
					return false;
				}
			});
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;				
		<% End If %>
	<% else %>
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/16th/")%>');
			return false;
		<% end if %>
	<% End If %>
}
</script>
<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/tit_select.png" alt="매일 응모 이벤트 골라보쑈" /></h3>
<a href="javascript:void(0);" class="btn-layer btn-gift">선물 리스트 보기</a>
<a href="" class="btn-layer btn-apply" style="bottom:8.5%;" onclick="checkpick();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/btn_select.png" alt="응모하기" /></a>
<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/img_pierrot_v2.gif" alt="" /></div>
<%'!-- 선물 리스트 레이어 --%>
<div id="lyrGiftList" class="layer" style="display:none;">
	<div class="layer-cont">
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/layer_gift_list.png" alt="" /></div>
		<ul>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1750502&pEtr=80410" class="mWeb" target="_blank">다이슨 V8 앱솔루드 플러스</a>
				<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1750502&pEtr=80410" onclick="fnAPPpopupProduct('1750502&pEtr=80410');return false;" class="mApp">다이슨 V8 앱솔루드 플러스</a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1474359&pEtr=80410" class="mWeb" target="_blank">오각뿔캔들</a>
				<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1474359&pEtr=80410" onclick="fnAPPpopupProduct('1474359&pEtr=80410');return false;" class="mApp">오각뿔캔들</a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1758010&pEtr=80410" class="mWeb" target="_blank">위글위글 블루투스 스피커</a>
				<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1758010&pEtr=80410" onclick="fnAPPpopupProduct('1758010&pEtr=80410');return false;" class="mApp">위글위글 블루투스 스피커</a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1768120&pEtr=80410" class="mWeb" target="_blank">오버액션토끼 가방고리</a>
				<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1768120&pEtr=80410" onclick="fnAPPpopupProduct('1768120&pEtr=80410');return false;" class="mApp">오버액션토끼 가방고리</a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1759439&pEtr=80410" class="mWeb" target="_blank">케이블바이트</a>
				<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1759439&pEtr=80410" onclick="fnAPPpopupProduct('1759439&pEtr=80410');return false;" class="mApp">케이블바이트</a>
			</li>
		</ul>
		<button type="button" class="btn-close"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/btn_layer_close.png" alt="닫기" /></button>
	</div>
</div>
<%'!--// 선물 리스트 레이어 --%>
<%'!-- 골라보쑈 응모 레이어 --%>
<div id="lyrGollabo" class="layer">
	<div class="layer-cont">
		<div id="layerCont"></div>
		<button type="button" class="btn-close"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/btn_layer_close.png" alt="닫기" /></button>
	</div>
</div>
<%'!--// 골라보쑈 응모 레이어 --%>

<%'!-- 응모결과 레이어 --%>
<div id="lyrResult" class="layer" style="display:none;">
	<div class="layer-cont">
		<div id="mypicklist" class="ct"></div>
		<button type="button" class="btn-close"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/btn_layer_close.png" alt="닫기" /></button>
	</div>
</div>
<%'!--// 응모결과 레이어 --%>

<p class="btn-result"><a href="" onclick="mypicklist();return false;">내 응모 현황 확인하기<i>&gt;</i></a></p>
<!-- #include virtual="/lib/db/dbclose.asp" -->