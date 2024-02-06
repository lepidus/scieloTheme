<?php

/**
 * @file plugins/themes/scieloTheme/pages/index/ScieloIndexHandler.php
 *
 * Copyright (c) 2020 - 2024 Lepidus Tecnologia
 * Copyright (c) 2020 - 2024 SciELO
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class ScieloIndexHandler
 * @ingroup pages_archive
 *
 * @brief Handle requests for index page.
 */

namespace APP\plugins\themes\scieloTheme\pages\index;

use APP\pages\index\IndexHandler;
use PKP\security\Validation;
use APP\core\Application;
use APP\template\TemplateManager;
use APP\facades\Repo;
use PKP\db\DAORegistry;
use APP\submission\Submission;
use PKP\plugins\PluginRegistry;
use APP\observers\events\UsageEvent;

class ScieloIndexHandler extends IndexHandler
{
    public function index($args, $request)
    {
        $this->validate(null, $request);
        $server = $request->getServer();

        if (!$server) {
            $server = $this->getTargetContext($request, $hasNoContexts);
            if ($server) {
                $request->redirect($server->getPath());
            }
            if ($hasNoContexts && Validation::isSiteAdmin()) {
                $request->redirect(null, 'admin', 'contexts');
            }
        }

        $this->setupTemplate($request);
        $router = $request->getRouter();
        $templateMgr = TemplateManager::getManager($request);
        if ($server) {
            $sections = Repo::section()->getCollector()->filterByContextIds([$server->getId()])->getMany();

            $count = $server->getData('itemsPerPage') ? $server->getData('itemsPerPage') : Config::getVar('interface', 'items_per_page');
            $submissionCollector = Repo::submission()->getCollector();
            $publishedSubmissions = $submissionCollector
                ->filterByContextIds([$server->getId()])
                ->filterByStatus([Submission::STATUS_PUBLISHED])
                ->orderBy($submissionCollector::ORDERBY_DATE_PUBLISHED)
                ->limit($count)
                ->getMany();

            $templateMgr->assign(array(
                'additionalHomeContent' => $server->getLocalizedData('additionalHomeContent'),
                'homepageImage' => $server->getLocalizedData('homepageImage'),
                'homepageImageAltText' => $server->getLocalizedData('homepageImageAltText'),
                'serverDescription' => $server->getLocalizedData('description'),
                'sections' => $sections,
                'pubIdPlugins' => PluginRegistry::loadCategory('pubIds', true),
                'publishedSubmissions' => $publishedSubmissions->toArray(),
            ));

            $this->_setupAnnouncements($server, $templateMgr);

            $templateMgr->display('frontend/pages/indexServer.tpl');
            event(new UsageEvent(Application::ASSOC_TYPE_SERVER, $server));
            return;
        } else {
            $serverDao = DAORegistry::getDAO('ServerDAO');
            $site = $request->getSite();

            if ($site->getRedirect() && ($server = $serverDao->getById($site->getRedirect())) != null) {
                $request->redirect($server->getPath());
            }
            $templateMgr->assign([
                'pageTitleTranslated' => $site->getLocalizedTitle(),
                'about' => $site->getLocalizedAbout(),
                'serverFilesPath' => $request->getBaseUrl() . '/' . Config::getVar('files', 'public_files_dir') . '/contexts/',
                'servers' => $serverDao->getAll(true)->toArray(),
                'site' => $site,
            ]);
            $templateMgr->setCacheability(TemplateManager::CACHEABILITY_PUBLIC);
            $templateMgr->display('frontend/pages/indexSite.tpl');
        }
    }
}
