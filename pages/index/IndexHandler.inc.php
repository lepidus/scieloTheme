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

import('lib.pkp.pages.index.PKPIndexHandler');

class IndexHandler extends PKPIndexHandler
{
    //
    // Public handler operations
    //
    /**
     * If no journal is selected, display list of journals.
     * Otherwise, display the index page for the selected journal.
     * @param $args array
     * @param $request Request
     */
    public function index($args, $request)
    {
        $this->validate(null, $request);
        $journal = $request->getJournal();

        if (!$journal) {
            $journal = $this->getTargetContext($request, $journalsCount);
            if ($journal) {
                // There's a target context but no journal in the current request. Redirect.
                $request->redirect($journal->getPath());
            }
            if ($journalsCount === 0 && Validation::isSiteAdmin()) {
                // No contexts created, and this is the admin.
                $request->redirect(null, 'admin', 'contexts');
            }
        }

        $this->setupTemplate($request);
        $router = $request->getRouter();
        $templateMgr = TemplateManager::getManager($request);
        if ($journal) {
            $context = $request->getContext();

            // OPS: Series
            $sectionDao = DAORegistry::getDAO('SectionDAO');
            $series = $sectionDao->getByContextId($journal->getId());

            // Latest preprints
            import('classes.submission.Submission');
            $submissionService = Services::get('submission');
            $count = $context->getData('itemsPerPage') ? $context->getData('itemsPerPage') : Config::getVar('interface', 'items_per_page');
            $params = array(
                'contextId' => $journal->getId(),
                'count' => $count,
                'orderBy' => 'datePublished',
                'status' => STATUS_PUBLISHED,
            );
            $publishedSubmissions = $submissionService->getMany($params);

            // Assign header and content for home page
            $templateMgr->assign(array(
                'additionalHomeContent' => $journal->getLocalizedData('additionalHomeContent'),
                'homepageImage' => $journal->getLocalizedData('homepageImage'),
                'homepageImageAltText' => $journal->getLocalizedData('homepageImageAltText'),
                'journalDescription' => $journal->getLocalizedData('description'),
                'series' => $series,
                'pubIdPlugins' => PluginRegistry::loadCategory('pubIds', true),
                'publishedSubmissions' => $publishedSubmissions,
            ));

            $this->_setupAnnouncements($journal, $templateMgr);

            $templateMgr->display('frontend/pages/indexJournal.tpl');
        } else {
            $journalDao = DAORegistry::getDAO('JournalDAO'); /* @var $journalDao JournalDAO */
            $site = $request->getSite();

            if ($site->getRedirect() && ($journal = $journalDao->getById($site->getRedirect())) != null) {
                $request->redirect($journal->getPath());
            }

            $templateMgr->assign(array(
                'pageTitleTranslated' => $site->getLocalizedTitle(),
                'about' => $site->getLocalizedAbout(),
                'journalFilesPath' => $request->getBaseUrl() . '/' . Config::getVar('files', 'public_files_dir') . '/journals/',
                'journals' => $journalDao->getAll(true),
                'site' => $site,
            ));
            $templateMgr->setCacheability(CACHEABILITY_PUBLIC);
            $templateMgr->display('frontend/pages/indexSite.tpl');
        }
    }
}
