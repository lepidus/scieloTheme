<?php

/**
 * @file /js/metricsDAO.php
 *
 * @class MetricsDAO
 * @ingroup plugins_generic_scieloMetrics
 *
 * Operations for retrieving the necessary metrics for the plugin.
 */

import('lib.pkp.classes.db.DAO');

class MetricsDAO extends DAO {
    function getPublicationCount(){
        $result = $this->retrieve(
			'SELECT COUNT(*) FROM publications WHERE status = 3'
		);

		$count = ($result->GetRowAssoc(false))['count(*)'];
        $result->Close();
        
        return $count;
    }

    function getJournalCount(){
        $result = $this->retrieve(
			'SELECT COUNT(*) FROM journals'
		);

		$count = ($result->GetRowAssoc(false))['count(*)'];
        $result->Close();
        
        return $count;
    }

    function getCitationCount(){
        $result = $this->retrieve(
			'SELECT COUNT(*) FROM citations'
		);

		$count = ($result->GetRowAssoc(false))['count(*)'];
        $result->Close();
        
        return $count;
    }
}
