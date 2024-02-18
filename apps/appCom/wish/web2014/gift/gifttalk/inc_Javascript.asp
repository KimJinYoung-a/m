//톡 O,X 혹은 A,B 체크 및 버튼 색상 활성화
function jsTalkvote(idx,tidx,v,i,t,s){
<% If IsUserLoginOK Then %>
	$.ajax({
			url: "/apps/appCom/wish/web2014/gift/gifttalk/vote.asp?idx="+idx+"&talkidx="+tidx+"&theme="+t+"&vote="+v+"&selectoxab="+s,
			cache: false,
			success: function(message)
			{
				if(message == "0"){
					alert("이미 투표하셨습니다.");
				}else if(message == "ok"){
				    // 선물의 참견 투표 참여 앰플리튜드 연동
                    fnAmplitudeEventMultiPropertiesAction('view_gifttalk', 'click_gifttalk_vote', 'Y');
				}else if(message == "x"){
					alert("삭제된 쇼핑톡 입니다.");
				}else if(message == "xxx"){
					alert("일시적인 통신장애입니다.\n새로고침 후 다시 투표해주세요.");
				}else{
				    // 선물의 참견 투표 참여 앰플리튜드 연동
                    fnAmplitudeEventMultiPropertiesAction('view_gifttalk', 'click_gifttalk_vote', 'Y');
					<% If (now() >= "2020-10-12" And now() < "2020-10-30") Then %>
					var arrdata="";
					arrdata = message.split("|");
					arrdatacount = arrdata[0].split(",");
					if(t == "2"){
						$("#countgood"+idx).text(message.split(",")[0]);
						$("#countbad"+idx).text(message.split(",")[1]);
						$("#btgood"+idx).addClass("on")
					}else if(t == "1"){
						if(v == "good"){
							$("#countgood"+idx).text(message.split(",")[0]);
							$("#btgood"+idx).addClass("on")
						}else{
							$("#countbad"+idx).text(message.split(",")[1]);
							$("#btbad"+idx).addClass("on")
						}
					}
					if(arrdata[1]=="t"){
						$("#sucessPop").show();
					}
					<% else %>
					if(t == "2"){
						$("#countgood"+idx).text(message.split(",")[0]);
						$("#countbad"+idx).text(message.split(",")[1]);
						$("#btgood"+idx).addClass("on")
					}else if(t == "1"){
						if(v == "good"){
							$("#countgood"+idx).text(message.split(",")[0]);
							$("#btgood"+idx).addClass("on")
						}else{
							$("#countbad"+idx).text(message.split(",")[1]);
							$("#btbad"+idx).addClass("on")
						}
					}
					<% end if %>
				}
			}
	});
<% Else %>
	if(confirm("로그인을 하셔야 참여가능합니다.\n로그인 하시겠습니까?") == true) {
		fnAPPpopupLogin();
		return false;
	} else {
		return false;
	}
<% End If %>
}

//톡 삭제
function jsMyTalkEdit(tidx){
	if(confirm("선택한 글을 삭제하시겠습니까?") == true) {
		$('input[id="gubun"]').val("d");
		$('input[id="talkidx"]').val(tidx);
		frm1.target = "iframeproc";
		frm1.submit();
		return true;
	} else {
		return false;
	}
}

//기프트톡 선택한 상품 집어넣기(팝업 닫으면서 js 호출)
function TalkItemSelect(v){
	var iurl = "<%=wwwUrl%>/apps/appCom/wish/web2014/gift/gifttalk/talk_write.asp?itemid="+v;
	setTimeout('fnAPPpopupBrowserURL("GIFT TALK 쓰기","'+iurl+'")',500);
}

//기프트톡 빠른 상품찾기 팝업(팝업 닫으면서 js 호출)
function goitemReturn(){
	setTimeout('fnAPPpopupBrowserURL("상품 찾기","<%=wwwUrl%>/apps/appCom/wish/web2014/gift/gifttalk/write_right_ajax.asp")',500);
}

//기프트톡 쓰기(NEW)
function writeShoppingTalkNew() {
	<% If IsUserLoginOK Then %>
	$.ajax({
		url: "/apps/appCom/wish/web2014/gift/gifttalk/doShoppingTalkProc.asp?gubun=u",
		cache: false,
		success: function(message) {
			fnAPPpopupBrowserURL("GIFT TALK 쓰기","<%=wwwUrl%>/apps/appcom/wish/web2014/gift/gifttalk/talk_write.asp?talkidx=");
			//top.location.href='/apps/appCom/wish/web2014/gift/gifttalk/talk_write.asp?talkidx=';
			//goBack('/apps/appCom/wish/web2014/gift/gifttalk/talk_write.asp?talkidx=');
		}
		,error: function(err) {
			alert(err.responseText);
			fnAPPclosePopup();
		}
	});
	<% Else %>
		if(confirm("로그인을 하셔야 참여가능합니다.\n로그인 하시겠습니까?") == true) {
			fnAPPpopupLogin();
			return false;
		} else {
			return false;
		}
	<% End If %>
}

function writeShoppingTalk(tidx,titemid){
	fnAPPpopupBrowserURL("나의톡 수정","<%=wwwUrl%>/apps/appcom/wish/web2014/gift/gifttalk/talk_write.asp?talkidx="+tidx+"&gubun=u&itemid="+titemid);
}

//톡쓰기 탭변환(상품검색<->나의위시)
function jsTalkRightListTabChange(a){
	document.location.replace('/apps/appCom/wish/web2014/gift/gifttalk/write_right_ajax.asp?tab='+a);
	/*
	$.ajax({
			url: "/apps/appCom/wish/web2014/gift/gifttalk/write_right_ajax.asp?tab="+a+"",
			cache: false,
			success: function(message)
			{
				$("#contentArea2").empty().append(message);
			}
	});
	*/
}

//톡쓰기 상품검색 검색어 체크
function jsTalkRightSearchInput(){
	if($("#searchtxt").val() == "상품코드 또는 검색어 입력"){
		$("#searchtxt").val("");
	}
}
