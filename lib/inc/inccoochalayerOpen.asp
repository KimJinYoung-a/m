<%
'####################################################
' Description : 제휴몰 쿠차(coocha) 타고 들어 올경우 레이어 처리
' History : 2015.09.01 한용민 생성
'####################################################
%>
<%
Dim iscoochaOpen
	iscoochaOpen = False

If (Now() > #09/01/2015 00:00:00# AND Now() < #01/01/2051 00:00:00#) Then
	if request.Cookies("rdsite")<>"" then
		if instr( lcase(request.Cookies("rdsite")) ,"coocha") <> 0 or instr( lcase(request.Cookies("rdsite")) ,"coomoa") <> 0 then
			if request.Cookies("coocha")("mode") = "" then
				'//쿠기 초기셋팅 7일간 보관
				response.Cookies("coocha").domain = "10x10.co.kr"
				response.Cookies("coocha")("mode") = "expires_n"
				response.Cookies("coocha").Expires = Date + 7
			end if

			if request.Cookies("coocha")("mode") = "expires_n" then
				IF application("Svr_Info") = "Dev" THEN
					if cstr(lcase(nowViewPage))=cstr("/_index.asp") or cstr(lcase(nowViewPage))=cstr("/category/category_itemprd.asp") then
						iscoochaOpen = True
					end if
				Else
					if cstr(lcase(nowViewPage))=cstr("/index.asp") or cstr(lcase(nowViewPage))=cstr("/category/category_itemprd.asp") then
						iscoochaOpen = True
					end if
				End If
			End If
		end if
	end if
End If

'response.write iscoochaOpen
%>
<% if iscoochaOpen then %>
	<style type="text/css">
	.window {display:none;}
	#mask {display:none; position:absolute; left:0; top:0; z-index:9000; background-color:#000; opacity:0.7;}
	.lyShopBnr {position:absolute; left:50%; top:300px; z-index:100000; width:68%; margin-left:-34%;}
	.lyShopBnr img {width:100%; vertical-align:top;}
	.lyShopBnr p {padding-top:15%;}
	.lyShopBnr .lyrClose {display:block; position:absolute; right:0; top:0%; width:16%; border:0; cursor:pointer; background:transparent;}
	.lyShopBnr .goApp {display:block; width:99%; margin:9% auto 0; background:transparent;}
	</style>
	<script type="text/javascript">
		$(function(){
			var maskHeight = $(document).height();
			var maskWidth =	$(window).width();
	
			$('#mask').css({'width':maskWidth,'height':maskHeight});
			$('#boxes').show();
			$('#mask').show();
			$('.window').show();
	
			$('.lyrClose').click(function(e) {
				document.coochafrm.mode.value="expires_y";
				document.coochafrm.gourl.value="";
				document.coochafrm.action = '/lib/inc/inccoochalayerOpen_process.asp';
				document.coochafrm.target = 'view';
				document.coochafrm.submit();

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
<% end if %>