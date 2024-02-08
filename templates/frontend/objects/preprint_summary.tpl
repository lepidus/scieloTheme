{**
 * templates/frontend/objects/preprint_summary.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief View of an Preprint summary which is shown within a list of preprints.
 *
 * @uses $preprint Preprint The preprint
 * @uses $hasAccess bool Can this user access galleys for this context? The
 *       context is a preprint.
 * @uses $showDatePublished bool Show the date this preprint was published?
 * @uses $hideGalleys bool Hide the preprint galleys for this preprint?
 * @uses $primaryGenreIds array List of file genre ids for primary file types
 *}
{assign var=preprintPath value=$preprint->getBestId()}

{if (!$section.hideAuthor && $preprint->getHideAuthor() == $smarty.const.AUTHOR_TOC_DEFAULT) || $preprint->getHideAuthor() == $smarty.const.AUTHOR_TOC_SHOW}
	{assign var="showAuthor" value=true}
{/if}

<div class="obj_article_summary">
	{if $preprint->getCurrentPublication()->getLocalizedData('coverImage')}
		<div class="cover">
			<a {if $journal}href="{url journal=$journal->getPath() page="preprint" op="view" path=$preprintPath}"{else}href="{url page="preprint" op="view" path=$preprintPath}"{/if} class="file">
				{assign var="coverImage" value=$preprint->getCurrentPublication()->getLocalizedData('coverImage')}
				<img
					src="{$preprint->getCurrentPublication()->getLocalizedCoverImageUrl($preprint->getData('contextId'))|escape}"
					alt="{$coverImage.altText|escape|default:''}"
				>
			</a>
		</div>
	{/if}

	<div class="title">
		<a id="preprint-{$preprint->getId()}" {if $journal}href="{url journal=$journal->getPath() page="preprint" op="view" path=$preprintPath}"{else}href="{url page="preprint" op="view" path=$preprintPath}"{/if}>
			{$preprint->getLocalizedTitle()|strip_unsafe_html}
			{if $preprint->getLocalizedSubtitle()}
				<span class="subtitle">
					{$preprint->getLocalizedSubtitle()|escape}
				</span>
			{/if}
		</a>
	</div>
	<div class="meta">

		{if $showAuthor}
		<div class="authors">
			{$preprint->getCurrentPublication()->getAuthorString($authorUserGroups)|escape}
		</div>
		{/if}

		{* DOI (requires plugin) *}
		{foreach from=$pubIdPlugins item=pubIdPlugin}
			{if $pubIdPlugin->getPubIdType() != 'doi'}
				{continue}
			{/if}
			{assign var=pubId value=$preprint->getCurrentPublication()->getStoredPubId($pubIdPlugin->getPubIdType())}
			{if $pubId}
				{assign var="doiUrl" value=$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
				<div class="doi">
						{capture assign=translatedDOI}{translate key="plugins.pubIds.doi.readerDisplayName"}{/capture}
						{translate key="semicolon" label=$translatedDOI}
					<span class="value">
						<a href="{$doiUrl}">
							{$doiUrl}
						</a>
					</span>
				</div>
			{/if}
		{/foreach}

		{if $preprint->getDatePublished()}
			<div class="published">
				{translate key="submission.dates" submitted=$preprint->getDateSubmitted()|date_format:$dateFormatShort published=$preprint->getDatePublished()|date_format:$dateFormatShort}
			</div>
		{/if}

		{if count($preprint->getPublishedPublications()) > 1}
			<div class="versions">
				{translate key="submission.numberOfVersions" numberOfVersions=count($preprint->getPublishedPublications())}
			</div>
		{/if}

		{if !empty($preprint->getCurrentPublication()->getLocalizedData('keywords'))}
		<div class="keywords">
			<ul class="keyword_links">
				{foreach name="keywords" from=$preprint->getCurrentPublication()->getLocalizedData('keywords') item="keyword"}
					<li>{$keyword|escape}</li>
				{/foreach}
			</ul>
		</div>
		{/if}
	</div>	

	{if !$hideGalleys}
		<ul class="galleys_links">
			{foreach from=$preprint->getGalleys() item=galley}
				{if $primaryGenreIds}
					{assign var="file" value=$galley->getFile()}
					{if !$galley->getRemoteUrl() && !($file && in_array($file->getGenreId(), $primaryGenreIds))}
						{continue}
					{/if}
				{/if}
				<li>
					{assign var="hasPreprintAccess" value=$hasAccess}
					{if $currentContext->getSetting('publishingMode') == $smarty.const.PUBLISHING_MODE_OPEN}
						{assign var="hasPreprintAccess" value=1}
					{/if}
					{include file="frontend/objects/galley_link.tpl" parent=$preprint labelledBy="preprint-{$preprint->getId()}" hasAccess=$hasPreprintAccess}
				</li>
				{call_hook name="Hypothesis::annotationNumber" galley=$galley}
			{/foreach}
		</ul>
	{/if}

	{call_hook name="Templates::Archive::Preprint"}
</div>
