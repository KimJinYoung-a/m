<%
	'최초 rdsite가 nvshop이라면 
	If Left(request.Cookies("rdsite"), 13) = "mobile_nvshop" Then
		'nvshop이라는 쿠키가 비어있거나 쿠키 mode가 o가 아니면.. 
		'####모드 정리 : //디폴트 mode = o ////로그인&회원가입클릭 : mode = x////회원가입이나 기존회원이 로그인해서 쿠폰 받음 : mode= x #######
		If (isempty(request.Cookies("nvshop")("mode"))) OR ((request.Cookies("nvshop")("mode") <> "x") AND (request.Cookies("nvshop")("mode") <> "y")) Then
			'rdsite가 nvshop으로 넘어왔고 로그인,회원가입,1일간 안보기 세개 다 안 눌렀다는 전제..
			'nvshop이라는 쿠키생성
			'쿠키보관 기간은 1주일로..(쿠폰사용기간이 1주일이므로)
			response.Cookies("nvshop").domain = "10x10.co.kr"
			response.Cookies("nvshop")("mode") = "o"
			response.Cookies("nvshop").Expires = Date + 7
		End If

		'상품상세페이지나 메인페이지면서 로그인,회원가입,1일간 안보기 세개 다 안 눌렀고 쿠폰도 안 받았다면..
		'쿠키 변조를 한다해도 백단에 쿠폰 받은 여부확인해서 받았으면 안 보내게 처리
		'mode를 y로 바꾸는 곳 dologin.asp, nvshopCookie_process.asp, dojoin_step2.asp
		If (request.Cookies("nvshop")("mode") = "o") Then
			'쿠폰 사용기간 이라면..
			If isNaverOpen Then
%>
<script type="text/javascript">
	$(function(){
		var maskHeight = $(document).height();
		var maskWidth =	$(window).width();

		$('#mask').css({'width':maskWidth,'height':maskHeight});
		$('#boxes').show();
		$('#mask').show();
		$('.window').show();

		$('.lyrClose').click(function(e) {
			e.preventDefault();
			$('#boxes').hide();
			$('.window').hide();
		});

		$('#mask').click(function () {
			$('#boxes').hide();
			$('.window').hide();
		});

		$(window).resize(function () {
			var box = $('#boxes .window');
			var maskHeight = $(document).height();
			var maskWidth = $(window).width();
			$('#mask').css({'width':maskWidth,'height':maskHeight});

			var winH = $(window).height();
			var winW = $(window).width();
			box.css('top', winH/2 - box.height()/2);
			box.css('left', winW/2 - box.width()/2);
		});
	});
</script>
<%
			End If
		End If
	ElseIf Left(request.Cookies("rdsite"), 15) = "mobile_daumshop" Then
		'daumshop이라는 쿠키가 비어있거나 쿠키 mode가 o가 아니면.. 
		'####모드 정리 : //디폴트 mode = o ////로그인&회원가입클릭 : mode = x////회원가입이나 기존회원이 로그인해서 쿠폰 받음 : mode= x #######
		If (isempty(request.Cookies("daumshop")("mode"))) OR ((request.Cookies("daumshop")("mode") <> "x") AND (request.Cookies("daumshop")("mode") <> "y")) Then
			'rdsite가 daumshop으로 넘어왔고 로그인,회원가입,1일간 안보기 세개 다 안 눌렀다는 전제..
			'daumshop이라는 쿠키생성
			'쿠키보관 기간은 1주일로..(쿠폰사용기간이 1주일이므로)
			response.Cookies("daumshop").domain = "10x10.co.kr"
			response.Cookies("daumshop")("mode") = "o"
			response.Cookies("daumshop").Expires = Date + 7
		End If

		'상품상세페이지나 메인페이지면서 로그인,회원가입,1일간 안보기 세개 다 안 눌렀고 쿠폰도 안 받았다면..
		'쿠키 변조를 한다해도 백단에 쿠폰 받은 여부확인해서 받았으면 안 보내게 처리
		'mode를 y로 바꾸는 곳 dologin.asp, daumshopCookie_process.asp, dojoin_step2.asp
		If (request.Cookies("daumshop")("mode") = "o") Then
			'쿠폰 사용기간 이라면..
			If isDaumOpen Then
%>
<script type="text/javascript">
	$(function(){
		var maskHeight = $(document).height();
		var maskWidth =	$(window).width();

		$('#mask').css({'width':maskWidth,'height':maskHeight});
		$('#boxes').show();
		$('#mask').show();
		$('.window').show();

		$('.lyrClose').click(function(e) {
			e.preventDefault();
			$('#boxes').hide();
			$('.window').hide();
		});

		$('#mask').click(function () {
			$('#boxes').hide();
			$('.window').hide();
		});

		$(window).resize(function () {
			var box = $('#boxes .window');
			var maskHeight = $(document).height();
			var maskWidth = $(window).width();
			$('#mask').css({'width':maskWidth,'height':maskHeight});

			var winH = $(window).height();
			var winW = $(window).width();
			box.css('top', winH/2 - box.height()/2);
			box.css('left', winW/2 - box.width()/2);
		});
	});
</script>
<%
			End If
		End If
	End If
%>