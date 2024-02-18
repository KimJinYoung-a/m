Vue.component('pb-reviews', {
    template: '\
    <div>\
        <ul class="review-list"\
            v-if="componentData.length > 0"\
        >\
            <li class="items"\
                v-bind:class="types[getRandomNumber(0,2)]"\
                v-for="(review, idx) in componentData"\
                v-if="idx < limit"\
                @click="productLink(review.itemId)"\
            >\
                <div class="thumbnail"\
                    v-bind:style="{\'background-image\': \'url(\'+ review.reviewImg +\')\'}"></div>\
                <div class="info">\
                    <div>\
                        <span class="icon icon-rating"><i style="width:100%;">리뷰 종합 별점 100점</i></span>\
                        <span class="writer">{{printUserName(review.userId, 2, \'*\')}}</span>\
                    </div>\
                    <span class="txt">{{review.contents}}</span>\
                </div>\
            </li>\
        </ul>\
        <button class="btn-more"\
            @click="setLimit"\
            v-if="limit != componentData.length && componentData.length > limit "\
        >+ <em>{{c_moreNumber}}</em>건 더보기</button>\
        </div>\
    ',
    data: function(){
        return {
            types: [
                'type-a',
                'type-b',
                'type-c'
            ],
            limit: 10,
            moreNumber: 10
        }
    },
    props: {
        componentData: {
            type: Array,
            default: []
        }
    },
    methods: {
        setLimit: function(){
            this.limit += this.moreNumber
        },        
        getRandomNumber: function getRandomNUmber(min, max) {
            return Math.floor(Math.random() * (max - min + 1)) + min;
        },
        productLink: function(itemId){
            if(isapp == 1){
                TnGotoProduct(itemId);
            }else{
                window.location.href = "/category/category_itemPrd.asp?itemid="+itemId
            }
            return false;
        },
        printUserName: function(name, num, replaceStr){
            return name.substr(0,name.length - num) + replaceStr.repeat(num)
        }
    },
    computed: {
        c_moreNumber: function(){
            return Math.floor(this.restArrNum / this.moreNumber) > 0 ? 
                   this.moreNumber : 
                   this.restArrNum % this.moreNumber
        },
        restArrNum: function(){
            return this.componentData.length > this.moreNumber ?
                   this.componentData.length - this.limit :
                   this.componentData.length
        }
    }    
})