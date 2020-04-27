<?php

/**
 * @file plugins/themes/scielo-theme/pages/index/IndexHandler.inc.php
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class IndexHandler
 * @ingroup pages_archive
 *
 * @brief Handle requests for index functions.
 */

import('classes.handler.Handler');

class IndexHandler extends Handler {

	/**
	 * @copydoc PKPHandler::authorize()
	 */
	function authorize($request, &$args, $roleAssignments) {
		import('lib.pkp.classes.security.authorization.ContextRequiredPolicy');
		$this->addPolicy(new ContextRequiredPolicy($request));

		import('classes.security.authorization.OpsServerMustPublishPolicy');
		$this->addPolicy(new OpsServerMustPublishPolicy($request));

		return parent::authorize($request, $args, $roleAssignments);
	}

	/**
	 * Display the preprint archive listings
	 * @param $args array
	 * @param $request PKPRequest
	 */
	function index($args, $request) {
		$this->setupTemplate($request);
		$page = isset($args[0]) ? (int) $args[0] : 1;
		$templateMgr = TemplateManager::getManager($request);
		$context = $request->getContext();

		// OPS: Series
		$sectionDao = DAORegistry::getDAO('SectionDAO');
		$series = $sectionDao->getByContextId($context->getId());

        $count = $context->getData('itemsPerPage') ? $context->getData('itemsPerPage') : Config::getVar('interface', 'items_per_page');
		$offset = $page > 1 ? ($page - 1) * $count : 0;
        error_log($count);
		import('classes.submission.Submission');
		$submissionService = Services::get('submission');
		$params = array(
			'contextId' => $context->getId(),
			'count' => $count,
			'offset' => $offset,
			'status' => STATUS_PUBLISHED,
		);
		$publishedSubmissions = $submissionService->getMany($params);
		$total = $submissionService->getMax($params);

		$showingStart = $offset + 1;
		$showingEnd = min($offset + $count, $offset + count($publishedSubmissions));
		$nextPage = $total > $showingEnd ? $page + 1 : null;
		$prevPage = $showingStart > 1 ? $page - 1 : null;

		$templateMgr->assign(array(
			'series' => $series,
			'publishedSubmissions' => $publishedSubmissions,
			'pubIdPlugins' => PluginRegistry::loadCategory('pubIds', true),
			'showingStart' => $showingStart,
			'showingEnd' => $showingEnd,
			'total' => $total,
			'nextPage' => $nextPage,
			'prevPage' => $prevPage,
		));

		$templateMgr->display('frontend/pages/indexJournal.tpl');
	}

	function setupTemplate($request) {
		parent::setupTemplate($request);
		AppLocale::requireComponents(LOCALE_COMPONENT_PKP_READER, LOCALE_COMPONENT_APP_EDITOR);
	}


}
