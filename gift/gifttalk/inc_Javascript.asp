//톡 O,X 혹은 A,B 체크 및 버튼 색상 활성화
function jsTalkvote(idx,tidx,v,i,t,s){
<% If IsUserLoginOK Then %>
	$.ajax({
			url: "/gift/gifttalk/vote.asp?idx="+idx+"&talkidx="+tidx+"&theme="+t+"&vote="+v+"&selectoxab="+s,
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

					if(arrdata[1]=="t"){
						$("#sucessPop").show();
					}
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
		location.href = "<%=M_SSLUrl%>/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>";
		return true;
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

//톡 쓰기(NEW)
function writeShoppingTalkNew() {
	<% If IsUserLoginOK Then %>
		$.ajax({
			url: "/gift/gifttalk/doShoppingTalkProc.asp?gubun=u",
			cache: false,
			success: function(message) {
				top.location.href='/gift/gifttalk/talk_write.asp?talkidx=';
				//goBack('/gift/gifttalk/talk_write.asp?talkidx=');
			}
			,error: function(err) {
				alert(err.responseText);
				goBack('/gift/gifttalk/');
			}
		});
	<% Else %>
		if(confirm("로그인을 하셔야 참여가능합니다.\n로그인 하시겠습니까?") == true) {
			location.href = "<%=M_SSLUrl%>/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>";
			return true;
		} else {
			return false;
		}
	<% End If %>
}

//톡 수정
function writeShoppingTalk(tidx,titemid){
	location.href="/gift/gifttalk/talk_write.asp?talkidx="+tidx+"&gubun=u&itemid="+titemid;
}

//톡쓰기 탭변환(상품검색,나의위시)
function jsTalkRightListTabChange(a){
	$.ajax({
			url: "/gift/gifttalk/write_right_ajax.asp?tab="+a+"",
			cache: false,
			success: function(message)
			{
				$("#contentArea2").empty().append(message);
			}
	});
}

//톡쓰기 상품검색 검색어 체크
function jsTalkRightSearchInput(){
	if($("#searchtxt").val() == "상품코드 또는 검색어 입력"){
		$("#searchtxt").val("");
	}
}