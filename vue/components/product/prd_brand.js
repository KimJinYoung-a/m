Vue.component('Product-Brand',{
    template : `<div class="prd_brand">{{brand_name}}</div>`,
    props : {
        brand_name : { type : String, default : '' }, //브랜드명
    }
})