Vue.component('event-list',{
    template :'\
                <li>\
                    <a @click="eventUrl(index,eventid)">\
                        <div class="thumbnail"><img :src="rectangleimage" :alt="eventname"></div>\
                        <div class="desc">\
                            <p class="headline">{{eventname}}</p>\
                            <p class="subcopy">\
                                <span>{{subcopy}}</span>\
                                <em class="discount color-red">{{salePerString}}</em>\
                                <em class="discount color-green">{{couponPerString}}</em>\
                            </p>\
                        </div>\
                    </a>\
                </li>\
                '
    ,
    props: {
        index : {
            type : Number,
            default : 0
        },
        eventid: {
            type: Number,
            default: 0
        },
        eventname : {
            type : String,
            default : ''
        },
        subcopy : {
            type : String,
            default : ''
        },
        squareimage : {
            type : String,
            default : ''
        },
        rectangleimage : {
            type : String,
            default : ''
        },
        saleper : {
            type : [Number, String],
            default : "0"
        },
        salecper : {
            type : [Number, String],
            default : "0"
        },
        isgift : {
            type : Boolean,
            default : false
        },
        issale : {
            type : Boolean,
            default : false
        },
        isoneplusone : {
            type : Boolean,
            default : false
        },
        isApp : {
            type : Boolean,
            default : false,
        },
        amplitudeActionName : {
            type : String,
            default : ""
        },
    },
    computed : {
        salePerString : function() {
            return this.saleper > 0 ? "~"+this.saleper+"%" : "";
        },
        couponPerString : function() {
            return this.salecper > 0 ? "+ "+this.salecper+"%" : "";
        }
    },
    methods : {        
        eventUrl : function(index,eventid) {
            fnAmplitudeEventMultiPropertiesAction(this.amplitudeActionName+'event','idx|eventcode',index +'|'+ eventid);
            var eventUrl = "/event/eventmain.asp?eventid="+ eventid;

            this.isApp ? fnAPPpopupAutoUrl(eventUrl) : window.location.href = eventUrl;
        },
    },
})