// video-list
Vue.component('video-list',{
    props : ['item','index','isapp'],
    template : '\
                <li>\
                    <a @click="linkUrl(isapp,item.contentsidx)">\
                        <div class="thm"><img :src="item.mainimage" alt=""><span class="badge" v-if="item.isNew == true">NEW</span></div>\
                        <div class="desc">\
                            <b class="headline">{{item.ctitle}}</b>\
                            <span class="subcopy">{{item.groupname}}</span>\
                        </div>\
                    </a>\
                    <div class="guide-clap"\
                        v-if="index == 0 && tipFlag"\
                        @click="hideTip"\
                    >마음에 드는 영상이라면 박수를 짝짝짝!<br>박수는 최대 30번까지 칠 수 있어요!</div>\
                    <clap-icon\
                        :is-login="true" \
                        :like-count="item.likecount" \
                        :my-like-count="item.mylikecount" \
                        :c-idx="item.contentsidx"></clap-icon>\
                </li>\
                '
    ,
    data: function(){
        return {
            tipFlag: true
        }
    },
    methods : {        
        linkUrl : function(isapp,contentsidx) {
            this.setViewCount(contentsidx); // viewcount

            if (isapp == 1) {
                fnAPPpopupTransparent('tenfluencer','http://fiximage.10x10.co.kr/m/2019/platform/tenfluencer.png','/tenfluencer/detail.asp?cidx='+contentsidx,'right','sc','titleimage');
            } else {
                location.href = '/tenfluencer/detail.asp?cidx='+contentsidx;
            }
        },
        setViewCount : function(contentsidx) {
            var _data = {cidx : contentsidx , device : 'M'};
            var _url = data_viewCount+'?json='+JSON.stringify(_data);
            $.ajax({
                type: "POST",
                url: _url,
                async : true,
                contentType:"application/json; charset=utf-8",
                dataType: "json",
            });
        },
        hideTip: function(){            
            this.tipFlag = false;            
        }        
    },
    mounted : function() {
        if(this.index == 0){
            var _this = this;
            window.setTimeout(function(){                
                _this.hideTip();
            }, 5000);
        }
    }    
})