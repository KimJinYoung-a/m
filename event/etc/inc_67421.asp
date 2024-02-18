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
' Description : 행운을 맞춰봐호우!
' History : 2015.11.19 원승현
'###########################################################

dim eCode, cnt, sqlStr, couponkey, regdate, gubun, arrList, i, totalsum, linkeCode, imgLoop, imgLoopVal, irdsite20, arrRdSite, vUserID
	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "65954"
	Else
		eCode 		= "67421"
	End If

	irdsite20 = requestCheckVar(request("rdsite"),32)

	if irdsite20<>"" then
		arrRdSite = split(irdsite20,",")
		irdsite20 = arrRdSite(0)
	end if

	vUserID = GetEncLoginUserID

	If IsUserLoginOK Then
		'// 총 응모횟수, 개인별 응모횟수값 가져온다.
		sqlstr = "Select count(sub_idx) as totcnt" &_
				"  ,count(case when convert(varchar(10),regdate,120) = '" & Left(now(),10) & "' then sub_idx end) as daycnt" &_
				" From db_event.dbo.tbl_event_subscript" &_
				" WHERE evt_code='" & eCode & "' and userid='" & vUserID & "'"
				'response.write sqlstr
		rsget.Open sqlStr,dbget,1
			totalsum = rsget(0)
			cnt = rsget(1)
		rsget.Close
	End If
%>
<style type="text/css">
img {vertical-align:top;}
.mEvt67421 {}
.evtApply {position:relative; padding:0 8.4375% 20.15625% 7.96875%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67421/m/howoo_slot_bg.png) no-repeat 50% 0; background-size:100% auto;}
.evtApply a {overflow:hidden; display:block; position:absolute; left:50%; bottom:0; width:52%; height:38%; margin-left:-26%; text-indent:-999em;}
.evtGift {position:relative; padding:28.5% 0 10.3125%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67421/m/howoo_gift_bg.png) no-repeat 50% 0; background-size:100% auto;}
.giftView {position:relative;}
.giftView ul {overflow:hidden; position:absolute; left:0; top:25%; bottom:0; width:100%; height:75%;}
.giftView ul li {float:left; width:33.333%; height:100%; text-indent:-999em;}
.giftView ul li a {overflow:hidden; display:block; width:100%; height:100%;}
.evtResultLyr {position:absolute; left:0; bottom:0; width:100%;}
.evtResultLyr div {position:relative; padding-top:10%;}
.evtResultLyr div span {display:block; position:absolute; right:4%; top:0; width:7.8125%; height:11%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67421/m/result_close.png) no-repeat 0 0; background-size:100% auto; text-indent:-999em; cursor:pointer;}
.howooDown {position:relative; margin-top:-5.9375%;}
.howooDown a {overflow:hidden; display:block; position:absolute; left:50%; bottom:7%; width:59%; height:30%; margin-left:-29.5%; text-indent:-999em;}
.evtNoti {padding:6.5% 4.6%; background-color:#e2e3e4;}
.evtNoti h3 {position:relative; display:inline-block; font-weight:bold; color:#3f3f3f; font-size:15px; padding-bottom:4px; margin-left:7px;}
.evtNoti h3:after {content:''; display:inline-block; position:absolute; left:0; bottom:0; width:100%; height:2px; background:#3f3f3f;}
.evtNoti ul {padding-top:15px;}
.evtNoti li {position:relative; font-size:11px; line-height:1.2; color:#7a7c7b; padding:0 0 4px 7px;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:4px; width:3px; height:3px; border-radius:50%; background:#7a7c7b;}
@media all and (min-width:480px){
	.evtNoti h3 {font-size:22px; padding-bottom:6px; margin-left:10px;}
	.evtNoti h3:after {height:3px;}
	.evtNoti ul {padding-top:22px;}
	.evtNoti li {font-size:16px; padding:0 0 6px 10px;}
	.evtNoti li:after {top:6px; width:4px; height:4px;}
}
</style>


<script type="text/javascript">
	$(function(){
		$('.evtResultLyr span').click(function(){
			$(this).parent().hide();
		});

		var chkapp = navigator.userAgent.match('tenapp');
		if ( chkapp ){
			$("#app").show();
			$("#mo").hide();
		}else{
			$("#app").hide();
			$("#mo").show();
		}
	});

	function checkform(){
		<% If vUserID = "" Then %>
			if ("<%=IsUserLoginOK%>"=="False") {
				<% if isApp=1 then %>
					parent.calllogin();
					return false;
				<% else %>
					parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
					return false;
				<% end if %>
				return false;
			}
		<% End If %>
		<% If vUserID <> "" Then %>
			// 오픈시 바꿔야됨
			<% If Now() >= #11/23/2015 10:00:00# And now() < #11/28/2015 00:00:00# Then %>
				$.ajax({
					type:"GET",
					url:"/event/etc/doEventSubscript67421.asp?mode=add",
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
										setTimeout("chgImgResult('"+res[1]+"','"+res[2]+"')", 500);
									}
									else
									{
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
						//var str;
						//for(var i in jqXHR)
						//{
						//	 if(jqXHR.hasOwnProperty(i))
						//	{
						//		str += jqXHR[i];
						//	}
						//}
						//alert(str);
						document.location.reload();
						return false;
					}
				});
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;				
			<% end if %>
		<% End If %>
	}


	function chgImgResult(img1, img2)
	{
		window.$('html,body').animate({scrollTop:$(".evtApply").offset().top}, 0);
		$('.evtResultLyr').show();
		$('#slotImg').empty().html(img1);
		$('#resultImgRight').empty().html(img2);
	}

	function houhouAppDn()
	{
		$.ajax({
			type:"GET",
			url:"/event/etc/doEventSubscript67421.asp?mode=houhouApp",
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
								<% If isApp="1" Then %>
									fnAPPpopupExternalBrowser("http://goo.gl/k22afs");
									return false;
								<% Else %>
									window.open("http://goo.gl/k22afs");
									return false;
								<% End If %>
							}
							else
							{
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
				//var str;
				//for(var i in jqXHR)
				//{
				//	 if(jqXHR.hasOwnProperty(i))
				//	{
				//		str += jqXHR[i];
				//	}
				//}
				//alert(str);
				document.location.reload();
				return false;
			}
		});
	}


</script>

<div class="evtCont">
	<div class="mEvt67421">
		<% If Trim(irdsite20)="houhou" Then %>
			<%' for dev msg : 호우호우 유입고객일경우 아래 이미지 노출되게 해주세요 %>
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/67421/m/howoo_tit_new.png" alt="선물 주세호우!" /></h2>
			<%' //for dev msg : 호우호우 유입고객일경우 아래 이미지 노출되게 해주세요 %>
		<% Else %>
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/67421/m/howoo_tit.png" alt="선물 주세호우!" /></h2>
		<% End If %>
		<%' 이벤트 응모 %>
		<div class="evtApply">
			<p>
				<div id="slotImg">
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/67421/m/howoo_slot.gif" alt="롤링" />
				</div>
			</p>
			<a href="" onclick="checkform();return false;">참여하기</a>
		</div>
		<%' // 이벤트 응모 %>
		<div class="evtGift">
			<div class="giftView">
				<ul>
					<li>
						<% If isApp="1" Then %>
							<a href="" onclick="fnAPPpopupProduct('1164622');return false;">
						<% Else %>
							<a href="/category/category_itemPrd.asp?itemid=1164622" target="_blank">
						<% End If %>
							1등 - 리플렉트 에코히터
						</a>
					</li>
					<li>
						<% If isApp="1" Then %>
							<a href="" onclick="fnAPPpopupProduct('1308640');return false;">
						<% Else %>
							<a href="/category/category_itemPrd.asp?itemid=1308640" target="_blank">
						<% End If %>
							2등 - 기상예청 유리병
						</a>
					</li>
					<li>
						<% If isApp="1" Then %>
							<a href="" onclick="fnAPPpopupExternalBrowser('https://www.instagram.com/p/2-L-JEB1_X/?taken-by=houhou_weather');return false;">
						<% Else %>
							<a href="https://www.instagram.com/p/2-L-JEB1_X/?taken-by=houhou_weather" target="_blank">
						<% End If %>
							3등 - 호우호우 텀블러
						</a>
					</li>
				</ul>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/67421/m/howoo_gift.png" alt="EVENT GIFT" />
			</div>
			<div class="evtResultLyr" style="display:none;"><!-- 이벤트 결과 노출 레이어-->
				<div>
					<span>layer close</span>
					<p id="resultImgRight"></p>
				</div>
			</div>
		</div>
		<p class="howooDown">
			<a href="" onclick="houhouAppDn();return false;">호우호우 다운로드</a>
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/67421/m/howoo_download.png" alt="텐바이텐의 친구 호우호우" />
		</p>
		<% If isApp="1" Then %>

		<% Else %>
			<p>
				<a href="http://m.10x10.co.kr/apps/link/?8020151119" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67421/m/howoo_tenten_download.png" alt="텐바이텐 APP에서 즐거운 쇼핑 즐기기!! - 텐바이텐 다운로드" /></a>
			</p>
		<% End If %>
		<div class="evtNoti">
			<h3>이벤트 유의사항</h3>
			<ul>
				<li>텐바이텐 ID 로그인 후 참여할 수 있습니다.</li>
				<li>매일 1회만 참여할 수 있습니다.</li>
				<li>당첨자 안내는 12월 2일 수요일에 공지됩니다.</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>