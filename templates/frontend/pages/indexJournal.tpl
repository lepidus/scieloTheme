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

	{* Additional Homepage Content *}
	{if $additionalHomeContent}
		<div class="additional_content">
			{$additionalHomeContent}
		</div>
	{/if}
	
	{* Announcements *}
	{if $numAnnouncementsHomepage && $announcements|@count}
		<section class="cmp_announcements highlight_first">
			<a id="homepageAnnouncements"></a>
			<h2>
				{translate key="announcement.announcements"}
			</h2>
			{assign var=announcement value=$announcements[0]}
			{include file="frontend/objects/announcement_summary.tpl" heading="h3"}
			{if $announcements|@count > 1 and $numAnnouncementsHomepage > 1}
				<div class="more">
					{assign var=iter value=1}
					{while $iter < $announcements|@count and $iter < $numAnnouncementsHomepage}
						{assign var=announcement value=$announcements[$iter]}
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
						{assign var=iter value=$iter+1}
					{/while}
				</div>
			{/if}
		</section>
	{/if}

	{* Metrics *}
    {*include file="frontend/components/metrics.tpl"*}

    {* Knowledge listing *}
    {* include file="frontend/components/knowledgeList.tpl" *}
    
	{* Latest preprints *}
	<section class="homepage_latest_preprints">
		<h2>{translate key="index.latestPreprints"}</h2>
		<ul class="cmp_article_list articles">
			{foreach from=$publishedSubmissions item="preprint"}
				<li>
					{include file="frontend/objects/preprint_summary.tpl"}
				</li>
			{/foreach}
			{* {include file="frontend/components/slider.tpl"} *}
		</ul>
        <div class="cmp_pagination">
            <a href="{url router=$smarty.const.ROUTE_PAGE page="preprints" path=2}" class="next">
                {translate key="plugins.themes.scielo.indexToArchive"}
            </a>
        </div>
	</section>



	
</div><!-- .page -->

{include file="frontend/components/footer.tpl"}
