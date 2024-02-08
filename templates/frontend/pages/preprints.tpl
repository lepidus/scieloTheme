{**
 * templates/frontend/pages/preprints.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display a list of preprints.
 *
 * @uses $preprints Array Collection of preprints to display
 * @uses $prevPage int The previous page number
 * @uses $nextPage int The next page number
 * @uses $showingStart int The number of the first item on this page
 * @uses $showingEnd int The number of the last item on this page
 * @uses $total int Count of all published preprints
 *}
{capture assign="pageTitle"}
	{if $prevPage}
		{translate key="archive.archivesPageNumber" pageNumber=$prevPage+1}
	{else}
		{translate key="archive.archives"}
	{/if}
{/capture}
{include file="frontend/components/header.tpl" pageTitleTranslated=$pageTitle}

<div class="page page_issue_archive">
	{include file="frontend/components/breadcrumbs.tpl" currentTitle=$pageTitle}

	<h1>
		{$pageTitle|escape}
	</h1>

	{* Search and category listing *}
	{include file="frontend/components/archiveHeader.tpl"}
    
	{* No preprints have been published *}
	{if empty($publishedSubmissions)}
		<p>{translate key="archive.noSubmissions"}</p>

	{* List preprints *}
	{else}
		<ul class="cmp_article_list articles">
			{foreach from=$publishedSubmissions item="preprint"}
				<li>
					{include file="frontend/objects/preprint_summary.tpl"}
				</li>
			{/foreach}
		</ul>

		{* Pagination *}
		{if $prevPage > 1}
			{capture assign=prevUrl}{url router=$smarty.const.ROUTE_PAGE page="archive" path=$prevPage}{/capture}
		{elseif $prevPage === 1}
			{capture assign=prevUrl}{url router=$smarty.const.ROUTE_PAGE page="archive"}{/capture}
		{/if}
		{if $nextPage}
			{capture assign=nextUrl}{url router=$smarty.const.ROUTE_PAGE page="archive" path=$nextPage}{/capture}
		{/if}
		{include
			file="frontend/components/pagination.tpl"
			prevUrl=$prevUrl
			nextUrl=$nextUrl
			showingStart=$showingStart
			showingEnd=$showingEnd
			total=$total
		}
	{/if}
</div>

{include file="frontend/components/footer.tpl"}
