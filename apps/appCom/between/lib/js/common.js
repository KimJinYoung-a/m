// 외부브라우저 호출
function openbrowser(url){
    window.location.href = "external+"+url;
    return false;
}

//브라우저 상단 숨김
if (navigator.userAgent.indexOf('MSIE') == -1) {
	window.addEventListener('load', function(){
		setTimeout(scrollTo, 0, 0, 1);
	}, false);
}

$(function(){
	//GNB Navi 영역 컨트롤
	$('.navi > li').click(function() {
		$('.navi > li').removeClass('current');
		$(this).addClass('current');
	});

	//TOP 버튼 컨트롤
	$('.goTop').click(function(){
		$('html, body').animate({scrollTop:0}, 'fast',function(){
			$('.goTop').fadeOut("fast");
		});
		
	;});

	$('.goTop').hide();
	$(window).scroll(function(){
		var scrlHeight = $(window).scrollTop();
		if (scrlHeight > 200) {
			$('.goTop').hide().fadeIn("fast");
		} else {
			$('.goTop').hide();
		};
	});

	var vSpos, vChk;
	$(window).on({
		'touchstart': function(e) {
			vSpos = $(window).scrollTop()
			vChk = false;
		}, 'touchmove': function(e) {
			if(vSpos!=$(window).scrollTop()) {
				$('.goTop').hide();
				vChk = true;
			}
		}, 'touchend': function(e) { 
			var scrlHeight = $(window).scrollTop();
			if (scrlHeight > 200) {
				if(vChk) $('.goTop').fadeIn("fast");
			} else {
				$('.goTop').hide();
			}
		}
	});

});

var myScroll;
function MSLoaded() {
	myScroll = new iScroll('scroller');
}

function newMSLoaded() {
	myScroll = new iScroll('scroller', {
		onBeforeScrollStart: function (e) {
			var target = e.target;
			while (target.nodeType != 1) target = target.parentNode;

			if (target.tagName != 'SELECT' && target.tagName != 'INPUT' && target.tagName != 'TEXTAREA')
				e.preventDefault();
		}
	});
}

var fEvt = function(e){ e.preventDefault(); };

// 모달창
function jsOpenPopup(sUrl) {
	if(sUrl==""||sUrl=="undefind") return;

	$.ajax({
		url: sUrl,
		cache: false,
		success: function(message) {
			$("#modalCont").empty().html(message);
			$("#modalCont").show();
			var popH = $('.midLyr .lyrPop').height();
			var iWht = $(window).height();
			//$('.midLyr .lyrPop').css('margin-top', -popH/2+'px');
			$('.midLyr .lyrPop').css('top', iWht/2-popH/2+'px');

			document.addEventListener('touchmove', fEvt, false);
			
			// 우편번호 팝업이라면
			if($(message).find(".lyrPopCont").hasClass("zipCode")) {
				MSLoaded();
				//setTimeout("MSLoaded();",200);
			}
			// 신 우편번호 팝업이라면
			if($(message).find(".lyrPopCont").hasClass("lyrPopZipcodeV16")) {
				newMSLoaded();
				$('.midLyr .lyrPop').css('top', (iWht/2-popH/2)/2+'px');
				//setTimeout("MSLoaded();",200);
			}

			//close
			$('.lyrClose').one('click', function(e){
				e.preventDefault();
				$("#modalCont").hide(0,function(){
					//$('.lyrPopWrap').hide();
					//$('.lyrPop').hide();
					$(this).empty();
				});
				document.removeEventListener('touchmove', fEvt, false);
			});
		}
		,error: function(err) {
			alert(err.responseText);
		}
	});
}

// 모달창 닫기
function jsClosePopup() {
	$("#modalCont").hide(0,function(){
		$(this).empty();
	});
	document.removeEventListener('touchmove', fEvt, false);
}

function IsDigit(v){
	for (var j=0; j < v.length; j++){
		if ((v.charAt(j) * 0 == 0) == false){
			return false;
		}
	}
	return true;
}

// 텐바이텐 로그인
function fnTenLogin() {
	jsOpenPopup('/apps/appCom/between/login/popTenLogin.asp');
}

// 텐바이텐 로그아웃
function fnTenLogout() {
	$(window).unbind('beforeunload');		// 언로드 이벤트 제거
	self.location.href="/apps/appCom/between/login/dologout.asp";
}


// 글자수 계산
function GetByteLength(val){
 	var real_byte = val.length;
 	for (var ii=0; ii<val.length; ii++) {
  		var temp = val.substr(ii,1).charCodeAt(0);
  		if (temp > 127) { real_byte++; }
 	}

   return real_byte;
}