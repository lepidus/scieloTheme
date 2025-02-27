<?php

/**
 * @file plugins/themes/scieloTheme/ScieloThemePlugin.php
 *
 * Copyright (c) 2020 - 2024 Lepidus Tecnologia
 * Copyright (c) 2020 - 2024 SciELO
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class ScieloThemePlugin
 * @ingroup plugins_themes_default
 *
 * @brief Scielo theme
 */

namespace APP\plugins\themes\scieloTheme;

use APP\core\Application;
use APP\file\PublicFileManager;
use PKP\config\Config;
use PKP\plugins\ThemePlugin;
use PKP\session\SessionManager;
use PKP\plugins\Hook;
use APP\template\TemplateManager;
use APP\facades\Repo;

class ScieloThemePlugin extends ThemePlugin
{
    public function isActive()
    {
        if (SessionManager::isDisabled()) {
            return true;
        }
        return parent::isActive();
    }

    /**
     * Initialize the theme's styles, scripts and hooks. This is run on the
     * currently active theme and it's parent themes.
     *
     * @return null
     */
    public function init()
    {
        // Register theme options
        $this->addOption('typography', 'FieldOptions', [
            'type' => 'radio',
            'label' => __('plugins.themes.scielo.option.typography.label'),
            'description' => __('plugins.themes.scielo.option.typography.description'),
            'options' => [
                [
                    'value' => 'notoSans',
                    'label' => __('plugins.themes.scielo.option.typography.notoSans'),
                ],
                [
                    'value' => 'notoSerif',
                    'label' => __('plugins.themes.scielo.option.typography.notoSerif'),
                ],
                [
                    'value' => 'notoSerif_notoSans',
                    'label' => __('plugins.themes.scielo.option.typography.notoSerif_notoSans'),
                ],
                [
                    'value' => 'notoSans_notoSerif',
                    'label' => __('plugins.themes.scielo.option.typography.notoSans_notoSerif'),
                ],
                [
                    'value' => 'lato',
                    'label' => __('plugins.themes.scielo.option.typography.lato'),
                ],
                [
                    'value' => 'lora',
                    'label' => __('plugins.themes.scielo.option.typography.lora'),
                ],
                [
                    'value' => 'lora_openSans',
                    'label' => __('plugins.themes.scielo.option.typography.lora_openSans'),
                ],
            ],
            'default' => 'notoSans',
        ]);


        $this->addOption('showDescriptionInServerIndex', 'FieldOptions', [
            'label' => __('manager.setup.contextSummary'),
                'options' => [
                [
                    'value' => true,
                    'label' => __('plugins.themes.scielo.option.showDescriptionInServerIndex.option'),
                ],
            ],
            'default' => false,
        ]);

        // Load primary stylesheet
        $this->addStyle('stylesheet', 'styles/index.less');

        // Store additional LESS variables to process based on options
        $additionalLessVariables = array();

        if ($this->getOption('typography') === 'notoSerif') {
            $this->addStyle('font', 'styles/fonts/notoSerif.less');
            $additionalLessVariables[] = '@font: "Noto Serif", -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen-Sans", "Ubuntu", "Cantarell", "Helvetica Neue", sans-serif;';
        } elseif (strpos($this->getOption('typography'), 'notoSerif') !== false) {
            $this->addStyle('font', 'styles/fonts/notoSans_notoSerif.less');
            if ($this->getOption('typography') == 'notoSerif_notoSans') {
                $additionalLessVariables[] = '@font-heading: "Noto Serif", serif;';
            } elseif ($this->getOption('typography') == 'notoSans_notoSerif') {
                $additionalLessVariables[] = '@font: "Noto Serif", serif;@font-heading: "Noto Sans", serif;';
            }
        } elseif ($this->getOption('typography') == 'lato') {
            $this->addStyle('font', 'styles/fonts/lato.less');
            $additionalLessVariables[] = '@font: Lato, sans-serif;';
        } elseif ($this->getOption('typography') == 'lora') {
            $this->addStyle('font', 'styles/fonts/lora.less');
            $additionalLessVariables[] = '@font: Lora, serif;';
        } elseif ($this->getOption('typography') == 'lora_openSans') {
            $this->addStyle('font', 'styles/fonts/lora_openSans.less');
            $additionalLessVariables[] = '@font: "Open Sans", sans-serif;@font-heading: Lora, serif;';
        } else {
            $this->addStyle('font', 'styles/fonts/notoSans.less');
        }

        // Update colour based on theme option
        if ($this->getOption('baseColour') !== '#1E6292') {
            $additionalLessVariables[] = '@bg-base:' . $this->getOption('baseColour') . ';';
            if (!$this->isColourDark($this->getOption('baseColour'))) {
                $additionalLessVariables[] = '@text-bg-base:rgba(0,0,0,0.84);';
                $additionalLessVariables[] = '@bg-base-border-color:rgba(0,0,0,0.2);';
            }
        }

        // Pass additional LESS variables based on options
        if (!empty($additionalLessVariables)) {
            $this->modifyStyle('stylesheet', array('addLessVariables' => join($additionalLessVariables)));
        }

        $request = Application::get()->getRequest();

        // Load icon font FontAwesome - http://fontawesome.io/
        $this->addStyle(
            'fontAwesome',
            $request->getBaseUrl() . '/lib/pkp/styles/fontawesome/fontawesome.css',
            array('baseUrl' => '')
        );

        // Get homepage image and use as header background if useAsHeader is true
        $context = Application::get()->getRequest()->getContext();
        if ($context && $this->getOption('useHomepageImageAsHeader') && ($homepageImage = $context->getLocalizedData('homepageImage'))) {
            $publicFileManager = new PublicFileManager();
            $publicFilesDir = $request->getBaseUrl() . '/' . $publicFileManager->getContextFilesPath($context->getId());
            $homepageImageUrl = $publicFilesDir . '/' . $homepageImage['uploadName'];

            $this->addStyle(
                'homepageImage',
                '.pkp_structure_head { background: center / cover no-repeat url("' . $homepageImageUrl . '"); }',
                ['inline' => true]
            );
        }

        // Load jQuery from a CDN or, if CDNs are disabled, from a local copy.
        $min = Config::getVar('general', 'enable_minified') ? '.min' : '';
        $jquery = $request->getBaseUrl() . '/lib/pkp/lib/vendor/components/jquery/jquery' . $min . '.js';
        $jqueryUI = $request->getBaseUrl() . '/lib/pkp/lib/vendor/components/jqueryui/jquery-ui' . $min . '.js';
        // Use an empty `baseUrl` argument to prevent the theme from looking for
        // the files within the theme directory
        $this->addScript('jQuery', $jquery, array('baseUrl' => ''));
        $this->addScript('jQueryUI', $jqueryUI, array('baseUrl' => ''));
        $this->addScript('jQueryTagIt', $request->getBaseUrl() . '/lib/pkp/js/lib/jquery/plugins/jquery.tag-it.js', array('baseUrl' => ''));

        // Load Bootsrap's dropdown
        $this->addScript('popper', 'js/lib/popper/popper.js');
        $this->addScript('bsUtil', 'js/lib/bootstrap/util.js');
        $this->addScript('bsDropdown', 'js/lib/bootstrap/dropdown.js');

        // Load custom JavaScript for this theme
        $this->addScript('default', 'js/main.js');

        // Add navigation menu areas for this theme
        $this->addMenuArea(['primary', 'user']);

        Hook::add('LoadHandler', [$this, 'replaceIndexHandler']);
        Hook::add('Templates::Common::Sidebar', [$this, 'setSidebarToNotShowAtHome']);
        Hook::add('PreprintHandler::view', [$this, 'addDataOnSubmissionView']);
    }

    public function register($category, $path, $mainContextId = null)
    {
        $success = parent::register($category, $path, $mainContextId);
        if ($success && $this->getEnabled($mainContextId)) {
        }
        return $success;
    }

    public function replaceIndexHandler($hookName, $params)
    {
        $page = $params[0];
        if ($page == '' or $page == 'index') {
            define('HANDLER_CLASS', 'APP\plugins\themes\scieloTheme\pages\index\ScieloIndexHandler');
            return true;
        }
        return false;
    }

    public function setSidebarToNotShowAtHome($hookName, $args)
    {
        $params = & $args[0];
        $smarty = & $args[1];
        $output = & $args[2];

        if ($params['location'] == 'sidebar') {
            $request = Application::get()->getRequest();
            $requestPath = $request->getRequestPath();
            $patternPreprintView = "~preprint\/view\/\d+~";

            if (preg_match($patternPreprintView, $requestPath) == 0) {
                return true;
            }
        }
    }

    public function addDataOnSubmissionView($hookName, $args)
    {
        $request = $args[0];
        $templateMgr = TemplateManager::getManager($request);
        $translatorsUserGroup = $this->getTranslatorsUserGroup($request->getContext()->getId());

        if ($translatorsUserGroup) {
            $templateMgr->assign(['translatorsUserGroupId' => $translatorsUserGroup->getId()]);
        }
    }

    private function getTranslatorsUserGroup(int $contextId)
    {
        $contextUserGroups = Repo::userGroup()->getCollector()
            ->filterByContextIds([$contextId])
            ->getMany();

        foreach ($contextUserGroups as $userGroup) {
            $userGroupAbbrev = strtolower($userGroup->getData('abbrev', 'en'));

            if ($userGroupAbbrev === 'tr') {
                return $userGroup;
            }
        }

        return null;
    }

    public function getContextSpecificPluginSettingsFile()
    {
        return $this->getPluginPath() . '/settings.xml';
    }

    public function getInstallSitePluginSettingsFile()
    {
        return $this->getPluginPath() . '/settings.xml';
    }

    public function getDisplayName()
    {
        return __('plugins.themes.scielo.name');
    }

    public function getDescription()
    {
        return __('plugins.themes.scielo.description');
    }
}
