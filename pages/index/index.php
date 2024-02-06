<?php

/**
 * @defgroup pages_index Index Pages
 */

/**
 * @file plugins/themes/scieloTheme/pages/index/index.php
 *
 * @ingroup pages_index
 * @brief Handle site index requests.
 *
 */

switch ($op) {
    case 'index':
        define('HANDLER_CLASS', 'IndexHandler');
        import('plugins.themes.scieloTheme.pages.index.IndexHandler');
        break;
}
