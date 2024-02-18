<style>
.body-sub .content {padding-bottom:0;}
.thingVol044 {position:relative;}
.thingVol044 button {background-color:transparent;}
.thingVol044 .intro {position:relative; }
.thingVol044 .btn-pick {position:absolute; bottom:8.9%; left:50%; margin-left:-20.2%; width:40.4%;}
.thingVol044 .card-play {position:relative; background-color:#b3fffe;}
.thingVol044 .card-play ul {overflow:hidden; width:28.66rem; margin:0 auto; padding:4.61rem 0 1.54rem;}
.thingVol044 .card-play .flip-wrap {float:left; width:13.98rem; height:12.63rem; padding:0 .42rem; margin-bottom:3.07rem; perspective:1000px; -webkit-perspective:1000px;}
.thingVol044 .card-play .flip-wrap.on .flipper,
.thingVol044 .card-play .flip-wrap.picked .flipper {transform:rotateY(180deg); -webkit-transform:rotateY(180deg);}
.thingVol044 .card-play .flip-wrap .flipper {position:relative; transition:.7s; -webkit-transition:.7s; transform-style:preserve-3d; -webkit-transform-style:preserve-3d;}
.thingVol044 .card-play .flip-wrap .flipper .front,
.thingVol044 .card-play .flip-wrap .flipper .back{position:absolute; backface-visibility:hidden; -webkit-backface-visibility:hidden;}
.thingVol044 .card-play .flip-wrap .flipper .front{transform:rotateY(180deg);}
.thingVol044 .card-play .flip-wrap .flipper .back {transform:rotateY(0deg);}
.thingVol044 .card-play .flip-wrap .flipper,
.thingVol044 .card-play .flip-wrap .flipper > div,
.thingVol044 .card-play .flip-wrap .flipper img{width:100%; height:100%;}
.thingVol044 .rolling {position:relative;}
.thingVol044 .rolling .pagination {position:absolute; bottom:1.58rem; left:0; z-index:5; width:100%; height:.64rem; paddivng-top:0;}
.thingVol044 .rolling .pagination span {width:.64rem; height:.64rem; background-color:#c3c3c3;}
.thingVol044 .rolling .pagination span.swiper-active-switch {background-color:#0066ff;}
.thingVol044 .rolling .slideNav {position:absolute; top:0; z-index:5; width:7.3%; height:100%;}
.thingVol044 .rolling .slideNav img {width:100%; height:100%;}
.thingVol044 .rolling .btnPrev {left:0;}
.thingVol044 .rolling .btnNext {right:0;}
.thingVol044 .game-layer,
.thingVol044 .ly-success-wrap {position:absolute; top:50%; left:50%; z-index:6; width:32rem; margin:-16.96rem 0 0 -16rem;}
.thingVol044 .ly-success-wrap {top:0; left:0; width:100%; height:100%; background-color:rgba(0,0,0,.8); margin:0;}
.thingVol044 .ly-success-wrap .ly-success {width:32rem; margin:0 auto; padding-top:4.94rem;}
.thingVol044 .ly-success-wrap .ly-success p {display:none;}
.thingVol044 .ly-success-wrap .ly-success p.show {display:block;}
.thingVol044 .ly-success-wrap button{position:absolute; bottom:7.48rem; left:50%; width:9.13rem; margin-left:-4.56rem; animation-delay:.3s;}
.thingVol044 .vod-wrap {padding-top:2.77rem; background:url(http://webimage.10x10.co.kr/playing/thing/vol044/m/bg_item.png);}
.thingVol044 .vod-wrap .vod {position:relative; width:76%; height:0; margin:0 auto; padding-bottom:46.4%;}
.thingVol044 .vod-wrap .vod iframe {position:absolute; top:0; left:0; width:100%; height:100%;}
.thingVol044 .vod-wrap a {display:inline-block; width:100%; padding:3.84rem 0 4.95rem;}
.bounce1{animation:bounce1 .7s 50; -webkit-animation:bounce1 .7s 50;}
.moveLeft{animation:moveLeft .6s 50; -webkit-animation:moveLeft .6s 50;}
@keyframes bounce1 {from,to {transform:translateY(5px);}50% {transform:translateY(-5px);}}
@keyframes moveLeft {from,to {transform:translateX(0px);}50% {transform:translateX(10px);}}
</style>
<script type="text/javascript">
var memoryGame = (function(){
    var instance;

    /**
     * @param {array} imgArr 이미지 배열
	 * @param {obj} ulElement li엘리먼트 담을 ul엘리먼트
	 * @param {string} backImgUrl 커버이미지
	 * @param {function} cb 콜백함수
     * 
     */
    function initiate(imgArr, ulElement, backImgUrl, cb){//게임 초기화
		
		var onceFlag;
        var ul = ulElement;        
        var liArr = "";
        var itemImgArr= [...imgArr];
        var itemCoverImg= backImgUrl;
        var elementNumber= itemImgArr.length;
		var target= "";
		var targetImg = "";
		var targetIdxArr = new Array;
        var eventTarget="";
        var eventTargetIndex="";
        var coverStatus= false;
        var flipStatus= false;
        var gameStatus= false;

        return {
            startGame: function(){
				// console.log("startGame");                
				if(onceFlag === true)return false;
                onceFlag = true;      
                gameStatus = true;                
                this.setTarget(); 
            },
            getRandomNumber: function(n){
                var rannum = Math.floor(Math.random() * n)
                return rannum;
            },
            initiateItem: function(){
				if(itemImgArr.length < 1){
                    console.error('매개변수-이미지 배열');
                    return;
                }
                // console.log("initiateItem");
                this.shuffleItems().renderItemList()//.setTarget();
            },
            renderItemList: function(){
					var li;
					var flipper;
					var front;
					var back;
					var backImg;
					var frontImg;
                for(var i = 0 ; i < elementNumber + 1 ; i++){                    
					li = document.createElement("li");  										
					li.className="flip-wrap card";	
					li.addEventListener("click", this.setEventTarget, true);
					li.addEventListener("click", this.flipItem.bind(this));
					flipper = document.createElement("div");  
					flipper.className="flipper";
					front = document.createElement("div");  
					front.className="front";
					back = document.createElement("div");  
					back.className="back";
					backImg = document.createElement('img'); 
					backImg.setAttribute("src", itemCoverImg);				
					frontImg = document.createElement('img'); 
					frontImg.setAttribute("src", itemImgArr[i]);

					ul.appendChild(li);
					li.appendChild(flipper);
					flipper.appendChild(back);
					back.appendChild(backImg);
					flipper.appendChild(front);
					front.appendChild(frontImg);                                     
                }
                liArr = ul.getElementsByTagName('li');
                return this;
            },
            flipItem: function(){              
                // console.log("flipItem");                
                if(flipStatus===false)return;
                if(gameStatus===false)return;           
				if(this.isTarget(eventTargetIndex))return;
				this.toFront(eventTarget);
					if(this.isPickTarget()){
						gameStatus=false;
						this.cbFunction(targetImg);
					}
				setTimeout(function(){
					if(this.isPickTarget()){
						return false;
					}					
					this.toBack(eventTarget);
				}.bind(this), 700);
            },
            setTarget: function(){
				// console.log("setTarget");				
				openTarget = this.getRandomNumber(targetIdxArr.length);
				// console.log("random num: ", openTarget);
				// console.log("liArr: ", liArr);
				target = targetIdxArr[openTarget];
				liArr[target].classList.add("on");
				flipStatus=true;
                return this;
            },
            shuffleItems: function(){
                // console.log("shuffleItems");
                var tmp;
                var ranNum 
				var chosenTarget = this.getRandomNumber(elementNumber);
				targetImg = itemImgArr[chosenTarget];

				itemImgArr.push(targetImg);
                for(var idx = 0 ; idx < elementNumber + 1; idx++){
                    ranNum = this.getRandomNumber(elementNumber + 1);
                    tmp = itemImgArr[idx];
                    itemImgArr[idx] = itemImgArr[ranNum];
					itemImgArr[ranNum] = tmp;           					         
				}   
				for(var idx = 0 ; idx < elementNumber + 1; idx++){
                	if(itemImgArr[idx] === targetImg){
						targetIdxArr.push(idx);
					} 
				}  				
				// console.log(itemImgArr);             
				// console.log("targetIdxArr : ", targetIdxArr);
                return this;
            },
            toBack: function(et){
                // console.log("toback");                                                
                flipStatus = true;   
                et.classList.remove("on");
                return this;
            },
            toFront: function(et){                
				// console.log("tofront");
				flipStatus = false;
				et.classList.add("on");
                return this;                
            },
            setEventTarget: function(e){
                if( flipStatus === false ) return;              
                eventTarget = e.currentTarget;                
				eventTargetIndex = Array.prototype.indexOf.call(eventTarget.parentNode.childNodes, eventTarget) - 1;
            },
            coverAll: function(){
                for(var i = 0 ; i < liArr.length ; i++ ){
                    this.toBack(liArr[i]);   
                }             
                return this;
            },            
            isTarget: function(eti){            
                return eti === target ? true : false;
            },
            isPickTarget: function(){
                // console.log(`pick: ${imgArr[eventTargetIndex]}, target: ${targetImg}`);                

                return itemImgArr[eventTargetIndex] === targetImg;
            },
            cbFunction: function(targetImg){
				cb(targetImg);
			}            
            
        }
    }

    return {
        getInstance: function(imgArr, ulElement, backImgUrl, cb){
            if(!instance){
                instance = initiate(imgArr, ulElement, backImgUrl, cb);
            }
            return instance;
        }
    }
})();

$(function(){

	var imgUrlArr = [
		"http://webimage.10x10.co.kr/playing/thing/vol044/m/img_card_1.png"
		,"http://webimage.10x10.co.kr/playing/thing/vol044/m/img_card_2.png"
		,"http://webimage.10x10.co.kr/playing/thing/vol044/m/img_card_3.png"
		,"http://webimage.10x10.co.kr/playing/thing/vol044/m/img_card_4.png"
		,"http://webimage.10x10.co.kr/playing/thing/vol044/m/img_card_5.png"
	];
	var backImgUrl = "http://webimage.10x10.co.kr/playing/thing/vol044/m/img_card_back.png"	
	var ulobj = document.getElementById("listContainer");

	function callback(successImg){
		
		var successPops = document.getElementById("successPop").getElementsByTagName("p");
		for(var i = 0 ; i < successPops.length ; i++){
			if( imgUrlArr[i] === successImg ){
				successPops[i].className = "show";
			}
		}		

		window.setTimeout(function(){
		$('.ly-success-wrap').fadeIn(200);
		$('html,body').animate({scrollTop : $('.ly-success-wrap').offset().top},700);
			}, 400);
	};	
	var game = memoryGame.getInstance(imgUrlArr, ulobj, backImgUrl, callback);
	game.initiateItem();	
	// slide template
	slideTemplate = new Swiper('.rolling .swiper-container',{
		loop:true,
		autoplay:3000,
		autoplayDisableOnInteraction:false,
		speed:800,
		pagination:".rolling .pagination",
		paginationClickable:true,
		nextButton:'.rolling .btnNext',
		prevButton:'.rolling .btnPrev'
	});

	$('.btn-pick').click(function(){
		$('html,body').animate({scrollTop : $('.card-play').offset().top},500);		
	});

	// $('.ly-exp-game').hide();
	$('.ly-exp-game').click(function(){
		$(this).fadeOut(300);
		game.startGame();
	});

	// card play

	$('.ly-success-wrap').hide();

	$('.ly-success-wrap').click(function(){
		$('.ly-success-wrap').fadeOut(700);
		$('html,body').animate({scrollTop : $('.memory-game').offset().top},500);
	});
});
</script>
<div id="content" class="content bgWht">
	<!-- contents -->
	<div id="content" class="content playV16">
		<!-- for dev msg : 플레이 상세페이지에는 클래스명 playDetailV16 넣어주세요 / 코너(메뉴)에 따라 클래스가 붙으며, 클래스명은 메뉴명을 따릅니다. -->
		<article class="playDetailV16 thing">
			<!-- contents -->
			<div class="cont">
				<div class="detail">
					<!-- THING. html 코딩 영역 : 클래스명은 thing+볼륨 예) thingVol001 / 이미지폴더는 볼륨을 따라 vol001 -->
					<div class="thingVol044">
						<div class="intro">
							<img src="http://webimage.10x10.co.kr/playing/thing/vol044/m/tit_lets_play.jpg" alt="PLAY로 PLAY하다" />
							<button class="btn-pick bounce1"><img src="http://webimage.10x10.co.kr/playing/thing/vol044/m/btn_pick.png" alt="뽑기" /></button>
						</div>

						<!-- card play-->
						<div class="card-play">
							<ul id="listContainer">
							</ul>								
							<div class="game-layer ly-exp-game">
								<img src="http://webimage.10x10.co.kr/playing/thing/vol044/m/img_about_game.png?v=1.00" alt="뽑힌 랜덤카드와  같은 카드를 맞춰주세요" />								
							</div>

							<div class="game-layer ly-success-wrap">								
								<div class="ly-success" id="successPop">
									<p><img src="http://webimage.10x10.co.kr/playing/thing/vol044/m/txt_success_1.png" alt="COLOR A DRAWING 이 색깔, 저 색깔! 무채색인 곳들에 활짝 생기를 불어 넣어 줘요!" /></p>
									<p><img src="http://webimage.10x10.co.kr/playing/thing/vol044/m/txt_success_2.png" alt="RIDE A BIKE! 오늘 하루, 무거웠던 마음을 자전거를 타며 바람과 함께 날려보세요!" /></p>
									<p><img src="http://webimage.10x10.co.kr/playing/thing/vol044/m/txt_success_3.png" alt="SING A SONG! 오늘 신나게 눈치 보지 말고 노래 불러보는 건 어때요? 스트레스가 노래와 함께 사라질 거 에요." /></p>
									<p><img src="http://webimage.10x10.co.kr/playing/thing/vol044/m/txt_success_4.png" alt="PLAY A GAME! 핑-퐁-핑-퐁! 아무 생각 없이 즐기기엔 게임이 최고! 오늘은 다른 생각하지 말고 게임을 즐기세요!" /></p>
									<p><img src="http://webimage.10x10.co.kr/playing/thing/vol044/m/txt_success_5.png" alt="GO CAMPING! 매미 소리 들으면서 밤 하늘 별보는 상상 해보셨나요? 가까운 곳으로 낭만 캠핑 GO! GO!" /></p>
									<button class="bounce1"><img src="http://webimage.10x10.co.kr/playing/thing/vol044/m/btn_go_item.png" alt="LET'S PLAY" /></button>
								</div>
							</div>
						</div>

						<div class="memory-game"><img src="http://webimage.10x10.co.kr/playing/thing/vol044/m/txt_memory_card.png" alt="LET’S PLAY  MEMORY GAME CARD" /></div>

						<!-- rolling -->
						<div class="swiper rolling">
							<div class="swiper-container">
								<div class="swiper-wrapper">
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol044/m/img_slide_1.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol044/m/img_slide_2.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol044/m/img_slide_3.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol044/m/img_slide_4.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol044/m/img_slide_5.jpg" alt="" /></div>
								</div>
							</div>
							<div class="pagination"></div>
							<button type="button" class="slideNav btnPrev"><img src="http://webimage.10x10.co.kr/playing/thing/vol044/m/btn_prev.png" alt="이전" /></button>
							<button type="button" class="slideNav btnNext"><img src="http://webimage.10x10.co.kr/playing/thing/vol044/m/btn_next.png" alt="다음" /></button>
						</div>
						<!-- vod -->
						<div class="vod-wrap">
							<div class="vod"><iframe width="560" height="315" src="https://www.youtube.com/embed/GRvGtj6X2zM?playsinline=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe></div>							
							
							<a href="/category/category_itemPrd.asp?itemid=2031659" onclick="TnGotoProduct('2031659');return false;" class="moveLeft"><img src="http://webimage.10x10.co.kr/playing/thing/vol044/m/btn_get.png" alt="구매하러 가기" /></a>
						</div>
						<div><img src="http://webimage.10x10.co.kr/playing/thing/vol044/m/txt_new_play.png" alt="텐바이텐 컨텐츠 채널 PLAY가 함께하는 즐거움으로 새롭게 다가갑니다." /></div>
						<div id="gotop" class="btn-top" style="display: block;"><button type="button">맨위로</button></div>
					</div>
					<!-- //THING. html 코딩 영역 -->
				</div>
			</div>	
			</div>
		</article>
	</div>

	<!-- //contents -->