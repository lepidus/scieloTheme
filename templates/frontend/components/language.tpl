{**
 * templates/frontend/components/language.tpl
 *
 * Copyright (c) 2020 - 2024 Lepidus Tecnologia
 * Copyright (c) 2020 - 2024 SciELO
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * Common site sidebar menu -- language toggle.
 *}

{capture assign="sidebarCode"}{call_hook name="Templates::Common::Sidebar" location="languageToggle"}{/capture}
{if $sidebarCode}
	{if $enableLanguageToggle}
	
	<div class="pkp_language">
		<div class="content">
			<ul>
				{foreach from=$languageToggleLocales item=localeName key=localeKey}	
					{if $localeKey != $currentLocale}
						<a href="{url router=PKPApplication::ROUTE_PAGE page="user" op="setLocale" path=$localeKey source=$smarty.server.REQUEST_URI}">
							{$localeName}
						</a>
					{/if}
				{/foreach}
			</ul>
		</div>
	</div><!-- .block_language -->
	{/if}
{/if}	
