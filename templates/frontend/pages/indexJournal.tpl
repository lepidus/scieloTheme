{**
 * templates/frontend/pages/indexJournal.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display the index page for a journal
 *
 * @uses $currentJournal Journal This journal
 * @uses $journalDescription string Journal description from HTML text editor
 * @uses $homepageImage object Image to be displayed on the homepage
 * @uses $additionalHomeContent string Arbitrary input from HTML text editor
 * @uses $announcements array List of announcements
 * @uses $numAnnouncementsHomepage int Number of announcements to display on the
 *       homepage
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName()}

<div class="page_index_journal">

	{call_hook name="Templates::Index::journal"}

	{if !$activeTheme->getOption('useHomepageImageAsHeader') && $homepageImage}
		<img src="{$publicFilesDir}/{$homepageImage.uploadName|escape:"url"}" alt="{$homepageImageAltText|escape}">
	{/if}	

	{* Search and category listing *}
	{include file="frontend/components/archiveHeader.tpl"}

	{* Server Description *}
	{if $activeTheme->getOption('showDescriptionInServerIndex')}
		<section class="homepage_about">
			<a id="homepageAbout"></a>
			<h2>{translate key="about.aboutContext"}</h2>
			{$currentContext->getLocalizedData('description')}
		</section>
	{/if}

    {* Metrics *}
    {include file="frontend/components/metrics.tpl"}

    {* Knowledge listing *}
    {include file="frontend/components/knowledgeList.tpl"}

	{* Slider da Scielo *}
	{* <div class="row">
		<div class="block releases">
		<div class="col-md-12">
			<h2>SciELO <span>{translate key="index.latestPreprints"}</span></h2>
			<div class="slider" id="pressreleases"> *}
			{* <a href="javascript:;" class="slide-back"><span class="glyphBtn arrowLeft"></span></a>
			<a href="javascript:;" class="slide-next"><span class="glyphBtn arrowRight"></span></a> *}
			{* <div class="slide-container">
				<div class="slide-wrapper">
				{foreach from=$publishedSubmissions item="preprint"}
					<li>
						{include file="frontend/objects/preprint_summary.tpl"}
					</li>
				{/foreach}
				</div>
			</div>
			</div>
		</div>
		<div class="clearfix"></div>
		</div>
	</div>  *}
    

	{* Latest preprints *}
	<section class="homepage_latest_preprints">
		<h1>{translate key="index.latestPreprints"}</h1>
		<ul class="cmp_article_list articles">
			{foreach from=$publishedSubmissions item="preprint"}
				<li>
					{include file="frontend/objects/preprint_summary.tpl"}
				</li>
			{/foreach}
		</ul> 
	</section>


	{* Announcements *}
	{if $numAnnouncementsHomepage && $announcements|@count}
		<section class="cmp_announcements highlight_first">
			<a id="homepageAnnouncements"></a>
			<h2>
				{translate key="announcement.announcements"}
			</h2>
			{foreach name=announcements from=$announcements item=announcement}
				{if $smarty.foreach.announcements.iteration > $numAnnouncementsHomepage}
					{break}
				{/if}
				{if $smarty.foreach.announcements.iteration == 1}
					{include file="frontend/objects/announcement_summary.tpl" heading="h3"}
					<div class="more">
				{else}
					<article class="obj_announcement_summary">
						<h4>
							<a href="{url router=$smarty.const.ROUTE_PAGE page="announcement" op="view" path=$announcement->getId()}">
								{$announcement->getLocalizedTitle()|escape}
							</a>
						</h4>
						<div class="date">
							{$announcement->getDatePosted()}
						</div>
					</article>
				{/if}
			{/foreach}
			</div><!-- .more -->
		</section>
	{/if}

	{* Additional Homepage Content *}
	{if $additionalHomeContent}
		<div class="additional_content">
			{$additionalHomeContent}
		</div>
	{/if}
</div><!-- .page -->

{include file="frontend/components/footer.tpl"}
