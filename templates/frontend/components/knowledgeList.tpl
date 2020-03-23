{**
 * templates/frontend/components/knowledgeList.tpl
*}

<div class="row">
    <div class="col-md-12 col-sm-12 periodicals">
        <h2>{translate key="plugins.themes.scielo.option.seriesList"}</h2>
        <div class="levelMenu">
            <ul>
                {if $series && $series->getCount()}
                    {iterate from=series item=serie}
                <li class="series_{$serie->getPath()|escape}">
					<a href="{url router=$smarty.const.ROUTE_PAGE page="series" op="view" path=$serie->getPath()|escape}">
						{$serie->getLocalizedTitle()|escape}
					</a>
				</li>
                    {/iterate}
                {/if}
            </ul>
            <div class="clearfix"></div>
        </div>
    </div>
</div>