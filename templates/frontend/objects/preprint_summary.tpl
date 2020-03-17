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

<div class="slide-item release">
    <a id="preprint-{$preprint->getId()}" {if $journal}href="{url journal=$journal->getPath() page="preprint" op="view" path=$preprintPath}"{else}href="{url page="preprint" op="view" path=$preprintPath}"{/if} target="_blank">
        <div class="col-md-12">
            <div class="published">
                {if $preprint->getDatePublished()}
                    <span>{translate key="submissions.published"}: {$preprint->getDatePublished()|date_format:$dateFormatShort}</span>
                {/if}
            </div>
            <h3 class="ellipsis"> {$preprint->getLocalizedTitle()|strip_unsafe_html} </h3>           
        </div>
    </a>
    {call_hook name="Templates::Archive::Preprint"}
</div>

