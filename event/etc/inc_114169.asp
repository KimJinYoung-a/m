<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<style>
.evt114169 {background:#fff;}
/* magazine css */
.evt114169 .magazine-viewport .container{
	position:absolute;
	top:50%;
	left:50%;
	width:922px;
	height:600px;
	margin:auto;
}

.evt114169 .magazine-viewport .magazine{
	width:922px;
	height:600px;
	left:-461px;
	top:-300px;
}

.evt114169 .magazine-viewport .page{
	width:461px;
	height:600px;
	background-color:white;
	background-repeat:no-repeat;
	background-size:100% 100%;
}

.evt114169 .magazine-viewport .zoomer .region{
	display:none;
}

.evt114169 .magazine .region{
	position:absolute;
	overflow:hidden;
	background:#0066FF;
	opacity:0.2;
	-webkit-border-radius:10px;
	-moz-border-radius:10px;
	-ms-border-radius:10px;
	-o-border-radius:10px;
	border-radius:10px;
	cursor:pointer;
	-ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=20)";
	filter: alpha(opacity=20);
}

.evt114169 .magazine .region:hover{
	opacity:0.5;
	-ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=50)";
	filter: alpha(opacity=50);
}

.evt114169 .magazine .region.zoom{
	opacity:0.01;
	-ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=1)";
	filter: alpha(opacity=1);
}

.evt114169 .magazine .region.zoom:hover{
	opacity:0.2;
	-ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=20)";
	filter: alpha(opacity=20);
}

.evt114169 .magazine .page{
	-webkit-box-shadow:0 0 20px rgba(0,0,0,0.2);
	-moz-box-shadow:0 0 20px rgba(0,0,0,0.2);
	-ms-box-shadow:0 0 20px rgba(0,0,0,0.2);
	-o-box-shadow:0 0 20px rgba(0,0,0,0.2);
	box-shadow:0 0 20px rgba(0,0,0,0.2);
}

.evt114169 .magazine-viewport .page img{
	-webkit-touch-callout: none;
	-webkit-user-select: none;
	-khtml-user-select: none;
	-moz-user-select: none;
	-ms-user-select: none;
	user-select: none;
	margin:0;
}

.evt114169 .magazine .even .gradient{
	position:absolute;
	top:0;
	left:0;
	width:100%;
	height:100%;

	background:-webkit-gradient(linear, left top, right top, color-stop(0.95, rgba(0,0,0,0)), color-stop(1, rgba(0,0,0,0.2)));
	background-image:-webkit-linear-gradient(left, rgba(0,0,0,0) 95%, rgba(0,0,0,0.2) 100%);
	background-image:-moz-linear-gradient(left, rgba(0,0,0,0) 95%, rgba(0,0,0,0.2) 100%);
	background-image:-ms-linear-gradient(left, rgba(0,0,0,0) 95%, rgba(0,0,0,0.2) 100%);
	background-image:-o-linear-gradient(left, rgba(0,0,0,0) 95%, rgba(0,0,0,0.2) 100%);
	background-image:linear-gradient(left, rgba(0,0,0,0) 95%, rgba(0,0,0,0.2) 100%);
}

.evt114169 .magazine .odd .gradient{
	position:absolute;
	top:0;
	left:0;
	width:100%;
	height:100%;

	background:-webkit-gradient(linear, right top, left top, color-stop(0.95, rgba(0,0,0,0)), color-stop(1, rgba(0,0,0,0.15)));
	background-image:-webkit-linear-gradient(right, rgba(0,0,0,0) 95%, rgba(0,0,0,0.15) 100%);
	background-image:-moz-linear-gradient(right, rgba(0,0,0,0) 95%, rgba(0,0,0,0.15) 100%);
	background-image:-ms-linear-gradient(right, rgba(0,0,0,0) 95%, rgba(0,0,0,0.15) 100%);
	background-image:-o-linear-gradient(right, rgba(0,0,0,0) 95%, rgba(0,0,0,0.15) 100%);
	background-image:linear-gradient(right, rgba(0,0,0,0) 95%, rgba(0,0,0,0.15) 100%);
}

.evt114169 .magazine-viewport .zoom-in .even .gradient,
.evt114169 .magazine-viewport .zoom-in .odd .gradient{

	display:none;

}

.evt114169 .magazine-viewport .loader{
	background-image:url(../pics/loader.gif);
	width:22px;
	height:22px;
	position:absolute;
	top:280px;
	left:219px;
}

.evt114169 .magazine-viewport .shadow{
	-webkit-transition: -webkit-box-shadow 0.5s;
	-moz-transition: -moz-box-shadow 0.5s;
	-o-transition: -webkit-box-shadow 0.5s;
	-ms-transition: -ms-box-shadow 0.5s;

	-webkit-box-shadow:0 0 20px #ccc;
	-moz-box-shadow:0 0 20px #ccc;
	-o-box-shadow:0 0 20px #ccc;
	-ms-box-shadow:0 0 20px #ccc;
	box-shadow:0 0 20px #ccc;
}

.evt114169 .magazine-viewport .next-button,
.evt114169 .magazine-viewport .previous-button{
	width:22px;
	height:600px;
	position:absolute;
	top:0;
}

.evt114169 .magazine-viewport .next-button{
	right:-22px;
	-webkit-border-radius:0 15px 15px 0;
	-moz-border-radius:0 15px 15px 0;
	-ms-border-radius:0 15px 15px 0;
	-o-border-radius:0 15px 15px 0;
	border-radius:0 15px 15px 0;
}

.evt114169 .magazine-viewport .previous-button{
	left:-22px;
	-webkit-border-radius:15px 0 0 15px;
	-moz-border-radius:15px 0 0 15px;
	-ms-border-radius:15px 0 0 15px;
	-o-border-radius:15px 0 0 15px;
	border-radius:15px 0 0 15px;
}

.evt114169 .magazine-viewport .previous-button-hover,
.evt114169 .magazine-viewport .next-button-hover{
	background-color:rgba(0,0,0, 0.2);
}

.evt114169 .magazine-viewport .previous-button-hover,
.evt114169 .magazine-viewport .previous-button-down{
	background-image:url(../pics/arrows.png);
	background-position:-4px 284px;
	background-repeat:no-repeat;
}

.evt114169 .magazine-viewport .previous-button-down,
.evt114169 .magazine-viewport .next-button-down{
	background-color:rgba(0,0,0, 0.4);
}

.evt114169 .magazine-viewport .next-button-hover,
.evt114169 .magazine-viewport .next-button-down{
	background-image:url(../pics/arrows.png);
	background-position:-38px 284px;
	background-repeat:no-repeat;
}

.evt114169 .magazine-viewport .zoom-in .next-button,
.evt114169 .magazine-viewport .zoom-in .previous-button{
	display:none;
}

.evt114169 .animated{
	-webkit-transition:margin-left 0.5s;
	-moz-transition:margin-left 0.5s;
	-ms-transition:margin-left 0.5s;
	-o-transition:margin-left 0.5s;
	transition:margin-left 0.5s;
}

.evt114169 .thumbnails{
	position:absolute;
	bottom:130px;
	left:0;
	width:100%;
	height:140px;
	z-index:1;
}

.evt114169 .thumbnails > div{
	width:1050px;
	height:100px;
	margin:20px auto;
}

.evt114169 .thumbnails ul{
	margin:0;
	padding:0;
	text-align:center;
	-webkit-transform:scale3d(0.5, 0.5, 1);
	-moz-transform:scale3d(0.5, 0.5, 1);
	-o-transform:scale3d(0.5, 0.5, 1);
	-ms-transform:scale3d(0.5, 0.5, 1);
	transform:scale3d(0.5, 0.5, 1);
	-webkit-transition:-webkit-transform ease-in-out 100ms;
	-moz-transition:-moz-transform ease-in-out 100ms;
	-ms-transition:-ms-transform ease-in-out 100ms;
	-o-transition:-o-transform ease-in-out 100ms;
	transition:transform ease-in-out 100ms;
}

.evt114169 .thumbanils-touch ul{
	-webkit-transform:none;
	-moz-transform:none;
	-o-transform:none;
	-ms-transform:none;
	transform:none;
}

.evt114169 .thumbnails-hover ul{
	-webkit-transform:scale3d(0.6, 0.6, 1);
	-moz-transform:scale3d(0.6, 0.6, 1);
	-o-transform:scale3d(0.6, 0.6, 1);
	-ms-transform:scale3d(0.6, 0.6, 1);
	transform:scale3d(0.6, 0.6, 1);
}

.evt114169 .thumbnails li{
	list-style:none;
	display:inline-block;
	margin:0 5px;
	-webkit-box-shadow:0 0 10px #ccc;
	-moz-box-shadow:0 0 10px #ccc;
	-ms-box-shadow:0 0 10px #ccc;
	-o-box-shadow:0 0 10px #ccc;
	box-shadow:0 0 10px  #ccc;
	-webkit-transition:-webkit-transform 60ms;
	-moz-transition:-webkit-transform 60ms;
	-o-transition:-webkit-transform 60ms;
	-ms-transition:-webkit-transform 60ms;
	transition:-webkit-transform 60ms;
}

.evt114169 .thumbnails li span{
	display:none;
}

.evt114169 .thumbnails .current{
	-webkit-box-shadow:0 0 10px red;
	-moz-box-shadow:0 0 10px red;
	-ms-box-shadow:0 0 10px red;
	-o-box-shadow:0 0 10px red;
	box-shadow:0 0 10px red;
}

.evt114169 .thumbnails .thumb-hover{
	-webkit-transform:scale3d(1.3, 1.3, 1);
	-moz-transform:scale3d(1.3, 1.3, 1);
	-o-transform:scale3d(1.3, 1.3, 1);
	-ms-transform:scale3d(1.3, 1.3, 1);
	transform:scale3d(1.3, 1.3, 1);

	-webkit-box-shadow:0 0 10px #666;
	-moz-box-shadow:0 0 10px #666;
	-ms-box-shadow:0 0 10px #666;
	-o-box-shadow:0 0 10px #666;
	box-shadow:0 0 10px #666;
}

.evt114169 .thumbanils-touch .thumb-hover{
	-webkit-transform:none;
	-moz-transform:none;
	-o-transform:none;
	-ms-transform:none;
	transform:none;
}

.evt114169 .thumbnails .thumb-hover span{
	position:absolute;
	bottom:-30px;
	left:0;
	z-index:2;
	width:100%;
	height:30px;
	font:bold 15px arial;
	line-height:30px;
	color:#666;
	display:block;
	cursor:default;
}

.evt114169 .thumbnails img{
	float:left;
}

.evt114169 .exit-message{
	position: absolute;
	top:10px;
	left:0;
	width:100%;
	height:40px;
	z-index:10000;
}

.evt114169 .exit-message > div{
	width:140px;
	height:30px;
	margin:auto;
	background:rgba(0,0,0,0.5);
	text-align:center;
	font:12px arial;
	line-height:30px;
	color:white;
	-webkit-border-radius:10px;
	-moz-border-radius:10px;
	-ms-border-radius:10px;
	-o-border-radius:10px;
	border-radius:10px;
}

.evt114169 .zoom-icon{
	position:absolute;
	z-index:1000;
	width:22px;
	height:22px;
	top:10px;
	right:10px;
	background-image:url(../pics/zoom-icons.png);
	background-size:88px 22px;
}

.evt114169 .zoom-icon-in{
	background-position:0 0;
	cursor: pointer;
}

.evt114169 .zoom-icon-in.zoom-icon-in-hover{
	background-position:-22px 0;
	cursor: pointer;
}

.evt114169 .zoom-icon-out{
	background-position:-44px 0;
}

.evt114169 .zoom-icon-out.zoom-icon-out-hover{
	background-position:-66px 0;
	cursor: pointer;
}

.evt114169 .bottom{
	position:absolute;
	left:0;
	bottom:0;
	width:100%;
}
</style>
<script type="text/javascript" src="/lib/js/jquery.min.1.7.js"></script>
<script type="text/javascript" src="/lib/js/modernizr.2.5.3.min.js"></script>
<script type="text/javascript" src="/lib/js/hash.js"></script>
<script type="text/javascript" src="/lib/js/magazine.js"></script>
<script type="text/javascript">

    function loadApp() {
    
         $('#canvas').fadeIn(1000);
    
         var flipbook = $('.magazine');
    
         // Check if the CSS was already loaded
        
        if (flipbook.width()==0 || flipbook.height()==0) {
            setTimeout(loadApp, 10);
            return;
        }
        
        // Create the flipbook
    
        flipbook.turn({
                
                // Magazine width
    
                width: 922,
    
                // Magazine height
    
                height: 600,
    
                // Duration in millisecond
    
                duration: 1000,
    
                // Hardware acceleration
    
                acceleration: !isChrome(),
    
                // Enables gradients
    
                gradients: true,
                
                // Auto center this flipbook
    
                autoCenter: true,
    
                // Elevation from the edge of the flipbook when turning a page
    
                elevation: 50,
    
                // The number of pages
    
                pages: 12,
    
                // Events
    
                when: {
                    turning: function(event, page, view) {
                        
                        var book = $(this),
                        currentPage = book.turn('page'),
                        pages = book.turn('pages');
                
                        // Update the current URI
    
                        Hash.go('page/' + page).update();
    
                        // Show and hide navigation buttons
    
                        disableControls(page);
                        
    
                        $('.thumbnails .page-'+currentPage).
                            parent().
                            removeClass('current');
    
                        $('.thumbnails .page-'+page).
                            parent().
                            addClass('current');
    
    
    
                    },
    
                    turned: function(event, page, view) {
    
                        disableControls(page);
    
                        $(this).turn('center');
    
                        if (page==1) { 
                            $(this).turn('peel', 'br');
                        }
    
                    },
    
                    missing: function (event, pages) {
    
                        // Add pages that aren't in the magazine
    
                        for (var i = 0; i < pages.length; i++)
                            addPage(pages[i], $(this));
    
                    }
                }
    
        });
    
        // Zoom.js
    
        $('.magazine-viewport').zoom({
            flipbook: $('.magazine'),
    
            max: function() { 
                
                return largeMagazineWidth()/$('.magazine').width();
    
            }, 
    
            when: {
    
                swipeLeft: function() {
    
                    $(this).zoom('flipbook').turn('next');
    
                },
    
                swipeRight: function() {
                    
                    $(this).zoom('flipbook').turn('previous');
    
                },
    
                resize: function(event, scale, page, pageElement) {
    
                    if (scale==1)
                        loadSmallPage(page, pageElement);
                    else
                        loadLargePage(page, pageElement);
    
                },
    
                zoomIn: function () {
    
                    $('.thumbnails').hide();
                    $('.made').hide();
                    $('.magazine').removeClass('animated').addClass('zoom-in');
                    $('.zoom-icon').removeClass('zoom-icon-in').addClass('zoom-icon-out');
                    
                    if (!window.escTip && !$.isTouch) {
                        escTip = true;
    
                        $('<div />', {'class': 'exit-message'}).
                            html('<div>Press ESC to exit</div>').
                                appendTo($('body')).
                                delay(2000).
                                animate({opacity:0}, 500, function() {
                                    $(this).remove();
                                });
                    }
                },
    
                zoomOut: function () {
    
                    $('.exit-message').hide();
                    $('.thumbnails').fadeIn();
                    $('.made').fadeIn();
                    $('.zoom-icon').removeClass('zoom-icon-out').addClass('zoom-icon-in');
    
                    setTimeout(function(){
                        $('.magazine').addClass('animated').removeClass('zoom-in');
                        resizeViewport();
                    }, 0);
    
                }
            }
        });
    
        // Zoom event
    
        if ($.isTouch)
            $('.magazine-viewport').bind('zoom.doubleTap', zoomTo);
        else
            $('.magazine-viewport').bind('zoom.tap', zoomTo);
    
    
        // Using arrow keys to turn the page
    
        $(document).keydown(function(e){
    
            var previous = 37, next = 39, esc = 27;
    
            switch (e.keyCode) {
                case previous:
    
                    // left arrow
                    $('.magazine').turn('previous');
                    e.preventDefault();
    
                break;
                case next:
    
                    //right arrow
                    $('.magazine').turn('next');
                    e.preventDefault();
    
                break;
                case esc:
                    
                    $('.magazine-viewport').zoom('zoomOut');	
                    e.preventDefault();
    
                break;
            }
        });
    
        // URIs - Format #/page/1 
    
        Hash.on('^page\/([0-9]*)$', {
            yep: function(path, parts) {
                var page = parts[1];
    
                if (page!==undefined) {
                    if ($('.magazine').turn('is'))
                        $('.magazine').turn('page', page);
                }
    
            },
            nop: function(path) {
    
                if ($('.magazine').turn('is'))
                    $('.magazine').turn('page', 1);
            }
        });
    
    
        $(window).resize(function() {
            resizeViewport();
        }).bind('orientationchange', function() {
            resizeViewport();
        });
    
        // Events for thumbnails
    
        $('.thumbnails').click(function(event) {
            
            var page;
    
            if (event.target && (page=/page-([0-9]+)/.exec($(event.target).attr('class'))) ) {
            
                $('.magazine').turn('page', page[1]);
            }
        });
    
        $('.thumbnails li').
            bind($.mouseEvents.over, function() {
                
                $(this).addClass('thumb-hover');
    
            }).bind($.mouseEvents.out, function() {
                
                $(this).removeClass('thumb-hover');
    
            });
    
        if ($.isTouch) {
        
            $('.thumbnails').
                addClass('thumbanils-touch').
                bind($.mouseEvents.move, function(event) {
                    event.preventDefault();
                });
    
        } else {
    
            $('.thumbnails ul').mouseover(function() {
    
                $('.thumbnails').addClass('thumbnails-hover');
    
            }).mousedown(function() {
    
                return false;
    
            }).mouseout(function() {
    
                $('.thumbnails').removeClass('thumbnails-hover');
    
            });
    
        }
    
    
        // Regions
    
        if ($.isTouch) {
            $('.magazine').bind('touchstart', regionClick);
        } else {
            $('.magazine').click(regionClick);
        }
    
        // Events for the next button
    
        $('.next-button').bind($.mouseEvents.over, function() {
            
            $(this).addClass('next-button-hover');
    
        }).bind($.mouseEvents.out, function() {
            
            $(this).removeClass('next-button-hover');
    
        }).bind($.mouseEvents.down, function() {
            
            $(this).addClass('next-button-down');
    
        }).bind($.mouseEvents.up, function() {
            
            $(this).removeClass('next-button-down');
    
        }).click(function() {
            
            $('.magazine').turn('next');
    
        });
    
        // Events for the next button
        
        $('.previous-button').bind($.mouseEvents.over, function() {
            
            $(this).addClass('previous-button-hover');
    
        }).bind($.mouseEvents.out, function() {
            
            $(this).removeClass('previous-button-hover');
    
        }).bind($.mouseEvents.down, function() {
            
            $(this).addClass('previous-button-down');
    
        }).bind($.mouseEvents.up, function() {
            
            $(this).removeClass('previous-button-down');
    
        }).click(function() {
            
            $('.magazine').turn('previous');
    
        });
    
    
        resizeViewport();
    
        $('.magazine').addClass('animated');
    
    }
    
    // Zoom icon
    
     $('.zoom-icon').bind('mouseover', function() { 
         
         if ($(this).hasClass('zoom-icon-in'))
             $(this).addClass('zoom-icon-in-hover');
    
         if ($(this).hasClass('zoom-icon-out'))
             $(this).addClass('zoom-icon-out-hover');
     
     }).bind('mouseout', function() { 
         
          if ($(this).hasClass('zoom-icon-in'))
             $(this).removeClass('zoom-icon-in-hover');
         
         if ($(this).hasClass('zoom-icon-out'))
             $(this).removeClass('zoom-icon-out-hover');
    
     }).bind('click', function() {
    
         if ($(this).hasClass('zoom-icon-in'))
             $('.magazine-viewport').zoom('zoomIn');
         else if ($(this).hasClass('zoom-icon-out'))	
            $('.magazine-viewport').zoom('zoomOut');
    
     });
    
     $('#canvas').hide();
    
    
    // Load the HTML4 version if there's not CSS transform
    
    yepnope({
        test : Modernizr.csstransforms,
        yep: ['/lib/js/turn.js'],
        both: ['/lib/js/zoom.min.js', '/lib/js/magazine.js'],
        complete: loadApp
    });
    
</script>
</head>
<body>
<div id="eventDetailV15" class="wrap">
	<!-- #include virtual="/html/lib/inc/incHeader.asp" -->
	<div class="container fullEvt"><!-- for dev msg :왼쪽메뉴(카테고리명) 사용시 클래스 :partEvt / 왼쪽메뉴(카테고리명) 사용 안할때 클래스 :fullEvt -->
		<div id="contentWrap">
			<div class="eventWrapV15">
				<div class="evtHead snsArea">
					<dl class="evtSelect ftLt">
						<dt><span>이벤트 더보기</span></dt>
						<dd>
							<ul>
								<li><strong>엔조이 이벤트 전체 보기</strong></li>
								<li>나는 모은다 고로 존재한다</li>
								<li>일년 열두달 매고 싶은, 플래그쉽 플래그쉽</li>
								<li>시어버터 보습막을 입자</li>
								<li>전국민 블루투스 키보드</li>
								<li>데스크도 여름 정리가 필요해 필요해 필요해</li>
								<li>지금 놀이터 갈래요!</li>
								<li>ELLY FACTORY</li>
								<li>폴프랭크 카메라</li>
								<li>폴프랭크 카메라</li>
								<li>폴프랭크 카메라</li>
							</ul>
						</dd>
					</dl>
					<div class="ftRt">
						<a href="" class="ftLt btn btnS2 btnGrylight"><em class="gryArr01">브랜드 전상품 보기</em></a>
						<div class="sns lMar10">
							<ul>
								<li><a href="#"><img src="//fiximage.10x10.co.kr/web2013/common/sns_me2day.gif" alt="미투데이"></a></li>
								<li><a href="#"><img src="//fiximage.10x10.co.kr/web2013/common/sns_twitter.gif" alt="트위터"></a></li>
								<li><a href="#"><img src="//fiximage.10x10.co.kr/web2013/common/sns_facebook.gif" alt="페이스북"></a></li>
								<li><a href="#"><img src="//fiximage.10x10.co.kr/web2013/common/sns_pinterest.gif" alt="핀터레스트"></a></li>
							</ul>
							<div class="favoriteAct myFavor"><strong>123</strong></div><!-- for dev msg :관심 play 등록 후 myFavor 클래스 추가 되게 해주세요 -->
						</div>
					</div>
				</div>

				<div class="eventContV15 tMar15">
					<!-- event area(이미지만 등록될때 / 수작업일때) -->
					<div class="contF contW">
                        <div class="evt114169">
                            <div id="canvas">
                                <div class="zoom-icon zoom-icon-in"></div>
                                <div class="magazine-viewport">
                                    <div class="container">
                                        <div class="magazine">
                                            <!-- Next button -->
                                            <div ignore="1" class="next-button"></div>
                                            <!-- Previous button -->
                                            <div ignore="1" class="previous-button"></div>
                                        </div>
                                    </div>
                                </div>
                                <!-- Thumbnails -->
                                <div class="thumbnails">
                                    <div>
                                        <ul>
                                            <li class="i">
                                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114169/m/1-thumb.jpg" width="76" height="100" class="page-1">
                                                <span>1</span>
                                            </li>
                                            <li class="d">
                                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114169/m/2-thumb.jpg" width="76" height="100" class="page-2">
                                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114169/m/3-thumb.jpg" width="76" height="100" class="page-3">
                                                <span>2-3</span>
                                            </li>
                                            <li class="d">
                                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114169/m/4-thumb.jpg" width="76" height="100" class="page-4">
                                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114169/m/5-thumb.jpg" width="76" height="100" class="page-5">
                                                <span>4-5</span>
                                            </li>
                                            <li class="d">
                                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114169/m/6-thumb.jpg" width="76" height="100" class="page-6">
                                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114169/m/7-thumb.jpg" width="76" height="100" class="page-7">
                                                <span>6-7</span>
                                            </li>
                                            <li class="d">
                                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114169/m/8-thumb.jpg" width="76" height="100" class="page-8">
                                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114169/m/9-thumb.jpg" width="76" height="100" class="page-9">
                                                <span>8-9</span>
                                            </li>
                                            <li class="d">
                                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114169/m/10-thumb.jpg" width="76" height="100" class="page-10">
                                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114169/m/11-thumb.jpg" width="76" height="100" class="page-11">
                                                <span>10-11</span>
                                            </li>
                                            <li class="i">
                                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114169/m/12-thumb.gif" width="76" height="100" class="page-12">
                                                <span>12</span>
                                            </li>
                                        <ul>
                                    <div>	
                                </div>
                            </div>
                        </div>  
					</div>
					<!-- //event area(이미지만 등록될때 / 수작업일때) -->
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>