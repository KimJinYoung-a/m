// clap template
Vue.component('clap-action',{
    props : ['likecount','contentsidx','mylikecount','index'],
    data : function() {
        return {
            likeClickCount : 0,
            likeContentsIdx : 0,
            likeTotalCount : 0,
            nowClickCount : 0,
            timer : null,
        }
    },
    template : '<div class="clap-wrap">\
                    <div class="count" ref="clapCount">1</div>\
                    <button type="button" class="btn-clap" :class="likeCheck(likecount)" @click.prevent="clapClick(likecount,contentsidx,mylikecount,$event)"><i>박수</i><span>{{getCount(likecount)}}</span></button>\
                    <div class="point">\
                        <span class="point-item"></span>\
                        <span class="point-item"></span>\
                        <span class="point-item"></span>\
                        <span class="point-item"></span>\
                        <span class="point-item"></span>\
                        <span class="point-item"></span>\
                        <span class="point-item"></span>\
                        <span class="point-item"></span>\
                    </div>\
                </div>'
    ,
    methods : {
        likeCheck : function(likecount) {
            return likecount > 0 ? "on" : "";
        },
        getCount : function(likecount) {
            return (likecount == 0 ||likecount == '') ? '짝짝짝!' : likecount;
        },
        clapClick : function(likecount , contentsidx , mylikecount , event) {
            var _this = this;
            var _userid = $("#userid").attr("rel");
            if (!_userid) {
                alert('로그인후 이용 가능합니다.');
                return location.href='/login/login.asp?vType=G&backpath=%2Ftenfluencer%2F';
            }

            if (mylikecount >= 30 || _this.likeClickCount >= 30)
            {
                this.clickLayer();
                return false;
            }

            if (_this.likeClickCount == 0)
            {
                _this.likeClickCount = mylikecount;
                _this.likeContentsIdx = contentsidx;
                _this.likeTotalCount = likecount;
            }

            // 가이드 숨김
            $(".guide-clap").fadeOut(200);
            // 클릭 이벤트 상위 클래스
            $parent = event.target.closest('.clap-wrap');
            $($parent).find('.count').text(_this.likeClickCount+1);
            $($parent).find("span").eq(0).text(_this.likeTotalCount+1);
            $(event.target.parentElement).addClass('on');
            // 카운트 Ui class 변경
            
            $($parent).addClass('is-touched');
            setTimeout(function(){
                $($parent).removeClass("is-touched");
                _this.likeClickCount++;
                _this.likeTotalCount++;
                _this.nowClickCount++;
            }, 300);
        },
        setCount : function() {
            var _data = {cidx : this.likeContentsIdx , device : 'M' , clickcount : this.nowClickCount};
            var _url = data_likeCount+'?json='+JSON.stringify(_data);
            $.ajax({
                type: "POST",
                url: _url,
                async : true,
                contentType:"application/json; charset=utf-8",
                dataType: "json",
            });

            this.nowClickCount = 0
        },
        clickLayer : function() {
            var popState = false;
            // 30번 박수
            var popClap = function() {
                $(".ly-clap").delay(300).show(0).delay(2100).hide(0);
            }
            if( popState === false ){
                popClap();
                popState = true;
            }
            setTimeout(function() {
                popState = false;
            }, 3000);
        },
        clickDeBounce : function() {
            var _timer = this.timer;
            var _this = this;

            if (_timer) {
                clearTimeout(_timer);
            }

            _timer = setTimeout(function(){
                _this.setCount();
            }, 1000);

            this.timer = _timer;
        }
    },
    watch : {
        likeClickCount : function(val , oldVal) {
            this.clickDeBounce();
            if (val == 30 || oldVal == 29) {
                this.clickLayer();
            }
        }
    }
})