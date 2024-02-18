Vue.component('pb-event-list', {
    template: '\
        <div class="list-card"\
            v-if="componentData.length > 0"\
        >\
            <ul>\
                <li\
                    v-for="item in componentData"\
                >\
                    <a @click="handleClickLink(item.evt_code)">\
                        <div class="thumbnail"><img :src="item.bannerImg" alt="">\
                            <em v-if="item.isgift">사은이벤트 진행중</em>\
                            <em v-if="item.isoneplusone">1+1증정 이벤트 진행중</em>\
                            <em v-if="item.isbookingsell">예약판매 진행중</em>\
                        </div>\
                        <div class="desc">\
                            <p class="tit">{{item.evt_name}}</p>\
                            <p class="subcopy">\
                               <span>{{item.evt_subcopyK}}</span>\
                               <em class="discount color-red"\
                                    v-if="item.issale"\
                               > {{dispSalePer(item.salePer)}}</em>\
                               <em class="discount color-green"\
                                    v-if="item.iscoupon"\
                               > {{dispSalePer(item.saleCPer)}}</em>\
                            </p>\
                        </div>\
                    </a>\
                </li>\
            </ul>\
        </div>\
    ',
    props: {
        componentData: {
            type: Array,
            default: []
        }
    },
    methods: {
        handleClickLink: function(evtCode){
            if(isapp == 1){
                fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid='+evtCode);
            }else{
                window.location.href = "/event/eventmain.asp?eventid="+evtCode
            }
            return false;
        },
        dispSalePer: function(salePer){
            var result = ""
            if(salePer != ""){
                result = salePer.indexOf("%") != -1 || salePer.indexOf("원") != -1 ? salePer 
                : salePer <= 100 ? salePer + "%"
                : salePer + "원"
            }
            return result
        }        
    }    
})