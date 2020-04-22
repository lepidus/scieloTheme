{**
 * templates/frontend/components/language.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * Common site sidebar menu -- language toggle.
 *}

{capture assign="sidebarCode"}{call_hook name="Templates::Common::Sidebar"}{/capture}
{if $sidebarCode}
	{if $enableLanguageToggle}
	
	<div class="pkp_language">

		<div class="content">
			<ul>
				{foreach from=$languageToggleLocales item=localeName key=localeKey}
                {if strpos($localeName, " ") != ""}
                    {capture assign=localeName}{substr($localeName, 0, strpos($localeName, " "))}{/capture}
                {/if}
				<a href="{url router=$smarty.const.ROUTE_PAGE page="user" op="setLocale" path=$localeKey source=$smarty.server.REQUEST_URI}">
					{$localeName}
				</a>
			
				{/foreach}
			</ul>
		</div>
	</div><!-- .block_language -->
	{/if}
{/if}	
