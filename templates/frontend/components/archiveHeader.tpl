{**
 * templates/frontend/components/archiveHeader.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * Archive header containing a search form and a category listing
 *}

 <section class="archiveHeader">
	{* Search *}
	<section class="archiveHeader_search">
		{include file="frontend/components/searchForm_archive.tpl" className="pkp_search_desktop"}
	</section>

</section>