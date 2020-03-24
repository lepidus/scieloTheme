{**
 * templates/frontend/components/searchForm_frontpage.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Simple display of a search form with just text input and search button
 *
 * @uses $searchQuery string Previously input search query
 *}
{if !$currentJournal || $currentJournal->getData('publishingMode') != $smarty.const.PUBLISHING_MODE_NONE}

	{capture name="searchFormUrl"}{url page="search" op="search" escape=false}{/capture}

	{$smarty.capture.searchFormUrl|parse_url:$smarty.const.PHP_URL_QUERY|parse_str:$formUrlParameters}

	<form class="pkp_search" action="{$smarty.capture.searchFormUrl|strtok:"?"|escape}" method="get" role="search" aria-label="{translate|escape key="submission.search"}">
		{csrf}
		{foreach from=$formUrlParameters key=paramKey item=paramValue}
			<input type="hidden" name="{$paramKey|escape}" value="{$paramValue|escape}"/>
		{/foreach}

        <div class="col-md-10 col-sm-10">
            <div class="input-group col-md-12 col-sm-12">
                <div class="form-textarea">
                    {block name=searchQueryFrontpage}
                        <textarea name="query" placeholder={translate key="search.SearchFor"} value="{$searchQuery|escape}" type="text" rows="1" class="form-control" aria-label="{translate|escape key="common.searchQuery"}"></textarea>
                    {/block}
                </div>

                {* <div class="selectBox index">
                    <select name="index[]">
                        <option value="">{translate key="search.advancedFilters"}</option>
                        <option value="year_cluster">{translate key="common.year"}</option>
                        <option value="au">{translate key="navigation.browseByAuthor"}</option>
                        <option value="ti">{translate key="navigation.browseByTitle"}</option>
                    </select>
                </div> *}
            </div>
        </div>
        <div class="col-md-2 col-sm-2">
            <button type="submit">
                {translate key="common.search"}
            </button>
        </div>
        <div class="clearfix"></div>
	</form>

{/if}
