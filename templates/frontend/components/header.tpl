{**
 * lib/pkp/templates/frontend/components/header.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Common frontend site header.
 * 
 * @uses $isFullWidth bool Should this page be displayed without sidebars? This
 *       represents a page-level override, and doesn't indicate whether or not
 *       sidebars have been configured for thesite.
 *}
{strip}
	{* Determine whether a logo or title string is being displayed *}
	{assign var="showingLogo" value=true}
	{if $displayPageHeaderTitle && !$displayPageHeaderLogo && is_string($displayPageHeaderTitle)}
		{assign var="showingLogo" value=false}
	{/if}
{/strip}
<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
{if !$pageTitleTranslated}{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}{/if}
{include file="frontend/components/headerHead.tpl"}
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
<body class="pkp_page_{$requestedPage|escape|default:"index"} pkp_op_{$requestedOp|escape|default:"index"}{if $showingLogo} has_site_logo{/if}" dir="{$currentLocaleLangDir|escape|default:"ltr"}">
	
	<div class="pkp_structure_page">

		{* Header *}
		<header class="pkp_structure_head" id="headerNavigationContainer" role="banner">
			<div class="pkp_head_wrapper">

				<div class="pkp_site_name_wrapper">
					<button class="pkp_site_nav_toggle">
						<span>Open Menu</span>
					</button>	
				
					<div class="pkp_site_name">
						{capture assign="homeUrl"}
							{if $currentContext && $multipleContexts}
								{url page="index" router=$smarty.const.ROUTE_PAGE}
							{else}
								{url context="index" router=$smarty.const.ROUTE_PAGE}
							{/if}
						{/capture}
						{if $displayPageHeaderLogo && is_array($displayPageHeaderLogo)}
						<a href="{$homeUrl}" class="is_img">
							<img src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}" width="{$displayPageHeaderLogo.width|escape}" height="{$displayPageHeaderLogo.height|escape}" {if $displayPageHeaderLogo.altText != ''}alt="{$displayPageHeaderLogo.altText|escape}"{/if} />
						</a>
						{elseif $displayPageHeaderTitle && !$displayPageHeaderLogo && is_string($displayPageHeaderTitle)}
							<a href={$homeUrl} class="is_img">
								<img src="/plugins/themes/scieloTheme/styles/img/logo-scielo.png" alt="{$applicationName|escape}" title="{$applicationName|escape}" width="180" height="90" />						
								<small>Preprints</small>
								<span>Scientific Electronic Library Online</span>
							</a> 
						{elseif $displayPageHeaderTitle && !$displayPageHeaderLogo && is_array($displayPageHeaderTitle)}
							<a href="{$homeUrl}" class="is_img">
								<img src="{$publicFilesDir}/{$displayPageHeaderTitle.uploadName|escape:"url"}" alt="{$displayPageHeaderTitle.altText|escape}" width="{$displayPageHeaderTitle.width|escape}" height="{$displayPageHeaderTitle.height|escape}" />
							</a>
						{else}
							{* Header adicionada, aka a nossa *}	
							<a href="{$homeUrl}" class="is_img">
								<img src="{$baseUrl}/templates/images/structure/logo.png" alt="{$applicationName|escape}" title="{$applicationName|escape}" width="180" height="90" />
							</a>
						{/if}
					</div>	
				</div>
				
				<div class="pkp_navigation_user_wrapper" id="navigationUserWrapper">
					{load_menu name="user" id="navigationUser" ulClass="pkp_navigation_user" liClass="profile"}
				</div>
				
				{* Language *}
				{include file="frontend/components/language.tpl"}

				{* Primary site navigation *}
				{include file="frontend/components/skipLinks.tpl"}

				{capture assign="primaryMenu"}
					{load_menu name="primary" id="navigationPrimary" ulClass="pkp_navigation_primary"}
				{/capture}

				<nav class="pkp_site_nav_menu" aria-label="{translate|escape key="common.navigation.site"}">
					<a id="siteNav"></a>
					<div class="pkp_navigation_primary_row">
						<div class="pkp_navigation_primary_wrapper">
							{* Primary navigation menu for current application *}
							{$primaryMenu}

						</div>
					</div>
				</nav>
				
			</div><!-- .pkp_head_wrapper -->
			
			{* Adiciona bootstrap *}
			<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
		</header><!-- .pkp_structure_head -->

		{* Wrapper for page content and sidebars *}
		{if $isFullWidth}
			{assign var=hasSidebar value=0}
		{/if}
		<div class="pkp_structure_content{if $hasSidebar} has_sidebar{/if}">
			<div class="pkp_structure_main" role="main">
				<a id="pkp_content_main"></a>