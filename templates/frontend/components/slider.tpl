{**
 * templates/frontend/components/slider.tpl
*}
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<link rel="stylesheet" href="/plugins/themes/scielo-theme/styles/owl.carousel.css">
<link rel="stylesheet" href="/plugins/themes/scielo-theme/styles/owl.theme.default.css">
<link rel="stylesheet" href="/plugins/themes/scielo-theme/styles/bootstrap.css">


<div class="container mt-3">
    <div class="row">
        <div class="owl-carousel owl-theme" >
            {foreach from=$publishedSubmissions item="preprint"}
            <div class="item">
                <div class="card">
                    {if $preprint->getCurrentPublication()->getLocalizedData('coverImage')}
                        {assign var=preprintPath value=$preprint->getBestId()}
                        <a {if $journal}href="{url journal=$journal->getPath() page="preprint" op="view" path=$preprintPath}"{else}href="{url page="preprint" op="view" path=$preprintPath}"{/if} class="file">
                            {assign var="coverImage" value=$preprint->getCurrentPublication()->getLocalizedData('coverImage')}
                            <img
                                src="{$preprint->getCurrentPublication()->getLocalizedCoverImageUrl($preprint->getData('contextId'))|escape}"
                                alt="{$coverImage.altText|escape|default:''}"
                                class="card-img-top"
                            >
                        </a>
                    {/if}

                    <div class="card-body">
                        {assign var=preprintPath value=$preprint->getBestId()}
                        <a id="preprint-{$preprint->getId()}" {if $journal}href="{url journal=$journal->getPath() page="preprint" op="view" path=$preprintPath}"{else}href="{url page="preprint" op="view" path=$preprintPath}"{/if}>
                            {$preprint->getLocalizedTitle()|strip_unsafe_html}
                            {if $preprint->getLocalizedSubtitle()}
                                <span class="subtitle">
                                    {$preprint->getLocalizedSubtitle()|escape}
                                </span>
                            {/if}
                        </a>
                        <button class="btn btn-primary btn-sm">Ler</button> 
                    </div>
                </div>
            </div>
            {/foreach}
        </div>
    </div>
    {* {call_hook name="Templates::Archive::Preprint"} *}
</div> 

<script src="https://code.jquery.com/jquery-3.1.0.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
<script src="/plugins/themes/scielo-theme/templates/frontend/owl.carousel.js"></script>

<script>
    $('.owl-carousel').owlCarousel({
    loop:true,
    margin:10,
    responsiveClass:true,
    responsive:{
        0:{
            items:1,
            nav:true
        },
        600:{
            items:3,
            nav:false
        },
        1000:{
            items:5,
            nav:true,
            loop:false
        }
    }
})
</script>